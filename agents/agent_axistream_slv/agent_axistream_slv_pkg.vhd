------------------------------------------------------------------------------- 
--  
-- COMPANY CONFIDENTIAL 
-- Copyright (c) TECNOBIT  2017 
--  
-- TECNOBIT S.L. 
--  
-- Filename               : file.vhd 
-- Author                 : microman
-- Creation Date          : 04/10/2022 
-- Repo path              : 
-- Architecture           : synthesizable 
-- Functional description :  
--  
-- description: Package functions to manage agent_axistream_mst 
--  
-- Version                : 1.0.0 

--------------------------------------------------------------------------------
-- Libraries    |                                                             --      
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

library xil_defaultlib;
use xil_defaultlib.logger_pkg.all;

--------------------------------------------------------------------------------
package agent_axistream_slv_pkg is

    constant c_axistream_data_width : integer range 0 to 256 := 64;

	type sq_axistream_slv_in is record
		verbose         : boolean;
		rx_tready       : std_logic;
		rx_tready_seq   : boolean;
	end record;

	type sq_axistream_slv_out is record
		rx_tdata : std_logic_vector(c_axistream_data_width - 1 downto 0);
	end record;	

end package agent_axistream_slv_pkg;
--------------------------------------------------------------------------------
