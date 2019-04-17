module Stack(Push,Pop,CLK,RST,DataIn,DataO);
input [4:0] Push; //DA
input [4:0] Pop;  //AA
input CLK;
input RST;
input [31:0] DataIn;
output [31:0] DataO;

reg Remove;
reg Enable;

wire [31:0] R00,R01,R02,R03;

reg [31:0] R0I,R1I,R2I,R3I;

RegisterNbit reg00 (R00, R0I,Enable,RST, CLK);
RegisterNbit reg01 (R01, R1I,Enable,RST, CLK);
RegisterNbit reg02 (R02, R2I,Enable, RST, CLK);
RegisterNbit reg03 (R03, R3I,Enable, RST, CLK);

tri_buf RB0(R00,DataO,Remove);

defparam reg00.N = 32;
defparam reg01.N = 32;
defparam reg02.N = 32;
defparam reg03.N = 32;

always@ (negedge CLK) begin

	Enable <= 1'b0;
	Remove <= 1'b0;
	
	if(Push == 5'b11110)
		begin
			R0I <= DataIn + 32'd4;
			R1I <= R00;
			R2I <= R01;
			R3I <= R02;
			Enable <= 1'b1;
		end
	else if(Pop == 5'b11110)
		begin
		R3I <= 32'b0;
		R2I <= R3I;
		R1I <= R2I;
		R0I <= R1I;
		Remove <= 1'b1;
		Enable <= 1'b1;
		end
end


endmodule