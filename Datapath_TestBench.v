module Datapath_TestBench();
	
	reg [4:0]SA, SB, DA, FS;
	reg WR, RST, CLK ,C0, EN_ALU,EN_B,M;
	wire [3:0] STAT;
	reg [63:0] K;
	wire [15:0] r0, r1, r2, r3, r4, r5, r6, r7;
	reg RWE,ROE,RCS,EN_ADDR_ALU;
	
	
	Datapath dp (SA,SB,DA,WR,RST,CLK,FS,C0,STAT,K,M,EN_ALU,EN_ADDR_ALU,EN_B,r0, r1, r2, r3, r4, r5, r6, r7,RCS,RWE,ROE);
	
	initial begin
		CLK <= 1'b1;
		
		K <= 64'd0;
		M <= 1'b0;
		WR <= 1'b1;
		RST <= 1'b1;
		RWE <= 1'b0;
		RCS <= 1'b0;
		ROE <= 1'b0;
		C0 <= 1'b0;
		SA <= 5'd30;
		SB	<= 5'd30;
		DA <= 5'd0;
		FS <= 5'b01000;
		EN_ALU <= 1'b1;
		EN_ADDR_ALU <= 1'b0;
		EN_B <= 1'b0;
		#5;
		RST <= 1'b0;
		#10; 
		DA <= DA + 5'd1; //Store 1 in r1
		K <= K + 64'd1;
		#10;
		#10; 
		DA <= DA + 5'd1; //Store 2 in r2
		K <= K + 64'd1;
		#10;
		#10; 
		DA <= DA + 5'd1; //Store 3 in r3
		K <= K + 64'd1;
		#10;
		#10; 
		DA <= DA + 5'd1; //Store 4 in r4
		K <= K + 64'd1;
		#10;
		#10; 
		DA <= DA + 5'd1; //Store 5 in r5
		K <= K + 64'd1;
		#10;
		#10;
		DA <= DA + 5'd1; //Store 6 in r6
		K <= K + 64'd1;
		#10;
		#10; 
		DA <= DA + 5'd1; //Store 7 in r7
		K <= K + 64'd1;
		#10;
		#10;
		RCS<=1'b1;
		WR <=1'b0;
		RWE <= 1'b1;
		K <= 64'd0;
		EN_B <= 1'b1;
		EN_ALU<=1'b0;
		EN_ADDR_ALU <=1'b1;
		FS <= 5'b00100;
		SA <= 5'b00010;
		SB <= 5'b00111;
		#10;
		#10;
		RCS <=1'b0;
		WR <= 1'b1;
		RWE <=1'b0;
		EN_B <= 1'b0;
		EN_ALU<=1'b1;
		EN_ADDR_ALU <=1'b0;
		M <= 1'b1;
		DA <= 5'd0;
		SA <= 5'b00001;	//1 + 7 stored in reg0
		SB <= 5'b00111;
		FS <= 5'b01000;
		#10;
		#10;
		DA <= 5'd1;
		SA <= 5'b00000;
		SB <= 5'b00101;		//8 - 5 stored in reg1
		FS <= 5'b01001;
		C0 <= 1'b1;
		#10;
		#10;
		EN_ALU <= 1'b0;
		EN_B <= 1'b1;
		DA <= 5'd3;  // Store r2 in r3
		SB <= 5'd2;
		#10;
		#10;
		DA <= DA + 5'd1; //Store r3 in r4
		SB <= SB + 5'd1;
		#10;
		#10;
		DA <= DA + 5'd1; //Store r4 in r5
		SB <= SB + 5'd1;
		#10;
		#10;
		DA <= DA + 5'd1; // store r5 in r6
		SB <= SB + 5'd1;
		#10;
		#10;
		DA <= DA + 5'd1; //store r6 in r7
		SB <= SB + 5'd1;
		#10;
		#10;
		RCS<=1'b1;
		WR <=1'b0;
		RWE <= 1'b0;
		ROE <= 1'b1;
		K <= 64'd0;
		EN_B <= 1'b0;
		EN_ALU<=1'b0;
		EN_ADDR_ALU <=1'b1;
		FS <= 5'b00100;
		SA <= 5'b00010;
		DA <= 5'b00111;
		#10;
		WR <=1'b1;
		#10;
		$stop; // delay another 320 ticks then stop the simulation
	end
	
	// simulate clock with period of 10 ticks
	always
		#5 CLK <= ~CLK;
	//always begin
		//#10 DA <= DA + 5'd1;
		//K <= {$random, $random};
		//#10;
	//end
	
	
endmodule