// Code your testbench here
// or browse Examples
module tb;
  logic bstream,clk,rst,sync;
  logic[7:0] data;
  logic[4:0] timeslot_num;
  
  serial_to_parallel SP(.bstream(bstream),.sync(sync),.clk(clk),.rst(rst),.data(data),.timeslot_num(timeslot_num));
  
  always #5 clk = ~clk;
  
  integer i;
  
  initial begin
    sync = 0;
    bstream = 0;
    clk = 0;
    rst = 0;
    #10 rst = 1;
    #10 bstream = 1;
    for(i=0;i<512;i=i+1) begin
      @(posedge clk);
      if(i==0) sync = 1;
      else sync = 0;
      bstream = $urandom_range(0, 1);
    end
    #10 $finish;
  end
  
  initial begin
    $dumpfile("tb.vcd");
    $dumpvars(0,tb);
  end
  
endmodule
