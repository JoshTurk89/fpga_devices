
------------------------------------------------------------------------------
-- Device/Project:  Device/Project name
-- File: 	          bin2bcd.vhd
-- Author:	        Joshua Jesus Quintana Di­az
-- Date:	          17/03/2024
-- Version:	        1.0
-- History:	        1.0 Initial Version
------------------------------------------------------------------------------
-- Description: 
------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bin2bcd is
  port (
    CLK      : in  std_logic;
    RESET    : in  std_logic;
    BIN      : in  std_logic_vector(13 downto 0);
    UNIT     : out std_logic_vector(3 downto 0);
    TEN      : out std_logic_vector(3 downto 0);
    HUNDRED  : out std_logic_vector(3 downto 0);
    THOUSAND : out std_logic_vector(3 downto 0)
  );
end entity;

architecture rtl of bin2bcd is
  --------------------------------------------------------------------------------
  --------------------- CONSTANT -------------------------------------------------
  --------------------------------------------------------------------------------
  constant C_CNT_ONE   : unsigned(3 downto 0) := "0001";
  constant C_CNT_THREE : unsigned(3 downto 0) := "0011";
  constant C_CNT_ZERO  : unsigned(3 downto 0) := "0000";

  --------------------------------------------------------------------------------
  ------------------------ SIGNALS -----------------------------------------------
  --------------------------------------------------------------------------------
  signal bi            : std_logic_vector(13 downto 0);
  signal bcd           : std_logic_vector(15 downto 0);
  signal cnt_bcd       : unsigned(3 downto 0);
  signal cnt_en        : std_logic;

begin
  --------------------------------------------------------------------------------
  --------------------- I/O Connections assignments ------------------------------
  --------------------------------------------------------------------------------
  UNIT     <= bcd(3 downto 0);
  TEN      <= bcd(7 downto 4);
  HUNDRED  <= bcd(11 downto 8);
  THOUSAND <= bcd(15 downto 12);

  --------------------------------------------------------------------------------
  --------------------- BODY -----------------------------------------------------
  --------------------------------------------------------------------------------
  bin_reg : process (CLK)
  begin
    if (rising_edge(CLK)) then
      if (RESET = '1') then
        bi <= (others => '0');
      else
        bi <= BIN;
        if (bi /= BIN) then
          cnt_en <= '1';
        else
          cnt_en <= '0';
        end if;
      end if;
    end if;
  end process bin_reg;

  cnt_bcd_reg : process (CLK)
  begin
    if (rising_edge(CLK)) then
      if (RESET = '1') then
        cnt_bcd <= "1111";
      else
        if (cnt_en = '1') then
          cnt_bcd <= "1101";

        else

          if (cnt_bcd = C_CNT_ZERO) then
            cnt_bcd <= "1111";
          elsif (cnt_bcd = "1111") then
            cnt_bcd <= cnt_bcd;
          else
            cnt_bcd <= cnt_bcd - C_CNT_ONE;
          end if;
        end if;

      end if;
    end if;
  end process cnt_bcd_reg;

  bin_to_bcd : process (CLK)
    variable v_bcd : unsigned(15 downto 0);
  begin
    if (rising_edge(CLK)) then
      if (RESET = '1') then
        bcd <= (others   => '0');
        v_bcd := (others => '0');
      else
        if (bi = "00000000000000") then
          bcd <= (others   => '0');
          v_bcd := (others => '0');

        elsif (bi >= "10011100001111") then
          bcd <= "1001100110011001";
          v_bcd := (others => '0');

        else
          if (cnt_bcd /= "1111") then

            if (v_bcd(3 downto 0) > "0100") then
              v_bcd(3 downto 0) := v_bcd(3 downto 0) + C_CNT_THREE;
            end if;

            if (v_bcd(7 downto 4) > "0100") then
              v_bcd(7 downto 4) := v_bcd(7 downto 4) + C_CNT_THREE;
            end if;

            if (v_bcd(11 downto 8) > "0100") then
              v_bcd(11 downto 8) := v_bcd(11 downto 8) + C_CNT_THREE;
            end if;

            if (v_bcd(15 downto 12) > "0100") then
              v_bcd(15 downto 12) := v_bcd(15 downto 12) + C_CNT_THREE;
            end if;

            v_bcd(15 downto 1) := v_bcd(14 downto 0);
            v_bcd(0)           := bi(to_integer(cnt_bcd));
            
            bcd <= std_logic_vector(v_bcd);

          else
            bcd <= bcd;
            v_bcd := (others => '0');

          end if;
        end if;
      end if;
    end if;
  end process bin_to_bcd;

end rtl;