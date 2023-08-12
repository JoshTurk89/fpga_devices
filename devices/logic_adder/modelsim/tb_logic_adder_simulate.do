onbreak {quit -f} 
onerror {quit -f} 

vsim -t ps -voptargs="+acc"  -wlf work/vsim.wlf work.tb_logic_adder 

set NumericStdNoWarnings 1 
set StdArithNoWarnings 1 

do {wave_tb_logic_adder.do} 

view wave 
view structure 
view signals 
