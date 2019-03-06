module RegisterFile32x64(A, B, SA, SB, D, DA, W, reset, clock, r0, r1, r2, r3, r4, r5, r6, r7);
	output [63:0]A; // A bus
	output [63:0]B; // B bus
	input [4:0]SA; // Select A - A Address
	input [4:0]SB; // Select B - B Address
	input [63:0]D; // Data input
	input [4:0]DA; // Data destination address
	input W; // write enable
	input reset; // positive logic asynchronous reset
	input clock;
	output [15:0] r0, r1, r2, r3, r4, r5, r6, r7; // outputs for visualization
	
	// create 32 load enable wires
	wire [31:0]load_enable;
	// instantiate a 5-to-32 line decoder and connect to the load enable wires
	// the cooresponding load_enable bit for DA will be on only when W is on
	Decoder5to32 decoder (load_enable, DA, W);
	
	// create 64-bit wires for each register
	wire [63:0]R00, R01, R02, R03, R04, R05, R06, R07, R08, R09;
	wire [63:0]R10, R11, R12, R13, R14, R15, R16, R17, R18, R19;
	wire [63:0]R20, R21, R22, R23, R24, R25, R26, R27, R28, R29;
	wire [63:0]R30, R31;
	
	// instantiate 31 registers
	RegisterNbit reg00 (R00, D, load_enable[0], reset, clock);
	RegisterNbit reg01 (R01, D, load_enable[1], reset, clock);
	RegisterNbit reg02 (R02, D, load_enable[2], reset, clock);
	RegisterNbit reg03 (R03, D, load_enable[3], reset, clock);
	RegisterNbit reg04 (R04, D, load_enable[4], reset, clock);
	RegisterNbit reg05 (R05, D, load_enable[5], reset, clock);
	RegisterNbit reg06 (R06, D, load_enable[6], reset, clock);
	RegisterNbit reg07 (R07, D, load_enable[7], reset, clock);
	RegisterNbit reg08 (R08, D, load_enable[8], reset, clock);
	RegisterNbit reg09 (R09, D, load_enable[9], reset, clock);
	RegisterNbit reg10 (R10, D, load_enable[10], reset, clock);
	RegisterNbit reg11 (R11, D, load_enable[11], reset, clock);
	RegisterNbit reg12 (R12, D, load_enable[12], reset, clock);
	RegisterNbit reg13 (R13, D, load_enable[13], reset, clock);
	RegisterNbit reg14 (R14, D, load_enable[14], reset, clock);
	RegisterNbit reg15 (R15, D, load_enable[15], reset, clock);
	RegisterNbit reg16 (R16, D, load_enable[16], reset, clock);
	RegisterNbit reg17 (R17, D, load_enable[17], reset, clock);
	RegisterNbit reg18 (R18, D, load_enable[18], reset, clock);
	RegisterNbit reg19 (R19, D, load_enable[19], reset, clock);
	RegisterNbit reg20 (R20, D, load_enable[20], reset, clock);
	RegisterNbit reg21 (R21, D, load_enable[21], reset, clock);
	RegisterNbit reg22 (R22, D, load_enable[22], reset, clock);
	RegisterNbit reg23 (R23, D, load_enable[23], reset, clock);
	RegisterNbit reg24 (R24, D, load_enable[24], reset, clock);
	RegisterNbit reg25 (R25, D, load_enable[25], reset, clock);
	RegisterNbit reg26 (R26, D, load_enable[26], reset, clock);
	RegisterNbit reg27 (R27, D, load_enable[27], reset, clock);
	RegisterNbit reg28 (R28, D, load_enable[28], reset, clock);
	RegisterNbit reg29 (R29, D, load_enable[29], reset, clock);
	RegisterNbit reg30 (R30, D, load_enable[30], reset, clock);
	// the last register, address 31, is always 0 for the ARMv8 architecture
	assign R31 = 64'b0;
	
	// set the number of bits for each register to 64
	defparam reg00.N = 64;
	defparam reg01.N = 64;
	defparam reg02.N = 64;
	defparam reg03.N = 64;
	defparam reg04.N = 64;
	defparam reg05.N = 64;
	defparam reg06.N = 64;
	defparam reg07.N = 64;
	defparam reg08.N = 64;
	defparam reg09.N = 64;
	defparam reg10.N = 64;
	defparam reg11.N = 64;
	defparam reg12.N = 64;
	defparam reg13.N = 64;
	defparam reg14.N = 64;
	defparam reg15.N = 64;
	defparam reg16.N = 64;
	defparam reg17.N = 64;
	defparam reg18.N = 64;
	defparam reg19.N = 64;
	defparam reg20.N = 64;
	defparam reg21.N = 64;
	defparam reg22.N = 64;
	defparam reg23.N = 64;
	defparam reg24.N = 64;
	defparam reg25.N = 64;
	defparam reg26.N = 64;
	defparam reg27.N = 64;
	defparam reg28.N = 64;
	defparam reg29.N = 64;
	defparam reg30.N = 64;
	
	// instantiate a 32:1 mux for selecting a register for the A output
	Mux32to1Nbit muxA (A, SA, R00, R01, R02, R03, R04, R05, R06, R07, R08, R09,
		  						     R10, R11, R12, R13, R14, R15, R16, R17, R18, R19,
								     R20, R21, R22, R23, R24, R25, R26, R27, R28, R29,
								     R30, R31);
	// instantiate a 32:1 mux for selecting a register for the B output
	Mux32to1Nbit muxB (B, SB, R00, R01, R02, R03, R04, R05, R06, R07, R08, R09,
		  						     R10, R11, R12, R13, R14, R15, R16, R17, R18, R19,
								     R20, R21, R22, R23, R24, R25, R26, R27, R28, R29,
								     R30, R31);
	// set the number of bits for the mux
	defparam muxA.N = 64;
	defparam muxB.N = 64;
	
	// outputs to visualize lower 16-bits of lower 8 registers on the DE0 or DE10
	assign r0 = R00[15:0];
	assign r1 = R01[15:0];
	assign r2 = R02[15:0];
	assign r3 = R03[15:0];
	assign r4 = R04[15:0];
	assign r5 = R05[15:0];
	assign r6 = R06[15:0];
	assign r7 = R07[15:0];
	
endmodule
