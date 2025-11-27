module model #(parameter
  DATA_WIDTH = 16,
  MAX = 99
) (
    input clk,
    input reset, start, stop,
    output logic [DATA_WIDTH-1:0] count
);

logic start_no_stop,nxt_start_no_stop;

logic[DATA_WIDTH-1:0] nxt_count;

always_ff@(posedge clk) begin
  if(reset) begin
     count <= 0;
     start_no_stop <= 0;
  end
  else begin
    count <= nxt_count;
    start_no_stop <= nxt_start_no_stop;
  end
end

always_comb begin
  if(stop) begin
  nxt_count = count;
  nxt_start_no_stop = 0;
  end
  else if(start) begin
  if(count != MAX) begin
    nxt_count = count + 1;
    nxt_start_no_stop = 1;
    end
    else begin
      nxt_count = 0;
      nxt_start_no_stop = 1;
    end
  end
  else if(start_no_stop) begin
    if(count != MAX) begin
    nxt_count = count + 1;
    nxt_start_no_stop = 1;
    end
    else begin
      nxt_count = 0;
      nxt_start_no_stop = 1;
    end
  end
  else begin
    nxt_count = count;
    nxt_start_no_stop = 0;
  end

end

endmodule
