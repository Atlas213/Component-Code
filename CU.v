module CU(CLK,Reset,out,r0, r1, r2, r3, r4, r5, r6, r7);


//IO
	//input [31:0] Inst;
	
	input CLK;
	
	input Reset;
	
	output [15:0] r0, r1, r2, r3, r4, r5, r6, r7;
	
	//reg TestPin;
	
	wire [3:0] Status; //Status Flags
	
	//output [63:0] K; // K
	
	///output [4:0] DDL;

	//output [4:0] AAL;
	
	//output [4:0] BBL;
	
	//output [4:0] FSL;
	
	output out;
	
//Internal Registers
	
	reg [4:0] DA;

	reg [4:0] AA; // Register file A line select

	reg [4:0] BA; // Register file B line select

	reg [4:0] FS; //ALU Function Select
	
	reg [1:0] PC_SEL; //register for PC select
	
	reg PC_MUX; //Controls K or A input to PC

	reg WR; // Write Enable register
	
	reg WRR; //Write RAM
	
	reg RR; //Read RAM
	
	reg RCS; 	//Chip select
	
	reg EN_ALU; //Enables the ALU
	
	reg EN_B;	//Enables the B bus of the reg to data line
	
	reg EN_K; // Enables Constant (Nick: i am assuming this is the mux for the b line reg. or k)

	reg EN_ADDR_ALU; // Enables ALU to RAM BUS
	
	reg EN_ADDR_PC;	//Enables PC to ram bus
	
	reg EN_PC; //Enables PC to the Databus
	
	reg Cin;	//// Carry In bit	
	
	reg SFL; // Load Status Flags
	
	reg[63:0] K;
	
	reg[2:0] State;
	
	reg Shift;
	
	reg BR_SEL;
	
//Wires

	wire[10:0] Opcode;
	wire [31:0] Inst;
	reg Comp;

//General Assignments	
	assign Opcode = Inst[31:21];
	
	//assign AAL = AA;
	
	//assign BBL = BA;
	
	//assign DDL = DA;
	
	//assign FSL = FS;
	
//Datapath
Datapath DP(AA,BA,DA,WR,Reset,CLK,FS,Cin,Status,K,EN_K,EN_ALU,EN_ADDR_ALU,EN_B,EN_PC,EN_ADDR_PC,PC_MUX,PC_SEL,RCS,WRR,RR,SFL,BR_SEL,Inst,out,r0, r1, r2, r3, r4, r5, r6, r7);
	

	
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

	K <= 64'd0;

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
	
	Cin <= 1'b0;	
	
	SFL <= 1'b0;
	
	BR_SEL <= 1'b0;
	
	//TestPin <= 1'b0;
	
	Shift <= 1'b0;

	if(Opcode[5] == 1)
		begin
		
		if(Opcode[10:8] == 3'b000)
			// B
			begin
				K <= Inst[25:0];
				PC_MUX <= 1'b1;
				BR_SEL <= 1'b1;
				PC_SEL <= 2'b10;
			end

		if(Opcode[10:8] == 3'b010)
			//B.cond
			begin
				case(Inst[4:0])
					5'b00000 : Comp <= Status[0]; // EQ
					5'b00001 : Comp <= ~Status[0]; //NE
					5'b00010 : Comp <= Status[2]; //HS
					5'b00011 : Comp <= ~Status[2]; //LO
					5'b00100 : Comp <= Status[1]; //MI
					5'b00101 : Comp <= ~Status[1]; //PL
					5'b00110 : Comp <= Status[3]; //VS
					5'b00111 : Comp <= ~Status[3]; //VC
					5'b01000 : Comp <= Status[2] & ~Status[0]; //HI
					5'b01001 : Comp <= ~Status[2] & Status[0]; //LS
					5'b01010 : Comp <= ~(Status[1] ^ Status[3]); //GE
					5'b01011 : Comp <= Status[1] ^ Status[3]; //LT
					5'b01100 : Comp <= ~Status[0] | ~(Status[1] ^ Status[3]); //GT
					5'b01101 : Comp <= Status[0] | (Status[1] ^ Status[3]); //LE
					default : Comp <= 1'b0;
				endcase
				if(Comp)
					begin
						K <= Inst[25:0];
						PC_MUX <= 1'b1;
						BR_SEL <= 1'b1;
						PC_SEL <= 2'b10;
					end
				else
					begin
						PC_SEL <= 2'b01;
					end
			end

		if(Opcode[10:8] == 3'b100)
			//BL
			begin
					if(State[0] == 0)
						begin
							DA <= 5'b11110;
							State <= State + 1;
						end
					else
						begin
							PC_SEL <= 2'b10;
							PC_MUX <= 1'b1;
							BR_SEL <= 1'b1;
							K <= Inst[25:0];
							State <= 3'b0;
						end
						
				//if(State[0] == 0 & State[1] == 0)
					//begin
						//PC_SEL <= 2'b00;
						//WR <= 1'b1;
						//EN_PC <= 1'b1;
						//DA <= 5'b11110;
						//State <= State + 1;
					//end
				//else if(State[0] == 1)
					//begin
						//DA <= 5'b11110;
						//AA <= 5'b11110;
						//PC_SEL <= 2'b00;
						//WR <= 1'b1;
						//EN_ALU <= 1'b1;
						//EN_K <= 1'b1;
						//K <= 64'd4;
						//FS <= 5'b01000;
						//State <= State + 1;
					//end
				//else if(State[1] == 1)
					//begin
						//PC_SEL <= 2'b10;
						//PC_MUX <= 1'b1;
						//K <= Inst[25:0];
						//State <= 3'd0;
					//end
			end
		if(Opcode[10:8] == 3'b101)
			//CBZ/CBNZ
			begin
					if(State[0] == 0)
						begin
						AA <= Inst[4:0];
						EN_K <= 1'b1;
						FS <= 00100;
						SFL <= 1'b1;
						PC_SEL <= 2'b00;
						State <= State + 1;
						end
					else if(State[0] == 1)
						begin
							if((Status[0] == 1 & Opcode[3] == 0) | (Status[0] == 0 & Opcode[3] == 1))
								begin
									K <= Inst[20:5];
									PC_MUX <= 1'b1;
									BR_SEL <= 1'b1;
									PC_SEL <= 2'b10;
								end
							else
								begin
									PC_SEL <= 2'b01;
								end
							State <= 3'd0;
						end
			end

		if(Opcode[10:8] == 3'b110)
			//BR
			begin
				if(Inst[9:5] == 5'b11110)
				begin
				
					if(State[0] == 0)
						begin
							AA <= 5'b11110;
							State <= State + 1;
						end
					else
						begin
							PC_SEL <= 2'b11;
							State <= 3'd0;
						end
				end
				else
				begin
				AA <= Inst[4:0];
				PC_SEL <= 2'b11;
				PC_MUX <= 1'b1;
				end
			end
			
	end
	if(Opcode[5] == 0)
		begin
	
		if(Opcode[4:2] == 3'b000)
			// D format
			begin
				K[9:0] <= Inst[20:12];
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
						else if(State[0] == 1)
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

					K[11:0] <= Inst[21:10];

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
							if(Opcode[0] == 1'b0)
								begin
									FS <= 5'b00100;
								end
							else
								begin
									FS <= 5'b00011;
								end
								
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

								K[11:0] <= Inst[21:10];

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

		if (Opcode[4:2] == 3'b101)
			// IW format
			begin
				DA <= Inst[4:0];
				EN_K <= 1'b1;
				EN_ALU <= 1'b1;
				WR <= 1'b1;
				if(Opcode[8] == 1)
					//MovK
					begin
						AA <= Inst[4:0];
						if(State[0] == 0)
							begin
								State <= State + 1;
								PC_SEL <= 2'b00;
								FS <= 5'b00000;
								K <= {48'b1,16'b0};
							end
						else if(State[0] == 1)
							begin
								State <= 3'd0;
								PC_SEL <= 2'b01;
								FS <= 5'b00100;
								K <= {48'b0,Inst[20:5]};
							end
					end
					
				if(Opcode[8] == 0)
					//MovZ
					begin
					AA <= 5'b11111;
					FS <= 5'b01000;
					PC_SEL <= 2'b01;
					if(Opcode[9] == 1)
						begin
							K <= {48'b0,Inst[20:5]};
						end
					else	//MOVN
						begin
							K <= {48'b0,~Inst[20:5]};
						end
					end
			end
		if (Opcode[4:2] == 3'b110)
			//R format
			begin
				// Format Wire Assignments

						DA <= Inst[4:0];

						AA <= Inst[9:5];
						
						BA <= Inst[20:16];

						WR <= 1'b1;

						EN_ALU <= 1'b1;
						
						if((Inst[15:10] == 6'b000000) | (Opcode[1] == 1'b1))
							begin
								PC_SEL <= 2'b01; //Incrment PC
							end
						else if(State[0] == 0)
							begin
								State <= State + 1;
								PC_SEL <= 2'b00;
							end
						else
							begin
								AA <= DA;
								PC_SEL <= 2'b01;
							end

				// Status Flags
				
						SFL <= Opcode[8];

				// Arithmetic/Shift

						if(Opcode[1] == 0 & State[0] == 0)
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
						
						if(Opcode[1] == 1 | State[0] == 1)
						//Shift Wire Assignments
						begin
							K[5:0] <= Inst[15:10];
							EN_K <= 1'b1;
							State <= 3'b0;
							if(Opcode[0] == 1 )
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