module LookAhead_unit_4b(
    output [3:0] C,
    output PG, GG, 
    input Cin, 
    input [3:0] P, G
);

wire [2:0] P0_comb;
wire [1:0] P1_comb;
wire P2_comb;

assign P0_comb[0] = P[1] & P[0];
assign P0_comb[1] = P[2] & P0_comb[0];
assign P0_comb[2] = P[3] & P0_comb[1];

assign P1_comb[0] = P[1] & P[2];
assign P1_comb[1] = P1_comb[0] & P[3];

assign P2_comb    = P[2] & P[3];

assign PG = P0_comb[2];
assign GG = G[3] | (G[2] & P[3]) | (P2_comb & G[1]) | (P1_comb[1] & G[0]);

assign C[0] = G[0] | (P[0] & Cin);
assign C[1] = G[1] | (G[0] & P[1]) | (P0_comb[0] & Cin);
assign C[2] = G[2] | (G[1] & P[2]) | (P1_comb[0] & G[0]) | (P0_comb[1] & Cin);
assign C[3] = GG   | (PG   & Cin);

endmodule
