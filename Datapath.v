module Datapath(SA,SB,DA,WR,IR,RST,CLK,FS,C0,PRESTAT,K,M,EN_ALU,EN_ADDR_ALU,EN_B,EN_PC,EN_ADDR_PC,PC_SEL,PS,r0, r1, r2, r3, r4, r5, r6, r7,RCS,RWE,ROE,SFL);
	input [4:0] SA; //ABUS register select
	input [4:0] SB; //BBUS register select
	input [4:0] DA; //Data input regiter select
	input WR; //Write enable
	input IR; //Load Instruction
	input RST; // Reset
	input CLK; // Clock
	input [4:0] FS;
	input C0; // Carry in bit
	output [3:0] PRESTAT; // Status output
	input [63:0] K; // Constant input
	input M; //Mux Selection
	input EN_ALU;
	input EN_ADDR_ALU;
	input EN_B; //ENABLE BBUS TO DBUS
	input EN_PC;
	input EN_ADDR_PC;
	input PC_SEL; 
	input [1:0] PS;
	output [15:0] r0, r1, r2, r3, r4, r5, r6, r7;
	input RCS,RWE,ROE;
	input SFL;
	wire [63:0] ABUS; // A line from the register file
	wire [63:0] DBUS; // Data Bus
	wire [63:0] FBUS; // ALU output bus
	wire [63:0] BBUS; // B line from the Register file
	wire [63:0] MBUS; // B or K input to ALU
	wire [7:0] 	RABUS; // Pc or Alu input to ram
	wire [31:0] PCBUS; // PC output to data bus
	wire [29:0] IPCBUS; // A or K input to PC
	wire [3:0] STAT; //ALU status wires
	
	RegisterFile32x64 RegFile	(ABUS,BBUS,SA,SB,DBUS,DA,WR,RST,CLK,r0, r1, r2, r3, r4, r5, r6, r7);
	ALU_LEGv8	ALU	(ABUS, MBUS, FS, C0,FBUS, STAT);
	PC progcount (IPCBUS[29:0],PS,CLK,PCBUS,RST);
	ram_sp_sr_sw RAM(CLK,RABUS,DBUS,RCS,RWE,ROE);
	
	
	
	mux2to1_64bit	DataMux (MBUS, M, BBUS, K);
	mux2to1_64bit	PCMux (IPCBUS, PC_SEL, ABUS[29:0], K[29:0]);
	
	tri_buf tbufB (BBUS,DBUS,EN_B); // En_B will connect the B line to the data bus
	tri_buf tbufF (FBUS,DBUS,EN_ALU); // En_ALU will connect the output of the ALU to the Databus
	tri_buf tbufDPC(PCBUS[31:0],DBUS[31:0],EN_PC);
	tri_buf tbufAPC(PCBUS[7:0],RABUS[7:0],EN_ADDR_PC);
	tri_buf tbufR (FBUS[7:0],RABUS[7:0],EN_ADDR_ALU);
	
	//RegisterNbit InstructionRegister(CONSIG,DBUS,IR,RST,CLK);
	//defparam InstructionRegister.N = 32;
	RegisterNbit STATRegister(PRESTAT,STAT,SFL,RST,CLK); //SFL will store the current Status flags
	defparam STATRegister.N = 4;



endmodule