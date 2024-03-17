vlib work/
vmap work/

set DUTDev       pulse_gen

set DUTDevDir    D:/Data/git/fpga_devices/devices/$DUTDev/vhdl
set TBDir        D:/Data/git/fpga_devices/devices/$DUTDev/tb/sim
set TBSQDir      D:/Data/git/fpga_devices/devices/$DUTDev/tb/sim/sequences

# Simulation Files

# DUT Devices Files 
vcom -2008 -work work  \
"D:/Data/git/fpga_devices/agents/common/logger.vhd" \
"$DUTDevDir/pulse_gen.vhd" \

# Testbench Files 
vcom -2008 -work work  \
"$TBDir/tb_pulse_gen_pkg.vhd" \
"$TBSQDir/seq0000_pkg.vhd" \
"$TBDir/tb_pulse_gen.vhd" \

