
------------------------------------------------------------------------------
-- Device/Project:  Device/Project name tested
-- File: 	          seq0000_pkg.vhd "zz -> num of sequentian" "yy -> type of functionality"
-- Author:	        Joshua Jesus Quintana Di­az
-- Date:	          16/03/2024
-- Version:	        1.0
-- History:	        1.0 Initial Version
------------------------------------------------------------------------------
-- Description: 
------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.tb_pulse_gen_pkg.all;
use work.logger_pkg.all;

package seq0000 is

  procedure seq0000_nominal (
    signal CLK       : in  std_logic;
    signal RESET     : in  std_logic;
    signal SEQ_START : out std_logic;
    signal SEQ_BUSY  : in  std_logic;
    signal PULSE_EN  : out std_logic;
    signal FREQ_DIV  : out std_logic_vector(C_FREQ_DIV_WIDTH - 1 downto 0);
    signal PULSES    : in  std_logic
  );

end seq0000;

package body seq0000 is
  procedure seq0000_nominal (
    signal CLK       : in  std_logic;
    signal RESET     : in  std_logic;
    signal SEQ_START : out std_logic;
    signal SEQ_BUSY  : in  std_logic;
    signal PULSE_EN  : out std_logic;
    signal FREQ_DIV  : out std_logic_vector(C_FREQ_DIV_WIDTH - 1 downto 0);
    signal PULSES    : in  std_logic
  ) is

    ----------------------------------------------------------------------------    
    ----------------------------------------------------------------------------    
    ----------------------------------------------------------------------------
    -- Constant to make available each step
    constant C_STEP10_EN : boolean := true;
    constant C_STEP20_EN : boolean := true;

  begin

    --------------------------------------------------------------------------------
    ----------------- INITIALIZATION -----------------------------------------------
    --------------------------------------------------------------------------------

    SEQ_START <= '0';
    PULSE_EN  <= '0';
    FREQ_DIV  <= std_logic_vector(to_unsigned(1, C_FREQ_DIV_WIDTH));
    wait until RESET = '1';
    wait for 400 ns;

    ------------------------------------------------------------------------------
    -- Test 010 : "Step Description"
    ------------------------------------------------------------------------------

    if C_STEP10_EN then

      PULSE_EN <= '1';
      wait for 500 ns;
      PULSE_EN <= '0';

    else
      rep_error(" == STEP10 skipped == ");
    end if;

    wait for 1 us;

    ------------------------------------------------------------------------------
    -- Test 020 : "Step Description"
    ------------------------------------------------------------------------------

    if C_STEP20_EN then

      FREQ_DIV <= std_logic_vector(to_unsigned(5, C_FREQ_DIV_WIDTH));
      wait for 40 ns;
      PULSE_EN <= '1';
      wait for 500 ns;
      PULSE_EN <= '0';

    else
      rep_error(" == STEP20 skipped == ");
    end if;

    wait for 1 us;

    assert false report "SIM END" severity failure;

  end seq0000_nominal;
end seq0000;