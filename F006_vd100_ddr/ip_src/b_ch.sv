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


module b_ch
  import mem_agent_types::*;
#(
    parameter DATA_WIDTH = AXI_MASTER_DATA_WIDTH
)(
  // Reset, Clock
    input  wire         clk
  , input  wire         rst_n
  , output logic        b_bit_out
  , if_axi4_master.b_ch maxi_b
);

  logic b_bit_nxt, b_bit_ff;
  always_comb begin
    b_bit_out           = b_bit_ff;
    b_bit_nxt           = ^{maxi_b.M_AXI_BID, maxi_b.M_AXI_BRESP, maxi_b.M_AXI_BUSER, maxi_b.M_AXI_BVALID};
    maxi_b.M_AXI_BREADY = 1'b1;
  end

  always @(posedge clk) begin
    b_bit_ff   <= b_bit_nxt;
    if (!rst_n) begin
      b_bit_ff <= 1'b0;
    end
  end

endmodule

`default_nettype wire

