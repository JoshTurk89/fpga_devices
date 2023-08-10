/******************************************************************************
*
* Copyright (C) 2013 - 2017 Xilinx, Inc.  All rights reserved.
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
/*****************************************************************************/
/**
* @file si5324.c
*
* This file programs si5324 chip which generates clock for the peripherals.
*
* Please refer to Si5324 Datasheet for more information
* http://www.silabs.com/Support%20Documents/TechnicalDocs/Si5324.pdf
*
* Tested on Zynq ZC706 platform
*
* <pre>
* MODIFICATION HISTORY:
*
* Ver   Who  Date	 Changes
* ----- ---- -------- ---------------------------------------------------------
* 1.0   srt  10/19/13 Initial Version
*
* </pre>
*
******************************************************************************/

/***************************** Include Files *********************************/
#include "xparameters.h"

#include "xil_printf.h"
//#include "xiicps.h"
#include "sleep.h"
//#include "xscugic.h"
#include "siliconreg.h"
#include "user_clock.h"
#include "i2c_access.h"
#include "si570.h"

//#include "vdm_tyr_ref_si5347.h"
/************************** Constant Definitions *****************************/
#define USER_CLK_IIC_CHANNEL_ADDRESS 		0x08
#define USER_CLKIIC_MUX_ADDRESS     		0x74
#define USER_CLK_IIC_SLAVE_ADDR		    0x5D

//#define USER_CLK_IIC_CHANNEL_ADDRESS 		0xF0
//#define USER_CLKIIC_MUX_ADDRESS     		0x75
//#define USER_CLK_IIC_SLAVE_ADDR				0x50



//#define XIIC	XIicPs
//#define INTC	XScuGic
///**************************** Type Definitions *******************************/
//typedef struct {
//	XIIC I2cInstance;
//	INTC IntcInstance;
//	volatile u8 TransmitComplete;   /* Flag to check completion of Transmission */
//	volatile u8 ReceiveComplete;    /* Flag to check completion of Reception  */
//	volatile u32 TotalErrorCount;
//} XIIC_LIB;
///************************** Function Prototypes *****************************/
//int I2cWriteData(XIIC_LIB *I2cLibPtr, u8 *WrBuffer, u16 ByteCount, u16 SlaveAddr);
//int I2cReadData(XIIC_LIB *I2cLibPtr, u8 *RdBuffer, u16 ByteCount, u16 SlaveAddr);
//int I2cPhyWrite(XIIC_LIB *I2cLibPtr, u8 PhyAddr, u8 Reg, u16 Data, u16 SlaveAddr);
//int I2cPhyRead(XIIC_LIB *I2cLibPtr, u8 PhyAddr, u8 Reg, u16 *Data, u16 SlaveAddr);
//int I2cSetupHardware(XIIC_LIB *I2cLibPtr);
/************************* Global Definitions *****************************/
/*
 * These configuration values generates 125MHz clock
 * For more information please refer to Si5324 Datasheet.
 */



int I2cSi570_read(XIIC_LIB *I2cLibPtr, u8 Reg, u8 *Data, u16 SlaveAddr)
{
	int Status;
	u8 WrBuffer[2];
	u8 RdBuffer[2];

	WrBuffer[0] = Reg;

	Status = I2cWriteData(I2cLibPtr, WrBuffer, 1, SlaveAddr);
	if (Status != XST_SUCCESS) {
		xil_printf("PhyWrite: Writing data failed\n\r");
		return Status;
	}

	Status = I2cReadData(I2cLibPtr, RdBuffer, 1, SlaveAddr);
	if (Status != XST_SUCCESS) {
		xil_printf("PhyRead: Reading data failed\n\r");
		return Status;
	}

	xil_printf("Read Value AD => 0x%x  DATA => 0x%x \n\r",WrBuffer[0], RdBuffer[0]);


	*Data = RdBuffer[0];

	return Status;
}

int I2cSi570_write(XIIC_LIB *I2cLibPtr, u8 Reg, u8 Data, u16 SlaveAddr)
{
	int Status;
	u8 WrBuffer[2];

	WrBuffer[0] = Reg;
	WrBuffer[1] = Data;

	Status = I2cWriteData(I2cLibPtr, WrBuffer, 2, SlaveAddr);
	if (Status != XST_SUCCESS) {
		xil_printf("PhyWrite: Writing data failed\n\r");
		return Status;
	}



	return Status;
}




/************************** Function Definitions *****************************/
 int MuxInit(XIIC_LIB *I2cLibInstancePtr)
 {
 	u8 WrBuffer[0];
 	int Status;

 	WrBuffer[0] = USER_CLK_IIC_CHANNEL_ADDRESS;

 	Status = I2cWriteData(I2cLibInstancePtr,
 				WrBuffer, 1, USER_CLKIIC_MUX_ADDRESS);
 	if (Status != XST_SUCCESS) {
 		xil_printf("Si5324: Writing failed\n\r");
 		return XST_FAILURE;
 	}

 	return XST_SUCCESS;
 }


/************************** Function Definitions *****************************/


int si570_read_config(XIIC_LIB *I2cLibInstancePtr, SI_reg_info *InitTable, u16 registerCount, u16 SlaveAddr)
{

	int Index;
	int Status;


	// Status = I2cSetupHardware(&I2cLibInstance);
	//if (Status != XST_SUCCESS) {
	//	xil_printf("Si570: Configuring HW failed\n\r");
	//	return XST_FAILURE;
	//}

	Status = MuxInit(I2cLibInstancePtr);
	if (Status != XST_SUCCESS) {
		xil_printf("Si570: Mux Init failed\n\r");
		return XST_FAILURE;
	}

	for (Index = 0; Index < registerCount; Index++) {

		Status = I2cSi570_read(I2cLibInstancePtr, InitTable[Index].RegIndex, InitTable[Index].Value, SlaveAddr);
		if (Status != XST_SUCCESS) {
			xil_printf("Si5347: Writing failed\n\r");
			return XST_FAILURE;
		}


	}
	return XST_SUCCESS;
}

int si570_write_config(XIIC_LIB *I2cLibInstancePtr, SI_reg_info *InitTable, u16 registerCount, u16 SlaveAddr)
{
	//XIIC_LIB I2cLibInstance;
	int Index;
	int Status;


	//Status = I2cSetupHardware(&I2cLibInstance);
	//if (Status != XST_SUCCESS) {
	//	xil_printf("Si570: Configuring HW failed\n\r");
	//	return XST_FAILURE;
	//}

	Status = MuxInit(I2cLibInstancePtr);
	if (Status != XST_SUCCESS) {
		xil_printf("Si570: Mux Init failed\n\r");
		return XST_FAILURE;
	}

	for (Index = 0; Index < registerCount; Index++) {

		Status = I2cSi570_write(I2cLibInstancePtr, InitTable[Index].RegIndex, InitTable[Index].Value, SlaveAddr);
		if (Status != XST_SUCCESS) {
			xil_printf("Si5347: Writing failed\n\r");
			return XST_FAILURE;
		}


	}
	return XST_SUCCESS;
}


  int si570_read_config_user(XIIC_LIB *I2cLibPtr)  {

	  int Status ;
	  u16 i2c_adr;

	  u32 Add;
	  u16 Add16;

	  /*

	for (i2c_adr = 1; i2c_adr < 255; i2c_adr++) {

		Status = si570_read_config(I2cLibPtr, user_clock_InitTable, sizeof(user_clock_InitTable)/8 , i2c_adr);
			if (Status = XST_SUCCESS) {
						xil_printf("fiesta***************************************************************************");
						xil_printf("fiesta***************************************************************************");
						xil_printf("fiesta***************************************************************************");
						xil_printf("fiesta***************************************************************************");
						xil_printf("fiesta***************************************************************************");
						xil_printf("fiesta***************************************************************************");
						xil_printf("fiesta***************************************************************************");
					}


				}  */


	 // Add = *(volatile u32 *)(0x7000000);
	 // Add16 = Add;

	  xil_printf("I2C_ADDR   => 0x%x  \n\r", Add16);

  	return si570_read_config(I2cLibPtr, user_clock_InitTable, sizeof(user_clock_InitTable)/8 , USER_CLK_IIC_SLAVE_ADDR);

	//  Status = si570_read_config(I2cLibPtr, user_clock_InitTable, sizeof(user_clock_InitTable)/8 , Add16);






  	return Status;





  }

  int si570_write_config_user(XIIC_LIB *I2cLibPtr)  {

  	return si570_write_config(I2cLibPtr, user_clock_InitTable, sizeof(user_clock_InitTable)/8 , USER_CLK_IIC_SLAVE_ADDR);
  }


//  int Program_REFSi5347(void)
//  {
//
//  	return ProgramSi5347(REF_InitTable, sizeof(REF_InitTable)/8 , REF_IIC_SLAVE_ADDR);
//  }
//
//  int Program_RECSi5347(void)
//  {
//
//  	return ProgramSi5347(REC_InitTable, sizeof(REC_InitTable)/8 , REC_IIC_SLAVE_ADDR);
//  }
