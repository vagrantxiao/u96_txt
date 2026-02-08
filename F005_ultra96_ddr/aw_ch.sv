//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2022.2 (lin64) Build 3671981 Fri Oct 14 04:59:54 MDT 2022
//Date        : Sun Feb  1 13:04:08 2026
//Host        : oquawk running 64-bit Ubuntu 20.04.6 LTS
//Command     : generate_tawget design_1_wrapper.bd
//Design      : design_1_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps
`default_nettype none

module aw_ch
  import mem_agent_types::*;
#(
    parameter ADDR_WIDTH         = AXI_MASTER_ADDR_WIDTH
  , parameter AWSIZE             = AXI_MASTER_SIZE
  , parameter WR_ADDR_BASE       = AXI_WR_ADDR_BASE
  , parameter WR_ADDR_HIGH       = AXI_WR_ADDR_HIGH
  , parameter WR_OUTSTANDING_MAX = AXI_WR_OUTSTANDING_MAX
)(
  // Reset, Clock
    input wire           clk
  , input wire           rst_n
  , input wire           w_start_in
  , if_axi4_master.aw_ch maxi_aw
);

  typedef  enum logic [1:0] {
      AW_IDLE
    , AW_REQ
  } aw_state_t;

  struct packed {
    logic                   wrreq;
    logic                   full;
    logic [ADDR_WIDTH-1:0]  data;
    logic                   rdreq;
    logic                   empty;
    logic [ADDR_WIDTH-1:0]  q;
  } aw_fifo_if;

  logic [ADDR_WIDTH-1:0] aw_addr_nxt, aw_addr_ff;
  aw_state_t             aw_st_nxt, aw_st_ff;
  
  always_comb begin

    // Default values
    aw_fifo_if.wrreq      = 0;
    maxi_aw.M_AXI_AWID    = 0;
    maxi_aw.M_AXI_AWLEN   = 8'd0;     // Burst Length: 0-255
    maxi_aw.M_AXI_AWSIZE  = AWSIZE;   // Burst Size: Fixed 2'b011
    maxi_aw.M_AXI_AWBURST = 2'b01;    // Burst Type: Fixed 2'b01(Incremental Burst)
    maxi_aw.M_AXI_AWLOCK  = 1'b0;     // Lock: Fixed 2'b00
    maxi_aw.M_AXI_AWCACHE = 4'b0011;  // Cache: Fiex 2'b0011
    maxi_aw.M_AXI_AWPROT  = 3'b000;   // Protect: Fixed 2'b000
    maxi_aw.M_AXI_AWQOS   = 4'b0000;  // QoS: Fixed 2'b0000
    maxi_aw.M_AXI_AWUSER  = '0;   // User: Fixed 32'd0


    // Assigned by registers
    aw_st_nxt             = aw_st_ff;
    aw_addr_nxt           = aw_addr_ff;
    aw_fifo_if.data       = aw_addr_ff;

    // Assigned by logic
    maxi_aw.M_AXI_AWADDR  =  aw_fifo_if.q;
    maxi_aw.M_AXI_AWVALID = ~aw_fifo_if.empty;
    aw_fifo_if.rdreq      = (~aw_fifo_if.empty && maxi_aw.M_AXI_AWREADY);
    

    case (aw_st_ff)
      AW_IDLE: begin
        if (w_start_in) begin
          aw_st_nxt = AW_REQ;
        end
        
      end

      AW_REQ: begin
        if (~aw_fifo_if.full) begin
          aw_fifo_if.wrreq  = 1'b1;
          if (aw_addr_ff == WR_ADDR_HIGH) begin
            aw_addr_nxt = WR_ADDR_BASE;
            aw_st_nxt   = AW_IDLE;
          end else begin
            aw_addr_nxt = aw_addr_ff + (1<<AWSIZE);
          end
        end
      end
      
      default: begin
        aw_st_nxt = AW_IDLE;
      end
    endcase
  end


  always @(posedge clk) begin
    aw_addr_ff   <= aw_addr_nxt;
    aw_st_ff     <= aw_st_nxt;
    if (~rst_n) begin
      aw_addr_ff <= WR_ADDR_BASE;
      aw_st_ff   <= AW_IDLE;
    end
  end

  xpm_fifo_sync #(
      .DOUT_RESET_VALUE  ("0"               )
    , .FIFO_MEMORY_TYPE  ("auto"            )
    , .FIFO_READ_LATENCY (0                 )
    , .FIFO_WRITE_DEPTH  (WR_OUTSTANDING_MAX)
    , .READ_DATA_WIDTH   (ADDR_WIDTH        )
    , .USE_ADV_FEATURES  ("0707"            )
    , .WRITE_DATA_WIDTH  (ADDR_WIDTH        )
  ) wr_addr_fifo (
      .dout              (aw_fifo_if.q      )
    , .empty             (aw_fifo_if.empty  )
    , .rd_en             (aw_fifo_if.rdreq  )

    , .din               (aw_addr_ff        )
    , .full              (aw_fifo_if.full   )
    , .wr_en             (aw_fifo_if.wrreq  )

    , .rst               (~rst_n            )
    , .wr_clk            (clk               )
  );

endmodule

`default_nettype wire

