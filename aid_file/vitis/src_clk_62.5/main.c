/******************************************************************************
 *
 * Copyright (C) 2018 Xilinx, Inc.  All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * Use of the Software is limited solely to applications:
 * (a) running on a Xilinx device, or
 * (b) that interact with a Xilinx device through a bus or interconnect.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
 * XILINX  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF
 * OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 *
 * Except as contained in this notice, the name of the Xilinx shall not be used
 * in advertising or otherwise to promote the sale, use or other dealings in
 * this Software without prior written authorization from Xilinx.
 *
 ******************************************************************************/

#include <stdio.h>
#include "xparameters.h"
#include "platform.h"
#include "platform_config.h"
#include "xil_printf.h"
#include "sleep.h"
#include "i2c_access.h"
#include "si570.h"
#include "xil_io.h"




/**************************** Type Definitions *******************************/
#define AURORA_RESET_ADD 0xA0000000
#define RESET 			0x00000001
#define AXI_I2C_ADD 	0xA0010000
#define AXI_GPIO_ADD	0xA0020000
#define RESET_FIFOS 	0x0000000E
#define CLEAR_RESET 	0
#define WRITE_START 	0x05
#define WRITE_OP 		0x04
#define WRITE_STOP 		0x06
#define I2C_ENABLE 		0x11
#define EXP_ADDR 		0x24
#define CONF_PORT_0 	0x06
#define CONF_PORT_1 	0x07
#define WRITE_CONF_0 	0x0F
#define WRITE_CONF_1 	0x00
#define ALL_1		  	0xFF
#define ALL_0_PORT_0  	0x0F
#define ALL_0_PORT_1  	0x00
#define OUT_PORT_0		0x02
#define OUT_PORT_1		0x03
//#define XIIC	XIicPs
//#define INTC	XScuGic
//typedef struct {
//	XIIC I2cInstance;
//	INTC IntcInstance;
//	volatile u8 TransmitComplete;   /* Flag to check completion of Transmission */
//	volatile u8 ReceiveComplete;    /* Flag to check completion of Reception  */
//	volatile u32 TotalErrorCount;
//} XIIC_LIB;
struct netif *echo_netif;
//int si570_read_config_user(XIIC_LIB *I2cLibPtr);
/************************** Function Prototypes *****************************/

void send_i2c_data(u8 slave_add, u8 reg_add, u8 data) {

	// Reset FIFOS
	Xil_Out32(AXI_I2C_ADD, (u32)RESET_FIFOS);
	// Clear Reset
	Xil_Out32(AXI_I2C_ADD, (u32)CLEAR_RESET);

	// Write to command FIFO
	Xil_Out32(AXI_I2C_ADD + (u32) 0x10, (u32)WRITE_START);
	// Write to command FIFO
	Xil_Out32(AXI_I2C_ADD + (u32) 0x10, (u32)WRITE_OP);
	// Write to command FIFO
	Xil_Out32(AXI_I2C_ADD + (u32) 0x10, (u32)WRITE_STOP);

	// Write to TX FIFO
	Xil_Out32(AXI_I2C_ADD + (u32) 0x8, (u32)(slave_add << 1));
	// Write to TX FIFO
	Xil_Out32(AXI_I2C_ADD + (u32) 0x8, (u32)reg_add);
	// Write to TX FIFO
	Xil_Out32(AXI_I2C_ADD + (u32) 0x8, (u32)data);

	// Enable I2C
	Xil_Out32(AXI_I2C_ADD, (u32)I2C_ENABLE);

	usleep(600);

}

int main(void)
{

	int Status;
	XIIC_LIB I2C1_intance;
	u8 WrBuffer[3];

	init_platform();
	xil_printf("START USER app \r\n");
	xil_printf("START USER app \r\n");
	xil_printf("START USER app \r\n");
	xil_printf("START USER app \r\n");


	Status = I2cSetupHardware(&I2C1_intance);
	if (Status != XST_SUCCESS) {
		xil_printf("I2C1_intance Configuring HW failed\n\r");
		return XST_FAILURE;
	}

	si570_write_config_user(&I2C1_intance);

	//  Uncomment to enable SI570 configuration read
	//	while(1){
	//		si570_read_config_user(&I2C1_intance);
	//	}


	//
	usleep(1000);

	//Xil_Out32(AURORA_RESET_ADD, RESET);

	/**
	Configure I2C Expander
	 */

	//send_i2c_data(EXP_ADDR, CONF_PORT_0, WRITE_CONF_0);

	//send_i2c_data(EXP_ADDR, CONF_PORT_1, WRITE_CONF_1);

	//send_i2c_data(EXP_ADDR, OUT_PORT_0, ALL_1);

	//send_i2c_data(EXP_ADDR, OUT_PORT_1, ALL_1);

	//send_i2c_data(EXP_ADDR, OUT_PORT_0, ALL_0_PORT_0);

	//send_i2c_data(EXP_ADDR, OUT_PORT_1, ALL_0_PORT_1);

	usleep(300);

	//Xil_Out32(AXI_GPIO_ADD, (u32)0x00000001);

	usleep(300);

	//Xil_Out32(AXI_GPIO_ADD, (u32)0x00000000);

	while(1);

	cleanup_platform();

	return 0;
}


