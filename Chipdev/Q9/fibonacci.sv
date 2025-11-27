module model #(parameter
  DATA_WIDTH=32
) (
  input clk,
  input resetn,
  output logic [DATA_WIDTH-1:0] out
);


logic[DATA_WIDTH-1:0] int_reg;

always_ff@(posedge clk) begin
  if(~resetn) begin
    out <= 1;
    int_reg <= 1;
  end
  else begin
    out <= int_reg;
    int_reg <= out + int_reg;
  end
end


endmodule
