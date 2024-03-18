
------------------------------------------------------------------------------
-- Device/Project:  Device/Project name
-- File: 	          bcd2disp_basys3.vhd
-- Author:	        Joshua Jesus Quintana Di­az
-- Date:	          18/03/2024
-- Version:	        1.0
-- History:	        1.0 Initial Version
------------------------------------------------------------------------------
-- Description: 
------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bcd2disp_basys3 is
  port (
    CLK   : in  std_logic;
    RESET : in  std_logic;
    BCD   : in  std_logic_vector(3 downto 0);
    DIGIT : out std_logic_vector(7 downto 0)
  );
end entity;

architecture rtl of bcd2disp_basys3 is
  --------------------------------------------------------------------------------
  ------------------------ SIGNALS -----------------------------------------------
  --------------------------------------------------------------------------------
  signal digi     : std_logic_vector(7 downto 0);
  signal digi_reg : std_logic_vector(7 downto 0);

begin
  --------------------------------------------------------------------------------
  --------------------- I/O Connections assignments ------------------------------
  --------------------------------------------------------------------------------
  DIGIT <= digi_reg;

  --------------------------------------------------------------------------------
  --------------------- BODY -----------------------------------------------------
  --------------------------------------------------------------------------------
  digit_reg : process (CLK)
  begin
    if (rising_edge(CLK)) then
      if (RESET = '1') then
        digi_reg <= (others => '0');
      else
        digi_reg <= digi;
      end if;
    end if;
  end process digit_reg;

  with BDC select digi <=
                         "11111100" when "0000",
                         "01100000" when "0001",
                         "11011010" when "0010",
                         "11110010" when "0011",
                         "01100110" when "0100",
                         "10110110" when "0101",
                         "10111110" when "0110",
                         "11100000" when "0111",
                         "11111110" when "1000",
                         "11110110" when "1001",
                         "11111101" when others;

end rtl;