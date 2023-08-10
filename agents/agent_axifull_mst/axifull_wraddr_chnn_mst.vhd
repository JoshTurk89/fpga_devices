
--------------------------------------------------------------------------------
--
-- COMPANY CONFIDENTIAL
-- Copyright (c) TECNOBIT 2017
--
-- TECNOBIT S.L.
--
-- Filename               : axifull_wraddr_chnn_mst.vhd
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

entity axifull_wraddr_chnn_mst is
  generic (
    G_AXI_ADDR_WIDTH   : positive := 35;
    G_AXI_DATA_WIDTH   : positive := 32;
    G_AXI_ID_WIDTH     : positive := 4;
    G_AXI_AWUSER_WIDTH : positive := 16
  );
  port (
    ACLK           : in  std_logic;
    ARESET_N       : in  std_logic;
    --------------------------------------------------------------------------------
    ---------------- WR ADDR CHANNEL -----------------------------------------------
    --------------------------------------------------------------------------------
    M_AXI_AWID     : out std_logic_vector (G_AXI_ID_WIDTH - 1 downto 0);
    M_AXI_AWADDR   : out std_logic_vector (G_AXI_ADDR_WIDTH - 1 downto 0);
    M_AXI_AWUSER   : out std_logic_vector (G_AXI_AWUSER_WIDTH - 1 downto 0);
    M_AXI_AWLEN    : out std_logic_vector (7 downto 0);
    M_AXI_AWSIZE   : out std_logic_vector (2 downto 0);
    M_AXI_AWBURST  : out std_logic_vector (1 downto 0);
    M_AXI_AWLOCK   : out std_logic_vector (0 to 0);
    M_AXI_AWCACHE  : out std_logic_vector (3 downto 0);
    M_AXI_AWPROT   : out std_logic_vector (2 downto 0);
    M_AXI_AWREGION : out std_logic_vector (3 downto 0);
    M_AXI_AWQOS    : out std_logic_vector (3 downto 0);
    M_AXI_AWVALID  : out std_logic;
    M_AXI_AWREADY  : in  std_logic;
    --------------------------------------------------------------------------------
    ---------------- LINK TO WR DATA CHANNEL ---------------------------------------
    --------------------------------------------------------------------------------
    NEW_BURST      : out std_logic;
    BURST_STATUS   : out std_logic_vector (15 downto 0);
    FIFO_FULL      : in  std_logic;
    --------------------------------------------------------------------------------
    -------------- SEQUENCES SIGNALS -----------------------------------------------
    --------------------------------------------------------------------------------
    SQ_WRADDR_RUN  : out std_logic; -- This Signal indicates that this module is still running
    SQ_START       : in  std_logic;
    SQ_WR_AXI_SIG  : in  t_wr_axifull_mst
  );
end axifull_wraddr_chnn_mst;

architecture beh of axifull_wraddr_chnn_mst is

  signal m_awid     : std_logic_vector (G_AXI_ID_WIDTH - 1 downto 0);
  signal m_awaddr   : std_logic_vector (G_AXI_ADDR_WIDTH - 1 downto 0);
  signal m_awuser   : std_logic_vector (G_AXI_AWUSER_WIDTH - 1 downto 0);
  signal m_awlen    : std_logic_vector (7 downto 0);
  signal m_awsize   : std_logic_vector (2 downto 0);
  signal m_awburst  : std_logic_vector (1 downto 0);
  signal m_awlock   : std_logic_vector (0 to 0);
  signal m_awcache  : std_logic_vector (3 downto 0);
  signal m_awprot   : std_logic_vector (2 downto 0);
  signal m_awregion : std_logic_vector (3 downto 0);
  signal m_awqos    : std_logic_vector (3 downto 0);
  signal m_awvalid  : std_logic;

  signal awvalid    : std_logic;
  signal burst_sts  : std_logic_vector (15 downto 0);

  signal wraddr_run : std_logic;

begin

  --------------------------------------------------------------------------------
  --------------------- I/O Connections assignments ------------------------------
  --------------------------------------------------------------------------------
  M_AXI_AWID     <= m_awid;
  M_AXI_AWADDR   <= m_awaddr;
  M_AXI_AWUSER   <= m_awuser;
  M_AXI_AWLEN    <= m_awlen;
  M_AXI_AWSIZE   <= m_awsize;
  M_AXI_AWBURST  <= m_awburst;
  M_AXI_AWLOCK   <= m_awlock;
  M_AXI_AWCACHE  <= m_awcache;
  M_AXI_AWPROT   <= m_awprot;
  M_AXI_AWREGION <= m_awregion;
  M_AXI_AWQOS    <= m_awqos;
  M_AXI_AWVALID  <= m_awvalid;

  NEW_BURST      <= awvalid;
  BURST_STATUS   <= burst_sts;

  SQ_WRADDR_RUN  <= wraddr_run;
  --------------------------------------------------------------------------------
  ------------ Useless Signals so far (Pending to update) ------------------------
  --------------------------------------------------------------------------------
  useless_sig : process (ACLK)
  begin
    if rising_edge(ACLK) then
      if ARESET_N = '0' then
        m_awid     <= (others => '0');
        m_awuser   <= (others => '0');
        m_awlock   <= (others => '0');
        m_awcache  <= (others => '0');
        m_awprot   <= (others => '0');
        m_awregion <= (others => '0');
        m_awqos    <= (others => '0');
      else
        m_awid     <= (others => '0');
        m_awuser   <= (others => '0');
        m_awlock   <= (others => '0');
        m_awcache  <= (others => '0');
        m_awprot   <= (others => '0');
        m_awregion <= (others => '0');
        m_awqos    <= (others => '0');
      end if;
    end if;
  end process useless_sig;

  --------------------------------------------------------------------------------
  ------------ Update AWRADDR, AWLEN, AWSIZE and AWBURST -------------------------
  --------------------------------------------------------------------------------

  process
    variable v_size_data     : integer                        := 0;
    variable v_size_data_aux : integer                        := 0;
    variable v_len_axi       : integer                        := 0;
    variable v_size_axi      : integer                        := 0;
    variable v_addr_offset   : integer                        := 0;
    variable v_burst_sts     : std_logic_vector (15 downto 0) := (others => '0');
    variable v_awaddr        : unsigned (63 downto 0)         := (others => '0');
    variable v_reset         : boolean                        := True;
  begin

    if v_reset then
      m_awaddr  <= (others => '0');
      m_awlen   <= (others => '0');
      m_awsize  <= (others => '0');
      m_awburst <= (others => '0');
      burst_sts <= (others => '0');
      v_reset := False;
    end if;

    v_size_data     := 0;
    v_size_data_aux := 0;
    v_len_axi       := 0;
    v_size_axi      := 0;
    v_addr_offset   := 0;
    v_awaddr        := (others => '0');
    awvalid    <= '0';
    wraddr_run <= '0';

    wait until SQ_START'event and SQ_START = '1';

    if SQ_WR_AXI_SIG.wr_chnn_en = '1' then
      
      v_awaddr := unsigned(SQ_WR_AXI_SIG.dst_addr_msb) & unsigned(SQ_WR_AXI_SIG.dst_addr_lsb);
      m_awburst <= SQ_WR_AXI_SIG.burst_axi_sig;
      v_size_data := SQ_WR_AXI_SIG.size_data;
      v_len_axi   := to_integer(unsigned(SQ_WR_AXI_SIG.len_axi_sig)) + 1;
      v_size_axi  := G_AXI_DATA_WIDTH/8;
      wraddr_run <= '1';

      while v_size_data > 0 loop

        -- This case is to stop wraddr channel because wrdata channel cannot store more burst in the buffer
        if FIFO_FULL = '1' then
          awvalid <= '0';
          wait until FIFO_FULL'event and FIFO_FULL = '0';

        else

          -- Normal Transmission
          if v_size_data >= (v_len_axi * v_size_axi) then
            v_size_data := v_size_data - (v_len_axi * v_size_axi);
            v_burst_sts := '0' & std_logic_vector(to_unsigned(v_size_axi, 7)) & std_logic_vector(to_unsigned(v_len_axi, m_awlen'length));

            -- Last Transmission with different v_len_axi
          elsif (v_size_data > v_size_axi) and (v_size_data mod v_size_axi = 0) then
            v_len_axi   := v_size_data / v_size_axi;
            v_size_data := 0;
            v_burst_sts := '0' & std_logic_vector(to_unsigned(v_size_axi, 7)) & std_logic_vector(to_unsigned(v_len_axi, m_awlen'length));

            -- Last Transmission when different v_len_axi and the last data has not all bytes as valid (The word width is bigger than remaining bytes)
          elsif (v_size_data > v_size_axi) and (v_size_data mod v_size_axi /= 0) then
            v_len_axi       := integer(ceil(real(v_size_data) / real(v_size_axi)));
            v_size_data_aux := v_size_data mod v_size_axi; -- The remaining bytes valid        
            v_burst_sts     := '1' & std_logic_vector(to_unsigned(v_size_data_aux, 7)) & std_logic_vector(to_unsigned(v_len_axi, m_awlen'length));
            v_size_data     := 0;

            -- Last Transmission when different v_len_axi and the last data has not all bytes as valid (The remaining bytes fits into in jusat word but not all )
          else
            v_len_axi       := 1;
            v_size_data_aux := v_size_data; -- The remaining bytes valid
            v_burst_sts     := '1' & std_logic_vector(to_unsigned(v_size_data_aux, 7)) & std_logic_vector(to_unsigned(v_len_axi, m_awlen'length));
            v_size_data     := 0;
          end if;
          v_awaddr      := v_awaddr + to_unsigned(v_addr_offset, 64);
          v_addr_offset := (v_len_axi * v_size_axi);
          m_awlen   <= std_logic_vector(to_unsigned((v_len_axi - 1), m_awlen'length));
          m_awsize  <= std_logic_vector(to_unsigned((natural(ceil(log2(real(v_size_axi))))), m_awsize'length));
          m_awaddr  <= std_logic_vector(v_awaddr(m_awaddr'length - 1 downto 0));
          burst_sts <= v_burst_sts;

          wait until ACLK'event and ACLK = '1';
          awvalid <= '1';
          wait until ACLK'event and ACLK = '1';
          awvalid <= '0';
          wait until ACLK'event and ACLK = '1' and m_awvalid = '1' and M_AXI_AWREADY = '1';

        end if;

      end loop;

    end if;

  end process;

  --------------------------------------------------------------------------------
  --------------------------- Gen AWVALID ----------------------------------------
  --------------------------------------------------------------------------------

  awvalid_proc : process (ACLK)
  begin
    if rising_edge(ACLK) then
      if ARESET_N = '0' then
        m_awvalid <= '0';
      else
        if (awvalid = '1') then
          m_awvalid <= '1';
        elsif (m_awvalid = '1' and M_AXI_AWREADY = '1') then
          m_awvalid <= '0';
        end if;
      end if;
    end if;
  end process awvalid_proc;

end beh;