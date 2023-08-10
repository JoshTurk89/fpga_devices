/*****************************************************************************/
/**
* @file user_clock.h  to generate 125MHZ
*
* This file programs si570  to generate 125MHz
*
*
******************************************************************************/

/***************************** Include Files *********************************/
#include "siliconreg.h"


/************************** Constant Definitions *****************************/

/**************************** Type Definitions *******************************/


/************************* Global Definitions *****************************/
/*
 * These configuration values generates 125MHz clock
 * For more information please refer to Si5347 Datasheet.
 */
SI_reg_info user_clock_InitTable[] = {
			/* Freeze the DCO (bit 4 of Register 137) */
			
			{ 137, 0x18 },
			
			/* registers configuration */
			{ 0x07, 0x02 },
			{ 0x08, 0x42 },
			{ 0x09, 0xBC },
			{ 0x0A, 0x02 },
			{ 0x0B, 0x75 },
			{ 0x0C, 0xDC },

			/* Unreeze the DCO (bit 4 of Register 137) */
			{ 137, 0x08 },
			
			/*  NewFreq bit (bit 6 of Register 135) */
			{ 135, 0x40 }


		};

