
------------------------------------------------------------------------------- 
--  
-- COMPANY CONFIDENTIAL 
-- Copyright (c) TECNOBIT  2017 
--  
-- TECNOBIT S.L. 
--  
-- Filename               : agent_axistream_mst_pkg.vhd 
-- Author                 : jjquintana
-- Creation Date          : 04/10/2022 
-- Repo path              : 
-- Architecture           : no-synthesizable 
-- Functional description :  
--  
--
-- Version                : 0.0.0 -> (jjquintana) First Version. File Created.
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

library xil_defaultlib;
use xil_defaultlib.logger_pkg.all;

--------------------------------------------------------------------------------
package agent_axistream_mst_pkg is

  shared variable busy : std_logic := '0';
  type t_mode is (BURST, BURST_TILL_EMPTY, SINGLE);

  type t_ag_cfg_axistream_mst is record
    start_transmission : std_logic;
    data               : integer;
    wr_txfifo          : std_logic;
    mode               : t_mode;
    num_words          : positive;
    latency            : time;
    timeout_tready     : time;
    verbose            : std_logic;
  end record;

  ------------------------------------
  -- Command start of burst transmission
  ------------------------------------
  procedure axistream_mst_start (
    verbose          : in  std_logic := '0';
    mode             : in  string    := "BURST"; -- Valid values are BURST,  BURST_TILL_EMPTY or SINGLE
    num_words        : in  positive  := 1;
    latency          : in  time      := 0 ns;
    timeout_tready   : in  time      := 0 ns;
    signal agent_cfg : out t_ag_cfg_axistream_mst);

  ------------------------------------
  -- Add new data to AXI TX fifo
  ------------------------------------
  procedure axistream_mst_add_data (
    data             : integer;
    signal agent_cfg : out t_ag_cfg_axistream_mst);

  ------------------------------------
  -- Wait until current transmission ends
  ------------------------------------
  procedure axistream_mst_waitend;

end package agent_axistream_mst_pkg;
--------------------------------------------------------------------------------
package body agent_axistream_mst_pkg is

  procedure axistream_mst_start (
    verbose          : in  std_logic := '0';
    mode             : in  string    := "BURST"; -- Valid values are BURST,  BURST_TILL_EMPTY or SINGLE
    num_words        : in  positive  := 1;
    latency          : in  time      := 0 ns;
    timeout_tready   : in  time      := 0 ns;
    signal agent_cfg : out t_ag_cfg_axistream_mst
  ) is
  begin

    if mode /= "BURST" and mode /= "BURST_TILL_EMPTY" and mode /= "SINGLE" then
      rep_failure ("FAILURE ERROR [Agent AXI stream]: Wrong mode configuration. Valid values are: BURST, BURST_TILL_EMPTY or SINGLE");
    else
      agent_cfg.num_words      <= num_words;
      agent_cfg.latency        <= latency;
      agent_cfg.timeout_tready <= timeout_tready;
      if mode = "BURST" then
        agent_cfg.mode <= BURST;
      elsif mode = "BURST_TILL_EMPTY" then
        agent_cfg.mode <= BURST_TILL_EMPTY;
      else
        agent_cfg.mode <= SINGLE;
      end if;
      wait for 0 ns; -- Delta stuff
      agent_cfg.start_transmission <= '1';
      wait for 0 ns; -- Set start_transmission delta
      agent_cfg.start_transmission <= '0';
      -- No more deltas :)
    end if;

  end procedure;

  procedure axistream_mst_add_data (
    data             : integer;
    signal agent_cfg : out t_ag_cfg_axistream_mst

  ) is
  begin
    agent_cfg.wr_txfifo <= '1';
    agent_cfg.data      <= data;
    wait for 0 ns;
    agent_cfg.wr_txfifo <= '0';
    wait for 0 ns;

  end procedure;

  ------------------------------------
  -- Wait until current transmission ends
  ------------------------------------
  procedure axistream_mst_waitend is
  begin

    while busy = '1' loop
      wait for 1 ns; -- Wait resolution
    end loop;

  end procedure;

end package body;
--------------------------------------------------------------------------------