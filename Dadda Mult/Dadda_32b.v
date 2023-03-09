module Dadda_32b(
    output [63:0] Y,
    input [31:0] A, B
);

wire [31:0] A0B0, A0B1, A1B0, A1B1;
wire [31:0] Sum0, Co0;
wire Carry_49, Carry_63, Carry_64, PG, GG; 

Dadda_16b MULT00(A0B0, A[0 +: 16],  B[0 +: 16]);
Dadda_16b MULT01(A0B1, A[0 +: 16],  B[16 +: 16]);
Dadda_16b MULT10(A1B0, A[16 +: 16], B[0 +: 16]);
Dadda_16b MULT11(A1B1, A[16 +: 16], B[16 +: 16]);

// Step 1
CSA_1b FA00(Sum0[0],  Co0[0],  A0B0[16], A0B1[0],  A1B0[0]);
CSA_1b FA01(Sum0[1],  Co0[1],  A0B0[17], A0B1[1],  A1B0[1]);
CSA_1b FA02(Sum0[2],  Co0[2],  A0B0[18], A0B1[2],  A1B0[2]);
CSA_1b FA03(Sum0[3],  Co0[3],  A0B0[19], A0B1[3],  A1B0[3]);
CSA_1b FA04(Sum0[4],  Co0[4],  A0B0[20], A0B1[4],  A1B0[4]);
CSA_1b FA05(Sum0[5],  Co0[5],  A0B0[21], A0B1[5],  A1B0[5]);
CSA_1b FA06(Sum0[6],  Co0[6],  A0B0[22], A0B1[6],  A1B0[6]);
CSA_1b FA07(Sum0[7],  Co0[7],  A0B0[23], A0B1[7],  A1B0[7]);
CSA_1b FA08(Sum0[8],  Co0[8],  A0B0[24], A0B1[8],  A1B0[8]);
CSA_1b FA09(Sum0[9],  Co0[9],  A0B0[25], A0B1[9],  A1B0[9]);
CSA_1b FA10(Sum0[10], Co0[10], A0B0[26], A0B1[10], A1B0[10]);
CSA_1b FA11(Sum0[11], Co0[11], A0B0[27], A0B1[11], A1B0[11]);
CSA_1b FA12(Sum0[12], Co0[12], A0B0[28], A0B1[12], A1B0[12]);
CSA_1b FA13(Sum0[13], Co0[13], A0B0[29], A0B1[13], A1B0[13]);
CSA_1b FA14(Sum0[14], Co0[14], A0B0[30], A0B1[14], A1B0[14]);
CSA_1b FA15(Sum0[15], Co0[15], A0B0[31], A0B1[15], A1B0[15]);
CSA_1b FA16(Sum0[16], Co0[16], A1B1[0],  A0B1[16], A1B0[16]);
CSA_1b FA17(Sum0[17], Co0[17], A1B1[1],  A0B1[17], A1B0[17]);
CSA_1b FA18(Sum0[18], Co0[18], A1B1[2],  A0B1[18], A1B0[18]);
CSA_1b FA19(Sum0[19], Co0[19], A1B1[3],  A0B1[19], A1B0[19]);
CSA_1b FA20(Sum0[20], Co0[20], A1B1[4],  A0B1[20], A1B0[20]);
CSA_1b FA21(Sum0[21], Co0[21], A1B1[5],  A0B1[21], A1B0[21]);
CSA_1b FA22(Sum0[22], Co0[22], A1B1[6],  A0B1[22], A1B0[22]);
CSA_1b FA23(Sum0[23], Co0[23], A1B1[7],  A0B1[23], A1B0[23]);
CSA_1b FA24(Sum0[24], Co0[24], A1B1[8],  A0B1[24], A1B0[24]);
CSA_1b FA25(Sum0[25], Co0[25], A1B1[9],  A0B1[25], A1B0[25]);
CSA_1b FA26(Sum0[26], Co0[26], A1B1[10], A0B1[26], A1B0[26]);
CSA_1b FA27(Sum0[27], Co0[27], A1B1[11], A0B1[27], A1B0[27]);
CSA_1b FA28(Sum0[28], Co0[28], A1B1[12], A0B1[28], A1B0[28]);
CSA_1b FA29(Sum0[29], Co0[29], A1B1[13], A0B1[29], A1B0[29]);
CSA_1b FA30(Sum0[30], Co0[30], A1B1[14], A0B1[30], A1B0[30]);
CSA_1b FA31(Sum0[31], Co0[31], A1B1[15], A0B1[31], A1B0[31]);

assign Y[0 +: 17] = {Sum0[0], A0B0[0 +: 16]};

ADD_32b_wCLA ADD0(Y[17 +: 32], Carry_49, 1'b0, {A1B1[16], Sum0[1 +: 31]}, Co0);
CLA_16b      ADD1({Carry_63, Y[63 -: 15]}, Carry_64, PG, GG, Carry_49, {1'b0, A1B1[17 +: 15]}, 16'b0);

endmodule
