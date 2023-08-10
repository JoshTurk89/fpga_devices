
--------------------------------------------------------------------------------
--
-- COMPANY CONFIDENTIAL
-- Copyright (c) TECNOBIT 2017
--
-- TECNOBIT S.L.
--
-- Filename               : agent_axifull_mst.vhd
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

entity agent_axifull_mst is
  generic (
    --------------------------------------------------------------------------------
    ------------------- AXI GENERICS -----------------------------------------------
    --------------------------------------------------------------------------------
    G_AXI_ADDR_WIDTH   : positive := 35;
    G_AXI_DATA_WIDTH   : positive := 32;
    G_AXI_ID_WIDTH     : positive := 4;
    G_AXI_AWUSER_WIDTH : positive := 1;
    G_AXI_WUSER_WIDTH  : positive := 1;
    G_AXI_ARUSER_WIDTH : positive := 1;
    G_AXI_RUSER_WIDTH  : positive := 1;
    G_AXI_BUSER_WIDTH  : positive := 1;
    --------------------------------------------------------------------------------
    ------------------- INTERNAL GENERICS ------------------------------------------
    --------------------------------------------------------------------------------
    G_BUFFER_WIDTH     : positive := 4;
    G_SIZE_ARRAY       : positive := 10
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
    ---------------- WR DATA CHANNEL -----------------------------------------------
    --------------------------------------------------------------------------------
    M_AXI_WID      : out std_logic_vector (G_AXI_ID_WIDTH - 1 downto 0);
    M_AXI_WDATA    : out std_logic_vector (G_AXI_DATA_WIDTH - 1 downto 0);
    M_AXI_WSTRB    : out std_logic_vector ((G_AXI_DATA_WIDTH/8) - 1 downto 0);
    M_AXI_WUSER    : out std_logic_vector (G_AXI_WUSER_WIDTH - 1 downto 0);
    M_AXI_WLAST    : out std_logic;
    M_AXI_WVALID   : out std_logic;
    M_AXI_WREADY   : in  std_logic;
    --------------------------------------------------------------------------------
    ---------------- WR RESPONSE CHANNEL -------------------------------------------
    --------------------------------------------------------------------------------
    M_AXI_BID      : in  std_logic_vector (G_AXI_ID_WIDTH - 1 downto 0);
    M_AXI_BRESP    : in  std_logic_vector (1 downto 0);
    M_AXI_BUSER    : in  std_logic_vector (G_AXI_BUSER_WIDTH - 1 downto 0);
    M_AXI_BVALID   : in  std_logic;
    M_AXI_BREADY   : out std_logic;
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
    ---------------- RD DATA CHANNEL -----------------------------------------------
    --------------------------------------------------------------------------------
    M_AXI_RID      : in  std_logic_vector (G_AXI_ID_WIDTH - 1 downto 0);
    M_AXI_RDATA    : in  std_logic_vector (G_AXI_DATA_WIDTH - 1 downto 0);
    M_AXI_RUSER    : in  std_logic_vector (G_AXI_RUSER_WIDTH - 1 downto 0);
    M_AXI_RRESP    : in  std_logic_vector (1 downto 0);
    M_AXI_RLAST    : in  std_logic;
    M_AXI_RVALID   : in  std_logic;
    M_AXI_RREADY   : out std_logic;
    --------------------------------------------------------------------------------
    -------------- SEQUENCES SIGNALS -----------------------------------------------
    --------------------------------------------------------------------------------
    SQ_START       : in  std_logic;
    SQ_BUSY        : out std_logic;
    SQ_WR_AXI_SIG  : in  t_wr_axifull_mst(mem(0 to (2 ** G_SIZE_ARRAY) - 1)(G_AXI_DATA_WIDTH - 1 downto 0));
    SQ_RD_AXI_SIG  : in  t_rd_axifull_mst;
    SQ_RD_AXI_MEM  : out t_rd_axifull_mst_mem(mem(0 to (2 ** G_BUFFER_WIDTH) - 1)(G_AXI_DATA_WIDTH - 1 downto 0))
  );
end agent_axifull_mst;

architecture beh of agent_axifull_mst is

  signal tb_wr_new_burst  : std_logic;
  signal tb_rd_new_burst  : std_logic;
  signal tb_wr_burst_sts  : std_logic_vector (15 downto 0);
  signal tb_rd_burst_sts  : std_logic_vector (15 downto 0);
  signal tb_ff_full       : std_logic;
  signal tb_ff_empty      : std_logic;
  signal tb_burst_end     : std_logic;
  signal tb_sq_busy       : std_logic;
  signal tb_sq_wraddr_run : std_logic;
  signal tb_sq_rdaddr_run : std_logic;
  signal tb_sq_rddata_run : std_logic;

begin

  tb_sq_busy <= tb_sq_wraddr_run or not(tb_ff_empty) or tb_sq_rdaddr_run or tb_sq_rddata_run;

  process
  begin
    SQ_BUSY <= '0';
    wait until SQ_START'event and SQ_START = '1';
    SQ_BUSY <= '1';
    wait until tb_sq_busy'event and tb_sq_busy = '0';
  end process;

  --------------------------------------------------------------------------------
  ---------------------- COMPONENT INSTANTIATION ---------------------------------
  --------------------------------------------------------------------------------

  -- WR ADDR CHANNEL
  wr_addr_chnn : axifull_wraddr_chnn_mst
  generic map(
    G_AXI_ADDR_WIDTH   => G_AXI_ADDR_WIDTH,
    G_AXI_DATA_WIDTH   => G_AXI_DATA_WIDTH,
    G_AXI_ID_WIDTH     => G_AXI_ID_WIDTH,
    G_AXI_AWUSER_WIDTH => G_AXI_AWUSER_WIDTH
  )
  port map(
    ACLK           => ACLK,
    ARESET_N       => ARESET_N,
    -------------------------------------------------------------------------------
    ---------------- WR ADDR CHANNEL ----------------------------------------------
    -------------------------------------------------------------------------------
    M_AXI_AWID     => M_AXI_AWID,
    M_AXI_AWADDR   => M_AXI_AWADDR,
    M_AXI_AWUSER   => M_AXI_AWUSER,
    M_AXI_AWLEN    => M_AXI_AWLEN,
    M_AXI_AWSIZE   => M_AXI_AWSIZE,
    M_AXI_AWBURST  => M_AXI_AWBURST,
    M_AXI_AWLOCK   => M_AXI_AWLOCK,
    M_AXI_AWCACHE  => M_AXI_AWCACHE,
    M_AXI_AWPROT   => M_AXI_AWPROT,
    M_AXI_AWREGION => M_AXI_AWREGION,
    M_AXI_AWQOS    => M_AXI_ARQOS,
    M_AXI_AWVALID  => M_AXI_AWVALID,
    M_AXI_AWREADY  => M_AXI_AWREADY,
    -------------------------------------------------------------------------------
    ---------------- LINK TO WR DATA CHANNEL --------------------------------------
    -------------------------------------------------------------------------------
    NEW_BURST      => tb_wr_new_burst,
    BURST_STATUS   => tb_wr_burst_sts,
    FIFO_FULL      => tb_ff_full,
    -------------------------------------------------------------------------------
    -------------- SEQUENCES SIGNALS ----------------------------------------------
    -------------------------------------------------------------------------------
    SQ_WRADDR_RUN  => tb_sq_wraddr_run,
    SQ_START       => SQ_START,
    SQ_WR_AXI_SIG  => SQ_WR_AXI_SIG
  );

  -- WR DATA CHANNEL
  wr_data_chnn : axifull_wrdata_chnn_mst
  generic map(
    G_AXI_DATA_WIDTH  => G_AXI_DATA_WIDTH,
    G_AXI_ID_WIDTH    => G_AXI_ID_WIDTH,
    G_AXI_WUSER_WIDTH => G_AXI_WUSER_WIDTH,
    G_BUFFER_WIDTH    => G_BUFFER_WIDTH
  )
  port map(
    ACLK          => ACLK,
    ARESET_N      => ARESET_N,
    -------------------------------------------------------------------------------
    ---------------- WR DATA CHANNEL ----------------------------------------------
    -------------------------------------------------------------------------------
    M_AXI_WID     => M_AXI_WID,
    M_AXI_WDATA   => M_AXI_WDATA,
    M_AXI_WSTRB   => M_AXI_WSTRB,
    M_AXI_WUSER   => M_AXI_WUSER,
    M_AXI_WLAST   => M_AXI_WLAST,
    M_AXI_WVALID  => M_AXI_WVALID,
    M_AXI_WREADY  => M_AXI_WREADY,
    -------------------------------------------------------------------------------
    ---------------- LINK TO WR ADDR CHANNEL --------------------------------------
    -------------------------------------------------------------------------------
    NEW_BURST     => tb_wr_new_burst,
    BURST_STATUS  => tb_wr_burst_sts,
    FIFO_FULL     => tb_ff_full,
    FIFO_EMPTY    => tb_ff_empty,
    -------------------------------------------------------------------------------
    -------------- SEQUENCES SIGNALS ----------------------------------------------
    -------------------------------------------------------------------------------
    SQ_WRADDR_RUN => tb_sq_wraddr_run,
    SQ_WR_AXI_SIG => SQ_WR_AXI_SIG
  );

  -- WR BRESP CHANNEL
  wr_bresp_chnn : axifull_wrbresp_chnn_mst
  generic map(
    G_AXI_ID_WIDTH    => G_AXI_ID_WIDTH,
    G_AXI_BUSER_WIDTH => G_AXI_BUSER_WIDTH
  )
  port map(
    ACLK         => ACLK,
    ARESET_N     => ARESET_N,
    -------------------------------------------------------------------------------
    ---------------- WR RESPONSE CHANNEL ------------------------------------------
    -------------------------------------------------------------------------------
    M_AXI_BID    => M_AXI_BID,
    M_AXI_BRESP  => M_AXI_BRESP,
    M_AXI_BUSER  => M_AXI_BUSER,
    M_AXI_BVALID => M_AXI_BVALID,
    M_AXI_BREADY => M_AXI_BREADY
  );

  -- RD ADDR CHANNEL
  rd_addr_chnn : axifull_rdaddr_chnn_mst
  generic map(
    G_AXI_ADDR_WIDTH   => G_AXI_ADDR_WIDTH,
    G_AXI_DATA_WIDTH   => G_AXI_DATA_WIDTH,
    G_AXI_ID_WIDTH     => G_AXI_ID_WIDTH,
    G_AXI_ARUSER_WIDTH => G_AXI_ARUSER_WIDTH
  )
  port map(
    ACLK           => ACLK,
    ARESET_N       => ARESET_N,
    -------------------------------------------------------------------------------
    ---------------- RD ADDR CHANNEL ----------------------------------------------
    -------------------------------------------------------------------------------
    M_AXI_ARID     => M_AXI_ARID,
    M_AXI_ARADDR   => M_AXI_ARADDR,
    M_AXI_ARUSER   => M_AXI_ARUSER,
    M_AXI_ARLEN    => M_AXI_ARLEN,
    M_AXI_ARSIZE   => M_AXI_ARSIZE,
    M_AXI_ARBURST  => M_AXI_ARBURST,
    M_AXI_ARLOCK   => M_AXI_ARLOCK,
    M_AXI_ARCACHE  => M_AXI_ARCACHE,
    M_AXI_ARPROT   => M_AXI_ARPROT,
    M_AXI_ARREGION => M_AXI_ARREGION,
    M_AXI_ARQOS    => M_AXI_ARQOS,
    M_AXI_ARVALID  => M_AXI_ARVALID,
    M_AXI_ARREADY  => M_AXI_ARREADY,
    -------------------------------------------------------------------------------
    ---------------- LINK TO RD DATA CHANNEL --------------------------------------
    -------------------------------------------------------------------------------
    NEW_BURST      => tb_rd_new_burst,
    BURST_STATUS   => tb_rd_burst_sts,
    BURST_END      => tb_burst_end,
    -------------------------------------------------------------------------------
    -------------- SEQUENCES SIGNALS ----------------------------------------------
    -------------------------------------------------------------------------------
    SQ_RDADDR_RUN  => tb_sq_rdaddr_run,
    SQ_START       => SQ_START,
    SQ_RD_AXI_SIG  => SQ_RD_AXI_SIG
  );

  -- RD DATA CHANNEL
  rd_data_chnn : axifull_rddata_chnn_mst
  generic map(
    G_AXI_DATA_WIDTH  => G_AXI_DATA_WIDTH,
    G_AXI_ID_WIDTH    => G_AXI_ID_WIDTH,
    G_AXI_RUSER_WIDTH => G_AXI_RUSER_WIDTH,
    G_BUFFER_WIDTH    => G_BUFFER_WIDTH
  )
  port map(
    ACLK          => ACLK,
    ARESET_N      => ARESET_N,
    -------------------------------------------------------------------------------
    ---------------- RD ADDR CHANNEL ----------------------------------------------
    -------------------------------------------------------------------------------
    M_AXI_RID     => M_AXI_RID,
    M_AXI_RDATA   => M_AXI_RDATA,
    M_AXI_RUSER   => M_AXI_RUSER,
    M_AXI_RRESP   => M_AXI_RRESP,
    M_AXI_RLAST   => M_AXI_RLAST,
    M_AXI_RVALID  => M_AXI_RVALID,
    M_AXI_RREADY  => M_AXI_RREADY,
    -------------------------------------------------------------------------------
    ---------------- LINK TO RD DATA CHANNEL --------------------------------------
    -------------------------------------------------------------------------------
    NEW_BURST     => tb_rd_new_burst,
    BURST_STATUS  => tb_rd_burst_sts,
    BURST_END     => tb_burst_end,
    -------------------------------------------------------------------------------
    -------------- SEQUENCES SIGNALS ----------------------------------------------
    -------------------------------------------------------------------------------
    SQ_RDADDR_RUN => tb_sq_rdaddr_run,
    SQ_RDDATA_RUN => tb_sq_rddata_run,
    SQ_RD_AXI_SIG => SQ_RD_AXI_SIG,
    SQ_MEM        => SQ_RD_AXI_MEM
  );

end beh;