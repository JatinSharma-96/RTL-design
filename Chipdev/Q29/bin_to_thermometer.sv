module model (
    input [7:0] din,
    output reg [255:0] dout
);

integer i;

always_comb begin
    dout = 0;
    for(i=0;i<256;i=i+1) begin
        if(i<=din) begin
            dout[i] = 1'b1;
        end 
    end
end

endmodule
