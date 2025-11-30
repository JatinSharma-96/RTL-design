// Code your testbench here
// or browse Examples
module tb();
  
  logic pclk,presetn,psels,penables,pwrites,pselm,penablem,pwritem,preadys,preadym;
  logic[7:0] paddrs,paddrm;
  logic[31:0] pwdatas,prdatas;
  logic[15:0] pwdatam,prdatam;
  
  
  apb_downsizer A(.PCLK(pclk),.PRESETn(presetn),.PSELs(psels),.PENABLEs(penables),.PWRITEs(pwrites),.PADDRs(paddrs),.PWDATAs(pwdatas),.PRDATAs(prdatas),.PREADYs(preadys),.PSELm(pselm),.PENABLEm(penablem),.PWRITEm(pwritem),.PADDRm(paddrm),.PWDATAm(pwdatam),.PRDATAm(prdatam),.PREADYm(preadym));
  
  
  integer i;
  
  initial begin
    pclk = 0;
    forever begin
      #5 pclk = 1;
      #5 pclk = 0;
    end
  end
  
  initial begin
    presetn = 1'b0;
    pwdatas = 0;
    psels = 0;penables = 0;pwrites = 0;
    prdatam = 16'h0000;
    preadym = 1'b1;
    
    @(posedge pclk);
    #1 presetn = 1'b1;
    @(posedge pclk);
    #1;
    psels = 1'b1;
    pwrites = 1'b1;
    pwdatas = 32'h1234_5678;
    paddrs = 8'b01000100;
    @(posedge pclk);
    #1;
    penables = 1'b1;
    repeat(3) begin
      @(posedge pclk);
    end
    #1;
    penables = 0;
    @(posedge pclk);
    #1;
    pwrites = 0;paddrs = 8'b01001000;prdatam = 16'habcd;
    @(posedge pclk);#1;
    penables = 1;
    @(posedge pclk);
    #1;
    prdatam = 16'h1234;
    repeat(4) begin
      @(posedge pclk);
    end
    #1;penables = 0;
    #1 $finish;
  end
  
  initial begin
    $dumpfile("tb.vcd");
    $dumpvars(0,tb);
  end
  
endmodule
