
------------------------------------------------------------------------------
-- Device/Project:  Device/Project name tested
-- File: 	          seqyyzz_pkg.vhd "zz -> num of sequentian" "yy -> type of functionality"
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

library work;
use work.tb_bin2bcd_pkg.all;
use work.logger_pkg.all;

package seq0000 is

  procedure seq0000_nominal (
    signal CLK       : in  std_logic;
    signal RESET     : in  std_logic;
    signal SEQ_START : out std_logic;
    signal SEQ_BUSY  : in  std_logic;
    signal BIN       : out std_logic_vector(13 downto 0);
    signal UNIT      : in  std_logic_vector(3 downto 0);
    signal TEN       : in  std_logic_vector(3 downto 0);
    signal HUNDRED   : in  std_logic_vector(3 downto 0);
    signal THOUSAND  : in  std_logic_vector(3 downto 0)
  );

end seq0000;

package body seq0000 is
  procedure seq0000_nominal (
    signal CLK       : in  std_logic;
    signal RESET     : in  std_logic;
    signal SEQ_START : out std_logic;
    signal SEQ_BUSY  : in  std_logic;
    signal BIN       : out std_logic_vector(13 downto 0);
    signal UNIT      : in  std_logic_vector(3 downto 0);
    signal TEN       : in  std_logic_vector(3 downto 0);
    signal HUNDRED   : in  std_logic_vector(3 downto 0);
    signal THOUSAND  : in  std_logic_vector(3 downto 0)
  ) is

    ----------------------------------------------------------------------------    
    ----------------------------------------------------------------------------    
    ----------------------------------------------------------------------------
    -- Constant to make available each step
    constant C_STEP10_EN : boolean := true;
    constant C_STEP20_EN : boolean := true;

    variable v_unit      : integer := 0;
    variable v_ten       : integer := 0;
    variable v_hundred   : integer := 0;
    variable v_thousand  : integer := 0;
    variable v_carrier   : integer := 0;

  begin

    --------------------------------------------------------------------------------
    ----------------- INITIALIZATION -----------------------------------------------
    --------------------------------------------------------------------------------

    SEQ_START <= '0';
    BIN       <= (others => '0');

    wait until RESET = '0';
    wait for 400 ns;

    ------------------------------------------------------------------------------
    -- Test 010 : "Step Description"
    ------------------------------------------------------------------------------

    if C_STEP10_EN then

      for i in 0 to 9999 loop
        BIN <= std_logic_vector(to_unsigned(i, 14));
        wait for 500 ns;

        if v_unit /= to_integer(unsigned(UNIT)) then
          rep_error(" UNIT ERROR ");
        end if;

        if v_ten /= to_integer(unsigned(TEN)) then
          rep_error(" TEN ERROR ");
        end if;

        if v_hundred /= to_integer(unsigned(HUNDRED)) then
          rep_error(" HUNDRED ERROR ");
        end if;

        if v_thousand /= to_integer(unsigned(THOUSAND)) then
          rep_error(" THOUSAND ERROR ");
        end if;

        if v_unit = 9 then
          v_unit := 0;

          if v_ten = 9 then
            v_ten := 0;

            if v_hundred = 9 then
              v_hundred  := 0;

              v_thousand := v_thousand + 1;

            else
              v_hundred := v_hundred + 1;
            end if;

          else
            v_ten := v_ten + 1;
          end if;

        else
          v_unit := v_unit + 1;
        end if;

      end loop;

    else
      rep_error(" == STEP10 skipped == ");
    end if;

    wait for 1 us;

    ------------------------------------------------------------------------------
    -- Test 020 : "Step Description"
    ------------------------------------------------------------------------------

    if C_STEP20_EN then

    else
      rep_error(" == STEP20 skipped == ");
    end if;

    wait for 1 us;

    assert false report "SIM END" severity failure;

  end seq0000_nominal;

end seq0000;