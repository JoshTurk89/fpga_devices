
------------------------------------------------------------------------------
-- Device/Project:  Testbench Device/Project name
-- File: 	          tb_bin2bcd.vhd
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

library work;
use work.tb_bin2bcd_pkg.all;
use work.seq0000.all;

entity tb_bin2bcd is
  generic (g_numtest : string(1 to 6) := "000000"
                                         );
end tb_bin2bcd;

architecture beh of tb_bin2bcd is

  -----------------------------------------------------------------------------------------
  -- --------------------------- TEST CLKS SIGNALS ----------------------------------------
  -----------------------------------------------------------------------------------------
  signal tb_clk      : std_logic := '1';
  signal tb_reset_n  : std_logic;

  --------------------------------------------------------------------------------
  ------------------- TEST SIGNALS -----------------------------------------------
  --------------------------------------------------------------------------------
  signal tb_bin      : std_logic_vector(13 downto 0);
  signal tb_unit     : std_logic_vector(3 downto 0);
  signal tb_ten      : std_logic_vector(3 downto 0);
  signal tb_hundred  : std_logic_vector(3 downto 0);
  signal tb_thousand : std_logic_vector(3 downto 0);
  --------------------------------------------------------------------------------
  -------------- SEQUENCES SIGNALS -----------------------------------------------
  --------------------------------------------------------------------------------
  signal tb_sq_start : std_logic;
  signal tb_sq_busy  : std_logic;

begin

  p_stimuli : process
  begin
    case g_numtest is
      when "000000" => seq0000_nominal (tb_clk, tb_reset_n, tb_sq_start, tb_sq_busy,
        tb_bin, tb_unit, tb_ten, tb_hundred, tb_thousand);
      when others => assert false report "test " & g_numtest & " not defined" severity failure;
    end case;
    wait;
  end process p_stimuli;

  -------------------------------------------------------------------------------- 
  ------------------------ Clk generations ---------------------------------------
  --------------------------------------------------------------------------------
  tb_clk     <= not(tb_clk) after C_CLK_SYS/2;

  --------------------------------------------------------------------------------
  ------------------------ rst generations ---------------------------------------
  --------------------------------------------------------------------------------
  tb_reset_n <= '1', '0' after 200 ns;

  --------------------------------------------------------------------------------
  ------------------ DUT COMPONENT INSTANTIATION ---------------------------------
  --------------------------------------------------------------------------------  

  DUT : bin2bcd
  port map(
    CLK      => tb_clk,
    RESET    => tb_reset_n,
    BIN      => tb_bin,
    UNIT     => tb_unit,
    TEN      => tb_ten,
    HUNDRED  => tb_hundred,
    THOUSAND => tb_thousand
  );

end beh;