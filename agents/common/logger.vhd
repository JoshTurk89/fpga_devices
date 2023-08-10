
-------------------------------------------------------------------------------- 
--  
-- COMPANY CONFIDENTIAL 
-- Copyright (c) TECNOBIT  2017 
--  
-- TECNOBIT S.L. 
--  
-- Filename               : logger_pkg.vhd 
-- Author                 : jjquintana
-- Creation Date          : 04/10/2022 
-- Origin Project         : N/A 
-- Repo path              : 
-- Architecture           : N/A
-- Functional description :  

--  
-- Version                : 0.0.0 -> First Version. File Created.                                                          --      
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

--------------------------------------------------------------------------------
package logger_pkg is

  shared variable sv_num_errors   : integer := 0;
  shared variable sv_num_warnings : integer := 0;

  procedure rep_note (
    msg : string
  );

  procedure rep_warning (
    msg : string
  );

  procedure rep_error (
    msg : string
  );

  procedure rep_failure (
    msg : string
  );

end package logger_pkg;
--------------------------------------------------------------------------------
package body logger_pkg is

  procedure rep_note (
    msg : string
  ) is
  begin
    assert false
    report msg
      severity note;
  end procedure;

  procedure rep_warning (
    msg : string
  ) is
  begin
    assert false
    report msg
      severity warning;

    sv_num_warnings := sv_num_warnings + 1;
  end procedure;

  procedure rep_error (
    msg : string
  ) is
  begin
    assert false
    report msg
      severity error;

    sv_num_errors := sv_num_errors + 1;
  end procedure;

  procedure rep_failure (
    msg : string
  ) is
  begin
    assert false
    report msg
      severity failure;

  end procedure;

end package body;
--------------------------------------------------------------------------------