module tb_16b_Dadda();

reg  [15:0] A;
reg  [15:0] B;
reg  [31:0] Y_ref [0:999];
reg  [15:0] Data [0:1999];
reg  [15:0] err;
wire [31:0] Y;

Dadda_16b TEST(Y, A, B);

integer i, j;
integer k = 1000;

initial begin
    $readmemh("input.txt", Data);
    A <= 16'h0;
    B <= 16'h0;
    #(10);
    for (i=0;i<k;i=i+1) begin
        A <= Data[i*2];
        B <= Data[i*2 + 1];
        #(10);
    end
    #15 $finish;
end

initial begin
    $readmemh("output.txt", Y_ref);
    err <= 16'h0;
    #(10)
    for (j=0;j<k;j=j+1) begin
        // $display("%h", Y_ref[j]);
        #(5);
        if (Y_ref[j] != Y) begin
            err <= err + 1;
        end
        #(5);
    end
end

// initial begin
//     A <= 16'hf0;
//     B <= 16'hf0;
//     #10
//     A <= 16'hff;
//     B <= 16'hff;
//     #10
//     A <= 16'he00;
//     B <= 16'he00;
//     #10
//     A <= 16'hffff;
//     B <= 16'hffff;
//     #10
//     A <= 16'hffff;
//     B <= 16'h1111;
//     #10
//     A <= 16'h1ff;
//     B <= 16'h014;
//     #10
//     A <= 16'h3fe;
//     B <= 16'h028;
//     #10
//     A <= 16'h7fc;
//     B <= 16'h050;
//     #10
//     A <= 16'hff8;
//     B <= 16'h0A0;
//     #10
//     $finish;
// end

endmodule