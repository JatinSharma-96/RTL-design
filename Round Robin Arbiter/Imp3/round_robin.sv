// Code your design here
module round_robin_arbiter #(parameter N=4) (input clk,rstn,
                                             input [N-1:0] req,
                                             output logic[N-1:0] grant,
                                             output logic grant_valid);
  
  logic[$clog2(N)-1:0] ptr,idx0,idx1,idx_n;
  logic[N-1:0] masked_req,mask,grant0,grant1;
  
  
  assign mask = {N{1'b1}} << ptr;
  assign masked_req = req & mask;
  
  simple_arbiter #(.N(N)) SA0(.req_in(masked_req),.req_out(grant0),.idx(idx0));
  simple_arbiter #(.N(N)) SA1(.req_in(req),.req_out(grant1),.idx(idx1));
  
  assign grant = (masked_req==0) ? grant1 : grant0;
  assign idx_n = (masked_req==0) ? idx1 : idx0;
  
  always_ff@(posedge clk or negedge rstn) begin
    if(~rstn) ptr <= 0;
    else begin
      ptr <= |req ? (idx_n+1)%N : ptr;
    end
  end
  
endmodule

module simple_arbiter #(parameter N=4) (input[N-1:0] req_in,
                      output logic[N-1:0] req_out,
                      output logic[$clog2(N)-1:0] idx);
  
  integer i;
  logic gs;
  
  always_comb begin
    gs = 0;
    req_out = 0;
    idx = 0;
    for(i=N-1;i>=0;i=i-1) begin
      if(req_in[i]==1'b1) begin
        gs = 1'b1;
        idx = i;
      end
    end
    req_out[idx] = gs;      
  end
  
endmodule
