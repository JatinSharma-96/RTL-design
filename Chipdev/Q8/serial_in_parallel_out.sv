module model #(parameter
  DATA_WIDTH = 16
) (
  input clk,
  input resetn,
  input din,
  output logic [DATA_WIDTH-1:0] dout
);

generate
  if(DATA_WIDTH > 1) begin
always_ff@(posedge clk) begin
  if(~resetn) dout <= 0;
  else dout <= {dout[DATA_WIDTH-2:0],din};
end
  end
  else begin
    always_ff@(posedge clk) begin
  if(~resetn) dout <= 0;
  else dout <= din;
end
  end
endgenerate
endmodule
