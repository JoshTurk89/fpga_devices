
# LPD DMA Channel 0
set base_dma 0xFFA80000
# set base_dma 0xFD500000

set DST_addr  0xA0010000
set SRC_addr  0x20000
set SIZE_bytes 1024    

for {set i 0} {$i< 100} {incr i} {
  mwr [expr $SRC_addr + $i*4] [expr $i+0x800]   
}

# ctrl 2
mwr [expr $base_dma+0x200] 0

# ctrl 0
mwr [expr $base_dma+0x110] 0x00000080

# ctrl 1
mwr [expr $base_dma+0x114] 0x000003FF

# SRC start addr
mwr [expr $base_dma+0x128] $SRC_addr
mwr [expr $base_dma+0x12C] 0

# DST start addr
mwr [expr $base_dma+0x138] $DST_addr
mwr [expr $base_dma+0x13c] 0

# SIZE 
mwr [expr $base_dma+0x130] $SIZE_bytes 
mwr [expr $base_dma+0x140] $SIZE_bytes

# COHRNT
# mwr [expr $base_dma+0x134] 0x1
# mwr [expr $base_dma+0x144] 0x1
# NO COHRNT
mwr [expr $base_dma+0x134] 0x0
mwr [expr $base_dma+0x144] 0x0

# ctrl 2 (launch process)
mwr [expr $base_dma+0x200] 0x1

