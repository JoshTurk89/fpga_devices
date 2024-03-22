--Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
--Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2023.2 (win64) Build 4029153 Fri Oct 13 20:14:34 MDT 2023
--Date        : Mon Mar 18 23:04:19 2024
--Host        : Josh running 64-bit major release  (build 9200)
--Command     : generate_target pulsegen_display_bd_wrapper.bd
--Design      : pulsegen_display_bd_wrapper
--Purpose     : IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity pulsegen_display_bd_wrapper is
  port (
    AN : out STD_LOGIC_VECTOR ( 3 downto 0 );
    CLK : in STD_LOGIC;
    DISPLAY : out STD_LOGIC_VECTOR ( 7 downto 0 );
    FREQ_DIV : in STD_LOGIC_VECTOR ( 13 downto 0 );
    PULSES : out STD_LOGIC;
    RESET : in STD_LOGIC
  );
end pulsegen_display_bd_wrapper;

architecture STRUCTURE of pulsegen_display_bd_wrapper is
  component pulsegen_display_bd is
  port (
    RESET : in STD_LOGIC;
    CLK : in STD_LOGIC;
    FREQ_DIV : in STD_LOGIC_VECTOR ( 13 downto 0 );
    DISPLAY : out STD_LOGIC_VECTOR ( 7 downto 0 );
    AN : out STD_LOGIC_VECTOR ( 3 downto 0 );
    PULSES : out STD_LOGIC
  );
  end component pulsegen_display_bd;
begin
pulsegen_display_bd_i: component pulsegen_display_bd
     port map (
      AN(3 downto 0) => AN(3 downto 0),
      CLK => CLK,
      DISPLAY(7 downto 0) => DISPLAY(7 downto 0),
      FREQ_DIV(13 downto 0) => FREQ_DIV(13 downto 0),
      PULSES => PULSES,
      RESET => RESET
    );
end STRUCTURE;
