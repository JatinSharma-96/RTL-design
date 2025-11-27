module model #(parameter
  DATA_WIDTH = 32
) (
  input  [DATA_WIDTH-1:0] din,
  output logic onehot
);

logic [DATA_WIDTH-1:0] sum;
integer i;

always_comb begin
  sum = 0;
  for(i=0;i<DATA_WIDTH;i=i+1) sum = sum + din[i];
end

assign onehot = (sum == 1);

endmodule
