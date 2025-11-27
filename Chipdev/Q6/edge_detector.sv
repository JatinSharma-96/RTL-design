module model (
  input clk,
  input resetn,
  input din,
  output dout
);

logic already1,out;

always_ff@(posedge clk) begin
  if(~resetn) begin 
    out <= 0;
    already1 <= 0;
  end
  else begin
    out <= din & ~already1 ? 1'b1 : 1'b0;
    already1 <= din;
  end
end

assign dout = out;

endmodule
