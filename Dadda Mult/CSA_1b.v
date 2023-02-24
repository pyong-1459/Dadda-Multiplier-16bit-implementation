module CSA_1b(
    output Sum, Co,
    input  A, B, Cin
);

assign Sum = A ^ B ^ Cin;
assign Co = (A & B) | (B & Cin) | (Cin & A);

endmodule