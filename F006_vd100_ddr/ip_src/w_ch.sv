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
  , if_axi4_master.w_ch maxi_w
);

  logic [DATA_WIDTH-1:0] wdata_nxt, wdata_ff;

  always_comb begin
    maxi_w.M_AXI_WDATA = wdata_ff;
    maxi_w.M_AXI_WSTRB = '1;
    maxi_w.M_AXI_WLAST = 1'b1;
    maxi_w.M_AXI_WUSER = '0;
    maxi_w.M_AXI_WVALID = 1'b1;

    if (maxi_w.M_AXI_WVALID && maxi_w.M_AXI_WREADY) begin
      wdata_nxt = wdata_ff + 1;
    end else begin
      wdata_nxt = wdata_ff;
    end
  end

  always @(posedge clk) begin
    wdata_ff   <= wdata_nxt;
    if (!rst_n) begin
      wdata_ff <= 0;
    end
  end

endmodule

`default_nettype wire

