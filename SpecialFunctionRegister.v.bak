module SpecialFunctionRegister(CLK,RST,Data,Addr,MW,MR);
input CLK; //Clock
input RST; // Reset
inout [15:0] Data; //Data input
input [7:0] Addr; // Address input
input MW; //Memory write
input MR; // Memory read

wire Load;
wire EN_BUF;
wire Enable;
wire [4:0] SFR_ADDR;
wire [15:0]load_enable;
wire [15:0] read_enable;
wire [15:0]R00, R01, R02, R03, R04, R05, R06, R07, R08;
wire [15:0]R09, R10, R11, R12, R13, R14, R15, R16;

assign Load = Enable & MW;
assign EN_BUF = Enable & MR;

AddressDetect AD(Addr,Enable,SFR_ADDR);

Decoder5to32 decodewrite(load_enable, SFR_ADDR, Load);
Decoder5to32 decoderead(read_enable, SFR_ADDR, EN_BUF);

sfr_tri_buf RB0(R00,Data,read_enable[0]);
sfr_tri_buf RB1(R01,Data,read_enable[1]);
sfr_tri_buf RB2(R02,Data,read_enable[2]);
sfr_tri_buf RB3(R03,Data,read_enable[3]);
sfr_tri_buf RB4(R04,Data,read_enable[4]);
sfr_tri_buf RB5(R05,Data,read_enable[5]);
sfr_tri_buf RB6(R06,Data,read_enable[6]);
sfr_tri_buf RB7(R07,Data,read_enable[7]);
sfr_tri_buf RB8(R08,Data,read_enable[8]);
sfr_tri_buf RB9(R09,Data,read_enable[9]);
sfr_tri_buf RB10(R10,Data,read_enable[10]);
sfr_tri_buf RB11(R11,Data,read_enable[11]);
sfr_tri_buf RB12(R12,Data,read_enable[12]);
sfr_tri_buf RB13(R13,Data,read_enable[13]);
sfr_tri_buf RB14(R14,Data,read_enable[14]);
sfr_tri_buf RB15(R15,Data,read_enable[15]);

RegisterNbit reg00 (R00, Data, load_enable[0], RST, CLK);
RegisterNbit reg01 (R01, Data, load_enable[1], RST, CLK);
RegisterNbit reg02 (R02, Data, load_enable[2], RST, CLK);
RegisterNbit reg03 (R03, Data, load_enable[3], RST, CLK);
RegisterNbit reg04 (R04, Data, load_enable[4], RST, CLK);
RegisterNbit reg05 (R05, Data, load_enable[5], RST, CLK);
RegisterNbit reg06 (R06, Data, load_enable[6], RST, CLK);
RegisterNbit reg07 (R07, Data, load_enable[7], RST, CLK);
RegisterNbit reg08 (R08, Data, load_enable[8], RST, CLK);
RegisterNbit reg09 (R09, Data, load_enable[9], RST, CLK);
RegisterNbit reg10 (R10, Data, load_enable[10], RST, CLK);
RegisterNbit reg11 (R11, Data, load_enable[11], RST, CLK);
RegisterNbit reg12 (R12, Data, load_enable[12], RST, CLK);
RegisterNbit reg13 (R13, Data, load_enable[13], RST, CLK);
RegisterNbit reg14 (R14, Data, load_enable[14], RST, CLK);
RegisterNbit reg15 (R15, Data, load_enable[15], RST, CLK);
defparam reg00.N = 16;
defparam reg01.N = 16;
defparam reg02.N = 16;
defparam reg03.N = 16;
defparam reg04.N = 16;
defparam reg05.N = 16;
defparam reg06.N = 16;
defparam reg07.N = 16;
defparam reg08.N = 16;
defparam reg09.N = 16;
defparam reg10.N = 16;
defparam reg11.N = 16;
defparam reg12.N = 16;
defparam reg13.N = 16;
defparam reg14.N = 16;
defparam reg15.N = 16;

endmodule