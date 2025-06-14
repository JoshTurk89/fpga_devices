
------------------------------------------------------------------------------
-- Device/Project:  Device/Project name package
-- File: 	          vgacontroller_pkg.vhd
-- Author:	        Joshua Jesus Quintana Di­az
-- Date:	          26/03/2024
-- Version:	        1.0
-- History:	        1.0 Initial Version
------------------------------------------------------------------------------
-- Description: 
------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

package vgacontroller_test_pkg is

  --------------------------------------------------------------------------------
  ---------------------- CONSTANT ------------------------------------------------
  --------------------------------------------------------------------------------
  constant C_BLACK   : std_logic_vector (11 downto 0) := "000000000000";
  constant C_BLUE    : std_logic_vector (11 downto 0) := "000011110000";
  constant C_GREEN   : std_logic_vector (11 downto 0) := "111100000000";
  constant C_CYAN    : std_logic_vector (11 downto 0) := "111111110000";
  constant C_RED     : std_logic_vector (11 downto 0) := "000000001111";
  constant C_MAGENTA : std_logic_vector (11 downto 0) := "000011111111";
  constant C_YELLOW  : std_logic_vector (11 downto 0) := "111100001111";
  constant C_WHITE   : std_logic_vector (11 downto 0) := "111111111111";

  --------------------------------------------------------------------------------
  ---------------------- COMPONENTS ----------------------------------------------
  --------------------------------------------------------------------------------
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
      PIXEL_X  : out std_logic_vector(11 downto 0);
      PIXEL_Y  : out std_logic_vector(11 downto 0)
    );
  end component;

end vgacontroller_test_pkg;