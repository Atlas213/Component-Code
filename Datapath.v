module Datapath(SA,SB,DA,WR,IR,RST,CLK,FS,C0,STAT,K,M,EN_ALU,EN_ADDR_ALU,EN_B,EN_PC,EN_ADDR_PC,PC_SEL,PS,r0, r1, r2, r3, r4, r5, r6, r7,RCS,RWE,ROE,CONSIG);
	input [4:0] SA; //ABUS register select
	input [4:0] SB; //BBUS register select
	input [4:0] DA; //Data input regiter select
	input WR; //Write enable
	input IR;
	input RST; // Reset
	input CLK; // Clock
	input [4:0] FS;
	input C0; // Carry in bit
	output [3:0] STAT; // Status output
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
	wire [63:0] ABUS;
	wire [63:0] DBUS;
	wire [63:0] FBUS; // ALU output bus
	wire [63:0] BBUS;
	wire [63:0] MBUS; //Mux bus
	wire [7:0] 	RABUS;
	wire [31:0] PCBUS;
	wire [29:0] IPCBUS;
	output [31:0] CONSIG;
	
	RegisterFile32x64 RegFile	(ABUS,BBUS,SA,SB,DBUS,DA,WR,RST,CLK,r0, r1, r2, r3, r4, r5, r6, r7);
	mux2to1_64bit	DataMux (MBUS, M, K, BBUS);
	mux2to1_64bit	PCMux (IPCBUS, PC_SEL, ABUS[29:0], K[29:0]);
	ALU_LEGv8	ALU	(ABUS, MBUS, FS, C0,FBUS, STAT);
	PC progcount (IPCBUS[29:0],PS,CLK,PCBUS,RST);
	tri_buf tbufB (BBUS,DBUS,EN_B);
	tri_buf tbufF (FBUS,DBUS,EN_ALU);
	tri_buf tbufDPC(PCBUS,DBUS,EN_PC);
	tri_buf tbufAPC(PCBUS,RABUS,EN_ADDR_PC);
	tri_buf tbufR (FBUS,RABUS,EN_ADDR_ALU);
	ram_sp_sr_sw RAM(CLK,RABUS,DBUS,RCS,RWE,ROE);
	RegisterNbit InstructionRegister(CONSIG,DBUS,IR,RST,CLK);
	defparam InstructionRegister.N = 32;



endmodule