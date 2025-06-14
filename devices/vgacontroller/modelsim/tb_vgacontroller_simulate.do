onbreak {quit -f} 
onerror {quit -f} 

vsim -t ps -voptargs="+acc"  -wlf work/vsim.wlf work.tb_vgacontroller 

set NumericStdNoWarnings 1 
set StdArithNoWarnings 1 

do {wave_tb_vgacontroller.do} 

view wave 
view structure 
view signals 
