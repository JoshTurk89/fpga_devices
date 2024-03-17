import os 
import shutil 
from tkinter import messagebox as MessageBox 

path_1   = 'pulse_gen_sync'
path_2   = 'pulse_gen_sync.runs/impl_1'
xsa_file = 'pulse_gen_sync.xsa'
psu_file = 'psu_init.tcl'
bit_file = 'pulse_gen_sync.bit'
ltx_file = 'debug_nets.ltx' 
star_file_1 = '../../star_file'
star_file_2 = '../../../../star_file'
list_file = [False, False, False, False]

def main():

 for i in range(4):
   if i == 0:
     os.chdir(path_1)
     check_copy_file(xsa_file, star_file_1, i)
   if i == 1:
     check_copy_file(psu_file, star_file_1, i)
   if i == 2:
     os.chdir(path_2)
     check_copy_file(bit_file, star_file_2, i)
   else:
     check_copy_file(ltx_file, star_file_2, i)

 cnt = 0
 for i in range(4):
   if list_file[i] == False:
     check_copy_file(ltx_file, star_file_2, i)

 if cnt != 0:
   popup("Warning", "Some files do not exist.\nCheck them in star_file folder and generate them first.")

def check_copy_file(files, dst_folder, num):
 if os.path.isfile(files):
   shutil.copy(files, dst_folder)
   list_file[num] = True

def popup(title, msg):
 if len(msg) > 0:
   MessageBox.showinfo(title, msg)

if __name__ == '__main__':
 main()
