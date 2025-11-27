module model #(parameter
  DATA_WIDTH = 32
) (
  input clk,
  input resetn,
  input [DATA_WIDTH-1:0] din,
  output logic [DATA_WIDTH-1:0] dout
);

logic[DATA_WIDTH-1:0] largest,nxt_largest,nxt_dout;

always_ff@(posedge clk) begin
  if(~resetn) begin
    dout <= 0;
    largest <= 0;
  end
  else begin
    dout <= nxt_dout;
    largest <= nxt_largest;
  end
end

always_comb begin
  if(largest == 0) nxt_largest = din;
  else if(din > largest) nxt_largest = din;
  else nxt_largest = largest;

  if(largest == 0) nxt_dout = 0;
  else if(din <= dout) nxt_dout = dout;
  else if(din <= largest) nxt_dout = din;
  else nxt_dout = largest; 
end

endmodule
