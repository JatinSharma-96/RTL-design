module model (
  input clk,
  input resetn,
  input [4:0] init,
  input din,
  output logic seen
);

logic[4:0] shift_reg,hold_reg,len;
logic flag;

always_ff@(posedge clk) begin
  if(~resetn) begin 
  shift_reg <= 0;
  hold_reg <= 1;
  flag <= 0;
  len <= 0;
  end
  else if(flag == 0) begin 
    hold_reg <= init;
    flag <= 1;
    shift_reg <= {shift_reg[3:0],din};
    len <= len+1;
  end
  else if(len != 5) begin 
    shift_reg <= {shift_reg[3:0],din};
    len <= len+1;
  end
  else if(len == 5) begin 
    shift_reg <= {shift_reg[3:0],din};
  end
end

assign seen = (shift_reg == hold_reg) && (len == 5);

endmodule
