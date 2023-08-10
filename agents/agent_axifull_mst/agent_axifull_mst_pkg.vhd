
------------------------------------------------------------------------------- 
--  
-- COMPANY CONFIDENTIAL 
-- Copyright (c) TECNOBIT  2017 
--  
-- TECNOBIT S.L. 
--  
-- Filename               : agent_axifull_mst_pkg.vhd 
-- Author                 : jjquintana
-- Creation Date          : 24/05/2023
-- Repo path              : 
-- Architecture           : no-synthesizable 
-- Functional description :  
--  
--
-- Version                : 0.0.0 -> (jjquintana) First Version. File Created.
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.logger_pkg.all;
use work.tb_common_pkg.all;

package agent_axifull_mst_pkg is

  -------------------------------------------------------------------------------
  --------------------- TYPES DECLARATION ---------------------------------------
  -------------------------------------------------------------------------------

  type t_wr_axifull_mst is record
    mem           : t_std_logic_vector_array;
    wr_chnn_en    : std_logic;
    src_addr_lsb  : std_logic_vector(31 downto 0);
    src_addr_msb  : std_logic_vector(31 downto 0);
    dst_addr_lsb  : std_logic_vector(31 downto 0);
    dst_addr_msb  : std_logic_vector(31 downto 0);
    size_data     : integer;                      -- Bytes
    len_axi_sig   : std_logic_vector(7 downto 0); -- num of data to be transfered in a burst
    size_axi_sig  : std_logic_vector(2 downto 0); -- size of each data to be transfered in a burst
    burst_axi_sig : std_logic_vector(1 downto 0); -- kind of burst according AXI specification
    verbose       : boolean;
  end record;

  type t_rd_axifull_mst is record
    rd_chnn_en    : std_logic;
    src_addr_lsb  : std_logic_vector(31 downto 0);
    src_addr_msb  : std_logic_vector(31 downto 0);
    dst_addr_lsb  : std_logic_vector(31 downto 0);
    dst_addr_msb  : std_logic_vector(31 downto 0);
    size_data     : integer;                      -- Bytes
    len_axi_sig   : std_logic_vector(7 downto 0); -- num of data to be transfered in a burst
    size_axi_sig  : std_logic_vector(2 downto 0); -- size of each data to be transfered in a burst
    burst_axi_sig : std_logic_vector(1 downto 0); -- kind of burst according AXI specification
    verbose       : boolean;
  end record;

  type t_rd_axifull_mst_mem is record
    mem : t_std_logic_vector_array;
  end record;

  -------------------------------------------------------------------------------
  -------------------- FUNCTIONS DECLARATION ------------------------------------
  -------------------------------------------------------------------------------

  function get_wrstrb(num_bytes : integer; strb_width : integer; flag : std_logic) return std_logic_vector;

  -------------------------------------------------------------------------------
  ----------------- COMPONENT DECLARATION ---------------------------------------
  -------------------------------------------------------------------------------

  -- WR ADDR CHANNEL
  component axifull_wraddr_chnn_mst is
    generic (
      G_AXI_ADDR_WIDTH   : positive := 35;
      G_AXI_DATA_WIDTH   : positive := 32;
      G_AXI_ID_WIDTH     : positive := 4;
      G_AXI_AWUSER_WIDTH : positive := 16
    );
    port (
      ACLK           : in  std_logic;
      ARESET_N       : in  std_logic;
      -------------------------------------------------------------------------------
      ---------------- WR ADDR CHANNEL ----------------------------------------------
      -------------------------------------------------------------------------------
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
      -------------------------------------------------------------------------------
      ---------------- LINK TO WR DATA CHANNEL --------------------------------------
      -------------------------------------------------------------------------------
      NEW_BURST      : out std_logic;
      BURST_STATUS   : out std_logic_vector (15 downto 0);
      FIFO_FULL      : in  std_logic;
      -------------------------------------------------------------------------------
      -------------- SEQUENCES SIGNALS ----------------------------------------------
      -------------------------------------------------------------------------------
      SQ_WRADDR_RUN  : out std_logic; -- This Signal indicates that this module is still running
      SQ_START       : in  std_logic;
      SQ_WR_AXI_SIG  : in  t_wr_axifull_mst
    );
  end component axifull_wraddr_chnn_mst;

  -- WR DATA CHANNEL
  component axifull_wrdata_chnn_mst is
    generic (
      G_AXI_DATA_WIDTH  : positive := 32;
      G_AXI_ID_WIDTH    : positive := 4;
      G_AXI_WUSER_WIDTH : positive := 16;
      G_BUFFER_WIDTH    : positive := 4
    );
    port (
      ACLK          : in  std_logic;
      ARESET_N      : in  std_logic;
      -------------------------------------------------------------------------------
      ---------------- WR DATA CHANNEL ----------------------------------------------
      -------------------------------------------------------------------------------
      M_AXI_WID     : out std_logic_vector (G_AXI_ID_WIDTH - 1 downto 0);
      M_AXI_WDATA   : out std_logic_vector (G_AXI_DATA_WIDTH - 1 downto 0);
      M_AXI_WSTRB   : out std_logic_vector ((G_AXI_DATA_WIDTH/8) - 1 downto 0);
      M_AXI_WUSER   : out std_logic_vector (G_AXI_WUSER_WIDTH - 1 downto 0);
      M_AXI_WLAST   : out std_logic;
      M_AXI_WVALID  : out std_logic;
      M_AXI_WREADY  : in  std_logic;
      -------------------------------------------------------------------------------
      ---------------- LINK TO WR ADDR CHANNEL --------------------------------------
      -------------------------------------------------------------------------------
      NEW_BURST     : in  std_logic;
      BURST_STATUS  : in  std_logic_vector (15 downto 0);
      FIFO_FULL     : out std_logic;
      FIFO_EMPTY    : out std_logic;
      -------------------------------------------------------------------------------
      -------------- SEQUENCES SIGNALS ----------------------------------------------
      -------------------------------------------------------------------------------
      SQ_WRADDR_RUN : in  std_logic; -- This Signal indicates that this module is still running
      SQ_WR_AXI_SIG : in  t_wr_axifull_mst
    );
  end component axifull_wrdata_chnn_mst;

  -- WR BRESP CHANNEL
  component axifull_wrbresp_chnn_mst is
    generic (
      G_AXI_ID_WIDTH    : positive := 4;
      G_AXI_BUSER_WIDTH : positive := 16
    );
    port (
      ACLK         : in  std_logic;
      ARESET_N     : in  std_logic;
      -------------------------------------------------------------------------------
      ---------------- WR RESPONSE CHANNEL ------------------------------------------
      -------------------------------------------------------------------------------
      M_AXI_BID    : in  std_logic_vector (G_AXI_ID_WIDTH - 1 downto 0);
      M_AXI_BRESP  : in  std_logic_vector (1 downto 0);
      M_AXI_BUSER  : in  std_logic_vector (G_AXI_BUSER_WIDTH - 1 downto 0);
      M_AXI_BVALID : in  std_logic;
      M_AXI_BREADY : out std_logic
    );
  end component axifull_wrbresp_chnn_mst;

  -- RD ADDR CHANNEL
  component axifull_rdaddr_chnn_mst is
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
  end component axifull_rdaddr_chnn_mst;

  -- RD DATA CHANNEL
  component axifull_rddata_chnn_mst is
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
  end component axifull_rddata_chnn_mst;

end package agent_axifull_mst_pkg;

-------------------------------------------------------------------------------
------------------------ BODY -------------------------------------------------
-------------------------------------------------------------------------------

package body agent_axifull_mst_pkg is

  -------------------------------------------------------------------------------
  ---------------- FUNCTION BODIES ----------------------------------------
  -------------------------------------------------------------------------------
  function get_wrstrb(num_bytes : integer; strb_width : integer; flag : std_logic) return std_logic_vector is
    variable wrstrb               : std_logic_vector(strb_width - 1 downto 0) := (others => '0');
  begin

    wrstrb := (others => '0');

    if (flag = '1') then
      for i in 0 to (num_bytes - 1) loop
        wrstrb(i) := '1';
      end loop;
    else
      wrstrb := (others => '1');
    end if;

    return wrstrb;

  end function;

end agent_axifull_mst_pkg;