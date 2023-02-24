module CLA_16b(
    output [15:0] Sum, 
    output CarryOut, PG, GG,
    input Cin, 
    input [15:0] A, B
);

wire [3:0] P, G;    // P4, 8, 12, 16
wire [3:0] C;       // C4, 8, 12, 16
wire [3:0] Cout_CLA;

CLA_4b CLA4b_0(.Sum(Sum[0 +: 4]),  .CarryOut(Cout_CLA[0]), .PG(P[0]), .GG(G[0]), .Cin(Cin),  .A(A[0 +: 4]),  .B(B[0 +: 4]));
CLA_4b CLA4b_1(.Sum(Sum[4 +: 4]),  .CarryOut(Cout_CLA[1]), .PG(P[1]), .GG(G[1]), .Cin(C[0]), .A(A[4 +: 4]),  .B(B[4 +: 4]));
CLA_4b CLA4b_2(.Sum(Sum[8 +: 4]),  .CarryOut(Cout_CLA[2]), .PG(P[2]), .GG(G[2]), .Cin(C[1]), .A(A[8 +: 4]),  .B(B[8 +: 4]));
CLA_4b CLA4b_3(.Sum(Sum[12 +: 4]), .CarryOut(Cout_CLA[3]), .PG(P[3]), .GG(G[3]), .Cin(C[2]), .A(A[12 +: 4]), .B(B[12 +: 4]));

LookAhead_unit_4b LCU16b(.C(C), .Cin(Cin), .P(P), .G(G), .PG(PG), .GG(GG));

assign CarryOut = C[3];

endmodule