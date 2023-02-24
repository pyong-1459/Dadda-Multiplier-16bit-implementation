`include "./CLA_16b/CLA_16b.v"
`include "./CLA_16b/CLA_4b.v"
`include "./CLA_16b/LCU_4b.v"
`include "./HA.v"
`include "./CSA_1b.v"

module Dadda_16b(
    output [31:0] Y, 
    input [15:0] A, B
);

wire [11:0] Step1Sum, Step1Co;
wire [43:0] Step2Sum, Step2Co;
wire [53:0] Step3Sum, Step3Co;
wire [45:0] Step4Sum, Step4Co;
wire [25:0] Step5Sum, Step5Co;
wire [27:0] Step6Sum, Step6Co;
wire [30:0] Step6A, Step6B;    // Last Step: {30} + {29, 1'b0} => 32bit Y

wire [15:0] DotProduct [0:15];
wire [15:0] Yh0, Yh1;
wire Carry_low, Carry_high0, Carry_high1, PG_low, PG_high0, PG_high1, GG_low, GG_high0, GG_high1;

genvar i;
generate
    for (i=0; i<16; i=i+1) begin
        assign DotProduct[i] = B & {16{A[i]}};
    end
endgenerate
// 15 MSB, 0 LSB
// Step 1
HA      STEP1HA0 (Step1Sum[0],  Step1Co[0],  DotProduct[13][0],  DotProduct[12][1]);                        // Col13
CSA_1b  STEP1FA00(Step1Sum[1],  Step1Co[1],  DotProduct[14][0],  DotProduct[13][1],  DotProduct[12][2]);    // Col14
HA      STEP1HA1 (Step1Sum[2],  Step1Co[2],  DotProduct[11][3],  DotProduct[10][4]);                        // Col14
CSA_1b  STEP1FA01(Step1Sum[3],  Step1Co[3],  DotProduct[15][0],  DotProduct[14][1],  DotProduct[13][2]);    // Col15
CSA_1b  STEP1FA02(Step1Sum[4],  Step1Co[4],  DotProduct[12][3],  DotProduct[11][4],  DotProduct[10][5]);    // Col15
HA      STEP1HA2 (Step1Sum[5],  Step1Co[5],  DotProduct[9][6],   DotProduct[8][7]);                         // Col15
CSA_1b  STEP1FA03(Step1Sum[6],  Step1Co[6],  DotProduct[15][1],  DotProduct[14][2],  DotProduct[13][3]);    // Col16
CSA_1b  STEP1FA04(Step1Sum[7],  Step1Co[7],  DotProduct[12][4],  DotProduct[11][5],  DotProduct[10][6]);    // Col16
HA      STEP1HA3 (Step1Sum[8],  Step1Co[8],  DotProduct[9][7],   DotProduct[8][8]);                         // Col16
CSA_1b  STEP1FA05(Step1Sum[9],  Step1Co[9],  DotProduct[15][2],  DotProduct[14][3],  DotProduct[13][4]);    // Col17
CSA_1b  STEP1FA06(Step1Sum[10], Step1Co[10], DotProduct[12][5],  DotProduct[11][6],  DotProduct[10][7]);    // Col17
CSA_1b  STEP1FA07(Step1Sum[11], Step1Co[11], DotProduct[15][3],  DotProduct[14][4],  DotProduct[13][5]);    // Col18
//------------
// Step 2
HA      STEP2HA0 (Step2Sum[0],  Step2Co[0],  DotProduct[9][0],   DotProduct[8][1]);                         // Col9
CSA_1b  STEP2FA01(Step2Sum[1],  Step2Co[1],  DotProduct[10][0],  DotProduct[9][1],   DotProduct[8][2]);     // Col10
HA      STEP2HA1 (Step2Sum[2],  Step2Co[2],  DotProduct[7][3],   DotProduct[6][4]);                         // Col10
CSA_1b  STEP2FA02(Step2Sum[3],  Step2Co[3],  DotProduct[11][0],  DotProduct[10][1],  DotProduct[9][2]);     // Col11
CSA_1b  STEP2FA03(Step2Sum[4],  Step2Co[4],  DotProduct[8][3],   DotProduct[7][4],   DotProduct[6][5]);     // Col11
HA      STEP2HA2 (Step2Sum[5],  Step2Co[5],  DotProduct[5][6],   DotProduct[4][7]);                         // Col11
CSA_1b  STEP2FA04(Step2Sum[6],  Step2Co[6],  DotProduct[12][0],  DotProduct[11][1],  DotProduct[10][2]);    // Col12
CSA_1b  STEP2FA05(Step2Sum[7],  Step2Co[7],  DotProduct[9][3],   DotProduct[8][4],   DotProduct[7][5]);     // Col12
CSA_1b  STEP2FA06(Step2Sum[8],  Step2Co[8],  DotProduct[6][6],   DotProduct[5][7],   DotProduct[4][8]);     // Col12
HA      STEP2HA3 (Step2Sum[9],  Step2Co[9],  DotProduct[3][9],   DotProduct[2][10]);                        // Col12
CSA_1b  STEP2FA07(Step2Sum[10], Step2Co[10], Step1Sum[0],        DotProduct[11][2],  DotProduct[10][3]);    // Col13
CSA_1b  STEP2FA08(Step2Sum[11], Step2Co[11], DotProduct[9][4],   DotProduct[8][5],   DotProduct[7][6]);     // Col13
CSA_1b  STEP2FA09(Step2Sum[12], Step2Co[12], DotProduct[6][7],   DotProduct[5][8],   DotProduct[4][9]);     // Col13
CSA_1b  STEP2FA10(Step2Sum[13], Step2Co[13], DotProduct[3][10],  DotProduct[2][11],  DotProduct[1][12]);    // Col13
CSA_1b  STEP2FA11(Step2Sum[14], Step2Co[14], Step1Sum[1],        Step1Sum[2],        Step1Co[0]);           // Col14
CSA_1b  STEP2FA12(Step2Sum[15], Step2Co[15], DotProduct[9][5],   DotProduct[8][6],   DotProduct[7][7]);     // Col14
CSA_1b  STEP2FA13(Step2Sum[16], Step2Co[16], DotProduct[6][8],   DotProduct[5][9],   DotProduct[4][10]);    // Col14
CSA_1b  STEP2FA14(Step2Sum[17], Step2Co[17], DotProduct[3][11],  DotProduct[2][12],  DotProduct[1][13]);    // Col14
CSA_1b  STEP2FA15(Step2Sum[18], Step2Co[18], Step1Sum[3],        Step1Sum[4],        Step1Sum[5]);          // Col15
CSA_1b  STEP2FA16(Step2Sum[19], Step2Co[19], Step1Co[1],         Step1Co[2],         DotProduct[7][8]);     // Col15
CSA_1b  STEP2FA17(Step2Sum[20], Step2Co[20], DotProduct[6][9],   DotProduct[5][10],  DotProduct[4][11]);    // Col15
CSA_1b  STEP2FA18(Step2Sum[21], Step2Co[21], DotProduct[3][12],  DotProduct[2][13],  DotProduct[1][14]);    // Col15
CSA_1b  STEP2FA19(Step2Sum[22], Step2Co[22], Step1Sum[6],        Step1Sum[7],        Step1Sum[8]);          // Col16
CSA_1b  STEP2FA20(Step2Sum[23], Step2Co[23], Step1Co[3],         Step1Co[4],         Step1Co[5]);           // Col16
CSA_1b  STEP2FA21(Step2Sum[24], Step2Co[24], DotProduct[7][9],   DotProduct[6][10],  DotProduct[5][11]);    // Col16
CSA_1b  STEP2FA22(Step2Sum[25], Step2Co[25], DotProduct[4][12],  DotProduct[3][13],  DotProduct[2][14]);    // Col16
CSA_1b  STEP2FA23(Step2Sum[26], Step2Co[26], Step1Sum[9],        Step1Sum[10],       Step1Co[6]);           // Col17
CSA_1b  STEP2FA24(Step2Sum[27], Step2Co[27], Step1Co[7],         Step1Co[8],         DotProduct[9][8]);     // Col17
CSA_1b  STEP2FA25(Step2Sum[28], Step2Co[28], DotProduct[8][9],   DotProduct[7][10],  DotProduct[6][11]);    // Col17
CSA_1b  STEP2FA26(Step2Sum[29], Step2Co[29], DotProduct[5][12],  DotProduct[4][13],  DotProduct[3][14]);    // Col17
CSA_1b  STEP2FA27(Step2Sum[30], Step2Co[30], Step1Sum[11],       Step1Co[9],         Step1Co[10]);          // Col18
CSA_1b  STEP2FA28(Step2Sum[31], Step2Co[31], DotProduct[12][6],  DotProduct[11][7],  DotProduct[10][8]);    // Col18
CSA_1b  STEP2FA29(Step2Sum[32], Step2Co[32], DotProduct[9][9],   DotProduct[8][10],  DotProduct[7][11]);    // Col18
CSA_1b  STEP2FA30(Step2Sum[33], Step2Co[33], DotProduct[6][12],  DotProduct[5][13],  DotProduct[4][14]);    // Col18
CSA_1b  STEP2FA31(Step2Sum[34], Step2Co[34], Step1Co[11],        DotProduct[15][4],  DotProduct[14][5]);    // Col19
CSA_1b  STEP2FA32(Step2Sum[35], Step2Co[35], DotProduct[13][6],  DotProduct[12][7],  DotProduct[11][8]);    // Col19
CSA_1b  STEP2FA33(Step2Sum[36], Step2Co[36], DotProduct[10][9],  DotProduct[9][10],  DotProduct[8][11]);    // Col19
CSA_1b  STEP2FA34(Step2Sum[37], Step2Co[37], DotProduct[7][12],  DotProduct[6][13],  DotProduct[5][14]);    // Col19
CSA_1b  STEP2FA35(Step2Sum[38], Step2Co[38], DotProduct[15][5],  DotProduct[14][6],  DotProduct[13][7]);    // Col20
CSA_1b  STEP2FA36(Step2Sum[39], Step2Co[39], DotProduct[12][8],  DotProduct[11][9],  DotProduct[10][10]);   // Col20
CSA_1b  STEP2FA37(Step2Sum[40], Step2Co[40], DotProduct[9][11],  DotProduct[8][12],  DotProduct[7][13]);    // Col20
CSA_1b  STEP2FA38(Step2Sum[41], Step2Co[41], DotProduct[15][6],  DotProduct[14][7],  DotProduct[13][8]);    // Col21
CSA_1b  STEP2FA39(Step2Sum[42], Step2Co[42], DotProduct[12][9],  DotProduct[11][10], DotProduct[10][11]);   // Col21
CSA_1b  STEP2FA40(Step2Sum[43], Step2Co[43], DotProduct[15][7],  DotProduct[14][8],  DotProduct[13][9]);    // Col22
//------------
// Step 3
HA      STEP3HA0 (Step3Sum[0],  Step3Co[0],  DotProduct[6][0],   DotProduct[5][1]);                         // Col6
CSA_1b  STEP3FA00(Step3Sum[1],  Step3Co[1],  DotProduct[7][0],   DotProduct[6][1],   DotProduct[5][2]);     // Col7
HA      STEP3HA1 (Step3Sum[2],  Step3Co[2],  DotProduct[4][3],   DotProduct[3][4]);                         // Col7
CSA_1b  STEP3FA01(Step3Sum[3],  Step3Co[3],  DotProduct[8][0],   DotProduct[7][1],   DotProduct[6][2]);     // Col8
CSA_1b  STEP3FA02(Step3Sum[4],  Step3Co[4],  DotProduct[5][3],   DotProduct[4][4],   DotProduct[3][5]);     // Col8
HA      STEP3HA2 (Step3Sum[5],  Step3Co[5],  DotProduct[2][6],   DotProduct[1][7]);                         // Col8
CSA_1b  STEP3FA03(Step3Sum[6],  Step3Co[6],  Step2Sum[0],        DotProduct[7][2],   DotProduct[6][3]);     // Col9
CSA_1b  STEP3FA04(Step3Sum[7],  Step3Co[7],  DotProduct[5][4],   DotProduct[4][5],   DotProduct[3][6]);     // Col9
CSA_1b  STEP3FA05(Step3Sum[8],  Step3Co[8],  DotProduct[2][7],   DotProduct[1][8],   DotProduct[0][9]);     // Col9
CSA_1b  STEP3FA06(Step3Sum[9],  Step3Co[9],  Step2Sum[1],        Step2Sum[2],        Step2Co[0]);           // Col10
CSA_1b  STEP3FA07(Step3Sum[10], Step3Co[10], DotProduct[5][5],   DotProduct[4][6],   DotProduct[3][7]);     // Col10
CSA_1b  STEP3FA08(Step3Sum[11], Step3Co[11], DotProduct[2][8],   DotProduct[1][9],   DotProduct[0][10]);    // Col10
CSA_1b  STEP3FA09(Step3Sum[12], Step3Co[12], Step2Sum[3],        Step2Sum[4],        Step2Sum[5]);          // Col11
CSA_1b  STEP3FA10(Step3Sum[13], Step3Co[13], Step2Co[1],         Step2Co[2],         DotProduct[3][8]);     // Col11
CSA_1b  STEP3FA11(Step3Sum[14], Step3Co[14], DotProduct[2][9],   DotProduct[1][10],  DotProduct[0][11]);    // Col11
CSA_1b  STEP3FA12(Step3Sum[15], Step3Co[15], Step2Sum[6],        Step2Sum[7],        Step2Sum[8]);          // Col12
CSA_1b  STEP3FA13(Step3Sum[16], Step3Co[16], Step2Sum[9],        Step2Co[3],         Step2Co[4]);           // Col12
CSA_1b  STEP3FA14(Step3Sum[17], Step3Co[17], Step2Co[5],         DotProduct[1][11],  DotProduct[0][12]);    // Col12
CSA_1b  STEP3FA15(Step3Sum[18], Step3Co[18], Step2Sum[10],       Step2Sum[11],       Step2Sum[12]);         // Col13
CSA_1b  STEP3FA16(Step3Sum[19], Step3Co[19], Step2Sum[13],       Step2Co[6],         Step2Co[7]);           // Col13
CSA_1b  STEP3FA17(Step3Sum[20], Step3Co[20], Step2Co[8],         Step2Co[9],         DotProduct[0][13]);    // Col13
CSA_1b  STEP3FA18(Step3Sum[21], Step3Co[21], Step2Sum[14],       Step2Sum[15],       Step2Sum[16]);         // Col14
CSA_1b  STEP3FA19(Step3Sum[22], Step3Co[22], Step2Sum[17],       Step2Co[10],        Step2Co[11]);          // Col14
CSA_1b  STEP3FA20(Step3Sum[23], Step3Co[23], Step2Co[12],        Step2Co[13],        DotProduct[0][14]);    // Col14
CSA_1b  STEP3FA21(Step3Sum[24], Step3Co[24], Step2Sum[18],       Step2Sum[19],       Step2Sum[20]);         // Col15
CSA_1b  STEP3FA22(Step3Sum[25], Step3Co[25], Step2Sum[21],       Step2Co[14],        Step2Co[15]);          // Col15
CSA_1b  STEP3FA23(Step3Sum[26], Step3Co[26], Step2Co[16],        Step2Co[17],        DotProduct[0][15]);    // Col15
CSA_1b  STEP3FA24(Step3Sum[27], Step3Co[27], Step2Sum[22],       Step2Sum[23],       Step2Sum[24]);         // Col16
CSA_1b  STEP3FA25(Step3Sum[28], Step3Co[28], Step2Sum[25],       Step2Co[18],        Step2Co[19]);          // Col16
CSA_1b  STEP3FA26(Step3Sum[29], Step3Co[29], Step2Co[20],        Step2Co[21],        DotProduct[1][15]);    // Col16
CSA_1b  STEP3FA27(Step3Sum[30], Step3Co[30], Step2Sum[26],       Step2Sum[27],       Step2Sum[28]);         // Col17
CSA_1b  STEP3FA28(Step3Sum[31], Step3Co[31], Step2Sum[29],       Step2Co[22],        Step2Co[23]);          // Col17
CSA_1b  STEP3FA29(Step3Sum[32], Step3Co[32], Step2Co[24],        Step2Co[25],        DotProduct[2][15]);    // Col17
CSA_1b  STEP3FA30(Step3Sum[33], Step3Co[33], Step2Sum[30],       Step2Sum[31],       Step2Sum[32]);         // Col18
CSA_1b  STEP3FA31(Step3Sum[34], Step3Co[34], Step2Sum[33],       Step2Co[26],        Step2Co[27]);          // Col18
CSA_1b  STEP3FA32(Step3Sum[35], Step3Co[35], Step2Co[28],        Step2Co[29],        DotProduct[3][15]);    // Col18
CSA_1b  STEP3FA33(Step3Sum[36], Step3Co[36], Step2Sum[34],       Step2Sum[35],       Step2Sum[36]);         // Col19
CSA_1b  STEP3FA34(Step3Sum[37], Step3Co[37], Step2Sum[37],       Step2Co[30],        Step2Co[31]);          // Col19
CSA_1b  STEP3FA35(Step3Sum[38], Step3Co[38], Step2Co[32],        Step2Co[33],        DotProduct[4][15]);    // Col19
CSA_1b  STEP3FA36(Step3Sum[39], Step3Co[39], Step2Sum[38],       Step2Sum[39],       Step2Sum[40]);         // Col20
CSA_1b  STEP3FA37(Step3Sum[40], Step3Co[40], Step2Co[34],        Step2Co[35],        Step2Co[36]);          // Col20
CSA_1b  STEP3FA38(Step3Sum[41], Step3Co[41], Step2Co[37],        DotProduct[6][14],  DotProduct[5][15]);    // Col20
CSA_1b  STEP3FA39(Step3Sum[42], Step3Co[42], Step2Sum[41],       Step2Sum[42],       Step2Co[38]);          // Col21
CSA_1b  STEP3FA40(Step3Sum[43], Step3Co[43], Step2Co[39],        Step2Co[40],        DotProduct[9][12]);    // Col21
CSA_1b  STEP3FA41(Step3Sum[44], Step3Co[44], DotProduct[8][13],  DotProduct[7][14],  DotProduct[6][15]);    // Col21
CSA_1b  STEP3FA42(Step3Sum[45], Step3Co[45], Step2Sum[43],       Step2Co[41],        Step2Co[42]);          // Col22
CSA_1b  STEP3FA43(Step3Sum[46], Step3Co[46], DotProduct[12][10], DotProduct[11][11], DotProduct[10][12]);   // Col22
CSA_1b  STEP3FA44(Step3Sum[47], Step3Co[47], DotProduct[9][13],  DotProduct[8][14],  DotProduct[7][15]);    // Col22
CSA_1b  STEP3FA45(Step3Sum[48], Step3Co[48], Step2Co[43],        DotProduct[15][8],  DotProduct[14][9]);    // Col23
CSA_1b  STEP3FA46(Step3Sum[49], Step3Co[49], DotProduct[13][10], DotProduct[12][11], DotProduct[11][12]);   // Col23
CSA_1b  STEP3FA47(Step3Sum[50], Step3Co[50], DotProduct[10][13], DotProduct[9][14],  DotProduct[8][15]);    // Col23
CSA_1b  STEP3FA48(Step3Sum[51], Step3Co[51], DotProduct[15][9],  DotProduct[14][10], DotProduct[13][11]);   // Col24
CSA_1b  STEP3FA49(Step3Sum[52], Step3Co[52], DotProduct[12][12], DotProduct[11][13], DotProduct[10][14]);   // Col24
CSA_1b  STEP3FA50(Step3Sum[53], Step3Co[53], DotProduct[15][10], DotProduct[14][11], DotProduct[13][12]);   // Col25
//------------
// Step 4
HA      STEP4HA0 (Step4Sum[0],  Step4Co[0],  DotProduct[4][0],   DotProduct[3][1]);                         // Col4
CSA_1b  STEP4FA00(Step4Sum[1],  Step4Co[1],  DotProduct[5][0],   DotProduct[4][1],   DotProduct[3][2]);     // Col5
HA      STEP4HA1 (Step4Sum[2],  Step4Co[2],  DotProduct[2][3],   DotProduct[1][4]);                         // Col5
CSA_1b  STEP4FA01(Step4Sum[3],  Step4Co[3],  Step3Sum[0],        DotProduct[4][2],   DotProduct[3][3]);     // Col6
CSA_1b  STEP4FA02(Step4Sum[4],  Step4Co[4],  DotProduct[2][4],   DotProduct[1][5],   DotProduct[0][6]);     // Col6
CSA_1b  STEP4FA03(Step4Sum[5],  Step4Co[5],  Step3Sum[1],        Step3Sum[2],        Step3Co[0]);           // Col7
CSA_1b  STEP4FA04(Step4Sum[6],  Step4Co[6],  DotProduct[2][5],   DotProduct[1][6],   DotProduct[0][7]);     // Col7
CSA_1b  STEP4FA05(Step4Sum[7],  Step4Co[7],  Step3Sum[3],        Step3Sum[4],        Step3Sum[5]);          // Col8
CSA_1b  STEP4FA06(Step4Sum[8],  Step4Co[8],  Step3Co[1],         Step3Co[2],         DotProduct[0][8]);     // Col8
CSA_1b  STEP4FA07(Step4Sum[9],  Step4Co[9],  Step3Sum[6],        Step3Sum[7],        Step3Sum[8]);          // Col9
CSA_1b  STEP4FA08(Step4Sum[10], Step4Co[10], Step3Co[3],         Step3Co[4],         Step3Co[5]);           // Col9
CSA_1b  STEP4FA09(Step4Sum[11], Step4Co[11], Step3Sum[9],        Step3Sum[10],       Step3Sum[11]);         // Col10
CSA_1b  STEP4FA10(Step4Sum[12], Step4Co[12], Step3Co[6],         Step3Co[7],         Step3Co[8]);           // Col10
CSA_1b  STEP4FA11(Step4Sum[13], Step4Co[13], Step3Sum[12],       Step3Sum[13],       Step3Sum[14]);         // Col11
CSA_1b  STEP4FA12(Step4Sum[14], Step4Co[14], Step3Co[9],         Step3Co[10],        Step3Co[11]);          // Col11
CSA_1b  STEP4FA13(Step4Sum[15], Step4Co[15], Step3Sum[15],       Step3Sum[16],       Step3Sum[17]);         // Col12
CSA_1b  STEP4FA14(Step4Sum[16], Step4Co[16], Step3Co[12],        Step3Co[13],        Step3Co[14]);          // Col12
CSA_1b  STEP4FA15(Step4Sum[17], Step4Co[17], Step3Sum[18],       Step3Sum[19],       Step3Sum[20]);         // Col13
CSA_1b  STEP4FA16(Step4Sum[18], Step4Co[18], Step3Co[15],        Step3Co[16],        Step3Co[17]);          // Col13
CSA_1b  STEP4FA17(Step4Sum[19], Step4Co[19], Step3Sum[21],       Step3Sum[22],       Step3Sum[23]);         // Col14
CSA_1b  STEP4FA18(Step4Sum[20], Step4Co[20], Step3Co[18],        Step3Co[19],        Step3Co[20]);          // Col14
CSA_1b  STEP4FA19(Step4Sum[21], Step4Co[21], Step3Sum[24],       Step3Sum[25],       Step3Sum[26]);         // Col15
CSA_1b  STEP4FA20(Step4Sum[22], Step4Co[22], Step3Co[21],        Step3Co[22],        Step3Co[23]);          // Col15
CSA_1b  STEP4FA21(Step4Sum[23], Step4Co[23], Step3Sum[27],       Step3Sum[28],       Step3Sum[29]);         // Col16
CSA_1b  STEP4FA22(Step4Sum[24], Step4Co[24], Step3Co[24],        Step3Co[25],        Step3Co[26]);          // Col16
CSA_1b  STEP4FA23(Step4Sum[25], Step4Co[25], Step3Sum[30],       Step3Sum[31],       Step3Sum[32]);         // Col17
CSA_1b  STEP4FA24(Step4Sum[26], Step4Co[26], Step3Co[27],        Step3Co[28],        Step3Co[29]);          // Col17
CSA_1b  STEP4FA25(Step4Sum[27], Step4Co[27], Step3Sum[33],       Step3Sum[34],       Step3Sum[35]);         // Col18
CSA_1b  STEP4FA26(Step4Sum[28], Step4Co[28], Step3Co[30],        Step3Co[31],        Step3Co[32]);          // Col18
CSA_1b  STEP4FA27(Step4Sum[29], Step4Co[29], Step3Sum[36],       Step3Sum[37],       Step3Sum[38]);         // Col19
CSA_1b  STEP4FA28(Step4Sum[30], Step4Co[30], Step3Co[33],        Step3Co[34],        Step3Co[35]);          // Col19
CSA_1b  STEP4FA29(Step4Sum[31], Step4Co[31], Step3Sum[39],       Step3Sum[40],       Step3Sum[41]);         // Col20
CSA_1b  STEP4FA30(Step4Sum[32], Step4Co[32], Step3Co[36],        Step3Co[37],        Step3Co[38]);          // Col20
CSA_1b  STEP4FA31(Step4Sum[33], Step4Co[33], Step3Sum[42],       Step3Sum[43],       Step3Sum[44]);         // Col21
CSA_1b  STEP4FA32(Step4Sum[34], Step4Co[34], Step3Co[39],        Step3Co[40],        Step3Co[41]);          // Col21
CSA_1b  STEP4FA33(Step4Sum[35], Step4Co[35], Step3Sum[45],       Step3Sum[46],       Step3Sum[47]);         // Col22
CSA_1b  STEP4FA34(Step4Sum[36], Step4Co[36], Step3Co[42],        Step3Co[43],        Step3Co[44]);          // Col22
CSA_1b  STEP4FA35(Step4Sum[37], Step4Co[37], Step3Sum[48],       Step3Sum[49],       Step3Sum[50]);         // Col23
CSA_1b  STEP4FA36(Step4Sum[38], Step4Co[38], Step3Co[45],        Step3Co[46],        Step3Co[47]);          // Col23
CSA_1b  STEP4FA37(Step4Sum[39], Step4Co[39], Step3Sum[51],       Step3Sum[52],       Step3Co[48]);          // Col24
CSA_1b  STEP4FA38(Step4Sum[40], Step4Co[40], Step3Co[49],        Step3Co[50],        DotProduct[9][15]);    // Col24
CSA_1b  STEP4FA39(Step4Sum[41], Step4Co[41], Step3Sum[53],       Step3Co[51],        Step3Co[52]);          // Col25
CSA_1b  STEP4FA40(Step4Sum[42], Step4Co[42], DotProduct[12][13], DotProduct[11][14], DotProduct[10][15]);   // Col25
CSA_1b  STEP4FA41(Step4Sum[43], Step4Co[43], Step3Co[53],        DotProduct[15][11], DotProduct[14][12]);   // Col26
CSA_1b  STEP4FA42(Step4Sum[44], Step4Co[44], DotProduct[13][13], DotProduct[12][14], DotProduct[11][15]);   // Col26
CSA_1b  STEP4FA43(Step4Sum[45], Step4Co[45], DotProduct[15][12], DotProduct[14][13], DotProduct[13][14]);   // Col27
//------------
// Step 5
HA      STEP5HA0 (Step5Sum[0],  Step5Co[0],  DotProduct[3][0],   DotProduct[2][1]);                         // Col3
CSA_1b  STEP5FA00(Step5Sum[1],  Step5Co[1],  Step4Sum[0],        DotProduct[2][2],   DotProduct[1][3]);     // Col4
CSA_1b  STEP5FA01(Step5Sum[2],  Step5Co[2],  Step4Sum[1],        Step4Sum[2],        Step4Co[0]);           // Col5
CSA_1b  STEP5FA02(Step5Sum[3],  Step5Co[3],  Step4Sum[3],        Step4Sum[4],        Step4Co[1]);           // Col6
CSA_1b  STEP5FA03(Step5Sum[4],  Step5Co[4],  Step4Sum[5],        Step4Sum[6],        Step4Co[3]);           // Col7
CSA_1b  STEP5FA04(Step5Sum[5],  Step5Co[5],  Step4Sum[7],        Step4Sum[8],        Step4Co[5]);           // Col8
CSA_1b  STEP5FA05(Step5Sum[6],  Step5Co[6],  Step4Sum[9],        Step4Sum[10],       Step4Co[7]);           // Col9
CSA_1b  STEP5FA06(Step5Sum[7],  Step5Co[7],  Step4Sum[11],       Step4Sum[12],       Step4Co[9]);           // Col10
CSA_1b  STEP5FA07(Step5Sum[8],  Step5Co[8],  Step4Sum[13],       Step4Sum[14],       Step4Co[11]);          // Col11
CSA_1b  STEP5FA08(Step5Sum[9],  Step5Co[9],  Step4Sum[15],       Step4Sum[16],       Step4Co[13]);          // Col12
CSA_1b  STEP5FA09(Step5Sum[10], Step5Co[10], Step4Sum[17],       Step4Sum[18],       Step4Co[15]);          // Col13
CSA_1b  STEP5FA10(Step5Sum[11], Step5Co[11], Step4Sum[19],       Step4Sum[20],       Step4Co[17]);          // Col14
CSA_1b  STEP5FA11(Step5Sum[12], Step5Co[12], Step4Sum[21],       Step4Sum[22],       Step4Co[19]);          // Col15
CSA_1b  STEP5FA12(Step5Sum[13], Step5Co[13], Step4Sum[23],       Step4Sum[24],       Step4Co[21]);          // Col16
CSA_1b  STEP5FA13(Step5Sum[14], Step5Co[14], Step4Sum[25],       Step4Sum[26],       Step4Co[23]);          // Col17
CSA_1b  STEP5FA14(Step5Sum[15], Step5Co[15], Step4Sum[27],       Step4Sum[28],       Step4Co[25]);          // Col18
CSA_1b  STEP5FA15(Step5Sum[16], Step5Co[16], Step4Sum[29],       Step4Sum[30],       Step4Co[27]);          // Col19
CSA_1b  STEP5FA16(Step5Sum[17], Step5Co[17], Step4Sum[31],       Step4Sum[32],       Step4Co[29]);          // Col20
CSA_1b  STEP5FA17(Step5Sum[18], Step5Co[18], Step4Sum[33],       Step4Sum[34],       Step4Co[31]);          // Col21
CSA_1b  STEP5FA18(Step5Sum[19], Step5Co[19], Step4Sum[35],       Step4Sum[36],       Step4Co[33]);          // Col22
CSA_1b  STEP5FA19(Step5Sum[20], Step5Co[20], Step4Sum[37],       Step4Sum[38],       Step4Co[35]);          // Col23
CSA_1b  STEP5FA20(Step5Sum[21], Step5Co[21], Step4Sum[39],       Step4Sum[40],       Step4Co[37]);          // Col24
CSA_1b  STEP5FA21(Step5Sum[22], Step5Co[22], Step4Sum[41],       Step4Sum[42],       Step4Co[39]);          // Col25
CSA_1b  STEP5FA22(Step5Sum[23], Step5Co[23], Step4Sum[43],       Step4Sum[44],       Step4Co[41]);          // Col26
CSA_1b  STEP5FA23(Step5Sum[24], Step5Co[24], Step4Sum[45],       Step4Co[43],        Step4Co[44]);          // Col27
CSA_1b  STEP5FA24(Step5Sum[25], Step5Co[25], Step4Co[45],        DotProduct[15][13], DotProduct[14][14]);   // Col28
//------------
// Step 6
HA      STEP6HA0 (Step6Sum[0],  Step6Co[0],  DotProduct[2][0],   DotProduct[1][1]);                         // Col2
CSA_1b  STEP6FA00(Step6Sum[1],  Step6Co[1],  Step5Sum[0],        DotProduct[1][2],   DotProduct[0][3]);     // Col3
CSA_1b  STEP6FA01(Step6Sum[2],  Step6Co[2],  Step5Sum[1],        Step5Co[0],         DotProduct[0][4]);     // Col4
CSA_1b  STEP6FA02(Step6Sum[3],  Step6Co[3],  Step5Sum[2],        Step5Co[1],         DotProduct[0][5]);     // Col5
CSA_1b  STEP6FA03(Step6Sum[4],  Step6Co[4],  Step5Sum[3],        Step5Co[2],         Step4Co[2]);           // Col6
CSA_1b  STEP6FA04(Step6Sum[5],  Step6Co[5],  Step5Sum[4],        Step5Co[3],         Step4Co[4]);           // Col7
CSA_1b  STEP6FA05(Step6Sum[6],  Step6Co[6],  Step5Sum[5],        Step5Co[4],         Step4Co[6]);           // Col8
CSA_1b  STEP6FA06(Step6Sum[7],  Step6Co[7],  Step5Sum[6],        Step5Co[5],         Step4Co[8]);           // Col9
CSA_1b  STEP6FA07(Step6Sum[8],  Step6Co[8],  Step5Sum[7],        Step5Co[6],         Step4Co[10]);          // Col10
CSA_1b  STEP6FA08(Step6Sum[9],  Step6Co[9],  Step5Sum[8],        Step5Co[7],         Step4Co[12]);          // Col11
CSA_1b  STEP6FA10(Step6Sum[10], Step6Co[10], Step5Sum[9],        Step5Co[8],         Step4Co[14]);          // Col12
CSA_1b  STEP6FA11(Step6Sum[11], Step6Co[11], Step5Sum[10],       Step5Co[9],         Step4Co[16]);          // Col13
CSA_1b  STEP6FA12(Step6Sum[12], Step6Co[12], Step5Sum[11],       Step5Co[10],        Step4Co[18]);          // Col14
CSA_1b  STEP6FA13(Step6Sum[13], Step6Co[13], Step5Sum[12],       Step5Co[11],        Step4Co[20]);          // Col15
CSA_1b  STEP6FA14(Step6Sum[14], Step6Co[14], Step5Sum[13],       Step5Co[12],        Step4Co[22]);          // Col16
CSA_1b  STEP6FA15(Step6Sum[15], Step6Co[15], Step5Sum[14],       Step5Co[13],        Step4Co[24]);          // Col17
CSA_1b  STEP6FA16(Step6Sum[16], Step6Co[16], Step5Sum[15],       Step5Co[14],        Step4Co[26]);          // Col18
CSA_1b  STEP6FA17(Step6Sum[17], Step6Co[17], Step5Sum[16],       Step5Co[15],        Step4Co[28]);          // Col19
CSA_1b  STEP6FA18(Step6Sum[18], Step6Co[18], Step5Sum[17],       Step5Co[16],        Step4Co[30]);          // Col20
CSA_1b  STEP6FA19(Step6Sum[19], Step6Co[19], Step5Sum[18],       Step5Co[17],        Step4Co[32]);          // Col21
CSA_1b  STEP6FA20(Step6Sum[20], Step6Co[20], Step5Sum[19],       Step5Co[18],        Step4Co[34]);          // Col22
CSA_1b  STEP6FA21(Step6Sum[21], Step6Co[21], Step5Sum[20],       Step5Co[19],        Step4Co[36]);          // Col23
CSA_1b  STEP6FA22(Step6Sum[22], Step6Co[22], Step5Sum[21],       Step5Co[20],        Step4Co[38]);          // Col24
CSA_1b  STEP6FA23(Step6Sum[23], Step6Co[23], Step5Sum[22],       Step5Co[21],        Step4Co[40]);          // Col25
CSA_1b  STEP6FA24(Step6Sum[24], Step6Co[24], Step5Sum[23],       Step5Co[22],        Step4Co[42]);          // Col26
CSA_1b  STEP6FA25(Step6Sum[25], Step6Co[25], Step5Sum[24],       Step5Co[23],        DotProduct[12][15]);   // Col27
CSA_1b  STEP6FA26(Step6Sum[26], Step6Co[26], Step5Sum[25],       Step5Co[24],        DotProduct[13][15]);   // Col28
CSA_1b  STEP6FA27(Step6Sum[27], Step6Co[27], Step5Co[25],        DotProduct[15][14], DotProduct[14][15]);   // Col29

assign Step6A = {Step6Co[27], Step6Sum, DotProduct[1][0], DotProduct[0][0]};
assign Step6B = {DotProduct[15][15], Step6Co[26:0], DotProduct[0][2], DotProduct[0][1], 1'b0};

CLA_16b ADDLOW  (Y[15:0], Carry_low, PG_low, GG_low,   1'b0, Step6A[0 +: 16], Step6B[0 +: 16]);
CLA_16b ADDHIGH0(Yh0, Carry_high0, PG_high0, GG_high0, 1'b0, {1'b0, Step6A[16 +: 15]}, {1'b0, Step6B[16 +: 15]});  // 0 Carry prediction
CLA_16b ADDHIGH1(Yh1, Carry_high1, PG_high1, GG_high1, 1'b1, {1'b0, Step6A[16 +: 15]}, {1'b0, Step6B[16 +: 15]});  // 1 Carry prediction

assign Y[31 -: 16] = Carry_low ? Yh1 : Yh0;

endmodule