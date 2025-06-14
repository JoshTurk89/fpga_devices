--Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
--Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2023.2 (win64) Build 4029153 Fri Oct 13 20:14:34 MDT 2023
--Date        : Thu Apr  4 14:40:50 2024
--Host        : Josh running 64-bit major release  (build 9200)
--Command     : generate_target vgacontroller_bd_wrapper.bd
--Design      : vgacontroller_bd_wrapper
--Purpose     : IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity vgacontroller_bd_wrapper is
  port (
    CLK : in STD_LOGIC;
    HSYNC : out STD_LOGIC;
    RESET : in STD_LOGIC;
    RGB : out STD_LOGIC_VECTOR ( 11 downto 0 );
    VSYNC : out STD_LOGIC
  );
end vgacontroller_bd_wrapper;

architecture STRUCTURE of vgacontroller_bd_wrapper is
  component vgacontroller_bd is
  port (
    CLK : in STD_LOGIC;
    RESET : in STD_LOGIC;
    VSYNC : out STD_LOGIC;
    HSYNC : out STD_LOGIC;
    RGB : out STD_LOGIC_VECTOR ( 11 downto 0 )
  );
  end component vgacontroller_bd;
begin
vgacontroller_bd_i: component vgacontroller_bd
     port map (
      CLK => CLK,
      HSYNC => HSYNC,
      RESET => RESET,
      RGB(11 downto 0) => RGB(11 downto 0),
      VSYNC => VSYNC
    );
end STRUCTURE;
