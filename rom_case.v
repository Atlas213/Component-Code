module rom_case(out, address);
	output reg [31:0] out;
	input  [31:0] address; // address- 16 deep memory  
	always @(address) begin
		case (address)
			31'd0:  out = 32'b10010001001111101000000000100001; // ADDI X1,X1,4000
			31'd4:  out = 32'b10010001001111101000000001000010; // ADDI X2,X2,4000
			31'd8:  out = 32'b11010011011000000010100000100001; // LSL X1,X1,10
			31'd12:  out = 32'b11010011011000000010100001000010; // LSL X2,X2,10
			31'd16:  out = 32'b11010010100000000000001010000001; // MOVZ X1,20
			31'd20:  out = 32'b11110010100000000000001010000010; // MOVK X2,20
			default: out=32'h0000;
			endcase
end
endmodule