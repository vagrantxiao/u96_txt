module xdff #(
    parameter WIDTH = 32
)(
    input                  clk
  , input                  rst_n
  , input      [WIDTH-1:0] din
  , output reg [WIDTH-1:0] dout
);

  always @(posedge clk) begin
    dout <= din;
    if (~rst_n) begin
      dout <= 0;
    end
  end

endmodule



