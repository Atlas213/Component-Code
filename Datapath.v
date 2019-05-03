module Datapath(SA,SB,DA,WR,RST,CLK,FS,C0,PRESTAT,K,M,EN_ALU,EN_ADDR_ALU,EN_B,EN_PC,EN_ADDR_PC,PC_SEL,PS,RCS,RWE,ROE,SFL,BR_SEL,inst,out,r0, r1, r2, r3, r4, r5, r6, r7);
	input [4:0] SA; //ABUS register select
	input [4:0] SB; //BBUS register select
	input [4:0] DA; //Data input regiter select
	input WR; //Write enable
	input RST; // Reset
	input CLK; // Clock
	input [4:0] FS; //ALU function select
	input C0; // Carry in bit
	output [3:0] PRESTAT; // Status output
	input [63:0] K; // Constant input
	input M; //Mux Selection
	input EN_ALU; //Enables output of ALU to data bus
	input EN_ADDR_ALU; //Enables output of ALU to Ram address bus
	input EN_B; //ENABLE BBUS TO DBUS
	input EN_PC; //Enables PC output to databus
	input EN_ADDR_PC; //Enables PC output to ram address bus
	input PC_SEL; //Enables K to PC input at 1, A at 0
	input [1:0] PS; //Selects PC incrment function
	input RCS,RWE,ROE; // Ram Chip select, write enable, read enable
	input SFL; // Stores Status flags from ALU
	input BR_SEL;
	output [31:0] inst;
	output out;
	output [15:0] r0, r1, r2, r3, r4, r5, r6, r7;
	wire [63:0] ABUS; // A line from the register file
	wire [63:0] DBUS; // Data Bus
	wire [63:0] FBUS; // ALU output bus
	wire [63:0] BBUS; // B line from the Register file
	wire [63:0] MBUS; // B or K input to ALU
	wire [7:0] 	RABUS; // Pc or Alu input to ram
	wire [31:0] PCBUS; // PC output to data bus
	wire [29:0] IPCBUS; // Buffer connected to PC
	wire [29:0] PREIPCBUS;//A or K connected to buffer
	wire [3:0] STAT; //ALU status wires
	
	RegisterFile32x64 RegFile	(ABUS,BBUS,SA,SB,DBUS,DA,WR,RST,CLK,r0, r1, r2, r3, r4, r5, r6, r7); //Register File
	ALU_LEGv8	ALU	(ABUS, MBUS, FS, C0,FBUS, STAT); //Athrimatic Logic Unit
	PC progcount (IPCBUS[29:0],PS,CLK,PCBUS,RST); // Program Counter
	ram_sp_sr_sw RAM(CLK,RABUS,DBUS,RCS,RWE,ROE); // Random Access Memory
	
	rom_case myrom(inst,PCBUS);
	
	mux2to1_64bit	DataMux (MBUS, M, BBUS, K); // K connected to input of ALU at 1, B at 0
	mux2to1_64bit	PCMux (PREIPCBUS, BR_SEL, ABUS[29:0], K[29:0]); //K connected to Buffer input at 1, A at 0
	Stack HS(DA,SA,CLK,RST,PCBUS,IPCBUS);
	SpecialFunctionRegister SFR(CLK,RST,DBUS[15:0],RABUS[7:0],RWE,ROE,out);
	tri_buf tbufK (PREIPCBUS,IPCBUS,PC_SEL);
	tri_buf tbufB (BBUS,DBUS,EN_B); // En_B will connect the B line to the data bus
	tri_buf tbufF (FBUS,DBUS,EN_ALU); // En_ALU will connect the output of the ALU to the Databus
	tri_buf tbufDPC(PCBUS[31:0],DBUS[31:0],EN_PC); //Connects PC output to databus
	tri_buf tbufAPC(PCBUS[7:0],RABUS[7:0],EN_ADDR_PC); //Connects PC output to ram address bus
	tri_buf tbufR (FBUS[7:0],RABUS[7:0],EN_ADDR_ALU); // Connects ALu output to ram address bus
	
	RegisterNbit STATRegister(PRESTAT,STAT,SFL,RST,CLK); //SFL will store the current Status flags
	defparam STATRegister.N = 4; //Register size 4



endmodule