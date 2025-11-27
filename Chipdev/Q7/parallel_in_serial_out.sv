module model #(parameter
  DATA_WIDTH = 16
) (
  input clk,
  input resetn,
  input [DATA_WIDTH-1:0] din,
  input din_en,
  output logic dout
);

logic[DATA_WIDTH-1:0] hold_reg;
logic[$clog2(DATA_WIDTH)-1:0] count;

generate 
  if(DATA_WIDTH > 1) begin
always_ff@(posedge clk)
begin
  if(~resetn) begin 
    hold_reg <= 0;
    count <= 0;
  end
  else begin
    if(din_en) begin
      hold_reg <= din;
      count <= 0;
    end
    else if((count+1'b1) != 0) begin
      hold_reg <= {1'b0,hold_reg[DATA_WIDTH-1:1]};
      count <= count + 1;
    end
  end
end
  end
  else begin
    always_ff@(posedge clk) begin
  if(~resetn) begin 
    hold_reg <= 0;
  end
  else begin
    if(din_en) hold_reg <= din;
    else hold_reg <= 1'b0;
  end
end
  end
endgenerate

assign dout = hold_reg[0];

endmodule
