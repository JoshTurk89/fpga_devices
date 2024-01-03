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

entity pulse_gen_sync is
  generic (
    G_FREQ_DIV_WIDTH : natural range 1 to 32        := 7;
    G_CLK_SOURCE     : integer range 1 to 500000000 := 50000000
  );
  port (
    CLK       : in  std_logic;
    RESET     : in  std_logic;
    GEN_EN    : in  std_logic;
    FREQ_DIV  : in  std_logic_vector (G_FREQ_DIV_WIDTH - 1 downto 0);
    PULSES    : out std_logic;
    PULSES_EN : out std_logic
  );
end entity;

architecture rtl of pulse_gen_sync is
  --------------------------------------------------------------------------------
  ------------------------ SIGNALS -----------------------------------------------
  --------------------------------------------------------------------------------

  signal gen_div_q0  : std_logic;
  signal gen_div_q1  : std_logic;
  signal freq_div_q0 : std_logic_vector(G_FREQ_DIV_WIDTH - 1 downto 0);
  signal freq_div_q1 : std_logic_vector(G_FREQ_DIV_WIDTH - 1 downto 0);

  signal pulses_en_q0 : std_logic;
  signal pulse        : std_logic;
  signal counter      : unsigned(G_FREQ_DIV_WIDTH - 1 downto 0);

begin

  --------------------------------------------------------------------------------
  --------------------- I/O Connections assignments ------------------------------
  --------------------------------------------------------------------------------
  PULSES_EN <= pulses_en_q0;
  PULSES    <= pulse;

  --------------------------------------------------------------------------------
  --------------------- BODY -----------------------------------------------------
  --------------------------------------------------------------------------------
  freq_div_sync : process (CLK)
  begin
    if (rising_edge(CLK)) then
      if (RESET = '1') then
        freq_div_q1 <= (others => '0');
        freq_div_q0 <= (others => '0');
      else
        freq_div_q1 <= freq_div_q0;
        freq_div_q0 <= FREQ_DIV;
      end if;
    end if;
  end process freq_div_sync;

end architecture;

gen_div_sync : process (CLK)
begin
  if (rising_edge(CLK)) then
    if (RESET = '1') then
      gen_div_q1 <= '0';
      gen_div_q0 <= '0';
    else
      gen_div_q1 <= gen_div_q0;
      gen_div_q0 <= GEN_EN;
    end if;
  end if;
end process gen_div_sync;

pulses_gen_sync : process (CLK)
begin
  if (rising_edge(CLK)) then
    if (RESET = '1') then
      pulses_en_q0 <= '0';
    else
      pulses_en_q0 <= gen_div_q1;
    end if;
  end if;
end process pulses_gen_sync;

pul_gen : process (CLK)
begin
  if (rising_edge(CLK)) then
    if (RESET = '1') then
      counter <= (others => '0');
      pulse   <= '0';
    else
      if gen_div_q1 = '0' then
        counter <= to_unsigned(((G_CLK_SOURCE / to_integer(unsigned(FREQ_DIV))) - 1), counter'length);
        pulse   <= '0';
      else
        if gen_div_q1 = '1'and pulses_en_q0 = '0' then
          pulse <= '1';
        elsif counter = (others => '0') then
          pulse   <= '1';
          counter <= to_unsigned(((G_CLK_SOURCE / to_integer(unsigned(FREQ_DIV))) - 1), counter'length);
        else
          pulse   <= '0';
          counter <= counter - 1;
        end if;
      end if;
    end if;
  end process pul_gen;

end architecture;
