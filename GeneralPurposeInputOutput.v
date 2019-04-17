module GeneralPurposeInputOutput(Addr,Value,CS,CLK,RST,OP);

//IO
input [1:0] Addr;
input Value;
input CS;
input CLK;
input RST;
output [3:0] OP;
//Registers
reg [3:0] Out;
//Assignments
	assign OP = Out;
//Function
	always @(RST) begin
		Out <= 4'd0;
	end
	always @(posedge CLK) begin
		if(CS == 1)
		begin
			case(Addr[1:0])
				2'b00: Out[0] <= Value;
				2'b01: Out[1] <= Value;
				2'b10: Out[2] <= Value;
				2'b11: Out[3] <= Value;
			endcase
		end
	end
endmodule	