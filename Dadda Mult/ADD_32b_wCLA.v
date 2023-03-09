module ADD_32b_wCLA(
    output [31:0]  Sum, 
    output Co, 
    input Cin,
    input [31:0] A, B
);

wire [15:0] SumH0, SumH1;
wire Carry_low, Carry_high0, Carry_high1;
wire PG0, GG0;
wire PG1, GG1;
wire PG2, GG2;

CLA_16b ADDLOW  (Sum[15:0], Carry_low,   PG0, GG0, Cin,  A[15 -: 16], B[15 -: 16]);
CLA_16b ADDHIGH0(SumH0,     Carry_high0, PG1, GG1, 1'b0, A[31 -: 16], B[31 -: 16]);
CLA_16b ADDHIGH1(SumH1,     Carry_high1, PG2, GG2, 1'b1, A[31 -: 16], B[31 -: 16]);

assign Sum[31 -: 16] = Carry_low ? SumH1 : SumH0;
assign Co = Carry_low ? Carry_high1 : Carry_high0;

endmodule