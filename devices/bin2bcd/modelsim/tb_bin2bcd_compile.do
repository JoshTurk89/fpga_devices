vlib work/
vmap work/

set DUTDev       bin2bcd

set AgentDir     D:/Data/git/fpga_devices/agents
set DevDir       D:/pl-hscl/devices
set DUTDevDir    D:/Data/git/fpga_devices/devices/$DUTDev/vhdl
set TBDir        D:/Data/git/fpga_devices/devices/$DUTDev/tb/sim
set TBSQDir      D:/Data/git/fpga_devices/devices/$DUTDev/tb/sim/sequences

# Simulation Files
vcom -2008 -work work  \
"$AgentDir/common/logger.vhd" \

# DUT Devices Files 
vcom -2008 -work work  \
"$DUTDevDir/bin2bcd.vhd" \

# Testbench Files
vcom -2008 -work work  \
"$TBDir/tb_bin2bcd_pkg.vhd" \
"$TBSQDir/seq0000_pkg.vhd" \
"$TBDir/tb_bin2bcd.vhd" \

