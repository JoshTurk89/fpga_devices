
------------------------------------------------------------------------------
-- Device/Project:  Testbench Device/Project name package
-- File: 	          tb_bin2bcd_pkg.vhd
-- Author:	        Joshua Jesus Quintana Di­az
-- Date:	          17/03/2024
-- Version:	        1.0
-- History:	        1.0 Initial Version
------------------------------------------------------------------------------
-- Description: 
------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package tb_bin2bcd_pkg is

  -------------------------------------------------------------------------------
  -------------------------- CONSTANTS ------------------------------------------
  -------------------------------------------------------------------------------
  constant C_CLK_SYS : time := 20 ns;

  --------------------------------------------------------------------------------
  ------------------ DUT COMPONENT INSTANTIATION ---------------------------------
  -------------------------------------------------------------------------------- 

  -- Device Under Test (DUT)
  component bin2bcd is
    port (
      CLK      : in  std_logic;
      RESET    : in  std_logic;
      BIN      : in  std_logic_vector(13 downto 0);
      UNIT     : out std_logic_vector(3 downto 0);
      TEN      : out std_logic_vector(3 downto 0);
      HUNDRED  : out std_logic_vector(3 downto 0);
      THOUSAND : out std_logic_vector(3 downto 0)
    );
  end component;

end tb_bin2bcd_pkg;