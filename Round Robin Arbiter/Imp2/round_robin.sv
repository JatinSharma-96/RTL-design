// Code your design here
module round_robin_arbiter #(parameter N=4) (input clk,rstn,
                                             input [N-1:0] req,
                                             output logic[N-1:0] grant,
                                             output logic grant_valid);
  
  logic[N-1:0] req_rot[N-1:0],int_grant[N-1:0],idx[N-1:0];
  logic[2*N-1:0] int_grant_shift;
  integer i,l;
  logic[$clog2(N)-1:0] ptr;
  
  genvar k;
  
  assign req_double = {req,req};
  
  always_comb begin
    for(i=0;i<N;i=i+1) begin
      if(i==0)
        req_rot[i] = req;
      else
        req_rot[i] = {req_rot[i-1][0],req_rot[i-1][N-1:1]};
    end
  end
  
  
  generate
    for(k=0;k<N;k=k+1) begin
      simple_arbiter SA (.req(req_rot[k]),.grant(int_grant[k]),.idx(idx[k]));
    end
  endgenerate
  
  assign int_grant_shift = {int_grant[ptr],int_grant[ptr]} << ptr;
  assign grant = int_grant_shift[2*N-1:N];
  
  always_ff@(posedge clk or negedge rstn) begin
    if(~rstn)
      ptr <= 0;
    else
      ptr <= |req ? (idx[ptr]+ptr+1)%N : ptr;
  end
  
endmodule
  
module simple_arbiter #(parameter N=4) (input[N-1:0] req,
                      output logic[N-1:0] grant,
                      output logic[N-1:0] idx);
  
  integer j;
  logic gs;
  always_comb begin
    gs = 0;
    grant = 0;
    idx = 0;
    for(j=N-1;j>=0;j=j-1) begin
      if(req[j] == 1'b1) begin
        idx = j;
        gs = 1;
      end
    end
    grant[idx] = gs;
  end
  
endmodule
