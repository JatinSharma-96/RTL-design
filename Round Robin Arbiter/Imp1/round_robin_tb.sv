// Code your testbench here
// or browse Examples
module tb();
  parameter N=4;
  
  logic clk,rstn;
  logic[N-1:0] req,grant;
  logic grant_valid;
  
  round_robin_arbiter #(.N(N)) R(.clk(clk),.rstn(rstn),.req(req),.grant(grant),.grant_valid(grant_valid));
  
  parameter cycle = 10;
  
  initial
    begin
      clk = 0;
      forever
        begin
          #(cycle/2) clk = 1;
          #(cycle/2) clk = 0;
        end
    end
  
  initial begin
    rstn = 0;
    #10 rstn= 1;
    #6 req = 4'b0010;
    #10 req = 4'b0001;
    #10 req = 4'b1100;
    #40 req = 4'b0011;
    #50 $finish;    
  end
  
  initial begin
    $dumpfile("tb.vcd");
    $dumpvars(0,tb);
  end
  
endmodule
