
--------------------------------------------------------------------------------
--
-- COMPANY CONFIDENTIAL
-- Copyright (c) TECNOBIT 2017
--
-- TECNOBIT S.L.
--
-- Filename               : axifull_wrbresp_chnn_mst.vhd
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

entity axifull_wrbresp_chnn_mst is
  generic (
    G_AXI_ID_WIDTH    : positive := 4;
    G_AXI_BUSER_WIDTH : positive := 16
  );
  port (
    ACLK         : in  std_logic;
    ARESET_N     : in  std_logic;
    --------------------------------------------------------------------------------
    ---------------- WR RESPONSE CHANNEL -------------------------------------------
    --------------------------------------------------------------------------------
    M_AXI_BID    : in  std_logic_vector (G_AXI_ID_WIDTH - 1 downto 0);
    M_AXI_BRESP  : in  std_logic_vector (1 downto 0);
    M_AXI_BUSER  : in  std_logic_vector (G_AXI_BUSER_WIDTH - 1 downto 0);
    M_AXI_BVALID : in  std_logic;
    M_AXI_BREADY : out std_logic
  );
end axifull_wrbresp_chnn_mst;

architecture beh of axifull_wrbresp_chnn_mst is
  signal m_bready : std_logic;
begin

  --------------------------------------------------------------------------------
  --------------------- I/O Connections assignments ------------------------------
  --------------------------------------------------------------------------------
  M_AXI_BREADY <= m_bready;

  --------------------------------------------------------------------------------
  --------------------------- Gen BREADY-----------------------------------------
  --------------------------------------------------------------------------------
  process (ACLK)
  begin
    if rising_edge(ACLK) then
      if ARESET_N = '0' then
        m_bready <= '0';
      else
        if M_AXI_BVALID = '1' and m_bready = '0' then
          m_bready <= '1';
        else
          m_bready <= '0';
        end if;
      end if;
    end if;
  end process;

  -- TODO --> Pending to update to take into account the posibilities to receive a different
  --          M_AXI_BRESP than "00" that means MSG OKEY

end beh;