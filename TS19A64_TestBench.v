module TS19A64_TestBench();
	//reg [31:0] Inst;
	
	reg CLK;
	
	reg Reset;
	
	wire [15:0] r0, r1, r2, r3, r4, r5, r6, r7;
	
	//wire TestPin;
	
	//wire [63:0] K;
	
	//wire [3:0] Status;
	
	//wire [4:0] DDL;

	//wire [4:0] AAL;
	
	//wire [4:0] BBL;
	
	//wire [4:0] FSL;
	wire out;
	
	TS19A64 TS(CLK,Reset,out,r0, r1, r2, r3, r4, r5, r6, r7);
	
	initial begin
	CLK <= 1'b1;
	Reset <= 1'b1;
	#100;
	Reset <= 1'b0;
	#5000;
	#5000;
	$stop;
	end
	
	always
		#1 CLK <= ~CLK;
	
endmodule