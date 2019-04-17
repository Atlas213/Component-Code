module TS19A64(CLK,Reset,r0, r1, r2, r3, r4, r5, r6, r7, TestPin,Status,K,DDL,AAL,BBL,FSL);
		
	//input [31:0] Inst;
	
	input CLK;
	
	input Reset;
	
	output [15:0] r0, r1, r2, r3, r4, r5, r6, r7;
	
	output TestPin;
	
	output [3:0] Status;
	
	output [63:0] K;
	
	output [4:0] DDL;

	output [4:0] AAL;
	
	output [4:0] BBL;
	
	output [4:0] FSL;
	
	CU ContU(CLK,Reset,r0, r1, r2, r3, r4, r5, r6, r7,TestPin,Status,K,DDL,AAL,BBL,FSL);
	
endmodule