
------------------------------------------------------------------------------
-- Device/Project:  Device/Project name
-- File: 	          display_mux.vhd
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
use ieee.math_real.log2;
use ieee.math_real.ceil;
use ieee.math_real.floor;

library work;
use work.TBD.all;

entity display_mux is
  port (
    CLK          : in  std_logic;
    RESET        : in  std_logic;
    UNIT_SEG     : in  std_logic_vector(7 downto 0);
    TEN_SEG      : in  std_logic_vector(7 downto 0);
    HUNDRED_SEG  : in  std_logic_vector(7 downto 0);
    THOUSAND_SEG : in  std_logic_vector(7 downto 0);
    AN           : out std_logic_vector(3 downto 0);
    DISPLAY      : out std_logic_vector(7 downto 0)
  );
end entity;

architecture rtl of display_mux is
  --------------------------------------------------------------------------------
  ------------------------ SIGNALS -----------------------------------------------
  --------------------------------------------------------------------------------
  signal digit   : std_logic_vector(7 downto 0);
  signal an_en   : std_logic_vector(3 downto 0);
  signal control : std_logic;

begin
  --------------------------------------------------------------------------------
  --------------------- I/O Connections assignments ------------------------------
  --------------------------------------------------------------------------------
  AN      <= an_en;
  DISPLAY <= digit;

  --------------------------------------------------------------------------------
  --------------------- BODY -----------------------------------------------------
  --------------------------------------------------------------------------------
  disp_mux : process (CLK)
  begin
    if (rising_edge(CLK)) then
      if (RESET = '1') then
        an_en   <= (others => '1');
        digit   <= (others => '0');
        control <= '0';

      else
        if (control = '0') then
          an_en(0) <= '0';
          digit    <= UNIT;
          control  <= '1';
          
        else
          an_en(1) <= an_en(0);
          an_en(2) <= an_en(1);
          an_en(3) <= an_en(2);
          an_en(0) <= an_en(3);

          case an_en is
            when "1110" => digit <= UNIT_SEG;
            when "1101" => digit <= TEN_SEG;
            when "1011" => digit <= HUNDRED_SEG;
            when "0111" => digit <= THOUSAND_SEG;
            when others => digit <= "11111101";
          end case;

        end if;
      end if;
    end if;
  end process disp_mux;

end rtl;