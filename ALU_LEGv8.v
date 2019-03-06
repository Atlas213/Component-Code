module ALU_LEGv8(A, B, FS, C0, F, status);
	input [63:0] A, B;
	input [4:0]FS;
	// FS0 - b invert
	// FS1 - a invert
	// FS4:2 - op. select
	//   000 - AND
	//   001 - OR
	//   010 - ADD
	//   011 - XOR
	//   100 - shift left
	//   101 - shift right
	//   110 - none / 0
	//   111 - none / 0
	input C0;
	output [63:0]F;
	output [3:0]status;
	
	wire Z, N, C, V;
	assign status = {V, C, N, Z};
	
	wire [63:0] A_Signal, B_Signal;
	// A Mux
	assign A_Signal = FS[1] ? ~A : A;
	// B Mux
	assign B_Signal = FS[0] ? ~B : B;
	
	assign N = F[63];
	
	assign Z = (F == 64'b0) ? 1'b1 : 1'b0;
	
	assign V = ~(A_Signal[63] ^ B_Signal[63]) &  (F[63] ^ A_Signal[63]);
	
	wire [63:0]and_output, or_output, xor_output, add_output, shift_left, shift_right;
	assign and_output = A_Signal & B_Signal;
	assign or_output = A_Signal | B_Signal;
	assign xor_output = A_Signal ^ B_Signal;
	Adder adder_inst (add_output, C, A_Signal, B_Signal, C0);
	Shifter shift_inst (shift_left, shift_right, A, B[5:0]);
	
	Mux8to1Nbit main_mux (F, FS[4:2], and_output, or_output, add_output, xor_output, shift_left, shift_right, 64'b0, 64'b0);
endmodule

module Shifter(left, right, A, shift_amount);
	output [63:0] left, right;
	input [63:0] A;
	input [5:0] shift_amount;
	
	assign left = A << shift_amount;
	assign right = A >> shift_amount;
endmodule

module Adder(S, Cout, A, B, Cin);
	output [63:0] S;
	output Cout;
	input [63:0] A, B;
	input Cin;
	wire [63:0]carry;
	
	
	
	
	CarryAdder_8bit carry0 (carry[7:0],A[7:0],B[7:0],Cin);
	CarryAdder_8bit carry1 (carry[15:8],A[15:8],B[15:8],carry[7]);
	CarryAdder_8bit carry2 (carry[23:16],A[23:16],B[23:16],carry[15]);
	CarryAdder_8bit carry3 (carry[31:24],A[31:24],B[31:24],carry[23]);
	CarryAdder_8bit carry4 (carry[39:32],A[39:32],B[39:32],carry[31]);
	CarryAdder_8bit carry5 (carry[47:40],A[47:40],B[47:40],carry[39]);
	CarryAdder_8bit carry6 (carry[55:48],A[55:48],B[55:48],carry[47]);
	CarryAdder_8bit carry7 (carry[63:56],A[63:56],B[63:56],carry[55]);
	assign Cout = carry[63];
	QuarterAdder adder_instf (S[0], A[0], B[0], Cin);
	genvar i;
	generate
	for (i=1; i<=63; i=i+1) begin: quarter_adders // blocks within a generate block need to be named
		QuarterAdder adder_inst (S[i],A[i], B[i], carry[i-1]);	
	end
	endgenerate
	// this will generate the following code:
	// FullAdder full_adders[0].adder_inst (S[0], carry[1], A[0], B[0], carry[0]);
	// FullAdder full_adders[1].adder_inst (S[1], carry[2], A[1], B[1], carry[1]);
	// ...
	// FullAdder full_adders[63].adder_inst (S[63], carry[64], A[63], B[63], carry[63]);
endmodule

module QuarterAdder(S, A, B, Cin);
	input A, B, Cin;
	output S;
	assign S = (A ^ B ^ Cin);
endmodule

module CarryAdder_8bit(Cout, A, B, C0);
	output [7:0] Cout;
	input [7:0] A, B;
	input C0;
	wire G0,G1,G2,G3,G4,G5,G6,G7;
	wire P0,P1,P2,P3,P4,P5,P6,P7;
	assign G0 = A[0] & B[0];
	assign G1 = A[1] & B[1];
	assign G2 = A[2] & B[2];
	assign G3 = A[3] & B[3];
	assign G4 = A[4] & B[4];
	assign G5 = A[5] & B[5];
	assign G6 = A[6] & B[6];
	assign G7 = A[7] & B[7];
	assign P0 = A[0] ^ B[0];
	assign P1 = A[1] ^ B[1];
	assign P2 = A[2] ^ B[2];
	assign P3 = A[3] ^ B[3];
	assign P4 = A[4] ^ B[4];
	assign P5 = A[5] ^ B[5];
	assign P6 = A[6] ^ B[6];
	assign P7 = A[7] ^ B[7];
	assign Cout[0] = G0 + (P0 & C0);
	assign Cout[1] = G1 + (G0 & P1) + (P0 & P1 & C0);
	assign Cout[2] = G2 + (G1 & P2) + (P1 & P2 & G0) + (P0 & P1 & P2 & C0);
	assign Cout[3] = G3 + (G2 & P3) + (P2 & P3 & G1) + (P1 & P2 & P3 & G0) + (P0 & P1 & P2 & P3 & C0);
	assign Cout[4] = G4 + (G3 & P4) + (P3 & P4 & G2) + (P2 & P3 & P4 & G1) + (P1 & P2 & P3 & P4 & G0) + (P0 & P1 & P2 & P3 & P4 & C0);
	assign Cout[5] = G5 + (G4 & P5) + (P4 & P5 & G3) + (P3 & P4 & P5 & G2) + (P2 & P3 & P4 & P5 & G1) + (P1 & P2 & P3 & P4 & P5 & G0) + (P0 & P1 & P2 & P3 & P4 & P5 & C0);
	assign Cout[6] = G6 + (G5 & P6) + (P5 & P6 & G4) + (P4 & P5 & P6 & G3) + (P3 & P4 & P5 & P6 & G2) + (P2 & P3 & P4 & P5 & P6 & G1) + (P1 & P2 & P3 & P4 & P5 & P6 & G0) + (P0 & P1 & P2 & P3 & P4 & P5 & P6 & C0);
	assign Cout[7] = G7 + (G6 & P7) + (P6 & P7 & G5) + (P5 & P6 & P7 & G4) + (P4 & P5 & P6 & P7 & G3) + (P3 & P4 & P5 & P6 & P7 & G2) + (P2 & P3 & P4 & P5 & P6 & P7 & G1) + (P1 & P2 & P3 & P4 & P5 & P6 & P7 & G0) + (P0 & P1 & P2 & P3 & P4 & P5 & P6 & P7 & C0);
endmodule
