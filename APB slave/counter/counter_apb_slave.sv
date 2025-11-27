// Code your design here
module counter_apb_slave(input PSEL,PENABLE,PWRITE,clk,rstn,
                         input[31:0] PWDATA,
                         input[3:0] PADDR,
                         output logic[31:0] PRDATA,
                         output logic PREADY);
  
  logic[31:0] load_val,count;
  logic lda,ena;
  logic st,nxt_st;
  
  logic wr_en_00,wr_en_01,wr_en_02,rd_en_00,rd_en_01,rd_en_02,rd_en_03;
  parameter SETUP = 1'b0,ACCESS = 1'b1;
  
  always_ff@(posedge clk or negedge rstn) begin
    if(~rstn)
      st <= 0;
    else begin
      st <= nxt_st; 
    end
  end
  
  always_ff@(posedge clk or negedge rstn) begin
    if(~rstn) begin
      load_val <= 0;
      lda <= 0;
      ena <= 0;
      PRDATA <= 0;
    end
    else begin
      if(wr_en_00) load_val <= PWDATA;
      else if(wr_en_01) lda <= PWDATA[0];
      else if(wr_en_02) ena <= PWDATA[0];
      else if(rd_en_00) PRDATA <= load_val;
      else if(rd_en_01) PRDATA <= {31'b0,lda};
      else if(rd_en_02) PRDATA <= {31'b0,ena};
      else if(rd_en_03) PRDATA <= count;
    end
  end
  
  always_comb begin   //2 cycle for both read and write
    case(st)
      SETUP : begin
        nxt_st = PSEL ? ACCESS : SETUP;
        wr_en_00 = 1'b0;
        wr_en_01 = 1'b0;
        wr_en_02 = 1'b0;
        rd_en_00 = PSEL & ~PWRITE & (PADDR == 0);
        rd_en_01 = PSEL & ~PWRITE & (PADDR == 1);
        rd_en_02 = PSEL & ~PWRITE & (PADDR == 2);
        rd_en_03 = PSEL & ~PWRITE & (PADDR == 3);
        PREADY = PWRITE;
      end
      ACCESS : begin
        PREADY = 1'b1;
        nxt_st = PENABLE&PREADY ? SETUP : ACCESS;
        wr_en_00 = PENABLE & PWRITE & (PADDR == 0);
        wr_en_01 = PENABLE & PWRITE & (PADDR == 1);
        wr_en_02 = PENABLE & PWRITE & (PADDR == 2);
        rd_en_00 = 1'b0;
        rd_en_01 = 1'b0;
        rd_en_02 = 1'b0;
        rd_en_03 = 1'b0;
      end
    endcase
  end
  
  counter C(.clk(clk),.rstn(rstn),.ld(lda),.en(ena),.ld_val(load_val),.count(count));
  
  
endmodule

module counter(input clk,rstn,ld,en,
               input[31:0] ld_val,
               output logic[31:0] count);
  
  always_ff@(posedge clk or negedge rstn) begin
    if(~rstn)
      count <= 0;
    else begin
      if(ld) count <= ld_val;
      else if(en) count <= count + 1;
    end
  end
  
endmodule
