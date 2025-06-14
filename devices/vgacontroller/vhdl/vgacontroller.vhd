
------------------------------------------------------------------------------
-- Device/Project:  Device/Project name
-- File: 	          vgacontroller.vhd
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
use ieee.math_real.log2;
use ieee.math_real.ceil;
use ieee.math_real.floor;

library work;
use work.vgacontroller_pkg.all;

entity vgacontroller is
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
end entity;

architecture rtl of vgacontroller is
  --   --------------------------------------------------------------------------------
  --   --------------------- CONSTANT -------------------------------------------------
  --   --------------------------------------------------------------------------------

  constant C_FREQ_DIV_WIDTH : natural                                           := natural(floor(log2(real(G_CLK_SOURCE/25)))) + 1;
  constant C_FREQ_DIV       : std_logic_vector((C_FREQ_DIV_WIDTH - 1) downto 0) := std_logic_vector(to_unsigned(natural(floor(real(G_CLK_SOURCE/25))), C_FREQ_DIV_WIDTH));

  --   --------------------------------------------------------------------------------
  --   ------------------------ SIGNALS -----------------------------------------------
  --   --------------------------------------------------------------------------------
  signal clk_50Mhz          : std_logic                                         := '0';
  signal clk_25Mhz          : std_logic                                         := '0';
  signal reset_25Mhz        : std_logic;
  signal horsync            : std_logic;
  signal hsync_end          : std_logic;
  signal versync            : std_logic;
  signal vsync_end          : std_logic;
  signal v_on               : std_logic;
  signal px_x               : unsigned(11 downto 0);
  signal px_y               : unsigned(11 downto 0);

begin
  --------------------------------------------------------------------------------
  --------------------- I/O Connections assignments ------------------------------
  --------------------------------------------------------------------------------
  HSYNC    <= horsync;
  VSYNC    <= versync;
  VIDEO_ON <= v_on;
  PIXEL_X  <= std_logic_vector(px_x);
  PIXEL_Y  <= std_logic_vector(px_y);

  --------------------------------------------------------------------------------
  --------------------- BODY -----------------------------------------------------
  --------------------------------------------------------------------------------
  clk50 : process (CLK)
  begin
    if (rising_edge(CLK)) then
      clk_50Mhz <= not(clk_50Mhz);
    end if;
  end process clk50;

  clk25 : process (clk_50Mhz)
  begin
    if (rising_edge(clk_50Mhz)) then
      clk_25Mhz <= not(clk_25Mhz);
    end if;
  end process clk25;

  v_on <= '1' when ((px_x < C_HDISPLAY) and (px_y < C_VDISPLAY)) else
          '0';

  horsync <= '0' when ((px_x > (C_HDISPLAY + C_RIGHT_BORDER)) and (px_x < (C_HDISPLAY + C_RIGHT_BORDER + C_HRETRACE))) else
             '1';

  versync <= '0' when (((px_y > (C_VDISPLAY + C_BOTTOM_BORDER)) and (px_y < (C_VDISPLAY + C_BOTTOM_BORDER + C_VRETRACE)))) else
             '1';

  hsync_end <= '1' when (px_x = (C_HDISPLAY + C_RIGHT_BORDER + C_HRETRACE + C_LEFT_BORDER - 1)) else
               '0';

  vsync_end <= '1' when (px_y = (C_VDISPLAY + C_BOTTOM_BORDER + C_VRETRACE + C_TOP_BORDER - 1)) else
               '0';

  pixel_x_cnt : process (CLK)
  begin
    if (rising_edge(CLK)) then
      if (RESET = '1') then
        px_x <= C_PIXEL_ZERO;
      else
        if (hsync_end = '1') then
          px_x <= C_PIXEL_ZERO;
        else
          px_x <= px_x + C_PIXEL_ONE;
        end if;
      end if;
    end if;
  end process pixel_x_cnt;

  pixel_y_cnt : process (CLK)
  begin
    if (rising_edge(CLK)) then
      if (RESET = '1') then
        px_y <= C_PIXEL_ZERO;
      else
        if (hsync_end = '1') then
          if (vsync_end = '1') then
            px_y <= C_PIXEL_ZERO;
          else
            px_y <= px_y + C_PIXEL_ONE;
          end if;
        end if;
      end if;
    end if;
  end process pixel_y_cnt;

end rtl;