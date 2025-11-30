// Code your design here
module apb_downsizer(input PCLK,PRESETn,PSELs,PENABLEs,PWRITEs,
                     input[7:0]PADDRs,input[31:0]PWDATAs,output logic[31:0] PRDATAs,output logic PREADYs,
	output logic PSELm,PENABLEm,PWRITEm,
                     output logic[7:0] PADDRm,output logic[15:0] PWDATAm,input[15:0] PRDATAm,input PREADYm);

typedef enum logic[2:0] {SETUP,ACCESS0,WAIT,ACCESS1,FT} st;
st PS,NS;

logic[31:0] read_data;
logic sel,store;

logic[7:0] addr_2;
assign addr_2 = PADDRs + 2'b10;
assign PADDRm = !sel ? PADDRs : addr_2;
assign PWDATAm = PWRITEs ? (!sel ? PWDATAs[15:0] : PWDATAs[31:16]) : 15'b0;

always_ff@(posedge PCLK) begin
	if(~PRESETn) begin
		PS <= SETUP;
		read_data <= 0;
	end
	else begin
		PS <= NS;
		if(store) read_data <= {PRDATAm,read_data[31:16]};
	end
end


always_comb begin
	case(PS)
		SETUP : NS = !PSELs ? SETUP : ACCESS0;
      ACCESS0 : NS = !(PREADYm&PENABLEs) ? ACCESS0 : WAIT;
		WAIT : NS = !PREADYm ? WAIT : ACCESS1;
		ACCESS1 : NS = !(PREADYm&PENABLEs) ? ACCESS1 : PWRITEs ? SETUP : FT;
		FT : NS = SETUP;
		default : NS = SETUP;
	endcase
end

always_comb begin
	PSELm = PSELs;
	PWRITEm = PWRITEs;
	PRDATAs = 32'b0;
	case(PS)
		SETUP : begin
			sel = 1'b0;
			PREADYs = ~PSELs;
			PENABLEm = PENABLEs;	
			store = 0;
		end
		ACCESS0 : begin
			sel = 1'b0;
			PREADYs = ~PSELs;
			PENABLEm = PENABLEs;
          store = PREADYm&(~PWRITEm)&PENABLEs;
		end
		WAIT : begin
			PENABLEm = ~PENABLEs;
			PREADYs = ~PSELs;
			sel = 1'b1;
			store = 1'b0;
		end
		ACCESS1: begin
			sel = 1'b1;
			PREADYs = PSELs&PWRITEs;
			PENABLEm = PENABLEs;
          store = PREADYm&(~PWRITEs);
		end
		FT: begin
			sel = 1'b1;
			PREADYs = PSELs&~PWRITEs;
			PENABLEm = 1'b0;
			store = 1'b0;
			PRDATAs = read_data;
		end
		default : begin
			store = 1'b0;
			sel = 1'b0;
			PREADYs = ~PSELs;
			PENABLEm = PENABLEs;
		end
	endcase
end

endmodule
