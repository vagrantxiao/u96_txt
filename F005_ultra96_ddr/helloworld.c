/******************************************************************************
*
* Copyright (C) 2009 - 2014 Xilinx, Inc.  All rights reserved.
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

/*
 * helloworld.c: simple test application
 *
 * This application configures UART 16550 to baud rate 9600.
 * PS7 UART (Zynq) is not initialized by this application, since
 * bootrom/bsp configures it to baud rate 115200
 *
 * ------------------------------------------------
 * | UART TYPE   BAUD RATE                        |
 * ------------------------------------------------
 *   uartns550   9600
 *   uartlite    Configurable only in HW design
 *   ps7_uart    115200 (configured by bootrom/bsp)
 */

#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"
#include "xparameters.h"
#include "xil_io.h"
#include "sleep.h"

#define CLK_PERIOD  10  // in ns, 10ns for 100MHz
#define DATA_WIDTH  128 // in bits, adjust according to your design
#define BYTES_PER_TRANSFER (DATA_WIDTH / 8) // Convert bits to bytes
#define RD_TEST_TIME 10
#define WR_TEST_TIME 10
#define INIT_WAIT_SECOND 10

#define IP_BASE     (XPAR_AXIL_CTRL_0_BASEADDR)
#define RD_REQ_CNT  (XPAR_AXIL_CTRL_0_BASEADDR+4)
#define RD_DATA_CNT (XPAR_AXIL_CTRL_0_BASEADDR+8)
#define WR_REQ_CNT  (XPAR_AXIL_CTRL_0_BASEADDR+12)
#define WR_DATA_CNT (XPAR_AXIL_CTRL_0_BASEADDR+16)
#define RD_REQ_BP   (XPAR_AXIL_CTRL_0_BASEADDR+20)
#define RD_DATA_BP  (XPAR_AXIL_CTRL_0_BASEADDR+24)
#define WR_REQ_BP   (XPAR_AXIL_CTRL_0_BASEADDR+28)
#define WR_DATA_BP  (XPAR_AXIL_CTRL_0_BASEADDR+32)
#define TIMESTAMP   (XPAR_AXIL_CTRL_0_BASEADDR+36)
#define RD_LATENCY  (XPAR_AXIL_CTRL_0_BASEADDR+40)
#define WR_LATENCY  (XPAR_AXIL_CTRL_0_BASEADDR+44)



void start_read() {
    Xil_Out32(IP_BASE, 1);
    Xil_Out32(IP_BASE, 0);
}

void start_write() {
    Xil_Out32(IP_BASE, 2);
    Xil_Out32(IP_BASE, 0);
}


float avg(float arr[], int size) {
    float sum = 0.0;
    for (int i = 0; i < size; i++) {
        sum += arr[i];
    }
    return sum / size;
}

int main()
{
	unsigned int rd_req_cnt_prev, rd_req_cnt;
	unsigned int rd_data_cnt_prev, rd_data_cnt;
	unsigned int wr_req_cnt_prev, wr_req_cnt;
	unsigned int wr_data_cnt_prev, wr_data_cnt;
	unsigned int rd_req_bp_prev, rd_req_bp;
	unsigned int wr_req_bp_prev, wr_req_bp;
    unsigned int rd_data_bp_prev, rd_data_bp;
    unsigned int wr_data_bp_prev, wr_data_bp;
	unsigned int rd_latency;
	unsigned int wr_latency;
    unsigned int timestamp_prev, timestamp;

    float time_diff[RD_TEST_TIME];
    float rd_throughput_MBps[RD_TEST_TIME];
    float wr_throughput_MBps[RD_TEST_TIME];
    float rd_req_bp_rate[RD_TEST_TIME];
    float wr_req_bp_rate[RD_TEST_TIME];
    float rd_data_bp_rate[RD_TEST_TIME];
    float wr_data_bp_rate[RD_TEST_TIME];
    float rd_latency_ns[RD_TEST_TIME];
    float wr_latency_ns[RD_TEST_TIME];
    unsigned int timestamp_array[RD_TEST_TIME];

    init_platform();
    for (int i=0; i < INIT_WAIT_SECOND; i++){
    	sleep(1);
    	printf("%d second\n", i);
    }

    wr_req_cnt_prev  = Xil_In32(WR_REQ_CNT);
    wr_data_cnt_prev = Xil_In32(WR_DATA_CNT);
    wr_req_bp_prev   = Xil_In32(WR_REQ_BP);
    wr_data_bp_prev  = Xil_In32(WR_DATA_BP);
    timestamp_prev   = Xil_In32(TIMESTAMP);

    start_write();
    for (int i=0; i < WR_TEST_TIME; i++){
        wr_req_cnt  = Xil_In32(WR_REQ_CNT);
        wr_data_cnt = Xil_In32(WR_DATA_CNT);
        wr_req_bp   = Xil_In32(WR_REQ_BP);
        wr_data_bp  = Xil_In32(WR_DATA_BP);
        wr_latency  = Xil_In32(WR_LATENCY);

        timestamp   = Xil_In32(TIMESTAMP);
        timestamp_array[i] = timestamp;
        time_diff[i] = (float)(timestamp - timestamp_prev) * CLK_PERIOD / 1e9; // Convert to seconds
        wr_throughput_MBps[i] = (float)(wr_data_cnt - wr_data_cnt_prev) * BYTES_PER_TRANSFER / time_diff[i] / 1e6; // in MB/s
        wr_req_bp_rate[i] = (float)(wr_req_bp - wr_req_bp_prev) / ((float)(wr_req_cnt - wr_req_cnt_prev)+(float)(wr_req_bp - wr_req_bp_prev)); // ratio of backpressure events to total requests
        wr_data_bp_rate[i] = (float)(wr_data_bp - wr_data_bp_prev) / ((float)(wr_data_cnt - wr_data_cnt_prev)+(float)(wr_data_bp - wr_data_bp_prev)); // ratio of backpressure events to total data transfers
        wr_latency_ns[i] = (float)wr_latency * CLK_PERIOD; // in nanoseconds

        // Update previous values for next iteration
        wr_req_cnt_prev  = wr_req_cnt;
        wr_data_cnt_prev = wr_data_cnt;
        wr_req_bp_prev   = wr_req_bp;
        wr_data_bp_prev  = wr_data_bp;
        timestamp_prev   = timestamp;
    }

    for (int i=0; i < WR_TEST_TIME; i++){
        printf("Timestamp: %08x\n", timestamp_array[i]);
        printf("Write Throughput: %.2f MB/s\n", wr_throughput_MBps[i]);
    }

    sleep(5);
	printf("Time: %.2f s\n", avg(time_diff, WR_TEST_TIME));
	printf("Write Throughput: %.2f MB/s\n", avg(wr_throughput_MBps, WR_TEST_TIME));
	printf("Write Request Backpressure Rate: %.2f times/s\n", avg(wr_req_bp_rate, WR_TEST_TIME));
	printf("Write Data Backpressure Rate: %.2f times/s\n", avg(wr_data_bp_rate, WR_TEST_TIME));
    printf("Average Write Latency: %.2f ns\n", avg(wr_latency_ns, WR_TEST_TIME));
    printf("We completed %08x write requests\n", Xil_In32(WR_REQ_CNT));
	printf("\n");

    rd_req_cnt_prev  = Xil_In32(RD_REQ_CNT);
    rd_data_cnt_prev = Xil_In32(RD_DATA_CNT);
    rd_req_bp_prev   = Xil_In32(RD_REQ_BP);
    rd_data_bp_prev  = Xil_In32(RD_DATA_BP);
    timestamp_prev   = Xil_In32(TIMESTAMP);

    start_read();
    for (int i=0; i < RD_TEST_TIME; i++){
        rd_req_cnt  = Xil_In32(RD_REQ_CNT);
        rd_data_cnt = Xil_In32(RD_DATA_CNT);
        rd_req_bp   = Xil_In32(RD_REQ_BP);
        rd_data_bp  = Xil_In32(RD_DATA_BP);
        rd_latency  = Xil_In32(RD_LATENCY);
        timestamp   = Xil_In32(TIMESTAMP);
        timestamp_array[i] = timestamp;
        time_diff[i] = (float)(timestamp - timestamp_prev) * CLK_PERIOD / 1e9; // Convert to seconds
        rd_throughput_MBps[i] = (float)(rd_data_cnt - rd_data_cnt_prev) * BYTES_PER_TRANSFER / time_diff[i] / 1e6; // in MB/s
        rd_req_bp_rate[i] = (float)(rd_req_bp - rd_req_bp_prev) / ((float)(rd_req_cnt - rd_req_cnt_prev)+(float)(rd_req_bp - rd_req_bp_prev)); // ratio of backpressure events to total requests
        rd_data_bp_rate[i] = (float)(rd_data_bp - rd_data_bp_prev) / ((float)(rd_data_cnt - rd_data_cnt_prev)+(float)(rd_data_bp - rd_data_bp_prev)); // ratio of backpressure events to total data transfers
        rd_latency_ns[i] = (float)rd_latency * CLK_PERIOD; // in nanoseconds

        // Update previous values for next iteration
        rd_req_cnt_prev  = rd_req_cnt;
        rd_data_cnt_prev = rd_data_cnt;
        rd_req_bp_prev   = rd_req_bp;
        rd_data_bp_prev  = rd_data_bp;
        timestamp_prev   = timestamp;
    }

    for (int i=0; i < RD_TEST_TIME; i++){
        printf("Timestamp: %08x\n", timestamp_array[i]);
        printf("Read Throughput: %.2f MB/s\n", rd_throughput_MBps[i]);

    }
	printf("Time: %.2f s\n", avg(time_diff, RD_TEST_TIME));
	printf("Read Throughput: %.2f MB/s\n", avg(rd_throughput_MBps, RD_TEST_TIME));
	printf("Read Request Backpressure Rate: %.2f times/s\n", avg(rd_req_bp_rate, RD_TEST_TIME));
	printf("Read Data Backpressure Rate: %.2f times/s\n", avg(rd_data_bp_rate, RD_TEST_TIME));
	printf("Average Read Latency: %.2f ns\n", avg(rd_latency_ns, RD_TEST_TIME));
	printf("\n");


    print("Finish Test\n");
    cleanup_platform();
    return 0;
}

