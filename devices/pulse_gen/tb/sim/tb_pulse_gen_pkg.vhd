
------------------------------------------------------------------------------
-- Device/Project:  Testbench Device/Project name package
-- File: 	          tb_pulse_gen_pkg.vhd
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

package tb_pulse_gen_pkg is

  -------------------------------------------------------------------------------
  -------------------------- CONSTANTS ------------------------------------------
  -------------------------------------------------------------------------------
  constant C_CLK_SYS        : time    := 20 ns;
  constant C_FREQ_DIV_WIDTH : integer := 7;

  --------------------------------------------------------------------------------
  ------------------ DUT COMPONENT INSTANTIATION ---------------------------------
  -------------------------------------------------------------------------------- 
  -- Device Under Test (DUT)
  component pulse_gen is
    generic (
      G_FREQ_DIV_WIDTH : natural range 1 to 32 := 7
    );
    port (
      CLK       : in  std_logic;
      RESET     : in  std_logic;
      PULSES_EN : in  std_logic;
      FREQ_DIV  : in  std_logic_vector (G_FREQ_DIV_WIDTH - 1 downto 0);
      PULSES    : out std_logic
    );
  end component;

end tb_pulse_gen_pkg;