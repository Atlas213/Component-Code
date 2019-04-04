module CU(Inst);

	input [31:0] Inst;
	output [4:0] DA;
	output [4:0] AA;
	output [4:0] BA;
	output [11:0] Const;
	output reg [4:0] FS;
	output reg WR; // Write Enable
	output reg SFL; // Load Status Flags
	output reg En_K; // Enables Constant
	output reg En_ALU; // Enables ALU
	output reg Cin; // Carry In bit
	wire[10:0] Opcode;
	wire[20:0] Fields;
	
	
	
	assign Opcode = Inst[31:21];
	assign Fields = Inst[20:0];
	
	
	always@(Inst) begin
	//ZERO ALL VALUES
	if(Opcode[4] = 1)
		case(Opcode[10:8])
		//B
		3'b000 :
		//B.cond
		3'b010 :
		//BL
		3'b100 :
		//CBZ/CBNZ
		3'b101 :
		//BR
		3'b110 :
		
		endcase
	else
		case(Opcode[4:2])
		//D
		3'b000 :
		3'b010 :
			// I format
				// Status Flags
					if(Opcode[8] = 1)
							SFL <= 1'b1;
					else
							SFL <= 1'b0;
				//ADD/SUB
					if(Opcode[9] = 1)
							FS <= 5'b01001;
					else
							FS <= 5'b01000;
				//Wire Assignments
					assign DA = Inst[4:0];
					assign AA = Inst[9:5];
					assign Const = Inst[22:0];
					KSEL <= 1'b1;
			
		3'b100 :
			//Logic
				// Function Select
					case(Opcode[9:8])
						
						//AND
							2'b00 :
								FS <= 5'b00000;
						//ORR
							2'b01	:
								FS <= 5'b00100;
						//EOR
							2'b10 :
								FS <= 5'b01100;
						//ANDS
							2'b11 
								FS <= 5'b00000;
								SFL <= 1'b1;
					endcase
				//Format Select
					if(Opcode[7] = 1)
						// I format
							// Status Flags
								if(Opcode[8] = 1)
									SFL <= 1'b1;
								else
									SFL <= 1'b1;
							//General Wire Assignments
								assign DA = Inst[4:0];
								assign AA = Inst[9:5];
								assign Const = Inst[22:0];
								En_K <= 1'b1;
					else
						// R format
							//General Wire Assignments
								assign DA = Inst[4:0];
								assign AA = Inst[9:5];
								assign BA = Inst[21:16];
								WR <= 1'b1;
				
		3'b101 :
			// IW format
		3'b110 :
			//R format
				// General Wire Assignments
						assign DA = Inst[4:0];
						assign AA = Inst[9:5];
						assign BA = Inst[21:16];
						WR <= 1'b1;
						En_ALU <= 1'b1;
				// Status Flags
						if(Opcode[8] = 1)
							SFL <= 1'b1;
						else
							SFL <= 1'b1;
				// Arithmetic/Shift
					if(Opcode[1] = 0)
						//Function Select
							if(Opcode[9] = 1)
								//Sub
									FS <= 5'b01001;
									Cin <= 1'b1;
							else(Opcode[9] = 0)
								//Add
									FS <= 5'b01000;
					else
						//Shift Wire Assignments
							if(Opcode[0])
								//Shift Left
									FS <= 5'b10000;
							else
								//Shift Right
									FS <= 5'b10100;
		endcase
	
	
end