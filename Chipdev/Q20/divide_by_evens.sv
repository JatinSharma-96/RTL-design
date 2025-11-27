module model (
  input clk,
  input resetn,
  output logic div2,
  output logic div4,
  output logic div6
);

logic[2:0] count;
logic was1,flag;

always_ff@(posedge clk) begin
  if(~resetn) begin
    count <= 0;
    was1 <= 0;
    div6 <= 0;
    flag <= 0;
  end
  else if(count == 2) begin
    count <= 3'b111;
    div6 <= 1;
    was1 <= ~was1;
    flag <= 0;
  end
  else if(count == 5 || flag == 1) begin
    count <= count - 1;
    div6 <= 0;
    flag <= 1;
  end
  else begin
    count <= count - 1;
    div6 <= 1;
    flag <= 0;
  end
end

assign div2 = count[0];
assign div4 = was1 ? ~count[1] : count[1];

endmodule
