onbreak {quit -f} 
onerror {quit -f} 

vsim -t ps -voptargs="+acc"  -wlf work/vsim.wlf work.tb_display_mux 

set NumericStdNoWarnings 1 
set StdArithNoWarnings 1 

do {wave_tb_display_mux.do} 

view wave 
view structure 
view signals 
