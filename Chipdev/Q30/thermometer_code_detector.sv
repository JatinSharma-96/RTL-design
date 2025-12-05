module model #(parameter
    DATA_WIDTH = 8
) (
    input [DATA_WIDTH-1:0] codeIn,
    output reg isThermometer
);

logic[DATA_WIDTH-1:0] gray_codeIn;
logic[DATA_WIDTH-1:0] temp[DATA_WIDTH-1:0];

always_comb begin
    case(codeIn[DATA_WIDTH-1])
    1'b0 : gray_codeIn = codeIn ^ (codeIn>>1);
    1'b1 : gray_codeIn = ~codeIn ^ (~codeIn>>1);
    default : gray_codeIn = codeIn ^ (codeIn>>1);
    endcase
end

genvar i;
generate
    for(i=0;i<DATA_WIDTH;i=i+1) begin
        assign inv = ~gray_codeIn[i];
        if(i==0) begin
            assign temp[i] = {gray_codeIn[DATA_WIDTH-1:i+1],inv};
        end
        else if(i==DATA_WIDTH-1) begin
            assign temp[i] = {inv,gray_codeIn[i-1:0]};
        end
        else begin
            assign temp[i] = {gray_codeIn[DATA_WIDTH-1:i+1],inv,gray_codeIn[i-1:0]};
        end
    end
endgenerate

integer j;
always_comb begin
  isThermometer = 1'b0;
  for(j=0;j<DATA_WIDTH;j=j+1) begin
    if(~|temp[j] == 1)  ///only one of temp has all zeros
      isThermometer = 1;
  end
end


endmodule
