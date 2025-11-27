module model #(parameter
    DATA_WIDTH=8
) (
    input clk,
    input resetn,
    input [DATA_WIDTH-1:0] din,
    input wr,
    output logic [DATA_WIDTH-1:0] dout,
    output logic full,
    output logic empty
);

logic[DATA_WIDTH-1:0] mem[0:1];
logic wr_ptr,rd_ptr,full_nxt;

always_ff@(posedge clk) begin
    if(~resetn) begin
        mem[0] <= 0;
        mem[1] <= 0;
        wr_ptr <= 0;
        rd_ptr <= 0;
        full <= 0;
        empty <= 1;
    end
    else if(wr) begin
        empty <= 0;
        mem[wr_ptr] <= din;
        wr_ptr <= wr_ptr + 1;
        if(full) rd_ptr <= rd_ptr + 1;
        full <= full_nxt;
    end
end

assign full_nxt = full ? 1'b1 : (wr_ptr + 1'b1 == rd_ptr);
assign dout = mem[rd_ptr];

endmodule
