// Code your testbench here
// or browse Examples
module tb();
  
  logic PSEL,PENABLE,PWRITE,clk,rstn,PREADY;
  logic[31:0] PWDATA,PRDATA;
  logic[3:0] PADDR;
  
  counter_apb_slave C0(.PSEL(PSEL),.PENABLE(PENABLE),.PWRITE(PWRITE),.clk(clk),.rstn(rstn),.PWDATA(PWDATA),.PADDR(PADDR),.PRDATA(PRDATA),.PREADY(PREADY));
  
  integer i;
  
  initial begin
    clk = 0;
    forever begin
      #5 clk = 1;
      #5 clk = 0;
    end
  end
  
  initial begin
    rstn = 0;
    PSEL = 0;
    PENABLE = 0;
    PWRITE = 0;
    PWDATA = 0;
    #10 rstn = 1;
    @(posedge clk);
    @(posedge clk);
    #1;
    PSEL = 1;
    PADDR = 2;
    PWRITE = 1;
    PWDATA = 1;
    @(posedge clk);
    #1;
    PENABLE = 1;
    for(i=0;i<20;i=i+1) begin
      @(posedge clk);
      #1;
      PENABLE = 0;
    end
    PADDR = 3;
    PWRITE = 0;
    @(posedge clk);
    PENABLE = 1;
    @(posedge clk);
    PENABLE = 0;
    #40 $finish;
  end
  
  initial begin
    $dumpfile("tb.vcd");
    $dumpvars(0,tb);
  end
  
  
endmodule
