module fr_cnt(
    input             clk
  , input             rst_n
  , input             en
  , output reg [31:0] cnt
);


always @(posedge clk) begin
  if (en) begin
    cnt <= cnt + 1;
  end else begin
    cnt <= cnt;
  end

  if (~rst_n) begin
    cnt <= 0;
  end
end


endmodule


