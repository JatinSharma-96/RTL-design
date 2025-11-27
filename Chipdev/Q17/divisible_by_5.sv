module model (
  input clk,
  input resetn,
  input din,
  output logic dout
);

typedef enum logic[2:0] {INIT,ZERO,ONE,TWO,THREE,FOUR} st;
st PS,NS;

always_ff@(posedge clk) begin
  if(~resetn) PS <= INIT;
  else PS <= NS;
end

always_comb begin
  case(PS)
  INIT : NS = din ? ONE : ZERO;
  ZERO : NS = din ? ONE : ZERO;
  ONE : NS = din ? THREE : TWO;
  TWO : NS = din ? ZERO : FOUR;
  THREE : NS = din ? TWO : ONE;
  FOUR : NS = din ? FOUR : THREE;
  default : NS = ZERO;
  endcase
end

assign dout = (PS == ZERO);

endmodule
