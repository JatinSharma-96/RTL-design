module model #(parameter
    FIZZ=3,
    BUZZ=5,
    MAX_CYCLES=100
) (
    input clk,
    input resetn,
    output logic fizz,
    output logic buzz,
    output logic fizzbuzz
);

logic[$clog2(MAX_CYCLES)-1:0] counter;

always_ff@(posedge clk) begin
    if(~resetn) counter <= 0;
    else if(counter == MAX_CYCLES-1) counter <= 0;
    else counter <= counter + 1;
end

assign fizz = (counter % FIZZ == 0);
assign buzz = (counter % BUZZ == 0);
assign fizzbuzz = fizz & buzz;

endmodule
