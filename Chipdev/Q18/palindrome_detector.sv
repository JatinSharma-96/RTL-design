module model #(parameter
  DATA_WIDTH=32
) (
  input [DATA_WIDTH-1:0] din,
  output logic dout
);

integer i;

always_comb begin
  dout = 1;
  for(i=0;i<DATA_WIDTH/2;i=i+1) begin
    if(din[i] != din[DATA_WIDTH-i-1]) begin
      dout = 0;
    end
  end
end

endmodule
