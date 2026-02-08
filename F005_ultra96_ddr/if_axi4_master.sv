
interface if_axi4_master #(
    parameter ADDR_WIDTH = 32
  , parameter DATA_WIDTH = 64
)(
    input wire ARESETN
  , input wire ACLK
);
  // Master Write Address
  logic [             0:0] M_AXI_AWID;
  logic [  ADDR_WIDTH-1:0] M_AXI_AWADDR;
  logic [             7:0] M_AXI_AWLEN;    // Burst Length: 0-255
  logic [             2:0] M_AXI_AWSIZE;   // Burst Size: Fixed 2'b011
  logic [             1:0] M_AXI_AWBURST;  // Burst Type: Fixed 2'b01(Incremental Burst)
  logic                    M_AXI_AWLOCK;   // Lock: Fixed 2'b00
  logic [             3:0] M_AXI_AWCACHE;  // Cache: Fiex 2'b0011
  logic [             2:0] M_AXI_AWPROT;   // Protect: Fixed 2'b000
  logic [             3:0] M_AXI_AWQOS;    // QoS: Fixed 2'b0000
  logic [             7:0] M_AXI_AWUSER;   // User: Fixed 32'd0
  logic                    M_AXI_AWVALID;
  logic                    M_AXI_AWREADY;

  // Master Write Data
  logic [DATA_WIDTH-1  :0] M_AXI_WDATA;
  logic [DATA_WIDTH/8-1:0] M_AXI_WSTRB;
  logic                    M_AXI_WLAST;
  logic [DATA_WIDTH/8-1:0] M_AXI_WUSER;
  logic                    M_AXI_WVALID;
  logic                    M_AXI_WREADY;

  // Master Write Response
  logic [             0:0] M_AXI_BID;
  logic [             1:0] M_AXI_BRESP;
  logic [             7:0] M_AXI_BUSER;
  logic                    M_AXI_BVALID;
  logic                    M_AXI_BREADY;
   
  // Master Read Address
  logic [           0:0] M_AXI_ARID;
  logic [ADDR_WIDTH-1:0] M_AXI_ARADDR;
  logic [           7:0] M_AXI_ARLEN;
  logic [           2:0] M_AXI_ARSIZE;
  logic [           1:0] M_AXI_ARBURST;
  logic [           1:0] M_AXI_ARLOCK;
  logic [           3:0] M_AXI_ARCACHE;
  logic [           2:0] M_AXI_ARPROT;
  logic [           3:0] M_AXI_ARQOS;
  logic [           7:0] M_AXI_ARUSER;
  logic                  M_AXI_ARVALID;
  logic                  M_AXI_ARREADY;
   
  // Master Read Data 
  logic [           0:0] M_AXI_RID;
  logic [DATA_WIDTH-1:0] M_AXI_RDATA;
  logic [           1:0] M_AXI_RRESP;
  logic                  M_AXI_RLAST;
  logic [           7:0] M_AXI_RUSER;
  logic                  M_AXI_RVALID;
  logic                  M_AXI_RREADY;

  modport aw_ch ( 
      output M_AXI_AWID
    , output M_AXI_AWADDR
    , output M_AXI_AWLEN
    , output M_AXI_AWSIZE
    , output M_AXI_AWBURST
    , output M_AXI_AWLOCK
    , output M_AXI_AWCACHE
    , output M_AXI_AWPROT
    , output M_AXI_AWQOS
    , output M_AXI_AWUSER
    , output M_AXI_AWVALID
    , input  M_AXI_AWREADY
    , input  ACLK
    , input  ARESETN
  );
  
  modport w_ch (
      output M_AXI_WDATA
    , output M_AXI_WSTRB
    , output M_AXI_WLAST
    , output M_AXI_WUSER
    , output M_AXI_WVALID
    , input  M_AXI_WREADY
    , input  ACLK
    , input  ARESETN
  );
  
  modport b_ch (
      input  M_AXI_BID
    , input  M_AXI_BRESP
    , input  M_AXI_BUSER
    , input  M_AXI_BVALID
    , output M_AXI_BREADY
    , input  ACLK
    , input  ARESETN
  );
  
  modport ar_ch (
      output M_AXI_ARID
    , output M_AXI_ARADDR
    , output M_AXI_ARLEN
    , output M_AXI_ARSIZE
    , output M_AXI_ARBURST
    , output M_AXI_ARLOCK
    , output M_AXI_ARCACHE
    , output M_AXI_ARPROT
    , output M_AXI_ARQOS
    , output M_AXI_ARUSER
    , output M_AXI_ARVALID
    , input  M_AXI_ARREADY
    , input  ACLK
    , input  ARESETN
  );

  modport r_ch (
      input  M_AXI_RID
    , input  M_AXI_RDATA
    , input  M_AXI_RRESP
    , input  M_AXI_RLAST
    , input  M_AXI_RUSER
    , input  M_AXI_RVALID
    , output M_AXI_RREADY
    , input  ACLK
    , input  ARESETN
  );

endinterface
