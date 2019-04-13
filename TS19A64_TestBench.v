module TS19A64_TestBench();
	reg [31:0] Inst;
	
	reg CLK;
	
	reg Reset;
	
	wire [15:0] r0, r1, r2, r3, r4, r5, r6, r7;
	
	wire TestPin;
	
	wire [63:0] K;
	
	wire [3:0] Status;
	
	wire [4:0] DDL;

	wire [4:0] AAL;
	
	wire [4:0] BBL;
	
	wire [4:0] FSL;
	
	TS19A64 TS(Inst,CLK,Reset,r0, r1, r2, r3, r4, r5, r6, r7,TestPin,Status,K,DDL,AAL,BBL,FSL);
	
	initial begin
	CLK <= 1'b1;
	Reset <= 1'b1;
	#100;
	Reset <= 1'b0;
	#100
	Inst = 32'b10010001000000000001010000000001; // ADDI X1, X0, 5
	#500
	Inst = 32'b11111000000000000001001111100001; // STUR X1, [X31, 1]
	#500
	Inst = 32'b11111000010000000001001111100010; // LDUR X2,[X31,1]
	#500
	$stop;
	end
	
	always
		#25 CLK <= ~CLK;
	
endmodule