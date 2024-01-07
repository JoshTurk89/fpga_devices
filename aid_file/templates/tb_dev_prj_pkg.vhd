
------------------------------------------------------------------------------
-- Device/Project:  Testbench Device/Project name package
-- File: 	          tb_dev_prj_pkg.vhd
-- Author:	        Joshua Jesus Quintana Di­az
-- Date:	          dd/mm/yy
-- Version:	        1.0
-- History:	        1.0 Initial Version
------------------------------------------------------------------------------
-- Description: 
------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.log2;
use ieee.math_real.ceil;
use ieee.math_real.floor;

library work;
use work.logger_pkg.all;
use work.tb_common_pkg.all;

package tb_dev_prj_pkg is

  -------------------------------------------------------------------------------
  -------------------------- CONSTANTS ------------------------------------------
  -------------------------------------------------------------------------------
  constant C_CLK_SYS : time := 10 ns;

  --------------------------------------------------------------------------------
  ------------------ DUT COMPONENT INSTANTIATION ---------------------------------
  -------------------------------------------------------------------------------- 

  -- Device Under Test (DUT)
  component dut is
    generic (

    );
    port (

    );
  end component;

  --------------------------------------------------------------------------------
  ----------------- AGENT COMPONENT INSTANTIATION --------------------------------
  -------------------------------------------------------------------------------- 

  --  Agent
  component agent_0 is
    generic (

    );
    port (

    );
  end component;

end tb_dev_prj_pkg;

package body tb_dev_prj_pkg is

end tb_dev_prj_pkg;
