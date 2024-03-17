------------------------------------------------------------------------------
-- Device   : Pulse Generator Syncronized Device
-- File     : pulse_gen_sync.vhd
-- Author   :	Joshua Jesus Quintana Di­az
-- Date     :	30/12/2023
-- Version  :	1.0
-- History  :	1.0 Initial Version
------------------------------------------------------------------------------
-- Description: Device to generate period pulses from clock source.
------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pulse_gen is
  generic (
    G_FREQ_DIV_WIDTH : natural range 1 to 32 := 7
  );
  port (
    CLK       : in  std_logic;
    RESET     : in  std_logic;
    PULSES_EN : in  std_logic;
    FREQ_DIV  : in  std_logic_vector (G_FREQ_DIV_WIDTH - 1 downto 0);
    PULSES    : out std_logic
  );
end entity;

architecture rtl of pulse_gen is

  --------------------------------------------------------------------------------
  ------------------------ CONSTANT -----------------------------------------------
  --------------------------------------------------------------------------------
  constant C_COUNTER_ONE  : unsigned(G_FREQ_DIV_WIDTH - 1 downto 0) := to_unsigned(1, G_FREQ_DIV_WIDTH);
  constant C_COUNTER_ZERO : unsigned(G_FREQ_DIV_WIDTH - 1 downto 0) := to_unsigned(0, G_FREQ_DIV_WIDTH);

  --------------------------------------------------------------------------------
  ------------------------ SIGNALS -----------------------------------------------
  --------------------------------------------------------------------------------
  signal pulse            : std_logic;
  signal cnt_ticks        : unsigned(G_FREQ_DIV_WIDTH - 1 downto 0);

begin

  --------------------------------------------------------------------------------
  --------------------- I/O Connections assignments ------------------------------
  --------------------------------------------------------------------------------
  PULSES <= pulse;

  --------------------------------------------------------------------------------
  --------------------- BODY -----------------------------------------------------
  --------------------------------------------------------------------------------

  freq_div_gen : process (CLK)
  begin
    if (rising_edge(CLK)) then
      if (RESET = '1') then
        pulse     <= '0';
        cnt_ticks <= (others => '0');
      else
        if (FREQ_DIV = std_logic_vector(C_COUNTER_ZERO)) then
          pulse     <= '0';
          cnt_ticks <= (others => '0');

        elsif (PULSES_EN = '0') then
          pulse     <= '0';
          cnt_ticks <= (others => '0');

        elsif (cnt_ticks = C_COUNTER_ZERO) then
          pulse     <= '1';
          cnt_ticks <= unsigned(FREQ_DIV) - C_COUNTER_ONE;

        else
          pulse     <= '0';
          cnt_ticks <= cnt_ticks - C_COUNTER_ONE;

        end if;
      end if;
    end if;
  end process freq_div_gen;

end rtl;