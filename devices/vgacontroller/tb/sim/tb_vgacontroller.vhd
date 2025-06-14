
------------------------------------------------------------------------------
-- Device/Project:  Testbench Device/Project name
-- File: 	          tb_vgacontroller.vhd
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
use work.tb_vgacontroller_pkg.all;
use work.seq0000.all;

entity tb_vgacontroller is
  generic (g_numtest : string(1 to 6) := "000000"
                                         );
end tb_vgacontroller;

architecture beh of tb_vgacontroller is

  -----------------------------------------------------------------------------------------
  -- --------------------------- TEST CLKS SIGNALS ----------------------------------------
  -----------------------------------------------------------------------------------------
  signal tb_clk      : std_logic := '1';
  signal tb_reset    : std_logic;

  --------------------------------------------------------------------------------
  ------------------- TEST SIGNALS -----------------------------------------------
  --------------------------------------------------------------------------------
  signal tb_hsync    : std_logic;
  signal tb_vsync    : std_logic;
  signal tb_video_on : std_logic;
  signal tb_px_x     : std_logic_vector(9 downto 0);
  signal tb_px_y     : std_logic_vector(9 downto 0);

  --------------------------------------------------------------------------------
  -------------- SEQUENCES SIGNALS -----------------------------------------------
  --------------------------------------------------------------------------------
  signal tb_sq_start : std_logic;
  signal tb_sq_busy  : std_logic;

begin

  p_stimuli : process
  begin
    case g_numtest is
      when "000000" => seq0000_nominal (tb_clk, tb_reset, tb_sq_start, tb_sq_busy,
        tb_hsync, tb_vsync, tb_video_on, tb_px_x, tb_px_y);
      when others => assert false report "test " & g_numtest & " not defined" severity failure;
    end case;
    wait;
  end process p_stimuli;

  -------------------------------------------------------------------------------- 
  ------------------------ Clk generations ---------------------------------------
  --------------------------------------------------------------------------------
  tb_clk   <= not(tb_clk) after C_CLK_SYS/2;

  --------------------------------------------------------------------------------
  ------------------------ rst generations ---------------------------------------
  --------------------------------------------------------------------------------
  tb_reset <= '1', '0' after 200 ns;

  --------------------------------------------------------------------------------
  ------------------ DUT COMPONENT INSTANTIATION ---------------------------------
  --------------------------------------------------------------------------------  

  DUT : vgacontroller
  generic map(
    G_CLK_SOURCE => 100
  )
  port map(
    CLK      => tb_clk,
    RESET    => tb_reset,
    HSYNC    => tb_hsync,
    VSYNC    => tb_vsync,
    VIDEO_ON => tb_video_on,
    PIXEL_X  => tb_px_x,
    PIXEL_Y  => tb_px_y
  );

end beh;