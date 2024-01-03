vlib work/ 
vmap work/ 

set DUTDev       pulse_gen_sync

set AgentDir     D:/pl-hscl/agents
set DevDir       D:/pl-hscl/devices
set DUTDevDir    D:/pl-hscl/devices/$DUTDev/vhdl
set TBDir        D:/pl-hscl/devices/$DUTDev/tb/sim
set TBSQDir      D:/pl-hscl/devices/$DUTDev/tb/sim/sequences

# Simulation Files
vcom -2008 -work work  \
"$AgentDir/example/example.vhd" \

# Common Package 
vcom -2008 -work work  \ 
"$DevDir/example/example.vhd" \

# Devices Files 
vcom -2008 -work work  \ 
"$DevDir/example/example.vhd" \

# DUT Devices Files 
vcom -2008 -work work  \ 
"$DUTDevDir/example/example.vhd" \

# Testbench Files 
vcom -2008 -work work  \ 
"$TBDir/tb_example_pkg.vhd" \ 
"$TBSQDir/test00000_pkg.vhd" \ 
"$TBDir/tb_example.vhd" \ 

