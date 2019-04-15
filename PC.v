module PC(in,PS,clock,Q,reset);
	parameter PC_RESET_VALUE = 32'h00000000;
	input[29:0] in;
	input[1:0] PS;
	input clock;
	output reg [31:0] Q;
	input reset;
	always @(posedge clock) begin
		if(reset == 1)
		 begin
			Q <= PC_RESET_VALUE;
		 end
		 else if(PS[1:0] == 2'b00)
			begin
				Q <= Q;
			end
			else if(PS[1:0] == 2'b01)
			begin
				Q <= Q + 32'd4;
			end
			else if(PS[1:0] == 2'b11)
			begin
				Q <= {2'b0,in[29:0]};
			end
			else
				begin
					if(in[25] == 0)
						begin
						Q <=	Q + 32'd4 + {in[29:0],2'b0};
						end
					else
						begin 
						Q <= Q + {4'b1111,in[25:0],2'b11} + 32'b1;
						end
				end
	end
endmodule