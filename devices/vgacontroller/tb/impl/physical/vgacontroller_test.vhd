
------------------------------------------------------------------------------
-- Device/Project:  Device/Project name
-- File: 	          vgacontroller_test.vhd
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

library work;
use work.vgacontroller_test_pkg.all;

entity vgacontroller_test is
  generic (
    G_CLK_SOURCE : natural range 1 to 300 := 100 -- MHz
  );
  port (
    CLK   : in  std_logic;
    RESET : in  std_logic;
    HSYNC : out std_logic;
    VSYNC : out std_logic;
    RGB   : out std_logic_vector(11 downto 0)
  );
end entity;

architecture rtl of vgacontroller_test is
  --------------------------------------------------------------------------------
  ------------------------ SIGNALS -----------------------------------------------
  --------------------------------------------------------------------------------
  signal v_on  : std_logic;
  signal color : std_logic_vector(11 downto 0);
  signal px_x  : std_logic_vector(11 downto 0);
  signal px_y  : std_logic_vector(11 downto 0);

begin
  --------------------------------------------------------------------------------
  --------------------- I/O Connections assignments ------------------------------
  --------------------------------------------------------------------------------
  RGB <= color;

  --------------------------------------------------------------------------------
  --------------------- BODY -----------------------------------------------------
  -------------------------------------------------------------------------------- 
  graphic : process (CLK)
    variable v_px_x : integer;
    variable v_px_y : integer;
  begin
    if (rising_edge(CLK)) then
      v_px_x := to_integer(unsigned(px_x));
      v_px_y := to_integer(unsigned(px_y));
      if (RESET = '1') then
        color <= C_WHITE;
      else
        if (v_on = '1') then
          if (v_px_x                        <= 183) then
            color                             <= C_RED;
          elsif ((183 < v_px_x) and (v_px_x <= 366)) then
            color                             <= C_MAGENTA;
          elsif ((366 < v_px_x) and (v_px_x <= 549)) then
            color                             <= C_BLUE;
          elsif ((549 < v_px_x) and (v_px_x <= 732)) then
            color                             <= C_BLACK;
          elsif ((732 < v_px_x) and (v_px_x <= 915)) then
            color                             <= C_CYAN;
          elsif ((915 < v_px_x) and (v_px_x <= 1098)) then
            color                             <= C_GREEN;
          else
            color <= C_YELLOW;
          end if;
        else
          color <= C_WHITE;
        end if;
      end if;
    end if;
  end process graphic;

  --------------------------------------------------------------------------------
  ---------------------- COMPONENT INSTANTIATION ---------------------------------
  --------------------------------------------------------------------------------
  VGA_CTRL : vgacontroller
  generic map(
    G_CLK_SOURCE => G_CLK_SOURCE
  )
  port map(
    CLK      => CLK,
    RESET    => RESET,
    HSYNC    => HSYNC,
    VSYNC    => VSYNC,
    VIDEO_ON => v_on,
    PIXEL_X  => px_x,
    PIXEL_Y  => px_y
  );

end rtl;