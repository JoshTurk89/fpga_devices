onbreak {quit -f} 
onerror {quit -f} 

vsim -t ps -voptargs="+acc"  -wlf work/vsim.wlf work.tb_pulse_gen_sync 

set NumericStdNoWarnings 1 
set StdArithNoWarnings 1 

do {wave_tb_pulse_gen_sync.do} 

view wave 
view structure 
view signals 
