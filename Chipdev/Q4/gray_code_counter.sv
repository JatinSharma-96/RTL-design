module model #(parameter
  DATA_WIDTH = 4
) (
  input clk,
  input resetn,
  output logic [DATA_WIDTH-1:0] out
);
integer i;
logic[DATA_WIDTH-1:0] gray2bin,gray_nxt,bin_1;

assign bin_1 = gray2bin + 1'b1;

always_comb begin
  for(i=DATA_WIDTH-1;i>=0;i=i-1) begin
    if(i==DATA_WIDTH-1) gray2bin[i] = out[i];
    else gray2bin[i] = gray2bin[i+1]^out[i];
  end
end

assign gray_nxt = bin_1 ^ {1'b0,bin_1>>1};

always_ff@(posedge clk) begin
  if(~resetn) out  = 0;
  else out <= gray_nxt;
end

endmodule
