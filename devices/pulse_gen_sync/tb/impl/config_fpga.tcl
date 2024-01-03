set cable                   "Digilent JTAG-SMT2NC 210308B0AF80"
set zynqmp_utils_file        "C:/apps/Xilinx/Vitis/2023.1/scripts/vitis/util/zynqmp_utils.tcl"
set bitstream_file           "../../star_file/pulse_gen_sync.bit"
set xsa_file                 "../../star_file/pulse_gen_sync.xsa"
set fsbl_app                 "../../star_file/fsbl.elf"
set main_app                 "../../star_file/pulse_gen_sync_app.elf"

connect -url TCP:10.213.87.8:3121
source $zynqmp_utils_file
targets -set -nocase -filter {jtag_cable_name =~ $cable && name =~"APU*"}
rst -system
after 3000
targets -set -nocase -filter {jtag_cable_name =~ $cable && name =~"APU*"}
reset_apu
targets -set -nocase -filter {jtag_cable_name =~ $cable && name =~"APU*"}
clear_rpu_reset
targets -set -nocase -filter {jtag_cable_name =~ $cable && name =~"*PS TAP*"}
fpga -file $bitstream_file
targets -set -nocase -filter {jtag_cable_name =~ $cable && name =~"APU*"}
loadhw -hw $xsa_file -mem-ranges [list {0x80000000 0xbfffffff} {0x400000000 0x5ffffffff} {0x1000000000 0x7fffffffff}] -regs
configparams force-mem-access 1
targets -set -nocase -filter {jtag_cable_name =~ $cable && name =~"APU*"}
set mode [expr [mrd -value 0xFF5E0200] & 0xf]
targets -set -nocase -filter {jtag_cable_name =~ $cable && name =~"*A53*#0"}
rst -processor
dow $fsbl_app

con
after 20000
stop
targets -set -nocase -filter {jtag_cable_name =~ $cable && name =~"*A53*#0"}
rst -processor
dow $main_app
configparams force-mem-access 0
con
after 20000

puts "MPSOC CONFIGURATION HAS FINISHED"
