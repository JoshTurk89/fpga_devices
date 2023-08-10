package require fileutil

#Set paths
set prj_path "D:/workbench/Proyectos/MIC/arinc_429_spi"
set work_path "D:/workbench/Proyectos/MIC/arinc_429_spi/work"
set design_path "D:/workbench/Proyectos/MIC/arinc_429_spi/hdl"
set tb_path "D:/workbench/Proyectos/MIC/arinc_429_spi/test/src"

#######################
# LIST OF DESIGN FILES #
#######################
set design_files "

$design_path/spi/spi_pkg.vhd \
    $design_path/spi/spi_buffer.vhd \
    $design_path/spi/spi_ctrl.vhd \
    $design_path/spi/spi_if.vhd \
    $design_path/spi/SPI_IP_wrapper.vhd \
    $design_path/spi/src/FIFO_MEMORY/sim/FIFO_MEMORY.v \
    $design_path/spi/src/FIFO_MEMORY_WORD_THROUGH/sim/FIFO_MEMORY_WORD_THROUGH.v \
    $prj_path/src/fifo_input_buffer/sim/fifo_input_buffer.v \
    $prj_path/src/axis_interconnect_429/sim/axis_interconnect_429.v \
    $design_path/arinc_429_aclk_reset.vhd \
    $design_path/bit_ctrl.vhd \
    $design_path/conf_mod_ctrl.vhd \
    $design_path/por_config_ctrl.vhd \
    $design_path/sdp_ram.vhd \
    $design_path/spi_rw_ctrl.vhd \
    $design_path/input_buffers.vhd \
    $design_path/out_buffers.vhd \
    $design_path/tx_a429_ctrl.vhd \
    $design_path/rx_a429_ctrl.vhd \
    $design_path/arinc_429_ctrl.vhd \
    $design_path/arinc_429_top.vhd \


"

#######################
# LIST OF TB FILES #
#######################
set tb_files "
$tb_path/logger.vhd \
$tb_path/agent_axistream_mst_pkg.vhd \
$tb_path/agent_axistream_mst.vhd \
$tb_path/hi_35930_model_pkg.vhd \
    $tb_path/hi_35930_model.vhd     \
    $tb_path/arinc_429_top_tb.vhd     \
"

#Create work directory if it not exists
if {[file exists "$prj_path/work"] == 0} {
    file mkdir work $prj_path/work
}

#Create work directory if it not exists
if {!([pwd] == "$prj_path/work")} {
    #create work library
    vlib work/
    vmap work

    # move modelsim.ini to work directory
    file copy -force "modelsim.ini" $work_path
    file copy -force "compile.tcl" $work_path
    file copy -force "simulate.tcl" $work_path

    # go to work directory
    cd $work_path
}

# compile design files
foreach {file} $design_files {
    if {[file exists $file] == 1 && [file extension $file] == ".v" } {
        vlog -work work -L mtiAvm -L mtiRnm -L mtiOvm -L mtiUvm -L mtiUPF -L infact $file
    } elseif {[file exists $file] == 1 && [file extension $file] == ".vhd" } {
        vcom  +acc=v -nologo -2008 -cover sbceft -coverfec $file
    }

}

# compile tb files
foreach {file} $tb_files {
    vcom  +acc=v -nologo -2008 -cover sbceft -coverfec $file
}


