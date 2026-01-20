/*
 * Program:

 *   This program is a C++ driver for using one DMA in ZCU102 board.
 *
 * History:
 *   2020/5/14     Yuanlong Xiao   First Release
*/

#include "xparameters.h"	/* SDK generated parameters */
//#include "xrtcpsu.h"		/* RTCPSU device driver */
//#include "xscugic.h"		/* Interrupt controller device driver */
//#include "xil_exception.h"
//#include "xil_printf.h"

#include "dma_driver.h"
#include "typedefs.h"
#include "sleep.h"


int main(void)
{

	int Status;
	dma_inst dma1(DMA_DEV_ID,
			 RX_BD_SPACE_HIGH,
			 RX_BD_SPACE_BASE,
			 MAX_PKT_LEN_TX,
			 MAX_PKT_LEN_RX,
			 TX_BD_SPACE_HIGH,
			 TX_BD_SPACE_BASE,
			 NUMBER_OF_PACKETS_TX,
			 NUMBER_OF_PACKETS_RX,
			 RX_BUFFER_BASE,
			 TX_BUFFER_BASE);

	Status = dma1.dma_init();
	if (Status != XST_SUCCESS) {
		xil_printf("Device Initiation Failed!\r\n");
		return XST_FAILURE;
	}

	Status = dma1.RecvPackets();
		if (Status != XST_SUCCESS) {
			xil_printf("Receiving Packets Failed!\r\n");
			return XST_FAILURE;
	}

	Status = dma1.WrTxBufClrRxBuf();
	if (Status != XST_SUCCESS) {
		xil_printf("Write Buffer Failed!\r\n");
		return XST_FAILURE;
	}

	Status = dma1.SendPackets();
	if (Status != XST_SUCCESS) {
		xil_printf("Sending Packets Failed!\r\n");
		return XST_FAILURE;
	}

	Status = dma1.CleanTxBuffer();
	if (Status != XST_SUCCESS) {
		xil_printf("Cleaning TxBuffer Failed!\r\n");
		return XST_FAILURE;
	}

	Status = dma1.RecvWait();
	if (Status != XST_SUCCESS) {
		xil_printf("Receiving Waits Failed!\r\n");
		return XST_FAILURE;
	}

	Status = dma1.CheckData();
	if (Status != XST_SUCCESS) {
		xil_printf("Checking Data Failed!\r\n");
		return XST_FAILURE;
	}

	Status = dma1.print_results();
	if (Status != XST_SUCCESS) {
		xil_printf("Printing results Failed!\r\n");
		return XST_FAILURE;
	}

	Status = dma1.CleanRxBuffer();
	if (Status != XST_SUCCESS) {
		xil_printf("Cleaning RxBuffer Failed!\r\n");
		return XST_FAILURE;
	}

	xil_printf("[INFO] app runs to the end\r\n");



	for(int i=0; i<3; i++){
		sleep(1);
		//printf("%d seconds\n", i);
	}

	xil_printf("[INFO] Successfully ran RTC Seconds Interrupt Example Test\r\n");
	return XST_SUCCESS;
}


