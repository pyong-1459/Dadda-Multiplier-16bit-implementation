module HA(
    output Sum, Co,
    input  A, B
);

assign Sum = A ^ B;
assign Co = A & B;

endmodule