vsim -t ps -voptargs=+acc -novopt -msgmode both -t ps -L xpm -L unisim -L blk_mem_gen_v8_4_4 -L axis_infrastructure_v1_1_0 -L axis_data_fifo_v2_0_3 -L fifo_generator_v13_2_5 -L axis_interconnect_v1_1_18 work.arinc_429_top_tb

if {[file exists wave.do] == 1} {
    do ./wave.do
}
add log -r /*
run 200 us  
