
--------------------------------------------------------------------------------
--
-- COMPANY CONFIDENTIAL
-- Copyright (c) TECNOBIT 2017
--
-- TECNOBIT S.L.
--
-- Filename               : axifull_rddata_chnn_mst.vhd
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

entity axifull_rddata_chnn_mst is
  generic (
    G_AXI_DATA_WIDTH  : positive := 32;
    G_AXI_ID_WIDTH    : positive := 4;
    G_AXI_RUSER_WIDTH : positive := 16;
    G_BUFFER_WIDTH    : positive := 4
  );
  port (
    ACLK          : in  std_logic;
    ARESET_N      : in  std_logic;
    --------------------------------------------------------------------------------
    ---------------- RD DATA CHANNEL -----------------------------------------------
    --------------------------------------------------------------------------------
    M_AXI_RID     : in  std_logic_vector (G_AXI_ID_WIDTH - 1 downto 0);
    M_AXI_RDATA   : in  std_logic_vector (G_AXI_DATA_WIDTH - 1 downto 0);
    M_AXI_RUSER   : in  std_logic_vector (G_AXI_RUSER_WIDTH - 1 downto 0);
    M_AXI_RRESP   : in  std_logic_vector (1 downto 0);
    M_AXI_RLAST   : in  std_logic;
    M_AXI_RVALID  : in  std_logic;
    M_AXI_RREADY  : out std_logic;
    --------------------------------------------------------------------------------
    ---------------- LINK TO RD ADDR CHANNEL ---------------------------------------
    --------------------------------------------------------------------------------
    NEW_BURST     : in  std_logic;
    BURST_STATUS  : in  std_logic_vector (15 downto 0);
    BURST_END     : out std_logic;
    --------------------------------------------------------------------------------
    -------------- SEQUENCES SIGNALS -----------------------------------------------
    --------------------------------------------------------------------------------
    SQ_RDADDR_RUN : in  std_logic; -- This Signal indicates that this module is still running
    SQ_RDDATA_RUN : out std_logic;
    SQ_RD_AXI_SIG : in  t_rd_axifull_mst;
    SQ_MEM        : out t_rd_axifull_mst_mem
  );
end axifull_rddata_chnn_mst;

architecture beh of axifull_rddata_chnn_mst is

  signal m_rready   : std_logic;

  signal burstend   : std_logic;
  signal rready     : std_logic;
  signal rd_pointer : std_logic_vector(G_BUFFER_WIDTH - 1 downto 0);
  signal mem_out    : t_std_logic_vector_array (0 to ((2 ** G_BUFFER_WIDTH) - 1))(G_AXI_DATA_WIDTH - 1 downto 0);
  signal rddata_run : std_logic;

begin

  --------------------------------------------------------------------------------
  --------------------- I/O Connections assignments ------------------------------
  --------------------------------------------------------------------------------
  SQ_MEM.mem    <= mem_out;
  M_AXI_RREADY  <= m_rready;
  BURST_END     <= burstend;
  SQ_RDDATA_RUN <= rddata_run;

  process

    variable v_burst_sts : std_logic_vector (15 downto 0) := (others => '0');
    variable v_reset     : boolean                        := True;
  begin

    if v_reset then

      v_burst_sts := (others => '0');
      rddata_run <= '0';
      rready     <= '0';
      burstend   <= '0';
      v_reset := False;
    end if;

    v_burst_sts := (others => '0');
    rready     <= '0';
    burstend   <= '0';
    rddata_run <= '0';

    wait until SQ_RDADDR_RUN'event and SQ_RDADDR_RUN = '1';

    while SQ_RDADDR_RUN loop
      rddata_run <= '1';
      wait until NEW_BURST'event and NEW_BURST = '1';
      v_burst_sts := BURST_STATUS;

      for i in 0 to (to_integer(unsigned(v_burst_sts(7 downto 0))) - 1) loop

        rready <= '1';

        wait until (ACLK'event and ACLK = '1' and m_rready = '1' and M_AXI_RVALID = '1');

        if i = (to_integer(unsigned(v_burst_sts(7 downto 0))) - 1) then
          rready <= '0';
          rddata_run <= '0';
        end if;

      end loop;

      burstend <= '1';
      wait until ACLK'event and ACLK = '1';
      burstend <= '0';

    end loop;

  end process;

  read_data : process (ACLK)
  begin
    if rising_edge(ACLK) then
      if ARESET_N = '0' then
        mem_out    <= (others => (others => '0'));
        rd_pointer <= (others => '0');
      else
        if (m_rready = '1' and M_AXI_RVALID = '1') then
          mem_out(to_integer(unsigned(rd_pointer))) <= M_AXI_RDATA;
          rd_pointer                                <= std_logic_vector(unsigned(rd_pointer) + to_unsigned(1, rd_pointer'length));
        end if;
      end if;
    end if;
  end process read_data;

  --------------------------------------------------------------------------------
  --------------------------- Gen RREADY -----------------------------------------
  --------------------------------------------------------------------------------

  rready_proc : process (ACLK)
  begin
    if rising_edge(ACLK) then
      if ARESET_N = '0' then
        m_rready <= '0';
      else
        if (rready = '1') then
          m_rready <= '1';
        elsif (rready = '0') then
          m_rready <= '0';
        end if;
      end if;
    end if;
  end process rready_proc;

end beh;