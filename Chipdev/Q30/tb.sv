// Code your testbench here
// or browse Examples
module tb;
  logic[7:0] codeIn;
  logic isThermometer;
  
  model M(.codeIn(codeIn),.isThermometer(isThermometer));
  
  initial begin
    codeIn = 8'h1;
    #5;
    codeIn = 8'h3;
    #5;
    codeIn = 8'h7;
    #5;
    codeIn = 8'h9;
    #5;
    codeIn = 8'h1f;
    #5;
    codeIn = 8'hff;
    #5;
    codeIn = 8'h3f;
    #5;
    codeIn = 8'h7f;
    #5;
    codeIn = 8'h0;
    #5;
    $finish;
  end
  
  initial begin
    $monitor($time,"	codeIn=%b	isThermometer=%b",codeIn,isThermometer);
  end
  
endmodule
