// Code your design here
module round_robin_arbiter #(parameter N=4) (input clk,rstn,
                                             input [N-1:0] req,
                                             output logic[N-1:0] grant,
                                             output logic grant_valid);
  
  logic[$clog2(N)-1:0] ptr,ptr_nxt,idx;
  logic[N-1:0] req_shifted,upt_grant;
  logic[2*N-1:0] req_shifted_double,grant_shifted;
  logic gs;
  integer i;
  
  genvar j,k;
  
  always_comb begin //simple arbiter
    gs = 0;
    idx = 0;
    upt_grant = 0;
    for(i=N-1;i>=0;i=i-1) begin
      if(req_shifted[i]) begin
        idx = i;
        gs = 1;
      end
    end
    upt_grant[idx] = gs;
  end
  
  assign req_shifted_double = {req,req} >> ptr;
  assign req_shifted = req_shifted_double[N-1:0];
  assign grant_shifted = {upt_grant,upt_grant} << ptr;
  assign grant = grant_shifted[2*N-1:N];
  
  assign grant_valid = |grant;
  
  always_ff@(posedge clk or negedge rstn) begin
    if(~rstn)
      ptr <= 0;
    else
      ptr <= ptr_nxt;
  end
  
  always_comb begin
    ptr_nxt = gs ? (idx+1+ptr)%N : ptr;   //idx value is decremented by ptr due to rotate, so need to increment it by ptr to get the next pointer value
  end
 
endmodule
