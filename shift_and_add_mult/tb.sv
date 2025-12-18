module tb();
  
  parameter BW = 4;
  
  parameter CYCLE = 10;
  
  logic[BW-1:0] multiplier,multiplicand;
  logic[1:0] opcode;  
  logic[2*BW-1:0] result;
  logic clk,resetn,ready;
  
  shift_add_mult #(.BW(BW)) M0(.multiplier(multiplier),.multiplicand(multiplicand),.opcode(opcode),.clk(clk),.resetn(resetn),.result(result),.ready(ready));
  
  initial begin
    clk = 0;
    forever begin
      #(CYCLE/2) clk = 1'b1;
      #(CYCLE/2) clk = 1'b0;
    end
  end
  
  initial begin
    opcode = 0;
    resetn = 0;
    multiplier = 0;
    multiplicand = 0;
    @(posedge clk);
    #1;
    resetn = 1;
    @(posedge clk);
    #1;
    opcode = 2'b01;
    multiplier = 7;
    multiplicand = 6;
    @(posedge clk);
    #1;
    opcode = 0;
    repeat(5) @(posedge clk);
    #1;
    multiplier = 9;
    multiplicand = 10;
    opcode = 2'b01;
    @(posedge clk);
    #1;
    opcode = 0;
    repeat(10) @(posedge clk);
    $finish;
  end
  
  initial begin
    $dumpfile("tb.vcd");
    $dumpvars(0,tb);
  end
  
endmodule
