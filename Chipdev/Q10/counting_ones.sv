module model #(parameter
  DATA_WIDTH = 16
) (
  input [DATA_WIDTH-1:0] din,
  output logic [$clog2(DATA_WIDTH):0] dout
);

integer i;

always_comb begin
  dout = 0;
  for(i=0;i<DATA_WIDTH;i=i+1) begin
    dout = dout + din[i];
  end
end

endmodule
