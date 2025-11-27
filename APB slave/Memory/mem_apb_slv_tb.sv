// Code your testbench here
// or browse Examples
module tb();
  
  logic psel,penable,pwrite,clk,rstn,pready;
  logic[7:0] pwdata,prdata;
  logic[3:0] paddr;
  
  integer j;
  
  mem_apb_slave M(.PSEL(psel),.PENABLE(penable),.PWRITE(pwrite),.clk(clk),.rstn(rstn),.PWDATA(pwdata),.PADDR(paddr),.PRDATA(prdata),.PREADY(pready));
  
  initial begin
  	clk = 0;
    forever begin
      #5 clk = 1;
      #5 clk = 0;
    end
  end
  
  initial begin
    rstn = 0;
    psel = 0;
    pwrite = 0;
    penable = 0;
    paddr = 0;
    @(posedge clk);
    @(negedge clk);
    rstn=1;
    for(j=0;j<16;j=j+1) begin
      @(posedge clk);
      #1;
      psel = 1;
      pwrite = 1;
      paddr = j;
      pwdata = j+6;
      @(posedge clk);
      penable = 1;
    end
    for(j=0;j<16;j=j+1) begin
      @(posedge clk);
      #1;
      psel = 1;
      pwrite = 0;
      paddr = j;
      @(posedge clk);
      penable = 1;
      @(posedge clk);
    end
    #50 $finish;
  end
  
  initial begin
    $dumpfile("tb.vcd");
    $dumpvars(0,tb);
  end
  
endmodule
