`timescale 1 ps / 1 ps
`default_nettype none

module fr_cnt #(
    parameter DATA_WIDTH = 32
)(
    input  wire                   clk
  , input  wire                   rst_n
  , input  wire                   en_in
  , output logic [DATA_WIDTH-1:0] cnt_out
);


always_ff @(posedge clk) begin
  if (en_in) begin
    cnt_out <= cnt_out + 1;
  end else begin
    cnt_out <= cnt_out;
  end

  if (~rst_n) begin
    cnt_out <= '0;
  end
end


endmodule

`default_nettype wire

