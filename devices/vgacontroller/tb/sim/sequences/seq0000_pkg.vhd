
------------------------------------------------------------------------------
-- Device/Project:  Device/Project name tested
-- File: 	          seq0000_pkg.vhd "zz -> num of sequentian" "yy -> type of functionality"
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

library work;
use work.logger_pkg.all;

package seq0000 is

  procedure seq0000_nominal (
    signal CLK       : in  std_logic;
    signal RESET   : in  std_logic;
    signal SEQ_START : out std_logic;
    signal SEQ_BUSY  : in  std_logic;
    signal HSYNC     : in  std_logic;
    signal VSYNC     : in  std_logic;
    signal VIDEO_ON  : in  std_logic;
    signal PIXEL_X   : in  std_logic_vector(9 downto 0);
    signal PIXEL_Y   : in  std_logic_vector(9 downto 0)
  );

end seq0000;

package body seq0000 is
  procedure seq0000_nominal (
    signal CLK       : in  std_logic;
    signal RESET   : in  std_logic;
    signal SEQ_START : out std_logic;
    signal SEQ_BUSY  : in  std_logic;
    signal HSYNC     : in  std_logic;
    signal VSYNC     : in  std_logic;
    signal VIDEO_ON  : in  std_logic;
    signal PIXEL_X   : in  std_logic_vector(9 downto 0);
    signal PIXEL_Y   : in  std_logic_vector(9 downto 0)
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

    wait until RESET = '0';
    wait for 400 ns;

    ------------------------------------------------------------------------------
    -- Test 010 : "Step Description"
    ------------------------------------------------------------------------------

    if C_STEP10_EN then

    else
      rep_error(" == STEP10 skipped == ");
    end if;

    wait for 36 ms;

    ------------------------------------------------------------------------------
    -- Test 020 : "Step Description"
    ------------------------------------------------------------------------------

    if C_STEP20_EN then

    else
      rep_error(" == STEP20 skipped == ");
    end if;

    wait for 1 us;

    assert false report "SIM END" severity failure;

  end seq0000_nominal;

end seq0000;