module model (
  input clk,
  input resetn,
  input din,
  output logic dout
);

typedef enum logic[1:0] {INIT,ZERO,ONE,TWO} st;
st PS,NS;

always_ff@(posedge clk) begin
  if(~resetn) PS <= INIT;
  else PS <= NS;
end

always_comb begin
  case(PS)
  INIT : NS = din ? ONE : ZERO;
  ZERO : NS = din ? ONE : ZERO;
  ONE : NS = din ? ZERO : TWO;
  TWO : NS = din ? TWO : ONE;
  default : NS = ZERO;
  endcase
end

assign dout = (PS == ZERO);

endmodule
