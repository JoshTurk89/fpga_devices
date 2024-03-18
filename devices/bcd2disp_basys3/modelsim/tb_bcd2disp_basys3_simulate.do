onbreak {quit -f} 
onerror {quit -f} 

vsim -t ps -voptargs="+acc"  -wlf work/vsim.wlf work.tb_bcd2disp_basys3 

set NumericStdNoWarnings 1 
set StdArithNoWarnings 1 

do {wave_tb_bcd2disp_basys3.do} 

view wave 
view structure 
view signals 
