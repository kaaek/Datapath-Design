`timescale 1ns / 1ps

module FPU_tb;

reg [31:0] op1, op2;
reg [1:0] opcode;
wire [31:0] result;

// Instantiate your FPU
FPU uut (
    .op1(op1),
    .op2(op2),
    .opcode(opcode),
    .result(result)
);

// Test vectors
initial begin
    // ADD: 1.0 + 1.0 = 2.0
    op1 = 32'h3F800000; // 1.0
    op2 = 32'h3F800000; // 1.0
    opcode = 2'b00; // ADD
    #10;
    $display("ADD: result = %h", result);

    // SUB: 3.0 - 2.0 = 1.0
    op1 = 32'h40400000; // 3.0
    op2 = 32'h40000000; // 2.0
    opcode = 2'b01; // SUB
    #10;
    $display("SUB: result = %h", result);

    // MUL: 2.0 * 3.0 = 6.0
    op1 = 32'h40000000; // 2.0
    op2 = 32'h40400000; // 3.0
    opcode = 2'b10; // MUL
    #10;
    $display("MUL: result = %h", result);

    // Special case: 0 * 0 = 0
    op1 = 32'h00000000;
    op2 = 32'h00000000;
    opcode = 2'b10; // MUL
    #10;
    $display("MUL Zero: result = %h", result);

    // Special case: inf + 1 = inf
    op1 = 32'h7F800000; // +inf
    op2 = 32'h3F800000; // 1.0
    opcode = 2'b00; // ADD
    #10;
    $display("ADD inf + 1: result = %h", result);

    // --- Extended / Edge Cases ---
    // SUB: +inf - +inf = NaN
    op1 = 32'h7F800000; op2 = 32'h7F800000; opcode = 2'b01; #10;
    $display("SUB inf - inf: result = %h", result);

    // MUL: +inf * 0.0 = NaN
    op1 = 32'h7F800000; op2 = 32'h00000000; opcode = 2'b10; #10;
    $display("MUL inf * 0: result = %h", result);

    // ADD: smallest subnormal + smallest subnormal
    op1 = 32'h00000001; op2 = 32'h00000001; opcode = 2'b00; #10;
    $display("ADD tiny + tiny: result = %h", result);

    // SUB: 1.0 - (-1.0) = 2.0
    op1 = 32'h3F800000; op2 = 32'hBF800000; opcode = 2'b01; #10;
    $display("SUB 1 - (-1): result = %h", result);

    // MUL: (-1.0) * 1.0 = -1.0
    op1 = 32'hBF800000; op2 = 32'h3F800000; opcode = 2'b10; #10;
    $display("MUL -1 * 1: result = %h", result);

    // ADD: NaN + 1.0 = NaN
    op1 = 32'h7FC00000; op2 = 32'h3F800000; opcode = 2'b00; #10;
    $display("ADD NaN + 1: result = %h", result);

    // SUB: 1.0 - 1.0 = 0
    op1 = 32'h3F800000; op2 = 32'h3F800000; opcode = 2'b01; #10;
    $display("SUB 1 - 1: result = %h", result);

    $stop;
end

endmodule
