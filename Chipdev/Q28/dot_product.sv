module model (
    input [7:0] din,
    input clk,
    input resetn,
    output reg [17:0] dout,
    output reg run
);

logic[7:0] mem[0:2];
logic[2:0] counter,nxt_counter;
logic[17:0] inter_result,nxt_inter_result,nxt_dout;
logic wr,nxt_run;

always_ff@(posedge clk) begin
    if(~resetn) begin
        mem[0] <= 0;
        mem[1] <= 0;
        mem[2] <= 0;
        counter <= 0;
        inter_result <= 0;
        dout <= 0;
        run <= 1;
    end
    else begin
        counter <= nxt_counter;
        if(wr) mem[counter] <= din;
        inter_result <= nxt_inter_result;
        dout <= nxt_dout;
        run <= nxt_run;
    end
end

always_comb begin
    nxt_counter = (counter == 5) ? 0 : counter + 1;
    wr = (counter <= 2);
  nxt_inter_result = ~wr ? (inter_result + mem[counter-3]*din) : 0;////need to optimize
    nxt_dout = (counter != 5) ? dout : nxt_inter_result;
    nxt_run = (counter == 5);
end

endmodule
