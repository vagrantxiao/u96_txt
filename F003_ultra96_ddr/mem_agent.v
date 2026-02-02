`timescale 1ns / 1ps

module mem_agent(  

  // Reset, Clock
  input           ARESETN,
  input           ACLK,

  // Master Write Address
  output [0:0]  M_AXI_AWID,
  output [31:0] M_AXI_AWADDR,
  output [7:0]  M_AXI_AWLEN,    // Burst Length: 0-255
  output [2:0]  M_AXI_AWSIZE,   // Burst Size: Fixed 2'b011
  output [1:0]  M_AXI_AWBURST,  // Burst Type: Fixed 2'b01(Incremental Burst)
  output        M_AXI_AWLOCK,   // Lock: Fixed 2'b00
  output [3:0]  M_AXI_AWCACHE,  // Cache: Fiex 2'b0011
  output [2:0]  M_AXI_AWPROT,   // Protect: Fixed 2'b000
  output [3:0]  M_AXI_AWQOS,    // QoS: Fixed 2'b0000
  output [0:0]  M_AXI_AWUSER,   // User: Fixed 32'd0
  output        M_AXI_AWVALID,
  input         M_AXI_AWREADY,

  // Master Write Data
  output [63:0] M_AXI_WDATA,
  output [7:0]  M_AXI_WSTRB,
  output        M_AXI_WLAST,
  output [0:0]  M_AXI_WUSER,
  output        M_AXI_WVALID,
  input         M_AXI_WREADY,

  // Master Write Response
  input [0:0]   M_AXI_BID,
  input [1:0]   M_AXI_BRESP,
  input [0:0]   M_AXI_BUSER,
  input         M_AXI_BVALID,
  output        M_AXI_BREADY,
    
  // Master Read Address
  output [0:0]  M_AXI_ARID,
  output [31:0] M_AXI_ARADDR,
  output [7:0]  M_AXI_ARLEN,
  output [2:0]  M_AXI_ARSIZE,
  output [1:0]  M_AXI_ARBURST,
  output [1:0]  M_AXI_ARLOCK,
  output [3:0]  M_AXI_ARCACHE,
  output [2:0]  M_AXI_ARPROT,
  output [3:0]  M_AXI_ARQOS,
  output [0:0]  M_AXI_ARUSER,
  output        M_AXI_ARVALID,
  input         M_AXI_ARREADY,
    
  // Master Read Data 
  input [0:0]   M_AXI_RID,
  input [63:0]  M_AXI_RDATA,
  input [1:0]   M_AXI_RRESP,
  input         M_AXI_RLAST,
  input [0:0]   M_AXI_RUSER,
  input         M_AXI_RVALID,
  output        M_AXI_RREADY,
  input [31:0]  start,
  output [31:0] error
    );
	

wire wr_burst_data_req;
wire wr_burst_finish;
wire rd_burst_finish;
wire rd_burst_req;
wire wr_burst_req;
wire[9:0] rd_burst_len;
wire[9:0] wr_burst_len;
wire[31:0] rd_burst_addr;
wire[31:0] wr_burst_addr;
wire rd_burst_data_valid;
wire[63 : 0] rd_burst_data;
wire[63 : 0] wr_burst_data;

mem_test
#(
	.MEM_DATA_BITS(64),
	.ADDR_BITS(27)
)
mem_test_m0
(
	.rst(~ARESETN),                                 
	.mem_clk(M_AXI_ACLK),                             
	.rd_burst_req(rd_burst_req),               
	.wr_burst_req(wr_burst_req),               
	.rd_burst_len(rd_burst_len),               
	.wr_burst_len(wr_burst_len),               
	.rd_burst_addr(rd_burst_addr),        
	.wr_burst_addr(wr_burst_addr),        
	.rd_burst_data_valid(rd_burst_data_valid),  
	.wr_burst_data_req(wr_burst_data_req),  
	.rd_burst_data(rd_burst_data),  
	.wr_burst_data(wr_burst_data),    
	.rd_burst_finish(rd_burst_finish),   
	.wr_burst_finish(wr_burst_finish),
    .start(start),
	.error(error[0])
); 
assign error[31:1] = 0;

aq_axi_master u_aq_axi_master
(
	.ARESETN(ARESETN),
	.ACLK(M_AXI_ACLK),
	
	.M_AXI_AWID(M_AXI_AWID),
	.M_AXI_AWADDR(M_AXI_AWADDR),     
	.M_AXI_AWLEN(M_AXI_AWLEN),
	.M_AXI_AWSIZE(M_AXI_AWSIZE),
	.M_AXI_AWBURST(M_AXI_AWBURST),
	.M_AXI_AWLOCK(M_AXI_AWLOCK),
	.M_AXI_AWCACHE(M_AXI_AWCACHE),
	.M_AXI_AWPROT(M_AXI_AWPROT),
	.M_AXI_AWQOS(M_AXI_AWQOS),
	.M_AXI_AWUSER(M_AXI_AWUSER),
	.M_AXI_AWVALID(M_AXI_AWVALID),
	.M_AXI_AWREADY(M_AXI_AWREADY),
	
	.M_AXI_WDATA(M_AXI_WDATA),
	.M_AXI_WSTRB(M_AXI_WSTRB),
	.M_AXI_WLAST(M_AXI_WLAST),
	.M_AXI_WUSER(M_AXI_WUSER),
	.M_AXI_WVALID(M_AXI_WVALID),
	.M_AXI_WREADY(M_AXI_WREADY),
	
	.M_AXI_BID(M_AXI_BID),
	.M_AXI_BRESP(M_AXI_BRESP),
	.M_AXI_BUSER(M_AXI_BUSER),
	.M_AXI_BVALID(M_AXI_BVALID),
	.M_AXI_BREADY(M_AXI_BREADY),
	
	.M_AXI_ARID(M_AXI_ARID),
	.M_AXI_ARADDR(M_AXI_ARADDR),
	.M_AXI_ARLEN(M_AXI_ARLEN),
	.M_AXI_ARSIZE(M_AXI_ARSIZE),
	.M_AXI_ARBURST(M_AXI_ARBURST),
	.M_AXI_ARLOCK(M_AXI_ARLOCK),
	.M_AXI_ARCACHE(M_AXI_ARCACHE),
	.M_AXI_ARPROT(M_AXI_ARPROT),
	.M_AXI_ARQOS(M_AXI_ARQOS),
	.M_AXI_ARUSER(M_AXI_ARUSER),
	.M_AXI_ARVALID(M_AXI_ARVALID),
	.M_AXI_ARREADY(M_AXI_ARREADY),
	
	.M_AXI_RID(M_AXI_RID),
	.M_AXI_RDATA(M_AXI_RDATA),
	.M_AXI_RRESP(M_AXI_RRESP),
	.M_AXI_RLAST(M_AXI_RLAST),
	.M_AXI_RUSER(M_AXI_RUSER),
	.M_AXI_RVALID(M_AXI_RVALID),
	.M_AXI_RREADY(M_AXI_RREADY),
	
	.MASTER_RST(~ARESETN),
	
	.WR_START(wr_burst_req),
	.WR_ADRS({wr_burst_addr[28:0],3'd0}),
	.WR_LEN({wr_burst_len,3'd0}), 
	.WR_READY(),
	.WR_FIFO_RE(wr_burst_data_req),
	.WR_FIFO_EMPTY(1'b0),
	.WR_FIFO_AEMPTY(1'b0),
	.WR_FIFO_DATA(wr_burst_data),
	.WR_DONE(wr_burst_finish),
	
	.RD_START(rd_burst_req),
	.RD_ADRS({rd_burst_addr[28:0],3'd0}),
	.RD_LEN({rd_burst_len,3'd0}), 
	.RD_READY(),
	.RD_FIFO_WE(rd_burst_data_valid),
	.RD_FIFO_FULL(1'b0),
	.RD_FIFO_AFULL(1'b0),
	.RD_FIFO_DATA(rd_burst_data),
	.RD_DONE(rd_burst_finish),
	.DEBUG()                                         
);



endmodule
