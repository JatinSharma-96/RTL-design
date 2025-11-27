module model #(parameter
  DATA_WIDTH = 32
) (
  input  [DATA_WIDTH-1:0] din,
  output logic [$clog2(DATA_WIDTH):0] dout
);

integer i,idx;
logic gs;

always_comb begin
  gs = 0;
  for(i=DATA_WIDTH-1;i>=0;i=i-1) begin
    if(din[i]==1) begin
      idx = i;
      gs = 1;
    end
  end
end

assign dout = gs ? idx : DATA_WIDTH;

endmodule
