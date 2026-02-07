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

module mem_agent_axi #(
    parameter RD_ADDR_BASE = 32'h4000_0000
  , parameter RD_ADDR_HIGH = 32'h5000_0000
  , parameter WR_ADDR_BASE = 32'h4000_0000
  , parameter WR_ADDR_HIGH = 32'h5000_0000
  , parameter DATA_WIDTH   = 64
)(
  // Reset, Clock
    input         ARESETN
  , input         ACLK

  // Master Write Address
  , output [0:0]  M_AXI_AWID
  , output [31:0] M_AXI_AWADDR
  , output [7:0]  M_AXI_AWLEN    // Burst Length: 0-255
  , output [2:0]  M_AXI_AWSIZE   // Burst Size: Fixed 2'b011
  , output [1:0]  M_AXI_AWBURST  // Burst Type: Fixed 2'b01(Incremental Burst)
  , output        M_AXI_AWLOCK   // Lock: Fixed 2'b00
  , output [3:0]  M_AXI_AWCACHE  // Cache: Fiex 2'b0011
  , output [2:0]  M_AXI_AWPROT   // Protect: Fixed 2'b000
  , output [3:0]  M_AXI_AWQOS    // QoS: Fixed 2'b0000
  , output [7:0]  M_AXI_AWUSER   // User: Fixed 32'd0
  , output        M_AXI_AWVALID
  , input         M_AXI_AWREADY

  // Master Write Data
  , output [63:0] M_AXI_WDATA
  , output [7:0]  M_AXI_WSTRB
  , output        M_AXI_WLAST
  , output [7:0]  M_AXI_WUSER
  , output        M_AXI_WVALID
  , input         M_AXI_WREADY

  // Master Write Response
  , input [0:0]   M_AXI_BID
  , input [1:0]   M_AXI_BRESP
  , input [7:0]   M_AXI_BUSER
  , input             M_AXI_BVALID
  , output            M_AXI_BREADY
   
  // Master Read Address
  , output     [0:0]  M_AXI_ARID
  , output     [31:0] M_AXI_ARADDR
  , output     [7:0]  M_AXI_ARLEN
  , output     [2:0]  M_AXI_ARSIZE
  , output     [1:0]  M_AXI_ARBURST
  , output     [1:0]  M_AXI_ARLOCK
  , output     [3:0]  M_AXI_ARCACHE
  , output     [2:0]  M_AXI_ARPROT
  , output     [3:0]  M_AXI_ARQOS
  , output     [7:0]  M_AXI_ARUSER
  , output            M_AXI_ARVALID
  , input             M_AXI_ARREADY
   
  // Master Read Data 
  , input      [0:0]  M_AXI_RID
  , input      [63:0] M_AXI_RDATA
  , input      [1:0]  M_AXI_RRESP
  , input             M_AXI_RLAST
  , input      [7:0]  M_AXI_RUSER
  , input             M_AXI_RVALID
  , output            M_AXI_RREADY

  , input             r_start_in
  , input             w_start_in

  , output     [31:0] rd_req_cnt_out
  , output     [31:0] rd_data_cnt_out
  , output     [31:0] wr_req_cnt_out
  , output     [31:0] wr_data_cnt_out
  , output     [31:0] rd_req_bp_out
  , output     [31:0] wr_req_bp_out
  , output     [31:0] wr_data_bp_out
  
  , output     [31:0] timestamp_out
  , output reg [31:0] rd_latency_out
  
  , output            rd_bit_out

);

  localparam AR_IDLE = 1'b0;
  localparam AR_REQ = 1'b1;

  reg  [1 :0] ar_st_nxt, ar_st_ff;

  reg  [31:0] ar_din_nxt, ar_din_ff; 
  reg         ar_wrreq; 
  wire        ar_full; 

  wire [31:0] ar_dout;
  wire        ar_empty;
  reg         ar_rdreq;

  wire [31:0] pkt_timestamp;
  
  assign M_AXI_AWID    = 0;
  assign M_AXI_AWADDR  = 0;
  assign M_AXI_AWLEN   = 0; // Burst Length: 0-255
  assign M_AXI_AWSIZE  = 0; // Burst Size: Fixed 2'b011
  assign M_AXI_AWBURST = 0; // Burst Type: Fixed 2'b01(Incremental Burst)
  assign M_AXI_AWLOCK  = 0; // Lock: Fixed 2'b00
  assign M_AXI_AWCACHE = 0; // Cache: Fiex 2'b0011
  assign M_AXI_AWPROT  = 0; // Protect: Fixed 2'b000
  assign M_AXI_AWQOS   = 0; // QoS: Fixed 2'b0000
  assign M_AXI_AWUSER  = 0; // User: Fixed 32'd0
  assign M_AXI_AWVALID = 0;
  assign M_AXI_WDATA   = 0;
  assign M_AXI_WSTRB   = 0;
  assign M_AXI_WLAST   = 0;
  assign M_AXI_WUSER   = 0;
  assign M_AXI_WVALID  = 0;
  assign M_AXI_BREADY  = 0;


   // Master Read Address
  assign M_AXI_ARID    = 0; 
  assign M_AXI_ARLEN   = 0;
  assign M_AXI_ARSIZE  = 3'b011;
  assign M_AXI_ARBURST = 2'b01;
  assign M_AXI_ARLOCK  = 2'b00;
  assign M_AXI_ARCACHE = 4'b0011;
  assign M_AXI_ARQOS   = 4'b0000;
  assign M_AXI_ARPROT  = 3'b000;
  assign M_AXI_ARUSER  = 0;

  assign M_AXI_ARADDR  =  ar_dout;
  assign M_AXI_ARVALID = ~ar_empty;

  fr_cnt debug_ar_cnt(
      .clk   (ACLK                             )
    , .rst_n (ARESETN                          )
    , .en    (M_AXI_ARVALID && M_AXI_ARREADY   ) 
    , .cnt   (rd_req_cnt_out                   )
  );

  fr_cnt debug_r_cnt(
      .clk   (ACLK                             )
    , .rst_n (ARESETN                          )
    , .en    (M_AXI_RVALID && M_AXI_RREADY     ) 
    , .cnt   (rd_data_cnt_out                  )
  );

  fr_cnt debug_aw_cnt(
      .clk   (ACLK                             )
    , .rst_n (ARESETN                          )
    , .en    (M_AXI_AWVALID && M_AXI_AWREADY   ) 
    , .cnt   (wr_req_cnt_out                   )
  );

  fr_cnt debug_w_cnt(
      .clk   (ACLK                             )
    , .rst_n (ARESETN                          )
    , .en    (M_AXI_WVALID && M_AXI_WREADY     ) 
    , .cnt   (wr_data_cnt_out                  )
  );

  fr_cnt debug_ar_bp(
      .clk   (ACLK                             ) 
    , .rst_n (ARESETN                          )
    , .en    (M_AXI_ARVALID && (~M_AXI_ARREADY)) 
    , .cnt   (rd_req_bp_out                    )
  );

  fr_cnt debug_aw_bp(
      .clk   (ACLK                             )
    , .rst_n (ARESETN                          )
    , .en    (M_AXI_AWVALID && (~M_AXI_AWREADY)) 
    , .cnt   (wr_req_bp_out                    )
  );

  fr_cnt debug_w_bp(
      .clk   (ACLK                             )
    , .rst_n (ARESETN                          )
    , .en    (M_AXI_WVALID && (~M_AXI_WREADY)  ) 
    , .cnt   (wr_data_bp_out                   )
  );

  
  fr_cnt debug_timestamp(
      .clk   (ACLK                             )
    , .rst_n (ARESETN                          )
    , .en    (1'b1                             ) 
    , .cnt   (timestamp_out                    )
  );

  xpm_fifo_sync #(
      .DOUT_RESET_VALUE  ("0"       )
    , .FIFO_MEMORY_TYPE  ("auto"    )
    , .FIFO_READ_LATENCY (0         )
    , .FIFO_WRITE_DEPTH  (16        )
    , .READ_DATA_WIDTH   (32        )
    , .USE_ADV_FEATURES  ("0707"    )
    , .WRITE_DATA_WIDTH  (32        )
  ) rd_addr_fifo (
      .dout              (ar_dout   )
    , .empty             (ar_empty  )
    , .rd_en             (ar_rdreq  )

    , .din               (ar_din_ff )
    , .full              (ar_full   )
    , .wr_en             (ar_wrreq  )

    , .rst               (~ARESETN  )
    , .wr_clk            (ACLK      )
  );

  always @(posedge ACLK) begin
    if(M_AXI_RVALID) begin
      rd_latency_out <= timestamp_out - pkt_timestamp;
    end else begin
      rd_latency_out <= rd_latency_out;
    end
    
    if (~ARESETN) begin
      rd_latency_out <= 0;
    end
  end
    
  
  xpm_fifo_sync #(
      .DOUT_RESET_VALUE  ("0"       )
    , .FIFO_MEMORY_TYPE  ("auto"    )
    , .FIFO_READ_LATENCY (0         )
    , .FIFO_WRITE_DEPTH  (1024      )
    , .READ_DATA_WIDTH   (32        )
    , .USE_ADV_FEATURES  ("0707"    )
    , .WRITE_DATA_WIDTH  (32        )
  ) rd_timestamp_fifo (
      .dout              (pkt_timestamp   )
    , .empty             (                ) // should never empty
    , .rd_en             (M_AXI_RVALID    )

    , .din               (timestamp_out   )
    , .full              (                ) // not used. should never full
    , .wr_en             (ar_wrreq        )

    , .rst               (~ARESETN        )
    , .wr_clk            (ACLK            )
  );
  
  always @(*) begin
    ar_wrreq   = 0;

    ar_rdreq   = (~ar_empty && M_AXI_ARREADY);

    ar_st_nxt  = ar_st_ff;
    ar_din_nxt = ar_din_ff;

    case (ar_st_ff)
      AR_IDLE: begin
        if (r_start_in) begin
          ar_st_nxt = AR_REQ;
        end
        
      end

      AR_REQ: begin
        if (~ar_full) begin
          ar_wrreq  = 1;
        end

      end
      
      default: begin
        ar_st_nxt = AR_IDLE;
      end
    endcase

    if (ar_wrreq) begin
      if (ar_din_ff == RD_ADDR_HIGH) begin
        ar_din_nxt = RD_ADDR_BASE;
      end else begin
        ar_din_nxt = ar_din_ff + 8;
      end
    end
  end


  always @(posedge ACLK) begin
    ar_din_ff   <= ar_din_nxt;
    ar_st_ff    <= ar_st_nxt;
    if (~ARESETN) begin
      ar_din_ff <= RD_ADDR_BASE;
      ar_st_ff  <= 0;
    end
  end

  assign M_AXI_RREADY  = 1'b1;
  assign rd_bit_out    = |{M_AXI_RID, M_AXI_RDATA, M_AXI_RRESP, M_AXI_RLAST, M_AXI_RUSER, M_AXI_RVALID};






























  parameter AW_IDLE = 1'b0;
  parameter AW_REQ  = 1'b1;

  reg [1:0]  aw_st_nxt, aw_st_ff;

  wire [31:0] aw_dout;
  wire        aw_empty;
  wire        aw_rdreq;

  reg  [31:0] aw_din_nxt, aw_din_ff;
  reg         aw_wrreq;
  wire        aw_full;


  always @(*) begin
    aw_wrreq   = 0;

    aw_rdreq   = (~aw_empty && M_AXI_AWREADY);

    aw_st_nxt  = aw_st_ff;
    aw_din_nxt = aw_din_ff;

    case (aw_st_ff)
      AW_IDLE: begin
        if (w_start_in) begin
          aw_st_nxt = AW_REQ;
        end
        
      end

      AW_REQ: begin
        if (~aw_full) begin
          aw_wrreq  = 1;
          if (aw_din_ff == WR_ADDR_HIGH) begin
            aw_din_nxt = WR_ADDR_BASE;
            aw_st_nxt  = AW_IDLE;
          end else begin
            aw_din_nxt = aw_din_ff + (DATA_WIDTH / 8);
          end
        end

      end
      
      default: begin
        aw_st_nxt = AW_IDLE;
      end
    endcase

  end


  always @(posedge ACLK) begin
    aw_din_ff   <= aw_din_nxt;
    aw_st_ff    <= aw_st_nxt;
    if (~ARESETN) begin
      aw_din_ff <= WR_ADDR_BASE;
      aw_st_ff  <= 0;
    end
  end


  xpm_fifo_sync #(
      .DOUT_RESET_VALUE  ("0"       )
    , .FIFO_MEMORY_TYPE  ("auto"    )
    , .FIFO_READ_LATENCY (0         )
    , .FIFO_WRITE_DEPTH  (16        )
    , .READ_DATA_WIDTH   (32        )
    , .USE_ADV_FEATURES  ("0707"    )
    , .WRITE_DATA_WIDTH  (32        )
  ) wr_addr_fifo (
      .dout              (aw_dout   )
    , .empty             (aw_empty  )
    , .rd_en             (aw_rdreq  )

    , .din               (aw_din_ff )
    , .full              (aw_full   )
    , .wr_en             (aw_wrreq  )

    , .rst               (~ARESETN  )
    , .wr_clk            (ACLK      )
  );







  assign M_AXI_AWID    = 0;
  assign M_AXI_AWADDR  = 0;
  assign M_AXI_AWLEN   = 0;
  assign M_AXI_AWSIZE  = 0;
  assign M_AXI_AWBURST = 0;
  assign M_AXI_AWLOCK  = 0;
  assign M_AXI_AWCACHE = 0;
  assign M_AXI_AWPROT  = 0;
  assign M_AXI_AWQOS   = 0;
  assign M_AXI_AWUSER  = 0;
  assign M_AXI_AWVALID = 0;

  assign M_AXI_WDATA   = 0;
  assign M_AXI_WSTRB   = 0;
  assign M_AXI_WLAST   = 0;
  assign M_AXI_WUSER   = 0;
  assign M_AXI_WVALID  = 0;

  assign M_AXI_BREADY  = 0;
 
  

endmodule

