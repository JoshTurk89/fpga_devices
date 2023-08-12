------------------------------------------------------------------------------
-- Project: Logic Adder Device
-- File: 	logic_adder.vhd
-- Author:	Joshua Jesus Quintana Di­az
-- Date:	19/10/22
-- Version:	1.0
-- History:	1.0 Initial Version
-- Design:	Implementation of logic adder with variable size entry.
------------------------------------------------------------------------------
-- Description: This module can be used for adding different size of 
-- 				std_logic_vectors using logic gates.
------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity logic_adder is
  generic (
    G_WIDTH : natural range 1 to 64 := 8 -- width of bit from 1 to 64 bit
  );
  port (
    CLK   : in  std_logic;
    RESET : in  std_logic;
    A     : in  std_logic_vector((G_WIDTH - 1) downto 0);
    B     : in  std_logic_vector((G_WIDTH - 1) downto 0);
    S     : out std_logic_vector(G_WIDTH downto 0)
  );
end logic_adder;

architecture rtl of logic_adder is

  signal sout     : std_logic_vector((G_WIDTH - 1) downto 0);
  signal cout     : std_logic_vector((G_WIDTH - 1) downto 0);
  signal soutcout : std_logic_vector(G_WIDTH downto 0);

begin
  --------------------------------------------------------------------------------
  --------------------- I/O Connections assignments ------------------------------
  --------------------------------------------------------------------------------

  S <= soutcout;

  --------------------------------------------------------------------------------
  --------------------- Register the Output --------------------------------------
  --------------------------------------------------------------------------------
  process (CLK)
  begin
    if rising_edge(CLK) then
      if RESET = '1' then
        soutcout <= (others => '0');
      else
        soutcout <= cout(cout'high) & sout;
      end if;
    end if;
  end process;

  --------------------------------------------------------------------------------
  --------------------------- Adder 1 bit ----------------------------------------
  --------------------------------------------------------------------------------
  adder_1bit : if G_WIDTH = 1 generate
    signal p0 : std_logic;
    signal p1 : std_logic;
    signal p2 : std_logic;
  begin
    p0      <= A(0) xor B(0);
    sout(0) <= p0 xor '0';
    p1      <= p0 and '0';
    p2      <= A(0) and B(0);
    cout(0) <= p1 or p2;
  end generate adder_1bit;

  --------------------------------------------------------------------------------
  --------------------------- Adder n bit ----------------------------------------
  --------------------------------------------------------------------------------
  adder_nbit : if G_WIDTH > 1 generate
    signal p0 : std_logic_vector((G_WIDTH - 1) downto 0);
    signal p1 : std_logic_vector((G_WIDTH - 1) downto 0);
    signal p2 : std_logic_vector((G_WIDTH - 1) downto 0);
  begin

    p0 (0)  <= A(0) xor B(0);
    sout(0) <= p0(0) xor '0';
    p1 (0)  <= p0(0) and '0';
    p2 (0)  <= A(0) and B(0);
    cout(0) <= p1(0) or p2(0);

    for_adder_nbit : for i in 1 to (G_WIDTH - 1) generate
    begin
      p0 (i)  <= A(i) xor B(i);
      sout(i) <= p0(i) xor cout(i - 1);
      p1 (i)  <= p0(i) and cout(i - 1);
      p2 (i)  <= A(i) and B(i);
      cout(i) <= p1(i) or p2(i);
    end generate for_adder_nbit;

  end generate adder_nbit;

end rtl;
