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


module w_ch
  import mem_agent_types::*;
#(
    parameter DATA_WIDTH = AXI_MASTER_DATA_WIDTH
)(
  // Reset, Clock
    input  wire         clk
  , input  wire         rst_n
  , output logic        rd_bit_out
  , if_axi4_master.r_ch maxi_r
);

  logic rd_bit_nxt, rd_bit_ff;
  always_comb begin
    rd_bit_out          = rd_bit_ff;
    rd_bit_nxt          = ^{maxi_r.M_AXI_RID, maxi_r.M_AXI_RDATA, maxi_r.M_AXI_RRESP, maxi_r.M_AXI_RLAST, maxi_r.M_AXI_RUSER, maxi_r.M_AXI_RVALID};
    maxi_r.M_AXI_RREADY = 1'b1;
  end

  always @(posedge clk) begin
    rd_bit_ff   <= rd_bit_nxt;
    if (!rst_n) begin
      rd_bit_ff <= 1'b0;
    end
  end

endmodule

`default_nettype wire

