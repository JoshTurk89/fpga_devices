
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

  with BCD select digi <=
                         "00000011" when "0000",
                         "10011111" when "0001",
                         "00100101" when "0010",
                         "00001101" when "0011",
                         "10011001" when "0100",
                         "01001001" when "0101",
                         "01000001" when "0110",
                         "00011111" when "0111",
                         "00000001" when "1000",
                         "00001001" when "1001",
                         "00000010" when others;

end rtl;