vlib work/
vmap work/

set DUTDev       vgacontroller

set AgentDir     D:/Data/git/fpga_devices/agents
set DevDir       D:/Data/git/fpga_devices/devices
set DUTDevDir    D:/Data/git/fpga_devices/devices/$DUTDev/vhdl
set TBDir        D:/Data/git/fpga_devices/devices/$DUTDev/tb/sim
set TBSQDir      D:/Data/git/fpga_devices/devices/$DUTDev/tb/sim/sequences

# Simulation Files
vcom -2008 -work work  \
"$AgentDir/common/logger.vhd" \

# Devices Files 
vcom -2008 -work work  \
"$DevDir/pulse_gen/vhdl/pulse_gen.vhd" \

# DUT Devices Files 
vcom -2008 -work work  \
"$DUTDevDir/vgacontroller_pkg.vhd" \
"$DUTDevDir/vgacontroller.vhd" \

# Testbench Files 
vcom -2008 -work work  \
"$TBDir/tb_vgacontroller_pkg.vhd" \
"$TBSQDir/seq0000_pkg.vhd" \
"$TBDir/tb_vgacontroller.vhd" \

