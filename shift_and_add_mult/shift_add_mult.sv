module shift_add_mult #(parameter BW=4) (input[BW-1:0] multiplier,
                                         input[BW-1:0] multiplicand,
                                         input[1:0] opcode,
                                         input clk, resetn,
                                         output logic[2*BW-1:0] result,
                                        output logic ready);
  
  logic[$clog2(BW)-1:0] count;
  logic[BW-1:0] str_multiplicand;
  logic[BW-1:0] pp,pp_nxt;
  logic cout;
  logic[2*BW-1:0] nxt_result;
  logic ld_counter,dec_counter,ld_and_shift,str_reg,start;
  
  typedef enum logic[1:0] {INIT,STR,LDnSHF} st;
  st PS,NS;
  
  assign pp = result[2*BW-1:BW];
  assign {cout,pp_nxt} = pp + str_multiplicand;
  
  always_ff@(posedge clk) begin
    if(~resetn) begin
      count <= 0;
      str_multiplicand <= 0;
      PS <= INIT;
      result <= 0;
    end
    else begin
      if(ld_counter) count <= BW-1;
      else if(dec_counter) count <= count - 1;
      
      if(str_reg) begin 
        str_multiplicand <= multiplicand;
        result <= {{BW{1'b0}},multiplier};
      end
      else if(ld_and_shift) begin
        result <= nxt_result;
      end
      
      PS <= NS;
      end
    end
  
  assign start = (opcode == 2'b01);
  
  always_comb begin
    case(PS)
      INIT : NS = start ? STR : INIT;
      STR : NS = LDnSHF;
      LDnSHF : NS = ready ? INIT : LDnSHF;
      default : NS = INIT;
    endcase
  end
 
  
  always_comb begin
    case(PS)
      INIT: begin
        ld_counter = 0;
        dec_counter = 0;
        str_reg = start;
        ld_and_shift = 0;
      end
      STR : begin
        ld_counter = 1;
        dec_counter = 0;
        ld_and_shift = 1;
        str_reg = 0;
      end
      LDnSHF : begin
        ld_counter = 0;
        dec_counter = ~ready;
        ld_and_shift = ~ready;
        str_reg = 0;
      end
      default : begin
        ld_counter = 0;
        dec_counter = 0;
        ld_and_shift = 0;
        str_reg = 0;
      end
    endcase
  end
  
  assign nxt_result = result[0] ? {cout,pp_nxt,result[BW-1:1]} : (result >> 1);
  assign ready = (count == 0) && ~ld_counter;


endmodule
