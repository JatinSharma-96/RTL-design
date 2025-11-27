// Code your design here
module serial_to_parallel(input bstream,
                          input sync,
                          input clk,rst,
                          output reg[7:0] data,
                          output[4:0] timeslot_num);
  logic[7:0] count,count_nxt,shift_reg;
  logic ld;
  
  always_ff@(posedge clk or negedge rst) begin
    if(~rst) begin
      count <= 8'b0;
      data <= 8'b0;
      shift_reg <= 8'b0;
    end
    else begin
      count <= count_nxt;
      data <= ld ? shift_reg : data;
      shift_reg <= {shift_reg[6:0],bstream};
    end
  end
  
  always_comb begin
    count_nxt = sync ? 8'b0 : count + 1;   ///sync is responsible for start and end of packet
    ld = (count[2:0] == 3'd7);
  end
  
  assign timeslot_num = count[7:3];
  
endmodule
