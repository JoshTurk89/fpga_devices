-- ----------------------------------------------------------------------------
-- Project Name  : tb_
-- Library       : crf212_sequences
-- Package Header: test001000)
-- File          : test001000_pkg.vhd
-- Lenguaje      : VHDL
-- --------------------------------------------------------------------------
-- Author        : fpfermoselle
-- Time          : 17:09:57 
-- Date          : 16-03-2020
-- --------------------------------------------------------------------------
-- Description   : RTL code
--
-- Notes         : None
-- 
-- Limitations   : None
-- ----------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.math_real.uniform;
use ieee.math_real.floor;

package test000000 is

  type t_in_rnd is array (0 to 10) of std_logic_vector(7 downto 0);
  type t_out_rnd is array (0 to 10) of std_logic_vector(8 downto 0);

  procedure test000000_logic_adder_1b (
    signal clk   : in  std_logic;
    signal reset : in  std_logic;
    signal a     : out std_logic_vector(7 downto 0);
    signal b     : out std_logic_vector(7 downto 0);
    signal s     : in  std_logic_vector(8 downto 0)
  );

  procedure adder (
    variable a : in  t_in_rnd;
    variable b : in  t_in_rnd;
    variable s : out t_out_rnd
  );

  function data_rnd(seed1 : in positive; seed2 : in positive; width_bit : in integer) return t_in_rnd;
end test000000;

package body test000000 is
  procedure test000000_logic_adder_1b (
    signal clk   : in  std_logic;
    signal reset : in  std_logic;
    signal a     : out std_logic_vector(7 downto 0);
    signal b     : out std_logic_vector(7 downto 0);
    signal s     : in  std_logic_vector(8 downto 0)
  ) is

    variable tb_a : t_in_rnd  := (others => (others => '0'));
    variable tb_b : t_in_rnd  := (others => (others => '0'));
    variable tb_s : t_out_rnd := (others => (others => '0'));

    variable test_pass   : boolean := True;
    variable error_count : integer := 0;

  begin

    a <= (others => '0');
    b <= (others => '0');

    wait until reset = '0';
    wait for 200 ns;

    tb_a := data_rnd(1, 5, 8);
    tb_b := data_rnd(2, 3, 8);
    adder(tb_a, tb_b, tb_s);

    for i in 0 to 10 loop
      a <= tb_a(i);
      b <= tb_b(i);
      wait for 20 ns;

      if tb_s(i) /= s then
        test_pass   := False;
        error_count := error_count + 1;
        assert False report("The sum has failed: real -> " & integer'image(conv_integer(unsigned(tb_s(i)))) &
        " / expected -> " & integer'image(conv_integer(unsigned(s)))) severity error;
      end if;

    end loop;

    if test_pass then
      report("Test Passed");
    else
      report("Test Failed with " & integer'image(error_count) & " errors");
    end if;

	wait for 1 us;

    assert false report "SIM END" severity failure;

  end test000000_logic_adder_1b;

  -- -------------------------------------------------------------------------
  -- Data Random
  -- -------------------------------------------------------------------------   	
  procedure adder (
    variable a : in  t_in_rnd;
    variable b : in  t_in_rnd;
    variable s : out t_out_rnd
  ) is
  begin

    for i in 0 to 10 loop
      s(i) := conv_std_logic_vector(conv_integer(unsigned(a(i))) + conv_integer(unsigned(b(i))), 9);
    end loop;

  end adder;

  -- -------------------------------------------------------------------------
  -- Data Random
  -- -------------------------------------------------------------------------
  function data_rnd(seed1 : in positive; seed2 : in positive; width_bit : in integer) return t_in_rnd is
    variable v_seed1 : positive := seed1;
    variable v_seed2 : positive := seed2;
    variable v_x     : real;
    variable v_max   : real;
    variable data    : t_in_rnd;
  begin

    v_max := real((2 ** (width_bit)) - 1);

    for i in 0 to 10 loop
      uniform(v_seed1, v_seed2, v_x);
      data(i) := conv_std_logic_vector(integer(floor(v_x * v_max)), width_bit);
    end loop;

    return data;

  end function;

end test000000;
