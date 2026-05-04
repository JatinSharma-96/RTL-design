// Code your testbench here
// or browse Examples
module tb;
  
  reg[31:0] haddr;
  reg[63:0] hwdata;
  wire[63:0] hrdata;
  reg hsel,hready,hwrite;
  reg[2:0] hburst,hsize;
  reg[1:0] htrans;
  wire hreadyout;
  wire hresp;
  reg hclk, hresetn;
  
  ahblite_mem_wrapper A0   (.haddr(haddr),.hwdata(hwdata),.hrdata(hrdata),.hsel(hsel),.hready(hreadyout),.hwrite(hwrite),.hburst(hburst),.hsize(hsize),.htrans(htrans),.hreadyout(hreadyout),.hresp(hresp),.hclk(hclk),.hresetn(hresetn));
  
  integer i;
  parameter CYCLE = 10;
  
  initial begin
    hclk = 0;
    forever begin
      #(CYCLE/2) hclk = 1'b1;
      #(CYCLE/2) hclk = 1'b0;
    end
  end

  initial begin
    htrans = 2'b00;
    hresetn = 0;
    hwrite = 0;
    hsize = 3'b011;
    @(posedge hclk);
    for(i=0;i<100;i=i+2) begin
      @(posedge hclk);
      #1;
      hresetn = 1;
    htrans = 2'b10;
    hsel = 1;
    hready = 1;
    haddr = i*8;
    hwrite = 1;
      hwdata = i*3;
      @(posedge hclk);
      #1;
     //ready = 0;
      hwdata = i*2;
      haddr = (i+1)*8;
      //hwrite = 0;
      //@(posedge hclk);
    end
    

    
  for(i=0;i<100;i=i+1) begin
    @(posedge hclk);
    #1;
  htrans = 2'b10;
  hsel = 1;
 hready = 1;
 haddr = i*8;
    hsize = 3;
  hwrite = 0;
        @(posedge hclk);
 end
    
    @(posedge hclk);
    #1;
    @(posedge hclk);
 // for(i=0;i<100;i=i+1) begin
 //   @(posedge hclk);
 // htrans = 2'b10;
//  hsel = 1;
 // hready = 1;
 // haddr = i;
//  hwrite = 0;
// end
 //(posedge hclk);
   //sel = 1;
    
    repeat (5) begin
      @(posedge hclk)
      hsel = 0;
    end
    $finish;
    
  end
  
  initial begin
    $dumpfile("tb.vcd");
    $dumpvars(0,tb);
  end
  
  
  
endmodule
