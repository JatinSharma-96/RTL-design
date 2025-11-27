module model #(parameter
  DIV_LOG2=3,
  OUT_WIDTH=32,
  IN_WIDTH=OUT_WIDTH+DIV_LOG2
) (
  input [IN_WIDTH-1:0] din,
  output logic [OUT_WIDTH-1:0] dout
);

logic[DIV_LOG2-1:0] val;
logic[IN_WIDTH-1-DIV_LOG2:0] temp;
logic[OUT_WIDTH-1:0] temp2;

assign val = 1<<(DIV_LOG2-1);
assign temp = din[IN_WIDTH-1:DIV_LOG2];
assign check = din[DIV_LOG2-1];

assign {cout,temp2} = temp + check;
assign dout = cout ? temp : temp2;

endmodule
