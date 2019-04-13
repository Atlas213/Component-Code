module CU(Inst,CLK,Reset,r0, r1, r2, r3, r4, r5, r6, r7,TestPin,Status,K,DDL,AAL,BBL,FSL);


//IO
	input [31:0] Inst;
	
	input CLK;
	
	input Reset;
	
	output [15:0] r0, r1, r2, r3, r4, r5, r6, r7;
	
	output reg TestPin;
	
	output [3:0] Status; //Status Flags
	
	output [63:0] K; // K
	
	output [4:0] DDL;

	output [4:0] AAL;
	
	output [4:0] BBL;
	
	output [4:0] FSL;
//Internal Registers
	
	reg [4:0] DA;

	reg [4:0] AA; // Register file A line select

	reg [4:0] BA; // Register file B line select

	reg [4:0] FS; //ALU Function Select
	
	reg [1:0] PC_SEL; //register for PC select
	
	reg PC_MUX;

	reg WR; // Write Enable register
	
	reg WRR; //Write RAM
	
	reg RR; //Read RAM
	
	reg RCS; 	//Chip select
	
	reg EN_ALU; //Enables the ALU
	
	reg EN_B;	//Enables the B bus of the reg to data line
	
	reg EN_K; // Enables Constant (Nick: i am assuming this is the mux for the b line reg. or k)

	reg EN_ADDR_ALU; // Enables ALU to RAM BUS
	
	reg EN_ADDR_PC;	//Enables PC to ram bus
	
	reg EN_PC; 
	
	reg IL;	//Enables instuction load
	
	reg Cin;	//// Carry In bit	
	
	reg SFL; // Load Status Flags
	
	reg[11:0] Const;
	
	reg[2:0] State;
	
//Wires

	wire[10:0] Opcode;
	
	//wire[31:0] temp; // Will replace 

//General Assignments	
	assign Opcode = Inst[31:21];
	
	assign K[11:0] = Const[11:0];
	
	assign K[63:12] = 52'd0;
	
	assign AAL = AA;
	
	assign BBL = BA;
	
	assign DDL = DA;
	
	assign FSL = FS;
	
//Datapath
Datapath DP(AA,BA,DA,WR,IL,Reset,CLK,FS,Cin,Status,K,EN_K,EN_ALU,EN_ADDR_ALU,EN_B,EN_PC,EN_ADDR_PC,PC_MUX,PC_SEL,r0, r1, r2, r3, r4, r5, r6,r7,RCS,WRR,RR,SFL);
	

	
	always@(negedge CLK) begin

	//ZERO ALL VALUES
	
	//Note from Nick: we may need a conditional statement here when considering the program
	//Counter for multicycle instructions. However this will do for now. So if Single zero else keep values.
	
	if(Reset == 1)
		begin
			State <= 3'd0;
		end
	
	DA <= 5'd0;

	AA <= 5'd0;

	BA <= 5'd0;

	Const <= 12'b0;

	FS <= 5'b0;
	
	PC_SEL <= 2'b0;
	
	PC_MUX <= 1'b0;

	WR <=1'b0; 
	
	WRR <= 1'b0; 
	
	RR <=1'b0; 
	
	RCS <=1'b0;
	
	EN_ALU <= 1'b0; 
	
	EN_B <= 1'b0;	
	
	EN_K <= 1'b0;

	EN_PC <= 1'b0;
	
	EN_ADDR_ALU <= 1'b0; 
	
	EN_ADDR_PC <= 1'b0;	
	
	IL <= 1'b0;	
	
	Cin <= 1'b0;	
	
	SFL <= 1'b0;
	
	TestPin <= 1'b0;

	//if(Opcode[4] == 1)
	
		
		//if(Opcode[10:8] == 3'b000)
		
			// B

		//if(Opcode[10:8] == 3'b010)

			//B.cond

		//if(Opcode[10:8] == 3'b100)

			//BL
		
		//if(Opcode[10:8] == 3'b101)
		
			//CBZ/CBNZ

		//if(Opcode[10:8] == 3'b110)
		
			// BR

	if(Opcode[5] == 0)
		begin
	
		if(Opcode[4:2] == 3'b000)
			// D format
			begin
				Const <= Inst[21:12];
				EN_K <= 1'b1;
				FS <= 5'b01000;
				RCS <= 1'b1;
				EN_ADDR_ALU <= 1'b1;
			
				if(Opcode[1] == 1)
				//LDUR
				begin
							DA <= Inst[4:0];
							AA <= Inst[9:5];
							RR <= 1'b1;
						if(State[0] == 0)
							begin
								PC_SEL <= 2'b00;
								State <= State + 1;
							end
						if(State[0] == 1)
							begin
								WR <= 1'b1; //enable write on second cycle
								PC_SEL <= 2'b01;
								State <= 3'd0;
							end
				end
				
				if(Opcode[1] == 0)
				//STUR
				begin
					AA <= Inst[9:5];
					BA <= Inst[4:0];
					EN_B <= 1'b1;
					WRR <= 1'b1;
					PC_SEL <= 2'b01;
				end
			
			end

		if(Opcode[4:2] == 3'b010)
			// I format
			begin
				//Format Wire Assignments

					 DA <= Inst[4:0];

					 AA <= Inst[9:5];

					Const <= Inst[21:10];

					EN_K <= 1'b1; // Enable Constant
					
					PC_SEL <= 2'b01; //Incrment PC
					
					EN_ALU <= 1'b1; //Enable ALU 
					
					WR <= 1'b1; //Enable Register Write

				//Operation Specific Funtion

					if(Opcode[9] == 1)
						begin
							FS <= 5'b01001; //SUB
							Cin <= 1'b1; // Carry In Bit
						end	
					if(Opcode[9] == 0)
						begin
							FS <= 5'b01000; //ADD
							TestPin <= 1'b1;
						end
				// Status Flags
				
					 SFL <= Opcode[8];
			end
		if (Opcode[4:2] == 3'b100)
			//Logic
			begin
				//Logic General Assignments
				
					PC_SEL <= 2'b01; //Incrment PC
					EN_ALU <= 1'b1;
					
				// Function Select

					//AND

						if(Opcode[9:8] == 2'b00)
							begin
								FS <= 5'b00000;
							end

					//ORR

						if(Opcode[9:8] == 2'b01)
							begin
								FS <= 5'b00100;
							end
					//EOR

						if(Opcode[9:8] == 2'b10)
							begin
								FS <= 5'b01100;
							end
					//ANDS

						if(Opcode[9:8] == 2'b11)
							begin
								FS <= 5'b00000;
								SFL <= 1'b1;
						end

				//Format Select

					if(Opcode[7] == 1)
						// I format
						begin
							//Format Wire Assignments

								DA <= Inst[4:0];

								AA <= Inst[9:5];

								Const <= Inst[21:10];

								EN_K <= 1'b1;
								
								WR <= 1'b1;
						end
					if(Opcode[7] == 0)
						// R format
						begin
							//Format Wire Assignments
								DA <= Inst[4:0];
								AA <= Inst[9:5];
								BA <= Inst[20:16];
								WR <= 1'b1; // Register Write Enable
						end
				end

		//if (Opcode[4:2] == 3'b101)
			// IW format
		if (Opcode[4:2] == 3'b110)
			//R format
			begin
				// Format Wire Assignments

						DA <= Inst[4:0];

						AA <= Inst[9:5];
						
						BA <= Inst[20:16];

						WR <= 1'b1;

						EN_ALU <= 1'b1;

				// Status Flags
				
						SFL <= Opcode[8];

				// Arithmetic/Shift

						if(Opcode[1] == 0)
							//Function Select
							begin
							if(Opcode[9] == 1)
								//Sub
								begin
									FS <= 5'b01001;
									Cin <= 1'b1;
								end
							if(Opcode[9] == 0)
								//Add
								begin
									FS <= 5'b01000;
								end
							end
						if(Opcode[1] == 1)
						//Shift Wire Assignments
							begin
							Const <= Inst[15:10];
							EN_K <= 1'b1;
							if(Opcode[0] == 1)
								//Shift Left
								begin
									FS <= 5'b10000;
								end

							if(Opcode[0] == 0)
								//Shift Right
								begin
									FS <= 5'b10100;
									
								end
						end
				end
		end
end 

endmodule 