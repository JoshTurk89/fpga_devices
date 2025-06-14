
------------------------------------------------------------------------------
-- Device/Project:  Testbench Device/Project name package
-- File: 	          tb_vgacontroller_pkg.vhd
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

package tb_vgacontroller_pkg is

  -------------------------------------------------------------------------------
  -------------------------- CONSTANTS ------------------------------------------
  -------------------------------------------------------------------------------
  constant C_CLK_SYS : time := 10 ns;

  --------------------------------------------------------------------------------
  ------------------ DUT COMPONENT INSTANTIATION ---------------------------------
  -------------------------------------------------------------------------------- 

  -- Device Under Test (DUT)
  component vgacontroller is
    generic (
      G_CLK_SOURCE : natural range 1 to 300 := 100 -- MHz
    );
    port (
      CLK      : in  std_logic;
      RESET    : in  std_logic;
      HSYNC    : out std_logic;
      VSYNC    : out std_logic;
      VIDEO_ON : out std_logic;
      PIXEL_X  : out std_logic_vector(9 downto 0);
      PIXEL_Y  : out std_logic_vector(9 downto 0)
    );
  end component;

end tb_vgacontroller_pkg;