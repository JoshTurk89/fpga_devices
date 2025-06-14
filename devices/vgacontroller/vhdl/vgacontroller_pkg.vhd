
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
use ieee.numeric_std.all;

package vgacontroller_pkg is

  --------------------------------------------------------------------------------
  ---------------------- CONSTANT ------------------------------------------------
  --------------------------------------------------------------------------------
  constant C_PIXEL_ZERO    : unsigned(11 downto 0) := to_unsigned(0, 12);
  constant C_PIXEL_ONE     : unsigned(11 downto 0) := to_unsigned(1, 12);

  --------------------------------------------------------------------------------
  ------------------ Resolucion 640x480 ------------------------------------------
  --------------------------------------------------------------------------------
  -- HSYNC
  -- constant C_HDISPLAY      : natural              := 640;
  -- FRONT_PORCH
  -- constant C_RIGHT_BORDER  : natural               := 16;
  -- constant C_HRETRACE      : natural               := 96;
  -- BACK_PORCH
  -- constant C_LEFT_BORDER   : natural               := 48;

  -- VSYNC  
  -- constant C_VDISPLAY      : natural              := 480;
  -- FRONT_PORCH
  -- constant C_BOTTOM_BORDER : natural               := 10;
  -- constant C_VRETRACE      : natural               := 2;
  -- BACK_PORCH
  -- constant C_TOP_BORDER    : natural               := 29;

  --------------------------------------------------------------------------------
  ------------------ Resolucion 1280x1024 ----------------------------------------
  --------------------------------------------------------------------------------
  -- HSYNC
  -- constant C_HDISPLAY      : natural               := 1280;
  -- FRONT_PORCH
  -- constant C_RIGHT_BORDER  : natural               := 48;
  -- constant C_HRETRACE      : natural               := 112;
  -- BACK_PORCH
  -- constant C_LEFT_BORDER   : natural               := 248;

  -- VSYNC
  -- constant C_VDISPLAY      : natural               := 1024;
  -- FRONT_PORCH
  -- constant C_BOTTOM_BORDER : natural               := 1;
  -- constant C_VRETRACE      : natural               := 3;
  -- BACK_PORCH
  -- constant C_TOP_BORDER    : natural               := 38;

  --------------------------------------------------------------------------------
  ------------------ Resolucion 1920x1080 ----------------------------------------
  --------------------------------------------------------------------------------
  -- HSYNC
  constant C_HDISPLAY      : natural               := 1920;
  -- FRONT_PORCH
  constant C_RIGHT_BORDER  : natural               := 88;
  constant C_HRETRACE      : natural               := 44;
  -- BACK_PORCH
  constant C_LEFT_BORDER   : natural               := 148;

  -- VSYNC
  constant C_VDISPLAY      : natural               := 1080;
  -- FRONT_PORCH
  constant C_BOTTOM_BORDER : natural               := 4;
  constant C_VRETRACE      : natural               := 5;
  -- BACK_PORCH
  constant C_TOP_BORDER    : natural               := 36;

end vgacontroller_pkg;