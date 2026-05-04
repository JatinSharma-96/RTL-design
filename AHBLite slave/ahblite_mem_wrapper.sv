// Code your design here
module ahblite_mem_wrapper (input[31:0] haddr,
                            input[63:0] hwdata,
                        output reg[63:0] hrdata,
                        input hsel,hready,hwrite,
                            input[2:0] hburst,
                            input[2:0] hsize,
                            input[1:0] htrans,
                        output reg hreadyout,
                            output reg hresp,
                           input hclk,
                           input hresetn);
  
  logic sel_addr,wr_en,rd_en,sel_rdata,hwrite_reg,nxt_hwrite,raw,misalign;
  
  logic[31:0] addr, addr_reg,nxt_addr_reg;
  logic[63:0] mem_rdata,mask;
  logic[2:0] hsize_reg;
  
  assign addr = addr_reg;
  assign raw = hwrite_reg & ~hwrite;


  
  localparam ID=2'b00, RUN=2'b01, WAIT=2'b10, ERR = 2'b11;
 
  localparam IDLE = 2'b00 , BUSY = 2'b01 , NONSEQ = 2'b10, SEQ = 2'b11;
  localparam _byte_=3'b000 , _half_ = 3'b001, _word_ = 3'b010 , _double_ = 3'b011;
  
  assign slave_sel = htrans[1] & hsel & hready;
  
  
  logic[1:0] st,nxt_st;
  
  always_ff@(posedge hclk or negedge hresetn) begin
    if(~hresetn) begin
      st <= 0;
      addr_reg <= 0;
      hwrite_reg <= 0;
      hsize_reg <= 0;
    end
    else begin
      st <= nxt_st ;
      addr_reg <= nxt_addr_reg;
      hwrite_reg <= nxt_hwrite;
      hsize_reg <= hsize;
    end
  end
  
  always_comb begin
    misalign = 0;
    //nxt_addr = {haddr[31:2],3'b000};
    case(hsize[2:0])
      _byte_ : misalign = 0;
      _half_ : misalign = haddr[0] == 1'b0 ? 0 : 1;
      _word_ : misalign = haddr[1:0] == 2'b00 ? 0 : 1;
      _double_ : misalign = haddr[2:0] == 3'b000 ? 0 : 1;
      default : misalign = 1;
    endcase
  end
  
    always_comb begin
    //nxt_addr = {haddr[31:2],3'b000};
      case({hsize_reg[2:0],haddr[2:0]})
      6'b000000 : mask = 64'h00000000000000FF;
      6'b000001 : mask = 64'h000000000000FF00;
      6'b000010 : mask = 64'h0000000000FF0000;
      6'b000011 : mask = 64'h00000000FF000000;
      6'b000100 : mask = 64'h000000FF00000000;
      6'b000101 : mask = 64'h0000FF0000000000;
      6'b000110 : mask = 64'h00FF000000000000;
      6'b000111 : mask = 64'hFF00000000000000;
      6'b001000 : mask = 64'h000000000000FFFF;
      6'b001010 : mask = 64'h00000000FFFF0000;
      6'b001100 : mask = 64'h0000FFFF00000000;
      6'b001110 : mask = 64'hFFFF000000000000;
      6'b010000 : mask = 64'h00000000FFFFFFFF;
      6'b010100 : mask = 64'hFFFFFFFF00000000;
      6'b011000 : mask = 64'hFFFFFFFFFFFFFFFF;
      default : mask = 64'h0000000000000000;
    endcase
  end
  
  
  
  always_comb begin
    hreadyout = 1'b1;
    hresp = 1'b0;
    case(st)
      ID : begin
        nxt_st = slave_sel ? misalign ? ERR : RUN : ID;
        wr_en = 0;
        rd_en = slave_sel & ~hwrite;
        sel_rdata = 0;
        nxt_hwrite = hwrite;
      end
      RUN :  begin
        nxt_st = (misalign & ~raw) ? ERR : hready ? RUN : WAIT;
        wr_en = raw ? hwrite_reg : hready ? hwrite_reg : 0;
        rd_en = hready & ~hwrite & ~raw;
        sel_rdata = hready & ~hwrite_reg & ~raw;
        hreadyout = ~raw;  //consecutive read and write not supported, min. 1 cycle gap
        nxt_hwrite = hready ? hwrite : hwrite_reg;
      end
      WAIT : begin
        nxt_st = misalign ? ERR : hready ? RUN : WAIT;
        wr_en = 0;
        rd_en = ~hwrite & hready ;
        sel_rdata = ~hready;
        hreadyout = 1;
        nxt_hwrite = hwrite;
      end
      ERR : begin
        nxt_st = ID;
        wr_en = 0;
        rd_en = 0;
        sel_rdata = 0;
        nxt_hwrite = 0;
        hresp = 1'b1;
      end
      default : begin
        nxt_st = IDLE;
        wr_en = 0;
        rd_en = 0;
        sel_rdata = 0;
        nxt_hwrite = 0;
      end
    endcase
  end
  
   assign hrdata = sel_rdata ? mem_rdata : 64'bz;
  assign nxt_addr_reg = {haddr[31:3],3'b0};
  
   
  mem_1024x64 M0 (.clk(hclk),.rstn(hresetn),.wr_en(wr_en),.rd_en(rd_en),.addr(addr[12:0]),.rdata(mem_rdata),.wdata(hwdata),.bwen(mask));
  
endmodule

module mem_1024x64 (input logic clk,rstn,wr_en,rd_en,
                    input[12:0] addr,
                    output logic[63:0] rdata,
                    input logic[63:0] wdata,
                    input logic[63:0] bwen);    
  
  logic[63:0] mem[1023:0];
  logic[63:0] mem_wr_data;
  integer i;
  
  genvar k;
  generate
    for(k=0;k<64;k=k+1) begin
      assign mem_wr_data[k] = bwen[k] ? wdata[k] : mem[addr[12:3]][k];
    end
  endgenerate
  
  always_ff@(posedge clk or negedge rstn) begin
    if(~rstn) begin
      for(i=0;i<16;i=i+1) begin
        mem[i] <= 0;
      end
        rdata <= 0;
    end
    else begin
      if(wr_en)
        mem[addr[12:3]] <= mem_wr_data;
      else if(rd_en) begin
        rdata <= mem[addr[12:3]];
      end      
      end
  end
  
endmodule
  
