
--------------------------------------------------------------------------------
--
-- COMPANY CONFIDENTIAL
-- Copyright (c) TECNOBIT 2017
--
-- TECNOBIT S.L.
--
-- Filename               : axifull_rdaddr_chnn_mst.vhd
-- Author                 : jjquintana
-- Creation Date          : 07/JUN/2023
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

entity axifull_rdaddr_chnn_mst is
  generic (
    G_AXI_ADDR_WIDTH   : positive := 35;
    G_AXI_DATA_WIDTH   : positive := 32;
    G_AXI_ID_WIDTH     : positive := 4;
    G_AXI_ARUSER_WIDTH : positive := 16
  );
  port (
    ACLK           : in  std_logic;
    ARESET_N       : in  std_logic;
    --------------------------------------------------------------------------------
    ---------------- RD ADDR CHANNEL -----------------------------------------------
    --------------------------------------------------------------------------------
    M_AXI_ARID     : out std_logic_vector (G_AXI_ID_WIDTH - 1 downto 0);
    M_AXI_ARADDR   : out std_logic_vector (G_AXI_ADDR_WIDTH - 1 downto 0);
    M_AXI_ARUSER   : out std_logic_vector (G_AXI_ARUSER_WIDTH - 1 downto 0);
    M_AXI_ARLEN    : out std_logic_vector (7 downto 0);
    M_AXI_ARSIZE   : out std_logic_vector (2 downto 0);
    M_AXI_ARBURST  : out std_logic_vector (1 downto 0);
    M_AXI_ARLOCK   : out std_logic_vector (0 to 0);
    M_AXI_ARCACHE  : out std_logic_vector (3 downto 0);
    M_AXI_ARPROT   : out std_logic_vector (2 downto 0);
    M_AXI_ARREGION : out std_logic_vector (3 downto 0);
    M_AXI_ARQOS    : out std_logic_vector (3 downto 0);
    M_AXI_ARVALID  : out std_logic;
    M_AXI_ARREADY  : in  std_logic;
    --------------------------------------------------------------------------------
    ---------------- LINK TO WR DATA CHANNEL ---------------------------------------
    --------------------------------------------------------------------------------
    NEW_BURST      : out std_logic;
    BURST_STATUS   : out std_logic_vector (15 downto 0);
    BURST_END      : in  std_logic;
    --------------------------------------------------------------------------------
    -------------- SEQUENCES SIGNALS -----------------------------------------------
    --------------------------------------------------------------------------------
    SQ_RDADDR_RUN  : out std_logic; -- This Signal indicates that this module is still running
    SQ_START       : in  std_logic;
    SQ_RD_AXI_SIG  : in  t_rd_axifull_mst
  );
end axifull_rdaddr_chnn_mst;

architecture beh of axifull_rdaddr_chnn_mst is

  signal m_arid     : std_logic_vector (G_AXI_ID_WIDTH - 1 downto 0);
  signal m_araddr   : std_logic_vector (G_AXI_ADDR_WIDTH - 1 downto 0);
  signal m_aruser   : std_logic_vector (G_AXI_ARUSER_WIDTH - 1 downto 0);
  signal m_arlen    : std_logic_vector (7 downto 0);
  signal m_arsize   : std_logic_vector (2 downto 0);
  signal m_arburst  : std_logic_vector (1 downto 0);
  signal m_arlock   : std_logic_vector (0 to 0);
  signal m_arcache  : std_logic_vector (3 downto 0);
  signal m_arprot   : std_logic_vector (2 downto 0);
  signal m_arregion : std_logic_vector (3 downto 0);
  signal m_arqos    : std_logic_vector (3 downto 0);
  signal m_arvalid  : std_logic;

  signal arvalid    : std_logic;
  signal burst_sts  : std_logic_vector (15 downto 0);

  signal rdaddr_run : std_logic;

begin

  --------------------------------------------------------------------------------
  --------------------- I/O Connections assignments ------------------------------
  --------------------------------------------------------------------------------
  M_AXI_ARID     <= m_arid;
  M_AXI_ARADDR   <= m_araddr;
  M_AXI_ARUSER   <= m_aruser;
  M_AXI_ARLEN    <= m_arlen;
  M_AXI_ARSIZE   <= m_arsize;
  M_AXI_ARBURST  <= m_arburst;
  M_AXI_ARLOCK   <= m_arlock;
  M_AXI_ARCACHE  <= m_arcache;
  M_AXI_ARPROT   <= m_arprot;
  M_AXI_ARREGION <= m_arregion;
  M_AXI_ARQOS    <= m_arqos;
  M_AXI_ARVALID  <= m_arvalid;

  BURST_STATUS   <= burst_sts;
  NEW_BURST      <= arvalid;

  SQ_RDADDR_RUN  <= rdaddr_run;
  --------------------------------------------------------------------------------
  ------------ Useless Signals so far (Pending to update) ------------------------
  --------------------------------------------------------------------------------
  useless_sig : process (ACLK)
  begin
    if rising_edge(ACLK) then
      if ARESET_N = '0' then
        m_arid     <= (others => '0');
        m_aruser   <= (others => '0');
        m_arlock   <= (others => '0');
        m_arcache  <= (others => '0');
        m_arprot   <= (others => '0');
        m_arregion <= (others => '0');
        m_arqos    <= (others => '0');
      else
        m_arid     <= (others => '0');
        m_aruser   <= (others => '0');
        m_arlock   <= (others => '0');
        m_arcache  <= (others => '0');
        m_arprot   <= (others => '0');
        m_arregion <= (others => '0');
        m_arqos    <= (others => '0');
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
    variable v_araddr        : unsigned (63 downto 0)         := (others => '0');
    variable v_reset         : boolean                        := True;
  begin

    if v_reset then
      m_araddr  <= (others => '0');
      m_arlen   <= (others => '0');
      m_arsize  <= (others => '0');
      m_arburst <= (others => '0');
      burst_sts <= (others => '0');
      v_reset := False;
    end if;

    v_size_data     := 0;
    v_size_data_aux := 0;
    v_len_axi       := 0;
    v_size_axi      := 0;
    v_addr_offset   := 0;
    v_araddr        := (others => '0');
    arvalid    <= '0';
    rdaddr_run <= '0';

    wait until SQ_START'event and SQ_START = '1';

    if SQ_RD_AXI_SIG.rd_chnn_en = '1' then

      m_arburst  <= SQ_RD_AXI_SIG.burst_axi_sig;
      rdaddr_run <= '1';

      v_araddr    := unsigned(SQ_RD_AXI_SIG.src_addr_msb) & unsigned(SQ_RD_AXI_SIG.src_addr_lsb);
      v_size_data := SQ_RD_AXI_SIG.size_data;
      v_len_axi   := to_integer(unsigned(SQ_RD_AXI_SIG.len_axi_sig)) + 1;
      v_size_axi  := G_AXI_DATA_WIDTH/8;

      while v_size_data > 0 loop

        -- Normal Transmission
        if v_size_data >= (v_len_axi * v_size_axi) then
          v_size_data := v_size_data - (v_len_axi * v_size_axi);
          v_burst_sts := '0' & std_logic_vector(to_unsigned(v_size_axi, 7)) & std_logic_vector(to_unsigned(v_len_axi, m_arlen'length));

          -- Last Transmission with different v_len_axi
        elsif (v_size_data > v_size_axi) and (v_size_data mod v_size_axi = 0) then
          v_len_axi   := v_size_data / v_size_axi;
          v_size_data := 0;
          v_burst_sts := '0' & std_logic_vector(to_unsigned(v_size_axi, 7)) & std_logic_vector(to_unsigned(v_len_axi, m_arlen'length));

          -- Last Transmission when different v_len_axi and the last data has not all bytes as valid (The word width is bigger than remaining bytes)
        elsif (v_size_data > v_size_axi) and (v_size_data mod v_size_axi /= 0) then
          v_len_axi       := integer(ceil(real(v_size_data) / real(v_size_axi)));
          v_size_data_aux := v_size_data mod v_size_axi; -- The remaining bytes valid        
          v_burst_sts     := '1' & std_logic_vector(to_unsigned(v_size_data_aux, 7)) & std_logic_vector(to_unsigned(v_len_axi, m_arlen'length));
          v_size_data     := 0;

          -- Last Transmission when different v_len_axi and the last data has not all bytes as valid (The remaining bytes fits into in jusat word but not all )
        else
          v_len_axi       := 1;
          v_size_data_aux := v_size_data; -- The remaining bytes valid
          v_burst_sts     := '1' & std_logic_vector(to_unsigned(v_size_data_aux, 7)) & std_logic_vector(to_unsigned(v_len_axi, m_arlen'length));
          v_size_data     := 0;
        end if;

        v_araddr      := v_araddr + to_unsigned(v_addr_offset, 64);
        v_addr_offset := (v_len_axi * v_size_axi);
        m_arlen   <= std_logic_vector(to_unsigned((v_len_axi - 1), m_arlen'length));
        m_arsize  <= std_logic_vector(to_unsigned((natural(ceil(log2(real(v_size_axi))))), m_arsize'length));
        m_araddr  <= std_logic_vector(v_araddr(m_araddr'length - 1 downto 0));
        burst_sts <= v_burst_sts;

        wait until ACLK'event and ACLK = '1';
        arvalid <= '1';
        wait until ACLK'event and ACLK = '1';
        arvalid <= '0';
        wait until ACLK'event and ACLK = '1' and m_arvalid = '1' and M_AXI_ARREADY = '1';

        if v_size_data /= 0 then
          wait until BURST_END'event and BURST_END = '1';
        end if;

      end loop;

    end if;

  end process;

  --------------------------------------------------------------------------------
  --------------------------- Gen AWVALID ----------------------------------------
  --------------------------------------------------------------------------------

  arvalid_proc : process (ACLK)
  begin
    if rising_edge(ACLK) then
      if ARESET_N = '0' then
        m_arvalid <= '0';
      else
        if (arvalid = '1') then
          m_arvalid <= '1';
        elsif (m_arvalid = '1' and M_AXI_ARREADY = '1') then
          m_arvalid <= '0';
        end if;
      end if;
    end if;
  end process arvalid_proc;

end beh;