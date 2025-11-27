module model (
  input clk,
  input resetn,
  input din,
  output logic dout
);

typedef enum logic [2:0] {
        S0,     // no match
        S1,     // saw 1
        S10,    // saw 10
        S101,   // saw 101
        S1010   // MATCH: output = 1 for one cycle
    } state_t;

    state_t state, next_state;

    // Moore output: high only in S1010
    assign dout = (state == S1010);

    // next-state logic
    always @(*) begin
        case (state)

            S0: begin
                if (din) next_state = S1;
                else     next_state = S0;
            end

            S1: begin
                if (!din) next_state = S10;
                else      next_state = S1;
            end

            S10: begin
                if (din) next_state = S101;
                else     next_state = S0;
            end

            S101: begin
                if (!din) 
                    next_state = S1010;     // full match
                else 
                    next_state = S1;        // could start over with a '1'
            end

            S1010: begin
                // Overlap: last '0' is part of "10"
                // After output pulse re-enter appropriate state
                if (din) next_state = S101; // "101(1)"
                else     next_state = S0;  // "1010(0)"
            end

            default: next_state = S0;
        endcase
    end

    // state register
    always @(posedge clk) begin
        if (!resetn)
            state <= S0;
        else
            state <= next_state;
    end

endmodule
