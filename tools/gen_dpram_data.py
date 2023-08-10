
import random

def main():

  txtfile = 'D:/pl-hscl/devices/axi4_dpram/tb/sim/sequences/src/dpram_data.txt'

  g = open(txtfile, "w")

  num_data = 16
  data_width = 64

  for i in range(0, num_data):

    value = int(random.random()*(2**data_width))
    value_hex = "%16X" % value

    if i == (num_data - 1):
      g.write(" " + value_hex)
    else:
      g.write(" " + value_hex + "\n")      

  g.close()


if __name__ == '__main__':
	main()