
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

entity display_mux is
  generic (
    G_SEL : natural range 1 to 50 := 18
  );
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
  signal cnt_freq_resh : unsigned((G_SEL - 1) downto 0);
  signal digit         : std_logic_vector(7 downto 0);
  signal an_en         : std_logic_vector(3 downto 0);

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
        cnt_freq_resh <= (others => '0');
        digit         <= (others => '0');
        an_en         <= (others => '1');

      else

        cnt_freq_resh <= cnt_freq_resh + 1;

        case cnt_freq_resh((G_SEL - 1) downto (G_SEL - 2)) is
          when "00" =>
            an_en <= "1110";
            digit <= UNIT_SEG;
          when "01" =>
            an_en <= "1101";
            digit <= TEN_SEG;
          when "10" =>
            an_en <= "1011";
            digit <= HUNDRED_SEG;
          when others =>
            an_en <= "0111";
            digit <= THOUSAND_SEG;
        end case;

      end if;
    end if;
  end process disp_mux;

end rtl;