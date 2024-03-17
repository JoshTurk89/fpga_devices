
------------------------------------------------------------------------------
-- Device/Project:  Testbench Device/Project name
-- File: 	          tb_pulse_gen.vhd
-- Author:	        Joshua Jesus Quintana Di­az
-- Date:	          16/03/2024
-- Version:	        1.0
-- History:	        1.0 Initial Version
------------------------------------------------------------------------------
-- Description: 
------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.tb_pulse_gen_pkg.all;
use work.seq0000.all;

entity tb_pulse_gen is
  generic (g_numtest : string(1 to 6) := "000000"
                                         );
end tb_pulse_gen;

architecture beh of tb_pulse_gen is

  -----------------------------------------------------------------------------------------
  -- --------------------------- TEST CLKS SIGNALS ----------------------------------------
  -----------------------------------------------------------------------------------------
  signal tb_clk      : std_logic := '1';
  signal tb_reset    : std_logic;

  --------------------------------------------------------------------------------
  ------------------- TEST SIGNALS -----------------------------------------------
  --------------------------------------------------------------------------------
  signal tb_pulse_en : std_logic;
  signal tb_freq_div : std_logic_vector (C_FREQ_DIV_WIDTH - 1 downto 0);
  signal tb_pulses   : std_logic;

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
        tb_pulse_en, tb_freq_div, tb_pulses);
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

  DUT : pulse_gen
  generic map(
    G_FREQ_DIV_WIDTH => C_FREQ_DIV_WIDTH
  )
  port map(
    CLK       => tb_clk,
    RESET     => tb_reset,
    PULSES_EN => tb_pulse_en,
    FREQ_DIV  => tb_freq_div,
    PULSES    => tb_pulses
  );

end beh;