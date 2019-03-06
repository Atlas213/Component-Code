module rom_case(out,address);
	output reg [15:0] out;
	input [7:0] address;
	
	always @(address)
	
	begin
		case(address)
			8'h00:out = 16'b1100000000000000;
			8'h01:out = 16'b1100100000000001;
			8'h02:out = 16'b1101000000000010;
			8'h03:out = 16'b1110000000000011;
			8'h04:out = 16'b1110100000000100;
			8'h05:out = 16'b1110100000000101;
			8'h06:out = 16'b1111000000000110;
			8'h07:out = 16'b1111100000000111;
			8'h08:out = 16'b0010100100001000;
			8'h09:out = 16'b0110100010011100;
			8'h0A:out = 16'b0111000011011000;
			8'h0C:out = 16'b1011100100000011;
			8'h0D:out = 16'b0110110001010001;
			8'h0E:out = 16'b1010010001000001;
			8'h0F:out = 16'b1011100111110001;
		 default:out = 16'b0000000000000000;
		endcase
	end
endmodule
