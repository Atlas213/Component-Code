module Datapath(SA,SB,DA,WR,RST,CLK,FS,C0,STAT,K,M,EN_ALU,EN_ADDR_ALU,EN_B,r0, r1, r2, r3, r4, r5, r6, r7,RCS,RWE,ROE);
	input [4:0] SA; //ABUS register select
	input [4:0] SB; //BBUS register select
	input [4:0] DA; //Data input regiter select
	input WR; //Write enable
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
	output [15:0] r0, r1, r2, r3, r4, r5, r6, r7;
	input RCS,RWE,ROE;
	wire [63:0] ABUS;
	wire [63:0] DBUS;
	wire [63:0] FBUS; // ALU output bus
	wire [63:0] BBUS;
	wire [63:0] MBUS; //Mux bus
	wire [7:0] 	RABUS;
	
	RegisterFile32x64 RegFile	(ABUS,BBUS,SA,SB,DBUS,DA,WR,RST,CLK,r0, r1, r2, r3, r4, r5, r6, r7);
	mux2to1_64bit	DataMux (MBUS, M, K, BBUS);
	ALU_LEGv8	ALU	(ABUS, MBUS, FS, C0,FBUS, STAT);
	tri_buf tbufB (BBUS,DBUS,EN_B);
	tri_buf tbufF (FBUS,DBUS,EN_ALU);
	tri_buf tbufR (FBUS,RABUS,EN_ADDR_ALU);
	ram_sp_sr_sw RAM(CLK,RABUS,DBUS,RCS,RWE,ROE);



endmodule