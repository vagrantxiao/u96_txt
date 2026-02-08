//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2022.2 (lin64) Build 3671981 Fri Oct 14 04:59:54 MDT 2022
//Date        : Sun Feb  1 13:04:08 2026
//Host        : oquark running 64-bit Ubuntu 20.04.6 LTS
//Command     : generate_target design_1_wrapper.bd
//Design      : design_1_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps
`default_nettype none

module mem_agent_maxi
#(
    parameter ADDR_WIDTH         = 32 
  , parameter DATA_WIDTH         = 64 
  , parameter RD_ADDR_BASE       = 32'h4000_0000 // 1 GB
  , parameter RD_ADDR_HIGH       = 32'h5000_0000 // 1 GB + 256 MB
  , parameter WR_ADDR_BASE       = 32'h4000_0000 // 1 GB
  , parameter WR_ADDR_HIGH       = 32'h5000_0000 // 1 GB + 256 MB
  , parameter RD_OUTSTANDING_MAX = 16
  , parameter WR_OUTSTANDING_MAX = 16
  , parameter DBG_CNT_BITS       = 32
)(
  // Reset, Clock
    input  wire                     ARESETN
  , input  wire                     ACLK

  // Master Write Address
  , output wire [0:0]              M_AXI_AWID
  , output wire [ADDR_WIDTH-1:0]   M_AXI_AWADDR
  , output wire [7:0]              M_AXI_AWLEN    // Burst Length: 0-255
  , output wire [2:0]              M_AXI_AWSIZE   // Burst Size: Fixed 2'b011
  , output wire [1:0]              M_AXI_AWBURST  // Burst Type: Fixed 2'b01(Incremental Burst)
  , output wire                    M_AXI_AWLOCK   // Lock: Fixed 2'b00
  , output wire [3:0]              M_AXI_AWCACHE  // Cache: Fiex 2'b0011
  , output wire [2:0]              M_AXI_AWPROT   // Protect: Fixed 2'b000
  , output wire [3:0]              M_AXI_AWQOS    // QoS: Fixed 2'b0000
  , output wire [7:0]              M_AXI_AWUSER   // User: Fixed 32'd0
  , output wire                    M_AXI_AWVALID
  , input  wire                    M_AXI_AWREADY

  // Master Write Data
  , output wire [DATA_WIDTH-1:0]   M_AXI_WDATA
  , output wire [DATA_WIDTH/8-1:0] M_AXI_WSTRB
  , output wire                    M_AXI_WLAST
  , output wire [7:0]              M_AXI_WUSER
  , output wire                    M_AXI_WVALID
  , input  wire                    M_AXI_WREADY

  // Master Write Response
  , input  wire  [0:0]             M_AXI_BID
  , input  wire  [1:0]             M_AXI_BRESP
  , input  wire  [7:0]             M_AXI_BUSER
  , input  wire                    M_AXI_BVALID
  , output wire                    M_AXI_BREADY
   
  // Master Read Address
  , output wire [0:0]              M_AXI_ARID
  , output wire [ADDR_WIDTH-1:0]   M_AXI_ARADDR
  , output wire [7:0]              M_AXI_ARLEN
  , output wire [2:0]              M_AXI_ARSIZE
  , output wire [1:0]              M_AXI_ARBURST
  , output wire [1:0]              M_AXI_ARLOCK
  , output wire [3:0]              M_AXI_ARCACHE
  , output wire [2:0]              M_AXI_ARPROT
  , output wire [3:0]              M_AXI_ARQOS
  , output wire [7:0]              M_AXI_ARUSER
  , output wire                    M_AXI_ARVALID
  , input  wire                    M_AXI_ARREADY
   
  // Master Read Data 
  , input  wire  [0:0]             M_AXI_RID
  , input  wire  [DATA_WIDTH-1:0]  M_AXI_RDATA
  , input  wire       [1:0]        M_AXI_RRESP
  , input  wire                    M_AXI_RLAST
  , input  wire       [7:0]        M_AXI_RUSER
  , input  wire                    M_AXI_RVALID
  , output wire                    M_AXI_RREADY

  , input  wire                    r_start_in
  , input  wire                    w_start_in

  , output wire [DBG_CNT_BITS-1:0] rd_req_cnt_out
  , output wire [DBG_CNT_BITS-1:0] rd_data_cnt_out
  , output wire [DBG_CNT_BITS-1:0] wr_req_cnt_out
  , output wire [DBG_CNT_BITS-1:0] wr_data_cnt_out
  , output wire [DBG_CNT_BITS-1:0] rd_req_bp_out
  , output wire [DBG_CNT_BITS-1:0] rd_data_bp_out
  , output wire [DBG_CNT_BITS-1:0] wr_req_bp_out
  , output wire [DBG_CNT_BITS-1:0] wr_data_bp_out
  
  , output wire [DBG_CNT_BITS-1:0] timestamp_out
  , output wire [DBG_CNT_BITS-1:0] rd_latency_out
  , output wire [DBG_CNT_BITS-1:0] wr_latency_out
  , output wire                    rd_bit_out
  , output wire                    b_bit_out
);



endmodule

`default_nettype wire
