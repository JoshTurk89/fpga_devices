
import random

def main():

  txtfile_bin = 'D:/pl-hscl/devices/ihsc_mdl_a/tb/impl/data.bin'
  txtfile_txt = 'D:/pl-hscl/devices/ihsc_mdl_a/tb/impl/data.txt'

  f = open(txtfile_bin, "wb")
  g = open(txtfile_txt, "w")

  data = []
  black_data = []

  size_Byte = 1024

  for i in range(0, size_Byte):    
    value = int(random.random()*255)
    data.append(value)
    value_hex = "%02X" % value
    
    if i == (size_Byte - 1):
      g.write("0x" + value_hex)
    else:
      g.write("0x" + value_hex + "\n")
  
  f.write(bytearray(data))
  f.close()
  g.close()


if __name__ == '__main__':
	main()