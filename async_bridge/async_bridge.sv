// Code your design here
module apb_async_bridge (input pclk1,pclk2,presetn1,presetn2,
                        input PSELS,PENABLES,PREADYM,PWRITES,
                         input[31:0] PWDATAS,PRDATAM,
                         input[31:0] PADDRS,
                         output reg[31:0] PRDATAS,PWDATAM,
                         output[31:0] PADDRM,
                        output reg PREADYS,PSELM,PENABLEM,PWRITEM);
  
  localparam IDLE = 2'b00, SEL = 2'b01, ENABLE = 2'b10, COMPLETE = 2'b11;
  
  logic[1:0] s2m_st,nxt_s2m_st,m2s_st,nxt_m2s_st;
  logic[2:0] complete_sync_mst,request_sync_mst,request_sync_mst_fp,request_sync_mst_rp,complete_sync_mst_rp;
  logic request, complete;
  logic[31:0] PRDATA_nxt;
  
  always_ff@(posedge pclk1 or negedge presetn1) begin
    if(~presetn1)
      s2m_st <= 0;
    else begin
      s2m_st <= nxt_s2m_st;
  end
  end
  
  always_ff@(posedge pclk1 or negedge presetn1) begin
    if(~presetn1) complete_sync_mst <= 0;
    else complete_sync_mst <= {complete_sync_mst[1:0],complete};
  end
  
  assign complete_sync_mst_rp = ~complete_sync_mst[2] & complete_sync_mst[1];
  assign complete_sync_mst_fp = complete_sync_mst[2] & ~complete_sync_mst[1];
    
  always_comb begin       //slave to master
      PREADYS = 1'b1;
      request = 1'b0;
      case(s2m_st)
        IDLE : nxt_s2m_st = PSELS ? SEL : IDLE;
        SEL : begin 
          nxt_s2m_st = ENABLE;
          PREADYS = 1'b0;
        end
        ENABLE : begin
          request = 1'b1;
          nxt_s2m_st = complete_sync_mst_rp ? COMPLETE : ENABLE;
          PREADYS = 1'b0;
        end
        COMPLETE :  begin
          request = 1'b0;
          PREADYS = complete_sync_mst_fp;
          nxt_s2m_st = complete_sync_mst_fp ? IDLE : COMPLETE;
          end
      endcase
    end
  
  
  always_ff@(posedge pclk2 or negedge presetn2) begin
    if(~presetn2) request_sync_mst <= 0;
    else request_sync_mst <= {request_sync_mst[1:0],request};
  end
  
  assign request_sync_mst_rp = ~request_sync_mst[2] & request_sync_mst[1];
  assign request_sync_mst_fp = request_sync_mst[2] & ~request_sync_mst[1];
  
    
    always_ff@(posedge pclk2 or negedge presetn2) begin
      if(~presetn2) begin
        PRDATAS <= 0;
      m2s_st <= 0;
      end
    else begin
      m2s_st <= nxt_m2s_st;
      PRDATAS <= PRDATA_nxt;
    end
    end
      
     
      
    always_comb begin       //master to slave
      PSELM = 0;
      PENABLEM = 0;
      complete = 0;
      PRDATA_nxt = PRDATAS;
      case(m2s_st)
        IDLE : nxt_m2s_st = request_sync_mst_rp ? SEL : IDLE;
        SEL : begin 
          nxt_m2s_st = ENABLE;
          PSELM = 1;
        end
        ENABLE : begin
          PSELM = 1;
          PENABLEM = 1;
          nxt_m2s_st = PREADYM ? COMPLETE : ENABLE;
        end
        COMPLETE :  begin
          complete = 1;
          PSELM = 0;
          PENABLEM = 0;
          nxt_m2s_st = request_sync_mst_fp ? IDLE : COMPLETE ;
          PRDATA_nxt = request_sync_mst_fp & ~PWRITEM ? PRDATAM : PRDATAS ;
          end
      endcase
    end
      
  assign PWDATAM = PWDATAS;
  assign PWRITEM = PWRITES;
  assign PADDRM = PADDRS;
  
  
endmodule
