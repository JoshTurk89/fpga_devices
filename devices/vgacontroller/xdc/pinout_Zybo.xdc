
## Clock signal
set_property -dict { PACKAGE_PIN L16   IOSTANDARD LVCMOS33 } [get_ports CLK]; #IO_L11P_T1_SRCC_35 Sch=sysclk

##Buttons
set_property -dict { PACKAGE_PIN R18   IOSTANDARD LVCMOS33 } [get_ports RESET]; #IO_L12N_T1_MRCC_35 Sch=btn[0]

##VGA Connector
set_property -dict { PACKAGE_PIN M19   IOSTANDARD LVCMOS33 } [get_ports { RGB[0] }]; #IO_L7P_T1_AD2P_35 Sch=VGA_R1
set_property -dict { PACKAGE_PIN L20   IOSTANDARD LVCMOS33 } [get_ports { RGB[1] }]; #IO_L9N_T1_DQS_AD3N_35 Sch=VGA_R2
set_property -dict { PACKAGE_PIN J20   IOSTANDARD LVCMOS33 } [get_ports { RGB[2] }]; #IO_L17P_T2_AD5P_35 Sch=VGA_R3
set_property -dict { PACKAGE_PIN G20   IOSTANDARD LVCMOS33 } [get_ports { RGB[3] }]; #IO_L18N_T2_AD13N_35 Sch=VGA_R4
set_property -dict { PACKAGE_PIN F19   IOSTANDARD LVCMOS33 } [get_ports { RGB[4] }]; #IO_L15P_T2_DQS_AD12P_35 Sch=VGA_R5
set_property -dict { PACKAGE_PIN H18   IOSTANDARD LVCMOS33 } [get_ports { RGB[5] }]; #IO_L14N_T2_AD4N_SRCC_35 Sch=VGA_G0
set_property -dict { PACKAGE_PIN N20   IOSTANDARD LVCMOS33 } [get_ports { RGB[6] }]; #IO_L14P_T2_SRCC_34 Sch=VGA_G1
set_property -dict { PACKAGE_PIN L19   IOSTANDARD LVCMOS33 } [get_ports { RGB[7] }]; #IO_L9P_T1_DQS_AD3P_35 Sch=VGA_G2
set_property -dict { PACKAGE_PIN J19   IOSTANDARD LVCMOS33 } [get_ports { RGB[8] }]; #IO_L10N_T1_AD11N_35 Sch=VGA_G3
set_property -dict { PACKAGE_PIN H20   IOSTANDARD LVCMOS33 } [get_ports { RGB[9] }]; #IO_L17N_T2_AD5N_35 Sch=VGA_G4
set_property -dict { PACKAGE_PIN F20   IOSTANDARD LVCMOS33 } [get_ports { RGB[10] }]; #IO_L15N_T2_DQS_AD12N_35 Sch=VGA=G5
set_property -dict { PACKAGE_PIN P20   IOSTANDARD LVCMOS33 } [get_ports { RGB[11] }]; #IO_L14N_T2_SRCC_34 Sch=VGA_B1
set_property -dict { PACKAGE_PIN M20   IOSTANDARD LVCMOS33 } [get_ports { RGB[12] }]; #IO_L7N_T1_AD2N_35 Sch=VGA_B2
set_property -dict { PACKAGE_PIN K19   IOSTANDARD LVCMOS33 } [get_ports { RGB[13] }]; #IO_L10P_T1_AD11P_35 Sch=VGA_B3
set_property -dict { PACKAGE_PIN J18   IOSTANDARD LVCMOS33 } [get_ports { RGB[14] }]; #IO_L14P_T2_AD4P_SRCC_35 Sch=VGA_B4
set_property -dict { PACKAGE_PIN G19   IOSTANDARD LVCMOS33 } [get_ports { RGB[15] }]; #IO_L18P_T2_AD13P_35 Sch=VGA_B5
set_property -dict { PACKAGE_PIN P19   IOSTANDARD LVCMOS33 } [get_ports HSYNC]; #IO_L13N_T2_MRCC_34 Sch=VGA_HS
set_property -dict { PACKAGE_PIN R19   IOSTANDARD LVCMOS33 } [get_ports VSYNC]; #IO_0_34 Sch=VGA_VS
