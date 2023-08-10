-------------------------------------------------------------------------------- 
--  
-- COMPANY CONFIDENTIAL 
-- Copyright (c) TECNOBIT  2017 
--  
-- TECNOBIT S.L. 
--  
-- Filename               : agent_axistream_mst.vhd 
-- Author                 : jjquintana
-- Creation Date          : 04/10/2022 
-- Repo path              : 
-- Architecture           : no-synthesizable 
-- Functional description :  
--
-- Version                : 0.0.0 -> (jjquintana) First Version. File Created.   
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_numeric.all;

library work;
use work.logger_pkg.all;
use work.agent_axistream_mst_pkg.all;

--------------------------------------------------------------------------------
entity agent_axistream_mst is
  generic (
    C_AXI_DATA_WIDTH : integer := 32;
    C_MAX_BUFFER     : integer := 255

  );
  port (
    -- AXI4-Stream master interface
    clk                  : in  std_logic;
    resetn               : in  std_logic;
    m_axis_tdata         : out std_logic_vector(C_AXI_DATA_WIDTH - 1 downto 0);
    m_axis_tvalid        : out std_logic;
    m_axis_tkeep         : out std_logic_vector((C_AXI_DATA_WIDTH/8) - 1 downto 0);
    m_axis_tlast         : out std_logic;
    m_axis_tready        : in  std_logic;

    -- AXI4-Stream master interface
    ag_cfg_axistream_mst : in  t_ag_cfg_axistream_mst
  );
end agent_axistream_mst;
--------------------------------------------------------------------------------
architecture beh of agent_axistream_mst is

  type t_fifo is array (0 to C_MAX_BUFFER) of std_logic_vector(C_AXI_DATA_WIDTH - 1 downto 0);

  signal rd_fdata                    : std_logic_vector(C_AXI_DATA_WIDTH - 1 downto 0) := (others => '0'); -- Data readed from TX fifo
  signal wr_fdata                    : std_logic_vector(C_AXI_DATA_WIDTH - 1 downto 0) := (others => '0'); -- Data to be write into TX fifo
  signal wr_txfifo, rd_txfifo        : std_logic                                       := '0';             -- Write and read TX fifo commands

  signal tx_fifo_full, tx_fifo_empty : std_logic                                       := '0';             -- Status TX fifo flags

  signal param_mode                  : t_mode                                          := BURST;           -- AXI transmission mode. Valid modes are BURST, BURST_TILL_EMPTY, SINGLE.
  signal param_timeout_tready        : time                                            := 0 ns;            -- Wait for tready timeout
  signal param_latency_tvalids       : time                                            := 0 ns;            -- Latency between TVALIDs
  signal param_num_words             : positive                                        := 1;               -- Number of words to transmit in a single burst (valid only when BURST mode is selected)
  signal param_verbose               : std_logic                                       := '0';

  signal start_transmission          : std_logic                                       := '0'; -- Trigger start of AXI transmission

begin

  p_cfg_agent : process
  begin

    wait until ag_cfg_axistream_mst'event;

    if ag_cfg_axistream_mst.verbose'event then
      param_verbose <= ag_cfg_axistream_mst.verbose;
    end if;

    if ag_cfg_axistream_mst.start_transmission'event then
      start_transmission <= ag_cfg_axistream_mst.start_transmission;
    end if;

    if ag_cfg_axistream_mst.data'event then
      wr_fdata <= std_logic_vector(to_unsigned(ag_cfg_axistream_mst.data, C_AXI_DATA_WIDTH));
    end if;

    if ag_cfg_axistream_mst.wr_txfifo'event then
      wr_txfifo <= ag_cfg_axistream_mst.wr_txfifo;
    end if;

    if ag_cfg_axistream_mst.mode'event then
      param_mode <= ag_cfg_axistream_mst.mode;
    end if;

    if ag_cfg_axistream_mst.timeout_tready'event then
      param_timeout_tready <= ag_cfg_axistream_mst.timeout_tready;
    end if;

    if ag_cfg_axistream_mst.latency'event then
      param_latency_tvalids <= ag_cfg_axistream_mst.latency;
    end if;

    if ag_cfg_axistream_mst.num_words'event then
      param_num_words <= ag_cfg_axistream_mst.num_words;
    end if;

  end process p_cfg_agent;

  ------------------------------------------
  -- Transmission FIFO handler
  ------------------------------------------
  p_txfifo_level : process
    variable v_fifo_level : integer := 0;
    variable v_tx_ptr     : integer := 0;
    variable v_rx_ptr     : integer := 0;
    variable v_fifo       : t_fifo;
  begin

    wait until wr_txfifo'event or rd_txfifo'event;
    -- ======================
    -- FIFO pointers Handler. Handles write and read memory pointers
    -- ======================
    -- Write into FIFO Branch
    if wr_txfifo = '1' then
      v_fifo(v_tx_ptr) := wr_fdata;

      -- Resets write pointer when it reachs the upper limit of the memory
      if v_tx_ptr = C_MAX_BUFFER then
        v_tx_ptr := 0;
      else
        v_tx_ptr := v_tx_ptr + 1;
      end if;
    end if;

    -- Read from FIFO Branch
    if rd_txfifo = '1' then
      rd_fdata <= v_fifo(v_rx_ptr);

      -- Resets read pointer when it reachs the upper limit of the memory
      if v_rx_ptr = C_MAX_BUFFER then
        v_rx_ptr := 0;
      else
        v_rx_ptr := v_rx_ptr + 1;
      end if;
    end if;
    -- End FIFO pointers Handler
    -- ======================

    -- ======================
    -- FIFO Storage Level
    -- ======================
    -- If simultaneous write and read, then dont update fifo level counter
    if wr_txfifo = '1' and rd_txfifo = '1' then
      null;
      -- Increment fifo level in write operations
    elsif wr_txfifo = '1' then
      if v_fifo_level = C_MAX_BUFFER then
        rep_failure ("FAILURE ERROR: Attempted to read from TX FIFO when its full");
      else
        v_fifo_level := v_fifo_level + 1;
      end if;
      -- Decrement fifo level in write operations
    elsif rd_txfifo = '1' then
      if v_fifo_level = 0 and rd_txfifo = '1' then
        rep_failure ("FAILURE ERROR: Attempted to read from TX FIFO when its empty");
      else
        v_fifo_level := v_fifo_level - 1;
      end if;
    end if;
    -- End FIFO storage level
    -- ======================

    -- ======================
    -- FIFO Status flags
    -- ======================
    -- FIFO is full condition
    if v_fifo_level = C_MAX_BUFFER then
      tx_fifo_full  <= '1';
      tx_fifo_empty <= '0';

      -- FIFO is empty condition
    elsif v_fifo_level = 0 then
      tx_fifo_full  <= '0';
      tx_fifo_empty <= '1';

      -- OK storage level
    else
      tx_fifo_full  <= '0';
      tx_fifo_empty <= '0';
    end if;
    -- End FIFO Status flags
    -- ======================

  end process p_txfifo_level;

  ------------------------------------------
  -- AXI-Stream master handler
  ------------------------------------------
  p_transfer : process
    variable v_burst_count : integer := 1;
  begin
    m_axis_tdata  <= (others => '0');
    m_axis_tvalid <= '0';
    m_axis_tlast  <= '0';
    m_axis_tkeep  <= (others => '1');
    busy := '0';
    wait until start_transmission = '1';
    busy := '1';
    -- ======================
    -- Transmission loop
    -- ======================
    l_axi_tx : loop
      -- If BURST_TILL_EMPTY and tx fifo is empty, abort transmission
      if tx_fifo_empty = '1' then
        if param_mode = BURST_TILL_EMPTY then
          exit l_axi_tx;
        else
          wait until tx_fifo_empty = '0';
        end if;

      else

        -- Simulation of latency between tvalids. Extract next data to send from TX fifo
        wait for param_latency_tvalids;
        rd_txfifo <= '1';
        wait for 0 ns;
        rd_txfifo <= '0';
        wait for 0 ns;

        -- Burst mode case. Agent master axi stream has 3 modes of operations.
        case param_mode is
            -- This mode send in a single burst transfer all data stored in fifo until is empty
          when BURST_TILL_EMPTY =>
            m_axis_tdata  <= rd_fdata;
            m_axis_tvalid <= '1';

            if param_timeout_tready > 0 ns then
              wait on clk until clk = '1' and m_axis_tready = '1' for param_timeout_tready;
            else
              wait on clk until clk = '1' and m_axis_tready = '1';
            end if;

            -- If empty flag is asserted, then there is no data left in TX fifo so assert tlast signal
            if tx_fifo_empty = '1' then
              m_axis_tlast <= '1';
            end if;

            -- If there is timeout for tready configured, wait for tready or until timeout. If not, wait forever for tready
            --if param_timeout_tready > 0 ns then
            --wait on clk until clk = '1' and m_axis_tready = '1' for param_timeout_tready;
            --else
            --wait on clk until clk = '1' and m_axis_tready = '1';
            -- end if;

            if m_axis_tready /= '1' then
              --rep_failure ("Timeout of AXI TREADY. Ready : " & to_string(m_axis_tready) & "Expected: 1");
            end if;

            m_axis_tvalid <= '0';
            m_axis_tlast  <= '0';

            -- This mode transfer one single word
          when SINGLE =>

            m_axis_tvalid <= '1';
            m_axis_tlast  <= '1';
            m_axis_tdata  <= rd_fdata;
            wait until clk = '1';
            -- If there is timeout for tready configured, wait for tready or until timeout. If not, wait forever for tready
            if param_timeout_tready > 0 ns then
              wait on clk until clk = '1' and m_axis_tready = '1' for param_timeout_tready;
            else
              wait on clk until clk = '1' and m_axis_tready = '1';
            end if;

            if m_axis_tready /= '1' then
              --rep_failure ("Timeout of AXI TREADY. Ready : " & to_string(m_axis_tready) & "Expected: 1");
            end if;

            m_axis_tvalid <= '0';
            m_axis_tlast  <= '0';

            exit l_axi_tx;

            -- This mode transfers a fixed number of words
          when BURST =>

            m_axis_tvalid <= '1';
            -- Assert tlast signal when transmitting last word
            if v_burst_count = param_num_words then
              m_axis_tlast <= '1';
            end if;
            m_axis_tdata <= rd_fdata;
            wait until clk = '1';

            -- If there is timeout for tready configured, wait for tready or until timeout. If not, wait forever for tready
            if param_timeout_tready > 0 ns then
              wait on clk until clk = '1' and m_axis_tready = '1' for param_timeout_tready;
            else
              wait on clk until clk = '1' and m_axis_tready = '1';
            end if;

            if m_axis_tready /= '1' then
              --rep_failure ("Timeout of AXI TREADY. Ready : " & to_string(m_axis_tready) & "Expected: 1");
            end if;
            m_axis_tvalid <= '0';

            -- Exit transmission loop after transmission of last word
            if m_axis_tlast = '1' then
              m_axis_tlast <= '0';
              v_burst_count := 1;
              exit l_axi_tx;
            else
              v_burst_count := v_burst_count + 1;
            end if;

        end case;
      end if;
    end loop;
    -- End FIFO Status flags
    -- ======================

  end process;

end architecture beh;
---------------------------------------------------------------------------------