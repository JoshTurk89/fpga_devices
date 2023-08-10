
-------------------------------------------------------------------------------- 
--  
-- COMPANY CONFIDENTIAL 
-- Copyright (c) TECNOBIT  2017 
--  
-- TECNOBIT S.L. 
--  
-- Filename               : tb_common_pkg.vhd 
-- Author                 : jjquintana
-- Creation Date          : 23/10/2022
-- Origin Project         : N/A 
-- Repo path              : 
-- Architecture           : N/A 
-- Functional description :  
-- 
--  
-- Version                : 0.0.0 -> First Version. File Created.
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

use std.textio.all;
use ieee.std_logic_textio.all;

package tb_common_pkg is

  -- Unconstraint array of std_logic_vector
  type t_std_logic_vector_array is array (natural range <>) of std_logic_vector;

  --------------------------------------------------------------------------------
  ----------------------------- PROCEDURES ---------------------------------------
  --------------------------------------------------------------------------------
  procedure proc_download_file (
    constant C_FILE_NAME   : in  string;
    constant C_ARRAY_WIDTH : in  integer;
    constant C_DATA_WIDTH  : in  integer;
    variable v_verbose     : in  boolean;
    variable v_data_array  : out t_std_logic_vector_array
  );

  --------------------------------------------------------------------------------
  ----------------------------- FUNCTIONS ----------------------------------------
  --------------------------------------------------------------------------------
  impure function func_load_file(file log : text; verbose : boolean; array_width : natural; data_width : natural) return t_std_logic_vector_array;

  function data_rnd(seed1                 : in positive; seed2 : in positive; data_rnd_max : in integer) return integer;

end package tb_common_pkg;
--------------------------------------------------------------------------------
package body tb_common_pkg is

  procedure proc_download_file (
    constant C_FILE_NAME   : in  string;
    constant C_ARRAY_WIDTH : in  integer;
    constant C_DATA_WIDTH  : in  integer;
    variable v_verbose     : in  boolean;
    variable v_data_array  : out t_std_logic_vector_array
  )is

    file input_file : text;
    variable v_verb : boolean := False;

  begin

    file_open(input_file, C_FILE_NAME, read_mode);
    v_data_array := func_load_file (input_file, v_verb, C_ARRAY_WIDTH, C_DATA_WIDTH);
    file_close(input_file);

    if v_verbose then
      for i in 0 to v_data_array'length - 1 loop
        report ("DATA " & integer'image(i) & " --> " & to_hstring(v_data_array(i)));
      end loop;
    end if;

  end proc_download_file;

  --------------------------------------------------------------------------------
  ----------------------------- FUNCTIONS ----------------------------------------
  --------------------------------------------------------------------------------
  impure function func_load_file(file log : text; verbose : boolean; array_width : natural; data_width : natural) return t_std_logic_vector_array is
    variable v_line                         : line;
    variable v_data_aux                     : std_logic_vector(data_width - 1 downto 0)                           := (others => '0');
    variable i                              : integer                                                             := 0;
    variable v_data                         : t_std_logic_vector_array(0 to array_width - 1)(data_width - 1 downto 0) := (others => (others => '0'));
    variable v_char                         : character;
  begin

    while not endfile (log) loop

      readline (log, v_line);
      read (v_line, v_char);

      if v_char /= '#' then
        hread(v_line, v_data_aux);
        v_data (i) := v_data_aux;
        i          := i + 1;
      end if;

      if verbose then
        report(" Data --> " & to_hstring(v_data_aux));
      end if;

    end loop;

    return v_data;

  end function;

  function data_rnd(seed1 : in positive; seed2 : in positive; data_rnd_max : in integer) return integer is
    variable v_seed1        : positive := seed1;
    variable v_seed2        : positive := seed2;
    variable v_x            : real;
    variable value          : integer := 0;
    variable count          : integer := 0;
  begin
    value := 0;
    while (value = 0) loop
      uniform(v_seed1, v_seed2, v_x);
      value := integer(floor(v_x * real(data_rnd_max)));
      count := count + 1;
      if count = 3 then
        value := 1;
      end if;
    end loop;

    return value;

  end function;

end package body;
--------------------------------------------------------------------------------