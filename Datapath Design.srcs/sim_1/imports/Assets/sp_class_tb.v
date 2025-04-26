`timescale 1ns / 1ps

module sp_class_tb;

reg [31:0] float;
wire snan, qnan, infinity, zero, subnormal, normal;
wire sign;
wire [7:0] exp;
wire [22:0] significand;

sp_class uut (
    .float(float),
    .snan(snan),
    .qnan(qnan),
    .infinity(infinity),
    .zero(zero),
    .subnormal(subnormal),
    .normal(normal),
    .sign(sign),
    .exp(exp),
    .significand(significand)
);

reg [31:0] testcases [0:9];
integer i;

initial begin
    testcases[0] = 32'h00000000; // +0
    testcases[1] = 32'h80000000; // -0
    testcases[2] = 32'h7F800000; // +inf
    testcases[3] = 32'hFF800000; // -inf
    testcases[4] = 32'h7FC00000; // qNaN
    testcases[5] = 32'h7FA00000; // sNaN
    testcases[6] = 32'h00400000; // subnormal
    testcases[7] = 32'h3F800000; // 1.0
    testcases[8] = 32'hBF800000; // -1.0
    testcases[9] = 32'h00000001; // smallest subnormal

    for (i = 0; i < 10; i = i + 1) begin
        float = testcases[i];
        #10;
        $display("float = %h, snan = %b, qnan = %b, inf = %b, zero = %b, subnormal = %b, normal = %b, sign = %b, exp = %h, sig = %h", float, snan, qnan, infinity, zero, subnormal, normal, sign, exp, significand);
    end
    $stop;
end

endmodule
