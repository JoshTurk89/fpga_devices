
-----------------------------------------------------------------------------------------
-- Proyect	: Logic Adder Device
-- File		: tb_logic_adder
-- Author	: Joshua JesÃºs Quintana DÃ­az
-- Date:	: 19/10/22
-- Version	: 1.0
-- Historic	: 1.0 Initial Version
-- Design	: Test in order to check the implementation of the adder of variable width 
-- 				of bits with logic Gates
-----------------------------------------------------------------------------------------
-- Description: Test in order to check the implementation of the adder of variable width 
-- 				of bits with logic Gates.
--				For that, the device will be test with different width in order to 
--				guarantee the good behaviour.
-----------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

library work;
use work.test000000.all;
-- use work.test000001.all;
-- use work.test000002.all;
-- use work.test000003.all;

entity tb_logic_adder is
  generic (g_numtest : string(1 to 6) := "000000"
                                         );
end tb_logic_adder;

architecture beh of tb_logic_adder is
  -----------------------------------------------------------------------------------------
  -- --------------------------- COMPONENT ------------------------------------------------
  -----------------------------------------------------------------------------------------
  component logic_adder
    generic (
      G_WIDTH : natural range 1 to 64 := 8
    );
    port (
      CLK   : in  std_logic;
      RESET : in  std_logic;
      A     : in  std_logic_vector((G_WIDTH - 1) downto 0);
      B     : in  std_logic_vector((G_WIDTH - 1) downto 0);
      S     : out std_logic_vector(G_WIDTH downto 0)
    );
  end component;

  constant c_clksys_period : time := 10 ns;

  -------------------------------------------------------------------------------- 
  ------------------------ Clk generations ---------------------------------------
  --------------------------------------------------------------------------------
  signal tb_clk : std_logic := '0';

  --------------------------------------------------------------------------------
  ------------------------ rst generations ---------------------------------------
  --------------------------------------------------------------------------------
  signal tb_reset : std_logic;

  -----------------------------------------------------------------------------------------
  -- --------------------------- TEST INPUT SIGNALS ---------------------------------------
  -----------------------------------------------------------------------------------------
  signal tb_a : std_logic_vector(7 downto 0);
  signal tb_b : std_logic_vector(7 downto 0);
  -----------------------------------------------------------------------------------------
  -- --------------------------- TEST OUTPUT SIGNALS --------------------------------------
  -----------------------------------------------------------------------------------------
  signal tb_s : std_logic_vector(8 downto 0);
begin

  p_stimuli : process
  begin
    case g_numtest is
      when "000000" => test000000_logic_adder_1b (tb_clk, tb_reset, tb_a, tb_b, tb_s);
        --   when "000001" => test000001_logic_adder_2b (tb_a, tb_b, tb_s);
        --   when "000002" => test000002_logic_adder_32b (tb_a, tb_b, tb_s);
        --   when "000003" => test000003_logic_adder_64b (tb_a, tb_b, tb_s);
      when others => assert false report "test " & g_numtest & " not defined" severity failure;
    end case;
    wait;
  end process p_stimuli;

  -------------------------------------------------------------------------------- 
  ------------------------ Clk generations ---------------------------------------
  --------------------------------------------------------------------------------
  tb_clk <= not(tb_clk) after c_clksys_period/2;

  --------------------------------------------------------------------------------
  ------------------------ rst generations ---------------------------------------
  --------------------------------------------------------------------------------
  tb_reset <= '1', '0' after 200 ns;

  i_dut : logic_adder
  generic map(G_WIDTH => 8)
  port map(
    CLK   => tb_clk,
    RESET => tb_reset,
    A     => tb_a,
    B     => tb_b,
    S     => tb_s);

end beh;
