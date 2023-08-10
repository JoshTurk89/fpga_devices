/******************************************************************************
*
* Copyright (C) 2013 - 2018 Xilinx, Inc.  All rights reserved.
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
* @file sfp.c
*
* This file programs sfp phy chip.
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
// #if defined (__arm__) && !defined (ARMR5)
// #if XPAR_GIGE_PCS_PMA_SGMII_CORE_PRESENT == 1 || \
//	XPAR_GIGE_PCS_PMA_1000BASEX_CORE_PRESENT == 1
#include "xil_printf.h"
#include "xiicps.h"
#include "sleep.h"
#include "xscugic.h"

/************************** Constant Definitions *****************************/
#define IIC_SFP_SLAVE_ADDR		0x56
#define IIC_SFP_MUX_ADDRESS		0x75
#define IIC_SFP_CHANNEL_ADDRESS	0xF0

#define XIIC	XIicPs
#define INTC	XScuGic
/**************************** Type Definitions *******************************/
typedef struct {
	XIIC I2cInstance;
	INTC IntcInstance;
	volatile u8 TransmitComplete;   /* Flag to check completion of Transmission */
	volatile u8 ReceiveComplete;    /* Flag to check completion of Reception */
	volatile u32 TotalErrorCount;
} XIIC_LIB;
/***************** Macros (Inline Functions) Definitions *********************/

/************************** Function Prototypes ******************************/
int I2cWriteData(XIIC_LIB *I2cLibPtr, u8 *WrBuffer, u16 ByteCount, u16 SlaveAddr);
int I2cReadData(XIIC_LIB *I2cLibPtr, u8 *RdBuffer, u16 ByteCount, u16 SlaveAddr);
int I2cPhyWrite(XIIC_LIB *I2cLibPtr, u8 PhyAddr, u8 Reg, u16 Data, u16 SlaveAddr);
int I2cPhyRead(XIIC_LIB *I2cLibPtr, u8 PhyAddr, u8 Reg, u16 *Data, u16 SlaveAddr);
int I2cSetupHardware(XIIC_LIB *I2cLibPtr);
/************************** Function Definitions *****************************/


/************************** Function Definitions *****************************/
 int MuxInitSFP(XIIC_LIB *I2cLibInstancePtr)
 {
 	u8 WrBuffer[0];
 	int Status;

 	WrBuffer[0] = IIC_SFP_CHANNEL_ADDRESS;

 	Status = I2cWriteData(I2cLibInstancePtr,
 				WrBuffer, 1, IIC_SFP_MUX_ADDRESS);
 	if (Status != XST_SUCCESS) {
 		xil_printf("SFP MUX : Writing failed\n\r");
 		return XST_FAILURE;
 	}

 	return XST_SUCCESS;
 }




/*****************************************************************************/
/**
 * This function program SFP PHY.
 *
 * @return	XST_SUCCESS if successful else XST_FAILURE.
 *
 ******************************************************************************/
int ProgramSfpPhy(void)
{
	XIIC_LIB I2cLibInstance;
	int Status;
	u8 WrBuffer[2];
	u16 phy_read_val;

	Status = I2cSetupHardware(&I2cLibInstance);
	if (Status != XST_SUCCESS) {
		xil_printf("Fail!!!\n\r");
		xil_printf("SFP_PHY: Configuring HW failed\n\r");
		return XST_FAILURE;
	}
	Status = MuxInitSFP(&I2cLibInstance);
	if (Status != XST_SUCCESS) {
		xil_printf("SFP_PHY: Mux Init failed\n\r");
		return XST_FAILURE;
	}

	WrBuffer[0] = 0;
	Status = I2cWriteData(&I2cLibInstance, WrBuffer, 1, IIC_SFP_SLAVE_ADDR);
	if (Status != XST_SUCCESS) {
		xil_printf("SFP_PHY: Writing failed\n\r");
		return XST_FAILURE;
	}

#if XPAR_GIGE_PCS_PMA_1000BASEX_CORE_PRESENT == 1
	/* Enabling 1000BASEX */
	I2cPhyWrite(&I2cLibInstance, IIC_SFP_SLAVE_ADDR, 0x1B, 0x9088, IIC_SFP_SLAVE_ADDR);
#else
	/* Enabling SGMII */
	I2cPhyWrite(&I2cLibInstance, IIC_SFP_SLAVE_ADDR, 0x1B, 0x9084, IIC_SFP_SLAVE_ADDR);
#endif

	/* Apply Soft Reset */
	I2cPhyWrite(&I2cLibInstance, IIC_SFP_SLAVE_ADDR, 0x00, 0x9140, IIC_SFP_SLAVE_ADDR);

	/* Enable 1000BaseT Full Duplex capabilities */
	I2cPhyWrite(&I2cLibInstance, IIC_SFP_SLAVE_ADDR, 0x09, 0x0E00, IIC_SFP_SLAVE_ADDR);

	/* Apply Soft Reset */
	I2cPhyWrite(&I2cLibInstance, IIC_SFP_SLAVE_ADDR, 0x00, 0x9140, IIC_SFP_SLAVE_ADDR);

	/* Advertise 10/100 Capabilities else change the capabilities */
	I2cPhyWrite(&I2cLibInstance, IIC_SFP_SLAVE_ADDR, 0x04, 0x0141, IIC_SFP_SLAVE_ADDR);

	/* Apply Soft Reset */
	I2cPhyWrite(&I2cLibInstance, IIC_SFP_SLAVE_ADDR, 0x00, 0x9140, IIC_SFP_SLAVE_ADDR);

	/* Apply Soft Reset */
	I2cPhyWrite(&I2cLibInstance, IIC_SFP_SLAVE_ADDR, 0x00, 0x9140, IIC_SFP_SLAVE_ADDR);

	I2cPhyWrite(&I2cLibInstance, IIC_SFP_SLAVE_ADDR, 0x10, 0xF079, IIC_SFP_SLAVE_ADDR);
	/* Apply Soft Reset */
	I2cPhyWrite(&I2cLibInstance, IIC_SFP_SLAVE_ADDR, 0x00, 0x9140, IIC_SFP_SLAVE_ADDR);

	I2cPhyWrite(&I2cLibInstance, IIC_SFP_SLAVE_ADDR, 0x16, 0x0001, IIC_SFP_SLAVE_ADDR);
	I2cPhyWrite(&I2cLibInstance, IIC_SFP_SLAVE_ADDR, 0x00, 0x9140, IIC_SFP_SLAVE_ADDR);
	I2cPhyWrite(&I2cLibInstance, IIC_SFP_SLAVE_ADDR, 0x00, 0x9340, IIC_SFP_SLAVE_ADDR);
	usleep(1);

	I2cPhyWrite(&I2cLibInstance, IIC_SFP_SLAVE_ADDR, 0x16, 0x0, IIC_SFP_SLAVE_ADDR);
	phy_read_val = 0x0;

	while((phy_read_val & 0x0C00) != 0x0C00) {
		I2cPhyRead(&I2cLibInstance, IIC_SFP_SLAVE_ADDR, 0x11, &phy_read_val, IIC_SFP_SLAVE_ADDR);
	}
	usleep(1);

	I2cPhyWrite(&I2cLibInstance, IIC_SFP_SLAVE_ADDR, 0x16, 0x0, IIC_SFP_SLAVE_ADDR);
	I2cPhyRead(&I2cLibInstance, IIC_SFP_SLAVE_ADDR, 0x11, &phy_read_val, IIC_SFP_SLAVE_ADDR);
	I2cPhyWrite(&I2cLibInstance, IIC_SFP_SLAVE_ADDR, 0x16, 0x0001, IIC_SFP_SLAVE_ADDR);

	/* configure speed */
	I2cPhyWrite(&I2cLibInstance, IIC_SFP_SLAVE_ADDR, 0x14, 0x0c61, IIC_SFP_SLAVE_ADDR);
	I2cPhyWrite(&I2cLibInstance, IIC_SFP_SLAVE_ADDR, 0x00, 0x9340, IIC_SFP_SLAVE_ADDR);
	I2cPhyWrite(&I2cLibInstance, IIC_SFP_SLAVE_ADDR, 0x16, 0x0, IIC_SFP_SLAVE_ADDR);

	return XST_SUCCESS;
}


int readSfpPhy(XIIC_LIB *I2cLibInstancePtr)
{

	int Status;
	int Index;
	int registerCount = 65;
	u8 WrBuffer[2];
	u16 phy_read_val;




	Status = MuxInitSFP(I2cLibInstancePtr);
	if (Status != XST_SUCCESS) {
		xil_printf("SFP_PHY: Mux Init failed\n\r");
		return XST_FAILURE;
	}

	I2cPhyWrite(I2cLibInstancePtr, IIC_SFP_SLAVE_ADDR, 0x16, 0x0001, IIC_SFP_SLAVE_ADDR);
	I2cPhyWrite(I2cLibInstancePtr, IIC_SFP_SLAVE_ADDR, 0x00, 0x0140, IIC_SFP_SLAVE_ADDR);
	I2cPhyWrite(I2cLibInstancePtr, IIC_SFP_SLAVE_ADDR, 0x16, 0x0001, IIC_SFP_SLAVE_ADDR);
	I2cPhyWrite(I2cLibInstancePtr, IIC_SFP_SLAVE_ADDR, 0x00, 0x8140, IIC_SFP_SLAVE_ADDR);
	I2cPhyWrite(I2cLibInstancePtr, IIC_SFP_SLAVE_ADDR, 0x16, 0x0001, IIC_SFP_SLAVE_ADDR);
	I2cPhyWrite(I2cLibInstancePtr, IIC_SFP_SLAVE_ADDR, 0x00, 0x0140, IIC_SFP_SLAVE_ADDR);
	I2cPhyWrite(I2cLibInstancePtr, IIC_SFP_SLAVE_ADDR, 0x16, 0x0001, IIC_SFP_SLAVE_ADDR);
	I2cPhyWrite(I2cLibInstancePtr, IIC_SFP_SLAVE_ADDR, 0x10, 0x0078, IIC_SFP_SLAVE_ADDR);
	sleep(5);


	I2cPhyWrite(I2cLibInstancePtr, IIC_SFP_SLAVE_ADDR, 0x16, 0x0000, IIC_SFP_SLAVE_ADDR);

	for (Index = 0; Index < registerCount; Index++) {

		Status = I2cPhyRead(I2cLibInstancePtr, IIC_SFP_SLAVE_ADDR, Index , &phy_read_val, IIC_SFP_SLAVE_ADDR);
		if (Status != XST_SUCCESS) {
			xil_printf("SFP_PHY: Writing failed\n\r");
			return XST_FAILURE;
		}

		xil_printf("Read Value AD => 0x%x  DATA => 0x%x \n\r",Index, phy_read_val);

	}


	I2cPhyWrite(I2cLibInstancePtr, IIC_SFP_SLAVE_ADDR, 0x16, 0x0001, IIC_SFP_SLAVE_ADDR);

	for (Index = 0; Index < registerCount; Index++) {

		Status = I2cPhyRead(I2cLibInstancePtr, IIC_SFP_SLAVE_ADDR, Index , &phy_read_val, IIC_SFP_SLAVE_ADDR);
		if (Status != XST_SUCCESS) {
			xil_printf("SFP_PHY: Writing failed\n\r");
			return XST_FAILURE;
		}

		xil_printf("Read Value AD (page 1) => 0x%x  DATA => 0x%x \n\r",Index, phy_read_val);

	}


	return XST_SUCCESS;
}



//#endif
// #endif
