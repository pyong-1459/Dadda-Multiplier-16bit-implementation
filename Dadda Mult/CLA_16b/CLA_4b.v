module CLA_4b(
    output [3:0] Sum, 
    output CarryOut, PG, GG,
    input Cin,
    input [3:0] A, B
);

wire [3:0] P, G;
wire [3:0] C;

FA_CLA_1b FA0(.S(Sum[0]), .P(P[0]), .G(G[0]), .A(A[0]), .B(B[0]), .Cin(Cin));
FA_CLA_1b FA1(.S(Sum[1]), .P(P[1]), .G(G[1]), .A(A[1]), .B(B[1]), .Cin(C[0]));
FA_CLA_1b FA2(.S(Sum[2]), .P(P[2]), .G(G[2]), .A(A[2]), .B(B[2]), .Cin(C[1]));
FA_CLA_1b FA3(.S(Sum[3]), .P(P[3]), .G(G[3]), .A(A[3]), .B(B[3]), .Cin(C[2]));

LookAhead_unit_4b LCU4b(.C(C), .Cin(Cin), .P(P), .G(G), .PG(PG), .GG(GG));

assign CarryOut = C[3];

endmodule

module FA_CLA_1b(
    output S, P, G,
    input A, B, Cin
);

assign P = A | B;
assign G = A & B;
assign S = (A ^ B) ^ Cin;

endmodule
