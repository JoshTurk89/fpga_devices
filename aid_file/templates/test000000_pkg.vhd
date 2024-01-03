
------------------------------------------------------------------------------
-- Device/Project: Logic Adder Device
-- File: 	device_project_arch_pkg.vhd
-- Author:	Joshua Jesus Quintana Di­az
-- Date:	
-- Version:	1.0
-- History:	1.0 Initial Version
-- Design:	
------------------------------------------------------------------------------
-- Description: 
------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.logger_pkg.all;
use work.tb_common_pkg.all;

package test000000 is

  procedure test000000_example (
    signal CLK       : in  std_logic;
    signal RESET_N   : in  std_logic;
    signal SEQ_START : out std_logic;
    signal SEQ_BUSY  : in  std_logic
  );

end test000000;

package body test000000 is
  procedure test000000_example (
    signal CLK       : in  std_logic;
    signal RESET_N   : in  std_logic;
    signal SEQ_START : out std_logic;
    signal SEQ_BUSY  : in  std_logic
  ) is

    ----------------------------------------------------------------------------    
    ----------------------------------------------------------------------------    
    ----------------------------------------------------------------------------
    -- Constant to make available each step
    constant c_step10_en : boolean := true;
    constant c_step20_en : boolean := true;
    constant c_step30_en : boolean := true;
    constant c_step40_en : boolean := true;
    constant c_step50_en : boolean := true;
    constant c_step60_en : boolean := true;
    constant c_step70_en : boolean := true;
    constant c_step80_en : boolean := true;
    constant c_step90_en : boolean := true;

    constant c_step10_en : boolean := false;
    constant c_step20_en : boolean := false;
    constant c_step30_en : boolean := false;
    constant c_step40_en : boolean := false;
    constant c_step50_en : boolean := false;
    constant c_step60_en : boolean := false;
    constant c_step70_en : boolean := false;
    constant c_step80_en : boolean := false;
    constant c_step90_en : boolean := false;

  begin

    --------------------------------------------------------------------------------
    ----------------- INITIALIZATION -----------------------------------------------
    --------------------------------------------------------------------------------

    SEQ_START <= '0';

    wait until RESET_N = '0';
    wait for 400 ns;

    ------------------------------------------------------------------------------
    -- Test 010 : "Description"
    ------------------------------------------------------------------------------

    if c_step10_en then

    else
      rep_error(" == STEP10 skipped == ");
    end if;

    wait for 1 us;

    ------------------------------------------------------------------------------
    -- Test 020 : "Description"
    ------------------------------------------------------------------------------

    if c_step20_en then

    else
      rep_error(" == STEP20 skipped == ");
    end if;

    wait for 1 us;

    ------------------------------------------------------------------------------
    -- Test 030 : "Description"
    ------------------------------------------------------------------------------

    if c_step30_en then

    else
      rep_error(" == STEP30 skipped == ");
    end if;

    wait for 1 us;

    ------------------------------------------------------------------------------
    -- Test 040 : "Description"
    ------------------------------------------------------------------------------

    if c_step40_en then

    else
      rep_error(" == STEP40 skipped == ");
    end if;

    wait for 1 us;

    ------------------------------------------------------------------------------
    -- Test 050 : "Description"
    ------------------------------------------------------------------------------

    if c_step50_en then

    else
      rep_error(" == STEP50 skipped == ");
    end if;

    wait for 1 us;

    ------------------------------------------------------------------------------
    -- Test 060 : "Description"
    ------------------------------------------------------------------------------

    if c_step60_en then

    else
      rep_error(" == STEP60 skipped == ");
    end if;

    wait for 1 us;

    ------------------------------------------------------------------------------
    -- Test 070 : "Description"
    ------------------------------------------------------------------------------

    if c_step70_en then

    else
      rep_error(" == STEP70 skipped == ");
    end if;

    wait for 1 us;

    assert false report "SIM END" severity failure;

  end test000000_example;

  procedure own_test (
    signal CLK           : in  std_logic;
    signal example_1     : out std_logic;
    signal example_2     : out std_logic_vector(31 downto 0);
    signal example_3     : in  std_logic;
    signal example_4     : in  std_logic_vector(31 downto 0);
    variable v_example_1 : in  std_logic;
    variable v_example_2 : in  integer
  ) is

  begin

  end own_test;
