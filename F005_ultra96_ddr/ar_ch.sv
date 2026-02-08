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

module ar_ch
  import mem_agent_types::*;
#(
    parameter ADDR_WIDTH         = AXI_MASTER_ADDR_WIDTH
  , parameter RD_ADDR_BASE       = AXI_RD_ADDR_BASE
  , parameter RD_ADDR_HIGH       = AXI_RD_ADDR_HIGH
  , parameter RD_OUTSTANDING_MAX = AXI_RD_OUTSTANDING_MAX
)(
  // Reset, Clock
    input wire           clk
  , input wire           rst_n
  , input wire           r_start_in
  , if_axi4_master.ar_ch maxi_ar
);

  typedef  enum logic [1:0] {
      AR_IDLE
    , AR_REQ
  } ar_state_t;

  struct packed {
    logic                   wrreq;
    logic                   full;
    logic [ADDR_WIDTH-1:0]  data;
    logic                   rdreq;
    logic                   empty;
    logic [ADDR_WIDTH-1:0]  q;
  } ar_fifo_if;

  logic [ADDR_WIDTH-1:0] ar_addr_nxt, ar_addr_ff;
  ar_state_t             ar_st_nxt, ar_st_ff;
  
  always_comb begin
    ar_fifo_if.wrreq      = 0;
   // Master Read Address
    maxi_ar.M_AXI_ARID    = '0; 
    maxi_ar.M_AXI_ARLEN   = '0;
    maxi_ar.M_AXI_ARSIZE  = 3'b011;
    maxi_ar.M_AXI_ARBURST = 2'b01;
    maxi_ar.M_AXI_ARLOCK  = 2'b00;
    maxi_ar.M_AXI_ARCACHE = 4'b0011;
    maxi_ar.M_AXI_ARQOS   = 4'b0000;
    maxi_ar.M_AXI_ARPROT  = 3'b000;
    maxi_ar.M_AXI_ARUSER  = '0;

    ar_st_nxt  = ar_st_ff;
    ar_addr_nxt = ar_addr_ff;

    maxi_ar.M_AXI_ARADDR  =  ar_fifo_if.q;
    maxi_ar.M_AXI_ARVALID = ~ar_fifo_if.empty;

    ar_fifo_if.rdreq   = (~ar_fifo_if.empty && maxi_ar.M_AXI_ARREADY);


    case (ar_st_ff)
      AR_IDLE: begin
        if (r_start_in) begin
          ar_st_nxt = AR_REQ;
        end
        
      end

      AR_REQ: begin
        if (~ar_fifo_if.full) begin
          ar_fifo_if.wrreq  = 1'b1;
          if (ar_addr_ff == RD_ADDR_HIGH) begin
            ar_addr_nxt = RD_ADDR_BASE;
          end else begin
            ar_addr_nxt = ar_addr_ff + 8;
          end
        end
      end
      
      default: begin
        ar_st_nxt = AR_IDLE;
      end
    endcase
  end


  always @(posedge clk) begin
    ar_addr_ff   <= ar_addr_nxt;
    ar_st_ff     <= ar_st_nxt;
    if (~rst_n) begin
      ar_addr_ff <= RD_ADDR_BASE;
      ar_st_ff   <= AR_IDLE;
    end
  end

  xpm_fifo_sync #(
      .DOUT_RESET_VALUE  ("0"               )
    , .FIFO_MEMORY_TYPE  ("auto"            )
    , .FIFO_READ_LATENCY (0                 )
    , .FIFO_WRITE_DEPTH  (RD_OUTSTANDING_MAX)
    , .READ_DATA_WIDTH   (ADDR_WIDTH        )
    , .USE_ADV_FEATURES  ("0707"            )
    , .WRITE_DATA_WIDTH  (ADDR_WIDTH        )
  ) rd_addr_fifo (
      .dout              (ar_fifo_if.q      )
    , .empty             (ar_fifo_if.empty  )
    , .rd_en             (ar_fifo_if.rdreq  )

    , .din               (ar_addr_ff        )
    , .full              (ar_fifo_if.full   )
    , .wr_en             (ar_fifo_if.wrreq  )

    , .rst               (~rst_n            )
    , .wr_clk            (clk               )
  );

endmodule

`default_nettype wire

