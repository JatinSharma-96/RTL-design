// Code your design here
module sync_fifo(input[7:0] wdata,
                 input wr_en,rd_en,rst,clk,
                 output logic[7:0] rdata,
                 output logic full,empty);
  
  typedef enum logic[1:0] {EMPTY,WRITE,READ,BOTH} st;
  st state,nxt_state;
  
  logic[7:0] mem[15:0];  
  logic[4:0] wr_ptr,rd_ptr;
  logic wincr,rincr;
  logic[3:0] wr_nxt;
  
  integer i;
  
  always_ff@(posedge clk) begin
    if(~rst) begin
      wr_ptr <= 4'b0;
      rd_ptr <= 4'b0;
      state <= EMPTY;
      for(i=0;i<16;i=i+1) begin
        mem[i] <= 8'b0;
      end
    end
    else begin
      wr_ptr <= wincr ? wr_ptr+1 : wr_ptr;
      rd_ptr <= rincr ? rd_ptr+1 : rd_ptr;
      state <= nxt_state;
      mem[wr_ptr[3:0]] <= full ? mem[wr_ptr[3:0]] : wr_en ? wdata : mem[wr_ptr] ;
    end
  end
  
  always_comb begin //Next state logic
    case(state)
      EMPTY : nxt_state = wr_en ? WRITE : EMPTY;
      WRITE : nxt_state = rd_en ? wr_en ? BOTH : READ : WRITE;
      READ : nxt_state = wr_en ? rd_en ? BOTH : WRITE : READ;
      BOTH : nxt_state = wr_en ? rd_en ? BOTH : WRITE : rd_en ? READ : BOTH;
      default : nxt_state = EMPTY;
    endcase
      end
  
  always_comb begin //Output Logic
    case(state)
      EMPTY : begin
        wincr = wr_en;
        rincr = 1'b0;
      end
      WRITE : begin
        wincr = full ? 1'b0 : wr_en;
        rincr = rd_en;
      end
      READ : begin
        wincr = wr_en;
        rincr = empty ? 1'b0 : rd_en;
      end
      BOTH : begin
        wincr = wr_en;
        rincr = rd_en;
      end
    endcase
  end
  
  //assign wr_nxt = (wr_ptr + 1'b1);
      
  assign rdata = empty ? 8'bz : mem[rd_ptr[3:0]];
  assign full = ({~wr_ptr[4],wr_ptr[3:0]} == rd_ptr) && !rd_en;
  assign empty = (rd_ptr == wr_ptr);
  
endmodule
