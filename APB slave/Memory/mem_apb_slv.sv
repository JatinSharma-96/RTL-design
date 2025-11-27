// Code your design here
module mem_apb_slave(input PSEL,PENABLE,PWRITE,clk,rstn,
                     input[7:0] PWDATA,
                     input[3:0] PADDR,
                     output logic[7:0] PRDATA,
                     output logic PREADY);
  
  logic[1:0] st,nxt_st;
  parameter SETUP=2'b00, ACCESS=2'b01, WAIT=2'b10;
  logic wr_en,rd_en;
  
  always_ff@(posedge clk or negedge rstn) begin
    if(~rstn)
      st <= SETUP;
    else
      st <= nxt_st;
  end
  
  always_comb begin
    case(st)
      SETUP : begin
        nxt_st = PSEL ? ACCESS : SETUP;
        wr_en = 0;
        rd_en = 0;
        PREADY = PWRITE;
      end
      ACCESS : begin
        nxt_st = PWRITE ? SETUP : WAIT;
        wr_en = PWRITE;
        rd_en = ~PWRITE;
        PREADY = PWRITE;
      end
      WAIT : begin
        nxt_st = SETUP;
        rd_en = 0;
        wr_en = 0;
        PREADY = 1;
      end
      default : begin
        nxt_st = SETUP;
        rd_en = 0;
        wr_en = 0;
        PREADY = 1;     
      end
    endcase
  end
  
  logic[7:0] rdata;
  
  mem_16x8 S0(.addr(PADDR),.wdata(PWDATA),.clk(clk),.rstn(rstn),.rdata(PRDATA),.wr_en(wr_en),.rd_en(rd_en));
  
endmodule

module mem_16x8(input logic[7:0] wdata,
                input logic clk,rstn,wr_en,rd_en,
                input[3:0] addr,
                output logic[7:0] rdata);    //16x8 synchronous emory
  
  
  logic[7:0] mem[15:0];
  integer i;
  
  always_ff@(posedge clk or negedge rstn) begin
    if(~rstn) begin
      for(i=0;i<16;i=i+1) begin
        mem[i] <= 0;
      end
        rdata <= 0;
    end
    else begin
      if(wr_en)
        mem[addr] <= wdata;
      else if(rd_en) begin
        rdata <= mem[addr];
      end      
      end
  end
  
endmodule
                     
