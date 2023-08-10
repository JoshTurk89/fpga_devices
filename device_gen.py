

import os
import shutil
import glob
import argparse
import subprocess
from tkinter import messagebox as MessageBox


#The different paths 
dev_path   = 'devices' 

#The different folders 
bd 			    = 'bd'
modelsim 	  = 'modelsim'
tb 	        = 'tb'
tb_sim      = 'sim'
tb_sim_seq  = 'sequences'
tb_impl     = 'impl'
vhdl 		    = 'vhdl'
vivado 	    = 'vivado'
vitis 	    = 'vitis'
xdc         = 'xdc'
star_file   = 'star_file'
doc         = 'doc'

#The different files 
gitkeep 		= '.gitkeep'

def main():

  print("Enter the name of new device: ")
  dev_name = input()
  os.chdir(dev_path)

  if os.path.exists(dev_name):
    print("This folder exists already.")
  else:
    create_rep(dev_name)
    vivado_script(dev_name)
    modelsim_script(dev_name)
    tb_imp_script(dev_name)
    vitis_script(dev_name)
    bd_script(dev_name)
    print("New device structure created.")

def bd_script(dev_name):

  dev_name_bd = dev_name + "_bd_bd"

  text_readme = ["Check the information stated into \"bd_2_star.py\" to be correct.\n",
              "Please, try to use the device name to generate the Block Design \"devicename_bd\"."]

  text_py = ["import os \n",
            "import shutil \n",
            "from tkinter import messagebox as MessageBox \n\n",
            "bd_tc_path   = \'" + dev_name_bd + "/hw_handoff\'\n",
            "bd_tcl_file = \'" + dev_name_bd + ".tcl'\n",
            "star_file = \'../../../star_file\'\n\n",
            "def main():\n\n",
            " os.chdir(bd_tc_path)\n",           
            " if os.path.isfile(bd_tcl_file):\n",
            "   shutil.copy(bd_tcl_file, star_file)\n",
            " else:\n",
            "   popup(\"Warning\", \"Some files do not exist.\\nCheck them in star_file folder and generate them first.\")\n\n",
            "def popup(title, msg):\n",
            " if len(msg) > 0:\n",
            "   MessageBox.showinfo(title, msg)\n\n",
            "if __name__ == \'__main__\':\n",
            " main()\n"]

  os.chdir(bd) 
  
  new_file("bd_2_star.py", text_py)
  new_file("README.txt", text_readme)

  os.chdir("..")

def vitis_script(dev_name):

  text_readme = ["Check the information stated into \"vitis_2_star.py\" to be correct.\n",
                "Please, try to use the device name to generate the app like \"devicename_app\"\n.",
                "Remember, if you generate a differential clock, you have the src needed in \"aid_file\" folde."]

  text_py = ["import os \n",
            "import shutil \n",
            "from tkinter import messagebox as MessageBox \n\n",
            "fsbl_path   = \'" + dev_name + "/export/" + dev_name + "/sw/" + dev_name + "/boot\'\n",
            "main_app_path   = \'../../../../../../" + dev_name + "_app/Debug\'\n",
            "fsbl_file = \'fsbl.elf\'\n",
            "app_file = \'" + dev_name + "_app.elf\'\n",
            "star_file_1 = \'../../../../../../../star_file\'\n",
            "star_file_2 = \'../../../star_file\'\n",
            "list_file = [False, False]\n\n",
            "def main():\n\n",            
            " for i in range(2):\n",
            "   if i == 0:\n",
            "     os.chdir(fsbl_path)\n",
            "     check_copy_file(fsbl_file, star_file_1, i)\n",
            "   if i == 1:\n",
            "     os.chdir(main_app_path)\n",
            "     check_copy_file(app_file, star_file_2, i)\n\n",
            " cnt = 0\n",
            " for i in range(2):\n",
            "   if list_file[i] == False:\n",
            "     check_copy_file(ltx_file, star_file_2, i)\n\n",
            " if cnt != 0:\n",
            "   popup(\"Warning\", \"Some files do not exist.\\nCheck them in star_file folder and generate them first.\")\n\n",
            "def check_copy_file(files, dst_folder, num):\n",
            " if os.path.isfile(files):\n",
            "   shutil.copy(files, dst_folder)\n",
            "   list_file[num] = True\n\n",
            "def popup(title, msg):\n",
            " if len(msg) > 0:\n",
            "   MessageBox.showinfo(title, msg)\n\n",
            "if __name__ == \'__main__\':\n",
            " main()\n"]

  os.chdir(vitis) 
  
  new_file("vitis_2_star.py", text_py)
  new_file("README.txt", text_readme)

  os.chdir("..")

def tb_imp_script(dev_name):

  cable             = "Digilent JTAG-SMT2NC 210308B0AF80"
  zynqmp_utils_file = "C:/apps/Xilinx/Vitis/2023.1/scripts/vitis/util/zynqmp_utils.tcl"
  bitstream_file    = "../../star_file/" + dev_name + ".bit"
  xsa_file          = "../../star_file/" + dev_name + ".xsa"
  fsbl_app          = "../../star_file/fsbl.elf"
  main_app          = "../../star_file/" + dev_name + "_app.elf"
  TCP               = "10.213.87.8:3121"
  
  pl_config = ["set cable                   \"" + cable + "\"\n",
              "set zynqmp_utils_file        \"" + zynqmp_utils_file + "\"\n",
              "set bitstream_file           \"" + bitstream_file + "\"\n",
              "set xsa_file                 \"" + xsa_file + "\"\n",
              "set fsbl_app                 \"" + fsbl_app + "\"\n",
              "set main_app                 \"" + main_app + "\"\n\n",
              "connect -url TCP:" + TCP + "\n",
              "source $zynqmp_utils_file\n",              
              "targets -set -nocase -filter {jtag_cable_name =~ $cable && name =~\"APU*\"}\n",
              "rst -system\n",
              "after 3000\n",
              "targets -set -nocase -filter {jtag_cable_name =~ $cable && name =~\"APU*\"}\n",
              "reset_apu\n",
              "targets -set -nocase -filter {jtag_cable_name =~ $cable && name =~\"APU*\"}\n",
              "clear_rpu_reset\n",
              "targets -set -nocase -filter {jtag_cable_name =~ $cable && name =~\"*PS TAP*\"}\n",
              "fpga -file $bitstream_file\n",
              "targets -set -nocase -filter {jtag_cable_name =~ $cable && name =~\"APU*\"}\n",
              "loadhw -hw $xsa_file -mem-ranges [list {0x80000000 0xbfffffff} {0x400000000 0x5ffffffff} {0x1000000000 0x7fffffffff}] -regs\n",
              "configparams force-mem-access 1\n",
              "targets -set -nocase -filter {jtag_cable_name =~ $cable && name =~\"APU*\"}\n",
              "set mode [expr [mrd -value 0xFF5E0200] & 0xf]\n",
              "targets -set -nocase -filter {jtag_cable_name =~ $cable && name =~\"*A53*#0\"}\n",
              "rst -processor\n",
              "dow $fsbl_app\n\n",
              "con\n",
              "after 20000\n",
              "stop\n",
              "targets -set -nocase -filter {jtag_cable_name =~ $cable && name =~\"*A53*#0\"}\n",
              "rst -processor\n",
              "dow $main_app\n",
              "configparams force-mem-access 0\n",
              "con\n",
              "after 20000\n\n",
              "puts \"MPSOC CONFIGURATION HAS FINISHED\"\n"]

  text_readme = ["Check the following points to make sure the config_fpga.tcl file is correct: \n",
              "  * Check the name for bitstream, xsa and app are the same into config_fpga.tcl file. \n", 
              "  * Check the cable and TCP are correct.  \n",
              "  * Take into account to be done the export the each file to star_file folder. \n"]

  os.chdir(tb + "/" + tb_impl)

  new_file("config_fpga.tcl", pl_config)
  new_file("README.txt", text_readme)

  os.chdir("../..")

def modelsim_script(dev_name):
  
  run_file  = "run_modelsim.bat"
  comp_file = "tb_" + dev_name + "_compile.do"
  sim_file  = "tb_" + dev_name + "_simulate.do"
  wave_file = "wave_tb_" + dev_name + ".do"

  run_text  = "C:\\modeltech64_10.1c\\win64\\modelsim.exe"

  comp_text = ["vlib work/ \n",
              "vmap work/ \n\n",
              "set DUTDev       " + dev_name + "\n\n",
              "set AgentDir     D:/pl-hscl/agents\n",
              "set DevDir       D:/pl-hscl/devices\n",
              "set DUTDevDir    D:/pl-hscl/devices/$DUTDev/vhdl\n",
              "set TBDir        D:/pl-hscl/devices/$DUTDev/tb/sim\n",
              "set TBSQDir      D:/pl-hscl/devices/$DUTDev/tb/sim/sequences\n\n",              
              "# Simulation Files\n",
              "vcom -2008 -work work  \\\n",
              "\"$AgentDir/example/example.vhd\" \\\n\n",
              "# Common Package \n",
              "vcom -2008 -work work  \\ \n",
              "\"$DevDir/example/example.vhd\" \\\n\n",
              "# Devices Files \n",
              "vcom -2008 -work work  \\ \n",
              "\"$DevDir/example/example.vhd\" \\\n\n",
              "# DUT Devices Files \n",
              "vcom -2008 -work work  \\ \n",
              "\"$DUTDevDir/example/example.vhd\" \\\n\n",
              "# Testbench Files \n",
              "vcom -2008 -work work  \\ \n",
              "\"$TBDir/tb_example_pkg.vhd\" \\ \n",
              "\"$TBSQDir/test00000_pkg.vhd\" \\ \n",
              "\"$TBDir/tb_example.vhd\" \\ \n\n"]

  sim_test = ["onbreak {quit -f} \n",
            "onerror {quit -f} \n\n",
            "vsim -t ps -voptargs=\"+acc\"  -wlf work/vsim.wlf work.tb_" + dev_name + " \n\n",
            "set NumericStdNoWarnings 1 \n",
            "set StdArithNoWarnings 1 \n\n",
            "do {" + wave_file + "} \n\n",
            "view wave \n",
            "view structure \n",
            "view signals \n"]

  # readme file
  text_readme = ["Check that compile.do contains all the files which are necessary for this device. \n\n", 
              "Check modelsim version used.  \n\n",
              "Check modelsim.ini. \n"]


  os.chdir(modelsim)

  new_file(run_file, run_text)
  new_file(comp_file, comp_text)
  new_file(sim_file, sim_test)
  new_file("README.txt", text_readme)

  f = open(wave_file, "x")
  f.close()

  modelsim_init_path = '../../../aid_file/modelsim.ini'
  modelsim_path = '../modelsim'
  shutil.copy(modelsim_init_path, modelsim_path)

  os.chdir("..")

def vivado_script(dev_name):
  
  # bat file
  dev_prj_tcl = dev_name + "_prj.tcl"
  text_bat = ["set PATH=%PATH%;C:\\Xilinx\\Vivado\\2023.1\\bin\\unwrapped\\win64.o\n\n", "vivado -mode tcl -nojournal -nolog -notrace -source " + dev_prj_tcl]

  # readme file
  text_readme = ["To use script.bat; it is needed to generate the tcl file from vivado. \n\n", 
                "To generate this file, the user shall follow the following bullets: \n\n",
                "  * Once the project is done, go to \"File->Project->Write Tcl\". \n", 
                "  * Change the path of \"Outout File\" for this root. \n",
                "  * Select the following \"Copy sources to new project\" and \"Recreate Block Desings using Tcl\". \n\n",
                "Check the information stated into \"vv_2_star.py\" to be correct."]

  text_py = ["import os \n",
            "import shutil \n",
            "from tkinter import messagebox as MessageBox \n\n",
            "path_1   = \'" + dev_name + "\'\n",
            "path_2   = \'" + dev_name + ".runs/impl_1\'\n",
            "xsa_file = \'" + dev_name + ".xsa\'\n",
            "psu_file = \'psu_init.tcl\'\n",
            "bit_file = \'" + dev_name + ".bit\'\n",
            "ltx_file = \'debug_nets.ltx\' \n",
            "star_file_1 = \'../../star_file\'\n",
            "star_file_2 = \'../../../../star_file\'\n",
            "list_file = [False, False, False, False]\n\n",
            "def main():\n\n",            
            " for i in range(4):\n",
            "   if i == 0:\n",
            "     os.chdir(path_1)\n",
            "     check_copy_file(xsa_file, star_file_1, i)\n",
            "   if i == 1:\n",
            "     check_copy_file(psu_file, star_file_1, i)\n",
            "   if i == 2:\n",
            "     os.chdir(path_2)\n",
            "     check_copy_file(bit_file, star_file_2, i)\n",
            "   else:\n",
            "     check_copy_file(ltx_file, star_file_2, i)\n\n",
            " cnt = 0\n",
            " for i in range(4):\n",
            "   if list_file[i] == False:\n",
            "     check_copy_file(ltx_file, star_file_2, i)\n\n",
            " if cnt != 0:\n",
            "   popup(\"Warning\", \"Some files do not exist.\\nCheck them in star_file folder and generate them first.\")\n\n",
            "def check_copy_file(files, dst_folder, num):\n",
            " if os.path.isfile(files):\n",
            "   shutil.copy(files, dst_folder)\n",
            "   list_file[num] = True\n\n",
            "def popup(title, msg):\n",
            " if len(msg) > 0:\n",
            "   MessageBox.showinfo(title, msg)\n\n",
            "if __name__ == \'__main__\':\n",
            " main()\n"]

  os.chdir(vivado)
 
  new_file("script.bat", text_bat)
  new_file("vv_2_star.py", text_py)
  new_file("README.txt", text_readme)

  os.chdir("..")

def create_rep(dev_name):

  # Ceate a new device folder and enter into new device folder
  os.mkdir(dev_name)
  os.chdir(dev_name)

  #Create each folder with its .gitkeep and back to repeat 
  os.mkdir(bd)
  create_gitkeep(bd)

  os.mkdir(doc)
  create_gitkeep(doc)

  os.mkdir(modelsim)
  create_gitkeep(modelsim)

  os.mkdir(vhdl)
  create_gitkeep(vhdl)

  os.mkdir(vivado)
  create_gitkeep(vivado)

  os.mkdir(vitis)
  create_gitkeep(vitis)

  os.mkdir(star_file)
  create_gitkeep(star_file)

  os.mkdir(xdc)
  create_gitkeep(xdc)

  os.mkdir(tb)
  os.chdir(tb)

  os.mkdir(tb_sim)
  os.mkdir(tb_impl)

  os.chdir(tb_sim)
  os.mkdir(tb_sim_seq)
  os.chdir(tb_sim_seq)
  f = open(gitkeep, "x")
  f.close()
  os.chdir("../..")

  os.chdir(tb_impl)
  f = open(gitkeep, "x")
  f.close()
  os.chdir("../..")

def create_gitkeep(folder):
  os.chdir(folder)
  f = open(gitkeep, "x")
  f.close() 
  os.chdir("..")

def new_file(name_file, text):
  f = open(name_file, "w")
  f.writelines(text)
  f.close()


if __name__ == '__main__':
	main()
