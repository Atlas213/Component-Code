module PC(in,PS,clock,Q,reset);
	parameter PC_RESET_VALUE = 32'h00000000;
	input[29:0] in;
	input[1:0] PS;
	input clock;
	output reg [31:0] Q;
	input reset;
	always @(posedge clock) begin
		case(PS[1:0])
		2'b00 :  Q <= reset ? PC_RESET_VALUE : Q;
		2'b01 : Q <= reset ? PC_RESET_VALUE : Q + 32'd4;
		2'b11 : Q <= reset ? PC_RESET_VALUE : {2'b0,in[29:0]};
		2'b10 : Q <= reset ? PC_RESET_VALUE : Q + 32'd4 + {2'b0,in[29:0]} + {2'b0,in[29:0]} + {2'b0,in[29:0]} + {2'b0,in[29:0]};
		endcase
	end
endmodule