// Code your testbench here
// or browse Examples
module tb();
  logic pclk1,pclk2,presetn1,presetn2,PSELS,PENABLES,PREADYM,PSELM,PENABLEM,PREADYS,PWRITES,PWRITEM;
  
  logic[31:0] PADDRS,PADDRM,PWDATAS,PWDATAM,PRDATAS,PRDATAM;
  
  apb_async_bridge A0(.pclk1(pclk1),.pclk2(pclk2),.presetn1(presetn1),.presetn2(presetn2),.PSELS(PSELS),.PENABLES(PENABLES),.PREADYM(PREADYM),.PREADYS(PREADYS),.PSELM(PSELM),.PENABLEM(PENABLEM),.PWDATAS(PWDATAS),.PWDATAM(PWDATAM),.PWRITES(PWRITES),.PWRITEM(PWRITEM),.PADDRS(PADDRS),.PADDRM(PADDRM),.PRDATAS(PRDATAS),.PRDATAM(PRDATAM));
  
  parameter CLK1 = 20, CLK2 = 10;
  
  
   initial
    begin
      pclk1 = 0;
      //#(CLK2/2) pclk1 = 1;
      forever
        begin
          #(CLK1/2) pclk1 = 1;
          #(CLK1/2) pclk1 = 0;
        end
    end
  
  initial
    begin
      pclk2 = 0;
      forever
        begin
          #(CLK2/2) pclk2 = 1;
          #(CLK2/2) pclk2 = 0;
        end
    end
  
  initial begin
    presetn1 = 0;
    presetn2 = 0;
    PSELS = 0;
    PENABLES = 0;
    PREADYM = 1;
    PWRITES = 0;
    PRDATAM = 32'h40;
    PADDRS = 32'h01;
    PWDATAS = 32'h00;
    #CLK2 presetn2 = 1;
    #CLK2 presetn1 = 1;
    #CLK2 PSELS = 1;
    #CLK1 PENABLES = 1;
    
    repeat(10) @(posedge pclk1);
    $finish;
  end
  
  initial begin
    $dumpfile("tb.vcd");
    $dumpvars(0,tb);
  end
  
 
  
  
endmodule
