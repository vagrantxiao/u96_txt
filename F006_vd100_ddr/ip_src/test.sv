`timescale 1 ps / 1 ps

module test();

parameter RD_LATENCY = 10;
parameter WR_LATENCY = 20;
parameter DATA_WIDTH = 128;
parameter ADDR_WIDTH = 32;

reg         ARESETN;
reg         ACLK;
wire [0:0]  M_AXI_AWID;
wire [ADDR_WIDTH-1:0] M_AXI_AWADDR;
wire [7:0]  M_AXI_AWLEN;
wire [2:0]  M_AXI_AWSIZE;
wire [1:0]  M_AXI_AWBURST;
wire        M_AXI_AWLOCK;
wire [3:0]  M_AXI_AWCACHE;
wire [2:0]  M_AXI_AWPROT;
wire [3:0]  M_AXI_AWQOS;
wire [7:0]  M_AXI_AWUSER;
wire        M_AXI_AWVALID;
reg         M_AXI_AWREADY;
wire [DATA_WIDTH-1:0] M_AXI_WDATA;
wire [DATA_WIDTH/8-1:0]  M_AXI_WSTRB;
wire        M_AXI_WLAST;
wire [7:0]  M_AXI_WUSER;
wire        M_AXI_WVALID;
reg         M_AXI_WREADY;
reg [0:0]   M_AXI_BID;
reg [1:0]   M_AXI_BRESP;
reg [7:0]   M_AXI_BUSER;
reg         M_AXI_BVALID;
wire        M_AXI_BREADY;
wire [0:0]  M_AXI_ARID;
wire [ADDR_WIDTH-1:0] M_AXI_ARADDR;
wire [7:0]  M_AXI_ARLEN;
wire [2:0]  M_AXI_ARSIZE;
wire [1:0]  M_AXI_ARBURST;
wire [1:0]  M_AXI_ARLOCK;
wire [3:0]  M_AXI_ARCACHE;
wire [2:0]  M_AXI_ARPROT;
wire [3:0]  M_AXI_ARQOS;
wire [7:0]  M_AXI_ARUSER;
wire        M_AXI_ARVALID;
reg         M_AXI_ARREADY;
reg [0:0]   M_AXI_RID;
reg [DATA_WIDTH-1:0]  M_AXI_RDATA;
reg [1:0]   M_AXI_RRESP;
reg         M_AXI_RLAST;
reg [7:0]   M_AXI_RUSER;
reg         M_AXI_RVALID;
wire        M_AXI_RREADY;
reg         r_start_in;
reg         w_start_in;
wire        rd_bit_out;
wire        b_bit_out;

reg [RD_LATENCY-1:0] r_hs_shifter;
reg [WR_LATENCY-1:0] w_hs_shifter;

always #5 ACLK = ~ACLK;

initial begin
  ARESETN       = 0;
  ACLK          = 0;
  M_AXI_AWREADY = 1;
  M_AXI_WREADY  = 1;
  M_AXI_BID     = 0;
  M_AXI_BRESP   = 0;
  M_AXI_BUSER   = 0;
  M_AXI_BVALID  = 0;
  M_AXI_ARREADY = 1;
  M_AXI_RID     = 1;
  M_AXI_RRESP   = 1;
  M_AXI_RLAST   = 1;
  M_AXI_RUSER   = 0;
  r_start_in    = 0;
  w_start_in    = 0;
  #1007
  ARESETN       = 1;
  
  #1000
  w_start_in    = 1'b1;
  #10
  w_start_in    = 1'b0;  
  #10_000
  M_AXI_AWREADY = 0;
  #10_000
  M_AXI_AWREADY = 1;
  
  #20_000
  r_start_in    = 1'b1;
  #10
  r_start_in    = 1'b0;
  
  
  #10_000
  M_AXI_ARREADY = 0;
  #10_000
  M_AXI_ARREADY = 1;
  #10_000
  $finish();
end

mem_agent_maxi dut1(
    .ARESETN       (ARESETN       )
  , .ACLK          (ACLK          )
  , .M_AXI_AWID    (M_AXI_AWID    )
  , .M_AXI_AWADDR  (M_AXI_AWADDR  )
  , .M_AXI_AWLEN   (M_AXI_AWLEN   )
  , .M_AXI_AWSIZE  (M_AXI_AWSIZE  )
  , .M_AXI_AWBURST (M_AXI_AWBURST )
  , .M_AXI_AWLOCK  (M_AXI_AWLOCK  )
  , .M_AXI_AWCACHE (M_AXI_AWCACHE )
  , .M_AXI_AWPROT  (M_AXI_AWPROT  )
  , .M_AXI_AWQOS   (M_AXI_AWQOS   )
  , .M_AXI_AWUSER  (M_AXI_AWUSER  )
  , .M_AXI_AWVALID (M_AXI_AWVALID )
  , .M_AXI_AWREADY (M_AXI_AWREADY )
  , .M_AXI_WDATA   (M_AXI_WDATA   )
  , .M_AXI_WSTRB   (M_AXI_WSTRB   )
  , .M_AXI_WLAST   (M_AXI_WLAST   )
  , .M_AXI_WUSER   (M_AXI_WUSER   )
  , .M_AXI_WVALID  (M_AXI_WVALID  )
  , .M_AXI_WREADY  (M_AXI_WREADY  )
  , .M_AXI_BID     (M_AXI_BID     )
  , .M_AXI_BRESP   (M_AXI_BRESP   )
  , .M_AXI_BUSER   (M_AXI_BUSER   )
  , .M_AXI_BVALID  (M_AXI_BVALID  )
  , .M_AXI_BREADY  (M_AXI_BREADY  )
  , .M_AXI_ARID    (M_AXI_ARID    )
  , .M_AXI_ARADDR  (M_AXI_ARADDR  )
  , .M_AXI_ARLEN   (M_AXI_ARLEN   )
  , .M_AXI_ARSIZE  (M_AXI_ARSIZE  )
  , .M_AXI_ARBURST (M_AXI_ARBURST )
  , .M_AXI_ARLOCK  (M_AXI_ARLOCK  )
  , .M_AXI_ARCACHE (M_AXI_ARCACHE )
  , .M_AXI_ARPROT  (M_AXI_ARPROT  )
  , .M_AXI_ARQOS   (M_AXI_ARQOS   )
  , .M_AXI_ARUSER  (M_AXI_ARUSER  )
  , .M_AXI_ARVALID (M_AXI_ARVALID )
  , .M_AXI_ARREADY (M_AXI_ARREADY )
  , .M_AXI_RID     (M_AXI_RID     )
  , .M_AXI_RDATA   (M_AXI_RDATA   )
  , .M_AXI_RRESP   (M_AXI_RRESP   )
  , .M_AXI_RLAST   (M_AXI_RLAST   )
  , .M_AXI_RUSER   (M_AXI_RUSER   )
  , .M_AXI_RVALID  (M_AXI_RVALID  )
  , .M_AXI_RREADY  (M_AXI_RREADY  )
  , .r_start_in    (r_start_in    )
  , .w_start_in    (w_start_in    )
  , .rd_bit_out    (rd_bit_out    )
  , .b_bit_out     (b_bit_out     )
);

always @(posedge ACLK) begin
  {M_AXI_RVALID, r_hs_shifter} <= {r_hs_shifter, (M_AXI_ARVALID && M_AXI_ARREADY)};
  {M_AXI_BVALID, w_hs_shifter} <= {w_hs_shifter, (M_AXI_AWVALID && M_AXI_AWREADY)};
  M_AXI_RDATA    <= (M_AXI_RVALID && M_AXI_RREADY) ? (M_AXI_RDATA+1) : M_AXI_RDATA;
  if (~ARESETN) begin
    r_hs_shifter <= '0;
    w_hs_shifter <= '0;
    M_AXI_RVALID <= 0;
    M_AXI_BVALID <= 0;
    M_AXI_RDATA  <= '0;
  end
end


endmodule
