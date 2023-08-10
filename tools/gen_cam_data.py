
import random

def main():

  txtfile = 'D:/pl-hscl/PL/devices/cam_dpram_mix/tb/sequences/src/cam_data_2_2.txt'

  g = open(txtfile, "w")

  data = []

  num_data = 16
  data_width = 32
  num_cam_data = 2
  num_dpram_data = 2

  for i in range(0, num_data):
    data_hex = ""
    for j in range(0, (num_cam_data + num_dpram_data)):

      if j >= ((num_cam_data + num_dpram_data) - num_dpram_data):
        value = i*j
      else:
        value = int(random.random()*(2**data_width))
      
      value_hex = "%08X" % value
      data_hex = data_hex + value_hex
    
    if i == (num_data - 1):
      g.write(" " + data_hex)
    else:
      g.write(" " + data_hex + "\n")
      

  g.close()


if __name__ == '__main__':
	main()