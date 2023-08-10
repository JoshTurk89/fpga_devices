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
use xil_defaultlib.agent_axistream_slv_pkg.all;

--------------------------------------------------------------------------------
package agent_axistream_slv_proc_pkg is

  --==========================================================================
	
	procedure axistream_slv_init   (
		signal sq_axistream_slv_in : out sq_axistream_slv_in);
 
 	--==========================================================================    

end package agent_axistream_slv_proc_pkg;

-- --------------------------------------------------------------------------

package body agent_axistream_slv_proc_pkg is

	procedure axistream_slv_init(signal sq_axistream_slv_in : out sq_axistream_slv_in) is
	begin
		sq_axistream_slv_in.verbose       <= False;
		sq_axistream_slv_in.rx_tready     <= '0';
		sq_axistream_slv_in.rx_tready_seq	<= False;
	end axistream_slv_init;
	
 end agent_axistream_slv_proc_pkg;