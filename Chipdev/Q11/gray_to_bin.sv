module model #(parameter
  DATA_WIDTH = 16
) (
  input [DATA_WIDTH-1:0] gray,
  output logic [DATA_WIDTH-1:0] bin
);

integer i;

always_comb begin
  for(i=DATA_WIDTH-1;i>=0;i=i-1) begin
    if(i == DATA_WIDTH-1) bin[i] = gray[i];
    else bin[i] = gray[i]^bin[i+1];
  end
end

endmodule
