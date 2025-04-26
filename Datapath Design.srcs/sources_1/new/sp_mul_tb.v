`timescale 1ns / 1ps

module sp_mul_tb;

reg  [31:0] a, b;
wire [31:0] product;

sp_mul uut (
    .a(a),
    .b(b),
    .product(product)
);

// Test inputs
reg [31:0] A_vals [0:9];
reg [31:0] B_vals [0:9];

integer i;

initial begin
    // Example test pairs (IEEE-754 hex format)
    A_vals[0] = 32'h3F800000; // 1.0
    B_vals[0] = 32'h3F800000; // 1.0

    A_vals[1] = 32'h40000000; // 2.0
    B_vals[1] = 32'h40400000; // 3.0

    A_vals[2] = 32'h00000001; // smallest subnormal
    B_vals[2] = 32'h3F800000; // 1.0

    A_vals[3] = 32'h7F800000; // +inf
    B_vals[3] = 32'h3F800000; // 1.0

    A_vals[4] = 32'h7F800000; // +inf
    B_vals[4] = 32'h00000000; // +0 → inf * 0 = NaN

    A_vals[5] = 32'h7FC00000; // qNaN
    B_vals[5] = 32'h3F800000; // 1.0

    A_vals[6] = 32'hBF800000; // -1.0
    B_vals[6] = 32'h3F800000; // 1.0

    A_vals[7] = 32'h00000000; // +0
    B_vals[7] = 32'h00000000; // +0

    A_vals[8] = 32'h00800000; // smallest normal (2^-126)
    B_vals[8] = 32'h00800000;

    A_vals[9] = 32'h3F800000; // 1.0
    B_vals[9] = 32'hBF800000; // -1.0

    // Loop through tests
    for (i = 0; i < 10; i = i + 1) begin
        a = A_vals[i];
        b = B_vals[i];
        #10;
        $display("a = %h, b = %h, product = %h", a, b, product);
    end

    $stop;
end

endmodule
