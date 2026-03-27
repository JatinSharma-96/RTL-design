// Code your design here
module ecc_encoder (input[7:0] in_data,
                       output[11:0] out_data);
  
  wire [11:0] temp;
  wire [3:0] ecc_bits, ecc_result;
  wire[3:0] temp1 [12];
  wire[11:0] temp2[4];

  assign ecc_bits = 4'b0;
  
  assign temp = {in_data[7:4],ecc_bits[3],in_data[3:1],ecc_bits[2],in_data[0],ecc_bits[1:0]};
  
  genvar i,j,k;
  generate
    for(i=0;i<12;i=i+1) begin
      assign temp1[i] = temp[i] ? (i+1) : 0;
    end
    for(j=0;j<12;j=j+1) begin
      for(k=0;k<4;k=k+1) begin
      assign  temp2[k][j] = temp1[j][k];
      end
    end
  endgenerate
  
  assign ecc_result[3] = ^temp2[3];
  assign ecc_result[2] = ^temp2[2];
  assign ecc_result[1] = ^temp2[1];
  assign ecc_result[0] = ^temp2[0];
  
  assign out_data = {ecc_result,in_data} ;
  
endmodule
