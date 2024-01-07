
------------------------------------------------------------------------------
-- Device/Project:  Device/Project name tested
-- File: 	          seqyyzz_pkg.vhd "zz -> num of sequentian" "yy -> type of functionality"
-- Author:	        Joshua Jesus Quintana Di­az
-- Date:	          dd/mm/yy
-- Version:	        1.0
-- History:	        1.0 Initial Version
------------------------------------------------------------------------------
-- Description: 
------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.log2;
use ieee.math_real.ceil;
use ieee.math_real.floor;

library work;
use work.logger_pkg.all;
use work.tb_common_pkg.all;

package seqyyzz is

  procedure seqyyzz_example (
    signal CLK       : in  std_logic;
    signal RESET_N   : in  std_logic;
    signal SEQ_START : out std_logic;
    signal SEQ_BUSY  : in  std_logic
  );

  procedure own_test (
    signal CLK           : in  std_logic;
    signal example_1     : out std_logic;
    signal example_2     : out std_logic_vector(31 downto 0);
    signal example_3     : in  std_logic;
    signal example_4     : in  std_logic_vector(31 downto 0);
    variable v_example_1 : in  std_logic;
    variable v_example_2 : in  integer
  );

end seqyyzz;

package body seqyyzz is
  procedure seqyyzz_example (
    signal CLK       : in  std_logic;
    signal RESET_N   : in  std_logic;
    signal SEQ_START : out std_logic;
    signal SEQ_BUSY  : in  std_logic
  ) is

    ----------------------------------------------------------------------------    
    ----------------------------------------------------------------------------    
    ----------------------------------------------------------------------------
    -- Constant to make available each step
    constant C_STEP10_EN : boolean := true;
    constant C_STEP20_EN : boolean := true;
    constant C_STEP30_EN : boolean := true;
    constant C_STEP40_EN : boolean := true;
    constant C_STEP50_EN : boolean := true;
    constant C_STEP60_EN : boolean := true;
    constant C_STEP70_EN : boolean := true;
    constant C_STEP80_EN : boolean := true;
    constant C_STEP90_EN : boolean := true;

  begin

    --------------------------------------------------------------------------------
    ----------------- INITIALIZATION -----------------------------------------------
    --------------------------------------------------------------------------------

    SEQ_START <= '0';

    wait until RESET_N = '0';
    wait for 400 ns;

    ------------------------------------------------------------------------------
    -- Test 010 : "Step Description"
    ------------------------------------------------------------------------------

    if C_STEP10_EN then

    else
      rep_error(" == STEP10 skipped == ");
    end if;

    wait for 1 us;

    ------------------------------------------------------------------------------
    -- Test 020 : "Step Description"
    ------------------------------------------------------------------------------

    if C_STEP20_EN then

    else
      rep_error(" == STEP20 skipped == ");
    end if;

    wait for 1 us;

    ------------------------------------------------------------------------------
    -- Test 030 : "Step Description"
    ------------------------------------------------------------------------------

    if C_STEP30_EN then

    else
      rep_error(" == STEP30 skipped == ");
    end if;

    wait for 1 us;

    ------------------------------------------------------------------------------
    -- Test 040 : "Step Description"
    ------------------------------------------------------------------------------

    if C_STEP40_EN then

    else
      rep_error(" == STEP40 skipped == ");
    end if;

    wait for 1 us;

    ------------------------------------------------------------------------------
    -- Test 050 : "Step Description"
    ------------------------------------------------------------------------------

    if C_STEP50_EN then

    else
      rep_error(" == STEP50 skipped == ");
    end if;

    wait for 1 us;

    ------------------------------------------------------------------------------
    -- Test 060 : "Step Description"
    ------------------------------------------------------------------------------

    if C_STEP60_EN then

    else
      rep_error(" == STEP60 skipped == ");
    end if;

    wait for 1 us;

    ------------------------------------------------------------------------------
    -- Test 070 : "Step Description"
    ------------------------------------------------------------------------------

    if C_STEP70_EN then

    else
      rep_error(" == STEP70 skipped == ");
    end if;

    wait for 1 us;

    assert false report "SIM END" severity failure;

  end seqyyzz_example;

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
