module CU(Inst);


//IO
	input [31:0] Inst;

	output [4:0] DA;

	output [4:0] AA;

	output [4:0] BA;

	output [11:0] Const;

	output reg [4:0] FS;
	
	output reg [1:0] PC_SEL; //register for PC select

	output reg WR; // Write Enable register
	
	output reg WRR; //Write RAM
	
	output reg RR; //Read RAM
	
	output reg RCS; 	//Chip select
	
	output reg Reset; //? is this an output shouldnt this be the same or is this
	
	output reg EN_ALU; //Enables the ALU
	
	output reg EN_B;	//Enables the B bus of the reg to data line
	
	output reg En_K; // Enables Constant (Nick: i am assuming this is the mux for the b line reg. or k)

	output reg EN_ADDR_ALU; // Enables ALU to RAM BUS
	
	output reg EN_ADDR_PC;	//Enables PC to ram bus
	
	output reg IL;	//Enables instuction load
	
	output reg Cin;	//// Carry In bit	
	
	output reg SFL; // Load Status Flags

//Wires
	wire[10:0] Opcode;

	wire[20:0] Fields;

//General Assignments	
	assign Opcode = Inst[31:21];

	assign Fields = Inst[20:0];

	

	always@(Inst) begin

	//ZERO ALL VALUES
	
	//Note from Nick: we may need a conditional statement here when considering the program
	//Counter for multicycle instructions. However this will do for now. So if Single zero else keep values.
	
	DA <= 5'b0;

	AA <=5'b0;

	BA <=5'b0;

	Const <=12'b0;

	FS <=4'b0;
	
	PC_SEL <=2'b0; 

	WR <=1'b0; 
	
	WRR <= 1'b0; 
	
	RR <=1'b0; 
	
	RCS <=1'b0; 	
	
	Reset <=1'b0;
	
	EN_ALU <= 1'b0; 
	
	EN_B <= 1'b0;	
	
	En_K <=1'b0; 
	
	EN_ADDR_ALU <= 1'b0; 
	
	EN_ADDR_PC <= 1'b0;	
	
	IL <= 1'b0;	
	
	Cin <= 1'b0;	
	
	SFL <=1'b0;
	
	
	

	if(Opcode[4] = 1)

		case(Opcode[10:8]) //I think the format needs to be diff. I.E. what we have, Value gets a variable

		//B

		3'b000 :

		//B.cond

		3'b010 :

		//BL

		3'b100 :

		//CBZ/CBNZ

		3'b101 :

		//BR

		3'b110 ;

		

		endcase

	else

		case(Opcode[4:2])

		//D

		3'b000 :

		3'b010 :

			// I format
			
				//Format Wire Assignments

					assign DA = Inst[4:0];

					assign AA = Inst[9:5];

					assign Const = Inst[22:0];

					KSEL <= 1'b1; // Enable Constant
					
					PC_SEL <= 2'b01; //Incrment PC
					
					EN_ALU <= 1'b1; //Enable ALU 
					
					WR <=1'b1; //Enable Register Write

				//Operation Specific Funtion

					if(Opcode[9] = 1)

							FS <= 5'b01001; //SUB
							Cin <= 1'b1; // Carry In Bit
							

					else

							FS <= 5'b01000; //ADD
				
				// Status Flags

					if(Opcode[8] = 1)

							SFL <= 1'b1;

					else

							SFL <= 1'b0;
		3'b100 :

			//Logic
				
				//Logic General Assignments
				
					PC_SEL <= 2'b01; //Incrment PC
					
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

							2'b11 :

								FS <= 5'b00000;

								SFL <= 1'b1;

					endcase

				//Format Select

					if(Opcode[7] = 1)

						// I format
							
							//Format Wire Assignments

								assign DA = Inst[4:0];

								assign AA = Inst[9:5];

								assign Const = Inst[22:0];

								En_K <= 1'b1;

					else

						// R format

							//Format Wire Assignments

								assign DA = Inst[4:0];

								assign AA = Inst[9:5];

								assign BA = Inst[21:16];

								WR <= 1'b1; // Register Write Enable

		3'b101 :

			// IW format

		3'b110 :

			//R format

				// Format Wire Assignments

						assign DA = Inst[4:0];

						assign AA = Inst[9:5];

						assign BA = Inst[21:16];

						WR <= 1'b1;

						En_ALU <= 1'b1;

				// Status Flags

						if(Opcode[8] = 1)

							SFL <= 1'b1;

						else

							SFL <= 1'b0;

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

endmodule 