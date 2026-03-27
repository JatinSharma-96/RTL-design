// Code your testbench here
// or browse Examples
module tb();
  
  reg[7:0] in;
  wire[11:0] result;
  
  ecc_encoder E(.in_data(in),.out_data(result));
  
  initial begin
    in = 8'b11010011;
  end
  
  initial begin
    $monitor($time,"   in = %b  out = %b",in,result);
  end
  
endmodule
