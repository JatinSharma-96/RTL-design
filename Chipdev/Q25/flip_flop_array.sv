module model (
    input [7:0] din,
    input [2:0] addr,
    input wr,
    input rd,
    input clk,
    input resetn,
    output logic [7:0] dout,
    output logic error
);

logic[7:0] rf[0:7];
logic std_addr[0:7];


integer i;

always_ff@(posedge clk) begin
    if(~resetn) begin
        for(i=0;i<8;i=i+1) begin
            rf[i] <= 0;
            std_addr[i] <= 0;
        end
        dout <= 0;
    end
    else begin
        if(wr & !rd & !temp2) begin
            rf[addr] <= din;
            std_addr[addr] <= 1;
            dout <= 0;
        end
        else if(rd & !wr) dout <= rf[addr];
        else dout <= 0;
    end
end

logic temp1,temp2;

always_comb begin
    //temp1 = rd & ~std_addr[addr]; //error condition
    temp2 = rd & wr; //error condition
end

always_ff@(posedge clk) begin
    if(~resetn) error <= 0;
    else error <= temp2;
end

endmodule
