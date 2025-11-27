// Code your testbench here
// or browse Examples
module tb();
  logic[7:0] wdata,rdata;
  logic wr_en,rd_en,rst,clk,full,empty;
  
  sync_fifo F(.wdata(wdata),.wr_en(wr_en),.rd_en(rd_en),.rst(rst),.clk(clk),.rdata(rdata),.full(full),.empty(empty));
  
  integer j=0;
  
  always #5 clk = ~clk;
  
  initial begin
    clk = 0;
    rst = 0;
    wr_en = 0;
    rd_en = 0;
    wdata = 8'b0;
    #10 rst = 1;
    for(j=0;j<32;j=j+1) begin
      @(negedge clk);
      wr_en = 1;
      wdata = j;
    end
    @(negedge clk);
    for(j=0;j<32;j=j+1) begin
      @(negedge clk);
      rd_en = 1;
      wr_en = 1;
      wdata = j+4;
    end
    #100 $finish;
  end

 initial begin
   $dumpfile("tb.vcd");
   $dumpvars(0,tb);
 end
  
endmodule
  
