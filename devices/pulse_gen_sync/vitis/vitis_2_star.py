import os 
import shutil 
from tkinter import messagebox as MessageBox 

fsbl_path   = 'pulse_gen_sync/export/pulse_gen_sync/sw/pulse_gen_sync/boot'
main_app_path   = '../../../../../../pulse_gen_sync_app/Debug'
fsbl_file = 'fsbl.elf'
app_file = 'pulse_gen_sync_app.elf'
star_file_1 = '../../../../../../../star_file'
star_file_2 = '../../../star_file'
list_file = [False, False]

def main():

 for i in range(2):
   if i == 0:
     os.chdir(fsbl_path)
     check_copy_file(fsbl_file, star_file_1, i)
   if i == 1:
     os.chdir(main_app_path)
     check_copy_file(app_file, star_file_2, i)

 cnt = 0
 for i in range(2):
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
