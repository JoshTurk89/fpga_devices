import os 
import shutil 
from tkinter import messagebox as MessageBox 

bd_tc_path   = 'logic_adder_bd_bd/hw_handoff'
bd_tcl_file = 'logic_adder_bd_bd.tcl'
star_file = '../../../star_file'

def main():

 os.chdir(bd_tc_path)
 if os.path.isfile(bd_tcl_file):
   shutil.copy(bd_tcl_file, star_file)
 else:
   popup("Warning", "Some files do not exist.\nCheck them in star_file folder and generate them first.")

def popup(title, msg):
 if len(msg) > 0:
   MessageBox.showinfo(title, msg)

if __name__ == '__main__':
 main()
