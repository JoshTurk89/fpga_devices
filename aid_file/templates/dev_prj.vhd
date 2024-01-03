
------------------------------------------------------------------------------
-- Device/Project: Logic Adder Device
-- File: 	logic_adder.vhd
-- Author:	Joshua Jesus Quintana Di­az
-- Date:	
-- Version:	1.0
-- History:	1.0 Initial Version
-- Design:	
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
use work.TBD.all;

entity dev_prj_entity is
  generic (

  );
  port (

  );
end entity;

architecture rtl of dev_prj_entity is
  --------------------------------------------------------------------------------
  --------------------- ATTRIBUTES -----------------------------------------------
  --------------------------------------------------------------------------------

  --------------------------------------------------------------------------------
  --------------------- CONSTANT -------------------------------------------------
  --------------------------------------------------------------------------------

  --------------------------------------------------------------------------------
  ---------------------- TYPES ---------------------------------------------------
  --------------------------------------------------------------------------------

  --------------------------------------------------------------------------------
  ------------------------ SIGNALS -----------------------------------------------
  --------------------------------------------------------------------------------

begin

  --------------------------------------------------------------------------------
  ----------------------- Check defined memory widths ----------------------------
  --------------------------------------------------------------------------------
  -- assert(natural(ceil(log2(real((G_CAM_NUM_WORD + G_DPRAM_NUM_WORD))))) = natural(floor(log2(real((G_CAM_NUM_WORD + G_DPRAM_NUM_WORD))))))
  -- report "The sum of number of words (CAM & DPRAM) is not 2^n." severity failure;
  -- assert((G_MEM_DATA_WIDTH mod 8) = 0) report "Wrong data width. It shall be multiple by 8" severity failure;
  -- assert(G_AXI_ADDR_WIDTH >= (C_OPT_MEM_ADDR_BITS + C_ADDR_LSB)) report "Wrong AXI address bus length." severity failure;
  -- assert(G_AXI_DATA_WIDTH = (G_MEM_DATA_WIDTH * (G_CAM_MODE + 1))) report "Wrong AXI data bus length." severity failure;

  --------------------------------------------------------------------------------
  --------------------- I/O Connections assignments ------------------------------
  --------------------------------------------------------------------------------

  --------------------------------------------------------------------------------
  --------------------- BODY -----------------------------------------------------
  --------------------------------------------------------------------------------

  -- bistable_name : process (CLK)
  -- begin
  --   if (rising_edge(CLK)) then
  --     if (ARESETN = '0') then
  --     else
  --     end if;
  --   end if;
  -- end process bistable_name;

  --------------------------------------------------------------------------------
  ---------------------- COMPONENT INSTANTIATION ---------------------------------
  --------------------------------------------------------------------------------

  DEV : device
  generic map(
    G_example_1 => example_1,
    G_example_2 => example_2
  )
  port map(
    EXAMPLE_1 => example_1,
    EXAMPLE_2 => example_2
  );

end architecture;
