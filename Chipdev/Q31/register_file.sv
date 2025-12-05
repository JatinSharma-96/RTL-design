module model #(parameter 
    DATA_WIDTH = 16
) (
    input [DATA_WIDTH-1:0] din,
    input [4:0] wad1,
    input [4:0] rad1, rad2,
    input wen1, ren1, ren2,
    input clk,
    input resetn,
    output logic [DATA_WIDTH-1:0] dout1, dout2,
    output logic collision
);


logic[DATA_WIDTH-1:0] mem[0:31];
logic coll_condn,wen_c;

integer i;

always_ff@(posedge clk) begin
    if(~resetn) begin
        //PS <= INIT;
        for(i=0;i<31;i=i+1) mem[i] <= 0 ;
        dout1 <= 0;
        dout2 <= 0;
        collision <= 0;
    end
    else begin
        //PS <= NS;
        if(wen_c) mem[wad1] <= din;
        if(ren1) dout1 <= ~coll_condn ? mem[rad1] : 0 ;
        else dout1 <= 0;
        if(ren2) dout2 <= ~coll_condn ? mem[rad2] : 0 ;
        else dout2 <= 0;
        collision <= coll_condn;
    end
end

assign wen_c = wen1 & ~coll_condn;

assign coll_condn = ((rad1==rad2)&ren1&ren2) || ((rad1==wad1)&ren1&wen1) || ((rad2==wad1)&ren2&wen1);


endmodule
