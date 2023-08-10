
--------------------------------------------------------------------------------
--
-- COMPANY CONFIDENTIAL
-- Copyright (c) TECNOBIT 2017
--
-- TECNOBIT S.L.
--
-- Filename               : axifull_wrdata_chnn_mst.vhd
-- Author                 : jjquintana
-- Creation Date          : 23/MAY/2023
-- Origin Project         : N/A
-- Repo path              :
-- Architecture           : no-synthesizable
-- Functional description : 
--
-- Version                : 0.0.0 -> (jjquintana) First Version. File Created.
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

library work;
use work.logger_pkg.all;
use work.tb_common_pkg.all;
use work.agent_axifull_mst_pkg.all;

entity axifull_wrdata_chnn_mst is
  generic (
    G_AXI_DATA_WIDTH  : positive := 32;
    G_AXI_ID_WIDTH    : positive := 4;
    G_AXI_WUSER_WIDTH : positive := 16;
    G_BUFFER_WIDTH    : positive := 4
  );
  port (
    ACLK          : in  std_logic;
    ARESET_N      : in  std_logic;
    --------------------------------------------------------------------------------
    ---------------- WR ADDR CHANNEL -----------------------------------------------
    --------------------------------------------------------------------------------
    M_AXI_WID     : out std_logic_vector (G_AXI_ID_WIDTH - 1 downto 0);
    M_AXI_WDATA   : out std_logic_vector (G_AXI_DATA_WIDTH - 1 downto 0);
    M_AXI_WSTRB   : out std_logic_vector ((G_AXI_DATA_WIDTH/8) - 1 downto 0);
    M_AXI_WUSER   : out std_logic_vector (G_AXI_WUSER_WIDTH - 1 downto 0);
    M_AXI_WLAST   : out std_logic;
    M_AXI_WVALID  : out std_logic;
    M_AXI_WREADY  : in  std_logic;
    --------------------------------------------------------------------------------
    ---------------- LINK TO WR DATA CHANNEL ---------------------------------------
    --------------------------------------------------------------------------------
    NEW_BURST     : in  std_logic;
    BURST_STATUS  : in  std_logic_vector (15 downto 0);
    FIFO_FULL     : out std_logic;
    FIFO_EMPTY    : out std_logic;
    --------------------------------------------------------------------------------
    -------------- SEQUENCES SIGNALS -----------------------------------------------
    --------------------------------------------------------------------------------
    SQ_WRADDR_RUN : in  std_logic; -- This Signal indicates that this module is still running
    SQ_WR_AXI_SIG : in  t_wr_axifull_mst
  );
end axifull_wrdata_chnn_mst;

architecture beh of axifull_wrdata_chnn_mst is

  signal m_wid       : std_logic_vector (G_AXI_ID_WIDTH - 1 downto 0);
  signal m_wdata     : std_logic_vector (G_AXI_DATA_WIDTH - 1 downto 0);
  signal m_wstrb     : std_logic_vector ((G_AXI_DATA_WIDTH/8) - 1 downto 0);
  signal m_wuser     : std_logic_vector (G_AXI_WUSER_WIDTH - 1 downto 0);
  signal m_wlast     : std_logic;
  signal m_wvalid    : std_logic;
  signal m_wvalid_1d : std_logic;

  signal cnt_burst   : integer;
  signal wvalid      : std_logic;

  type t_fifo is array (0 to ((2 ** G_BUFFER_WIDTH) - 1)) of std_logic_vector(15 downto 0);
  signal fifo       : t_fifo;
  signal ff_full    : std_logic;
  signal ff_empty   : std_logic;

  signal burst_sent : std_logic;
  signal wrdata_en  : std_logic;

begin

  --------------------------------------------------------------------------------
  --------------------- I/O Connections assignments ------------------------------
  --------------------------------------------------------------------------------
  M_AXI_WID    <= m_wid;
  M_AXI_WDATA  <= m_wdata;
  M_AXI_WSTRB  <= m_wstrb;
  M_AXI_WUSER  <= m_wuser;
  M_AXI_WLAST  <= m_wlast;
  M_AXI_WVALID <= m_wvalid_1d;

  FIFO_EMPTY   <= ff_empty;
  FIFO_FULL    <= ff_full;

  --------------------------------------------------------------------------------
  ------------ Useless Signals so far (Pending to update) ------------------------
  --------------------------------------------------------------------------------
  useless_sig : process (ACLK)
  begin
    if rising_edge(ACLK) then
      if ARESET_N = '0' then
        m_wid   <= (others => '0');
        m_wuser <= (others => '0');
      else
        m_wid   <= (others => '0');
        m_wuser <= (others => '0');
      end if;
    end if;
  end process useless_sig;

  --------------------------------------------------------------------------------
  ------------ Update AWRADDR, AWLEN, AWSIZE and AWBURST -------------------------
  --------------------------------------------------------------------------------
  wrdata_en <= SQ_WRADDR_RUN or not(ff_empty);

  process
    variable v_prt_mem   : integer := 0;
    variable rd_pointer  : std_logic_vector(G_BUFFER_WIDTH - 1 downto 0);
    variable v_burst_sts : std_logic_vector (15 downto 0) := (others => '0');
    variable v_reset     : boolean                        := True;
  begin

    if v_reset then
      m_wdata <= (others => '0');
      m_wstrb <= (others => '0');
      m_wlast <= '0';
      v_reset := False;
    end if;

    rd_pointer  := (others => '0');
    v_prt_mem   := 0;
    v_burst_sts := (others => '0');
    wvalid  <= '0';
    m_wlast <= '0';

    wait until SQ_WRADDR_RUN'event and SQ_WRADDR_RUN = '1';

    while SQ_WRADDR_RUN or not(ff_empty) loop
      wait until ACLK'event and ACLK = '1';
      if ff_empty = '1' and SQ_WRADDR_RUN = '1' then
        wvalid  <= '0';
        m_wlast <= '0';
        wait until (ff_empty'event and ff_empty = '0') or (SQ_WRADDR_RUN'event);

      elsif (SQ_WRADDR_RUN = '1' or ff_empty = '0') then
        -- New Burst is loaded
        v_burst_sts := fifo(to_integer(unsigned(rd_pointer)));
        rd_pointer  := std_logic_vector(unsigned(rd_pointer) + to_unsigned(1, rd_pointer'length));
        wvalid <= '1';

        -- Run Burst
        for i in 0 to (to_integer(unsigned(v_burst_sts(7 downto 0))) - 1) loop

          -- get_wrstrb(num_bytes, strb_width, flag)
          m_wstrb <= get_wrstrb(to_integer(unsigned(v_burst_sts(14 downto 8))), (G_AXI_DATA_WIDTH/8), v_burst_sts(15));
          m_wdata <= SQ_WR_AXI_SIG.mem(v_prt_mem);
          v_prt_mem := v_prt_mem + 1;

          if i = (to_integer(unsigned(v_burst_sts(7 downto 0))) - 1) then
            m_wlast <= '1';
          else
            m_wlast <= '0';
          end if;
          wait until (ACLK'event and ACLK = '1' and m_wvalid = '1' and M_AXI_WREADY = '1') or SQ_WRADDR_RUN'event or (ff_empty'event and ff_empty = '0');

        end loop;
      end if;
    end loop;

  end process;

  --------------------------------------------------------------------------------
  --------------------------- Gen WVALID -----------------------------------------
  --------------------------------------------------------------------------------

  wvalid_proc : process (ACLK)
  begin
    if rising_edge(ACLK) then
      if ARESET_N = '0' then
        m_wvalid    <= '0';
        m_wvalid_1d <= '0';
      else
        if (wvalid = '1') then
          m_wvalid    <= '1';
          m_wvalid_1d <= m_wvalid;
        elsif (wvalid = '0') then
          m_wvalid    <= '0';
          m_wvalid_1d <= '0';
        end if;
      end if;
    end if;
  end process wvalid_proc;

  --------------------------------------------------------------------------------
  ----------------------------- FIFO ---------------------------------------------
  --------------------------------------------------------------------------------
  burst_sent <= m_wlast and m_wvalid and M_AXI_WREADY;
  counter_bst : process (ACLK)
  begin
    if rising_edge(ACLK) then
      if ARESET_N = '0' then
        cnt_burst <= 0;
      else
        if NEW_BURST = '1' and burst_sent = '1' then
          cnt_burst <= cnt_burst;
        elsif NEW_BURST = '1' then
          cnt_burst <= cnt_burst + 1;
        elsif burst_sent = '1' then
          cnt_burst <= cnt_burst - 1;
        end if;
      end if;
    end if;
  end process counter_bst;

  ff_full <= '1' when cnt_burst = (2 ** G_BUFFER_WIDTH) else
             '0';
  ff_empty <= '1' when cnt_burst = 0 else
              '0';

  process (ACLK)
    variable wr_pointer : std_logic_vector(G_BUFFER_WIDTH - 1 downto 0);
  begin
    if rising_edge(ACLK) then
      if ARESET_N = '0' or wrdata_en = '0' then
        fifo <= (others       => (others => '0'));
        wr_pointer := (others => '0');
      else
        if NEW_BURST = '1' then
          fifo(to_integer(unsigned(wr_pointer))) <= BURST_STATUS;
          wr_pointer := std_logic_vector(unsigned(wr_pointer) + to_unsigned(1, wr_pointer'length));
        end if;
      end if;
    end if;
  end process;

end beh;