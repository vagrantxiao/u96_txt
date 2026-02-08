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
  import mem_agent_types::*;
#(
    parameter ADDR_WIDTH         = AXI_MASTER_ADDR_WIDTH
  , parameter DATA_WIDTH         = AXI_MASTER_DATA_WIDTH
  , parameter RD_ADDR_BASE       = AXI_RD_ADDR_BASE
  , parameter RD_ADDR_HIGH       = AXI_RD_ADDR_HIGH
  , parameter WR_ADDR_BASE       = AXI_WR_ADDR_BASE
  , parameter WR_ADDR_HIGH       = AXI_WR_ADDR_HIGH
  , parameter RD_OUTSTANDING_MAX = AXI_RD_OUTSTANDING_MAX
  , parameter WR_OUTSTANDING_MAX = AXI_WR_OUTSTANDING_MAX
  , parameter DBG_CNT_BITS       = DEBG_COUNTER_BITS 
)(
  // Reset, Clock
    input  wire                     ARESETN
  , input  wire                     ACLK

  // Master Write Address
  , output logic [0:0]              M_AXI_AWID
  , output logic [ADDR_WIDTH-1:0]   M_AXI_AWADDR
  , output logic [7:0]              M_AXI_AWLEN    // Burst Length: 0-255
  , output logic [2:0]              M_AXI_AWSIZE   // Burst Size: Fixed 2'b011
  , output logic [1:0]              M_AXI_AWBURST  // Burst Type: Fixed 2'b01(Incremental Burst)
  , output logic                    M_AXI_AWLOCK   // Lock: Fixed 2'b00
  , output logic [3:0]              M_AXI_AWCACHE  // Cache: Fiex 2'b0011
  , output logic [2:0]              M_AXI_AWPROT   // Protect: Fixed 2'b000
  , output logic [3:0]              M_AXI_AWQOS    // QoS: Fixed 2'b0000
  , output logic [7:0]              M_AXI_AWUSER   // User: Fixed 32'd0
  , output logic                    M_AXI_AWVALID
  , input  wire                     M_AXI_AWREADY

  // Master Write Data
  , output logic [DATA_WIDTH-1:0]   M_AXI_WDATA
  , output logic [DATA_WIDTH/8-1:0] M_AXI_WSTRB
  , output logic                    M_AXI_WLAST
  , output logic [7:0]              M_AXI_WUSER
  , output logic                    M_AXI_WVALID
  , input  wire                     M_AXI_WREADY

  // Master Write Response
  , input  wire  [0:0]              M_AXI_BID
  , input  wire  [1:0]              M_AXI_BRESP
  , input  wire  [7:0]              M_AXI_BUSER
  , input  wire                     M_AXI_BVALID
  , output logic                    M_AXI_BREADY
   
  // Master Read Address
  , output logic [0:0]              M_AXI_ARID
  , output logic [ADDR_WIDTH-1:0]   M_AXI_ARADDR
  , output logic [7:0]              M_AXI_ARLEN
  , output logic [2:0]              M_AXI_ARSIZE
  , output logic [1:0]              M_AXI_ARBURST
  , output logic [1:0]              M_AXI_ARLOCK
  , output logic [3:0]              M_AXI_ARCACHE
  , output logic [2:0]              M_AXI_ARPROT
  , output logic [3:0]              M_AXI_ARQOS
  , output logic [7:0]              M_AXI_ARUSER
  , output logic                    M_AXI_ARVALID
  , input  wire                     M_AXI_ARREADY
   
  // Master Read Data 
  , input  wire  [0:0]              M_AXI_RID
  , input  wire  [DATA_WIDTH-1:0]   M_AXI_RDATA
  , input  wire       [1:0]         M_AXI_RRESP
  , input  wire                     M_AXI_RLAST
  , input  wire       [7:0]         M_AXI_RUSER
  , input  wire                     M_AXI_RVALID
  , output logic                    M_AXI_RREADY

  , input  wire                     r_start_in
  , input  wire                     w_start_in
  , output logic                    rd_bit_out

  , output logic [DBG_CNT_BITS-1:0] rd_req_cnt_out
  , output logic [DBG_CNT_BITS-1:0] rd_data_cnt_out
  , output logic [DBG_CNT_BITS-1:0] wr_req_cnt_out
  , output logic [DBG_CNT_BITS-1:0] wr_data_cnt_out
  , output logic [DBG_CNT_BITS-1:0] rd_req_bp_out
  , output logic [DBG_CNT_BITS-1:0] wr_req_bp_out
  , output logic [DBG_CNT_BITS-1:0] wr_data_bp_out
  
  , output logic [DBG_CNT_BITS-1:0] timestamp_out
  , output logic [DBG_CNT_BITS-1:0] rd_latency_out
);

if_m_ylxiao #(.ADDR_WIDTH(ADDR_WIDTH), .DATA_WIDTH(DATA_WIDTH)) maxi_ar( .ARESETN(ARESETN), .ACLK(ACLK));
if_m_ylxiao #(.ADDR_WIDTH(ADDR_WIDTH), .DATA_WIDTH(DATA_WIDTH)) maxi_r ( .ARESETN(ARESETN), .ACLK(ACLK));
if_m_ylxiao #(.ADDR_WIDTH(ADDR_WIDTH), .DATA_WIDTH(DATA_WIDTH)) maxi_aw( .ARESETN(ARESETN), .ACLK(ACLK));
if_m_ylxiao #(.ADDR_WIDTH(ADDR_WIDTH), .DATA_WIDTH(DATA_WIDTH)) maxi_w ( .ARESETN(ARESETN), .ACLK(ACLK));
if_m_ylxiao #(.ADDR_WIDTH(ADDR_WIDTH), .DATA_WIDTH(DATA_WIDTH)) maxi_b ( .ARESETN(ARESETN), .ACLK(ACLK));

logic [DBG_CNT_BITS-1:0] timestamp_net;
logic [DBG_CNT_BITS-1:0] rd_data_timestamp_net;

// Master Read Address
assign M_AXI_ARID            = maxi_ar.M_AXI_ARID;
assign M_AXI_ARADDR          = maxi_ar.M_AXI_ARADDR;
assign M_AXI_ARLEN           = maxi_ar.M_AXI_ARLEN;
assign M_AXI_ARSIZE          = maxi_ar.M_AXI_ARSIZE;
assign M_AXI_ARBURST         = maxi_ar.M_AXI_ARBURST;
assign M_AXI_ARLOCK          = maxi_ar.M_AXI_ARLOCK;
assign M_AXI_ARCACHE         = maxi_ar.M_AXI_ARCACHE;
assign M_AXI_ARPROT          = maxi_ar.M_AXI_ARPROT;
assign M_AXI_ARQOS           = maxi_ar.M_AXI_ARQOS;
assign M_AXI_ARUSER          = maxi_ar.M_AXI_ARUSER;
assign M_AXI_ARVALID         = maxi_ar.M_AXI_ARVALID;
assign maxi_ar.M_AXI_ARREADY = M_AXI_ARREADY;

assign maxi_r.M_AXI_RID      = M_AXI_RID;
assign maxi_r.M_AXI_RDATA    = M_AXI_RDATA;
assign maxi_r.M_AXI_RRESP    = M_AXI_RRESP;
assign maxi_r.M_AXI_RLAST    = M_AXI_RLAST;
assign maxi_r.M_AXI_RUSER    = M_AXI_RUSER;
assign maxi_r.M_AXI_RVALID   = M_AXI_RVALID;
assign M_AXI_RREADY          = maxi_r.M_AXI_RREADY;


ar_ch #(
    .ADDR_WIDTH         (ADDR_WIDTH         )
  , .RD_ADDR_BASE       (RD_ADDR_BASE       )
  , .RD_ADDR_HIGH       (RD_ADDR_HIGH       )
  , .RD_OUTSTANDING_MAX (RD_OUTSTANDING_MAX )
)
ar_ch_inst(
    .clk                (ACLK               )
  , .rst_n              (ARESETN            )
  , .r_start_in         (r_start_in         )
  , .maxi_ar            (maxi_ar            )
);


r_ch #(
    .DATA_WIDTH         (DATA_WIDTH         )
)
r_ch_inst(
    .clk                (ACLK               )
  , .rst_n              (ARESETN            )
  , .rd_bit_out         (rd_bit_out         )
  , .maxi_r             (maxi_r             )
);

fr_cnt #(
  .DATA_WIDTH(32)
)
debug_timestamp(
    .clk       (ACLK                         )
  , .rst_n     (ARESETN                      )
  , .en_in     (1'b1                         ) 
  , .cnt_out   (timestamp_net                )
);

fr_cnt #(
  .DATA_WIDTH(DBG_CNT_BITS)
)
debug_ar_cnt(
    .clk       (ACLK                                           )
  , .rst_n     (ARESETN                                        )
  , .en_in     (maxi_ar.M_AXI_ARVALID && maxi_ar.M_AXI_ARREADY ) 
  , .cnt_out   (rd_req_cnt_out                                 )
);

fr_cnt #(
  .DATA_WIDTH(DBG_CNT_BITS)
)
debug_r_cnt(
    .clk       (ACLK                                           )
  , .rst_n     (ARESETN                                        )
  , .en_in     (maxi_r.M_AXI_RVALID && maxi_r.M_AXI_RREADY     ) 
  , .cnt_out   (rd_data_cnt_out                                )
);

fr_cnt #(
  .DATA_WIDTH(DBG_CNT_BITS)
)
debug_aw_cnt(
    .clk       (ACLK                                           )
  , .rst_n     (ARESETN                                        )
  , .en_in     (maxi_aw.M_AXI_AWVALID && maxi_aw.M_AXI_AWREADY ) 
  , .cnt_out   (wr_req_cnt_out                                 )
);

fr_cnt #(
  .DATA_WIDTH(DBG_CNT_BITS)
)
debug_w_cnt(
    .clk       (ACLK                                           )
  , .rst_n     (ARESETN                                        )
  , .en_in     (maxi_w.M_AXI_WVALID && maxi_w.M_AXI_WREADY     ) 
  , .cnt_out   (wr_data_cnt_out                                )
);

fr_cnt #(
  .DATA_WIDTH(DBG_CNT_BITS)
)
debug_ar_bp(
    .clk       (ACLK                                             ) 
  , .rst_n     (ARESETN                                          )
  , .en_in     (maxi_ar.M_AXI_ARVALID && (~maxi_ar.M_AXI_ARREADY)) 
  , .cnt_out   (rd_req_bp_out                                    )
);

fr_cnt #(
  .DATA_WIDTH(DBG_CNT_BITS)
)
debug_aw_bp(
    .clk       (ACLK                                             )
  , .rst_n     (ARESETN                                          )
  , .en_in     (maxi_aw.M_AXI_AWVALID && (~maxi_aw.M_AXI_AWREADY)) 
  , .cnt_out   (wr_req_bp_out                                    )
);

fr_cnt #(
  .DATA_WIDTH(DBG_CNT_BITS)
)
debug_w_bp(
    .clk       (ACLK                                           )
  , .rst_n     (ARESETN                                        )
  , .en_in     (maxi_w.M_AXI_WVALID && (~maxi_w.M_AXI_WREADY)  ) 
  , .cnt_out   (wr_data_bp_out                                 )
);

  
xpm_fifo_sync #(
    .DOUT_RESET_VALUE  ("0"         )
  , .FIFO_MEMORY_TYPE  ("auto"      )
  , .FIFO_READ_LATENCY (0           )
  , .FIFO_WRITE_DEPTH  (1024        )
  , .READ_DATA_WIDTH   (DBG_CNT_BITS)
  , .USE_ADV_FEATURES  ("0707"      )
  , .WRITE_DATA_WIDTH  (32          )
) rd_timestamp_fifo (
    .dout              (rd_data_timestamp_net                         ) 
  , .empty             (                                              ) // should never empty
  , .rd_en             (maxi_r.M_AXI_RVALID && maxi_r.M_AXI_RREADY    )

  , .din               (timestamp_net                                 )
  , .full              (                                              ) // not used. should never full
  , .wr_en             (maxi_ar.M_AXI_ARVALID && maxi_ar.M_AXI_ARREADY)

  , .rst               (~ARESETN                                      )
  , .wr_clk            (ACLK                                          )
);

always_ff @(posedge ACLK) begin
  if(maxi_r.M_AXI_RVALID && maxi_r.M_AXI_RREADY) begin
    rd_latency_out <= timestamp_net - rd_data_timestamp_net;
  end else begin
    rd_latency_out <= rd_latency_out;
  end
  
  if (~ARESETN) begin
    rd_latency_out <= 0;
  end
end

assign timestamp_out = timestamp_net;

endmodule

`default_nettype wire
