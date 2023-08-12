vlib work/ 
vmap work/ 

set DUTDev       logic_adder

set DUTDevDir    ../../$DUTDev/vhdl
set TBDir        ../../$DUTDev/tb/sim
set TBSQDir      ../../$DUTDev/tb/sim/sequences

# DUT Devices Files 
vcom -2008 -work work  \
"$DUTDevDir/logic_adder.vhd" \

# Testbench Files 
vcom -2008 -work work  \
"$TBSQDir/test000000_pkg.vhd" \
"$TBDir/tb_logic_adder.vhd" \

