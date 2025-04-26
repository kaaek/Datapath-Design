`timescale 1ns / 1ps

module FPU (
    input wire [31:0] op1,
    input wire [31:0] op2,
    input wire [1:0] opcode, // 00 = ADD, 01 = SUB, 10 = MUL
    output reg [31:0] result
);

// Wires to connect to the internal modules
wire [31:0] add_result;
wire [31:0] sub_result;
wire [31:0] mul_result;

// Instantiate the floating-point operation modules
sp_add u_add (
    .a(op1),
    .b(op2),
    .sum(add_result)
);

sp_sub u_sub (
    .a(op1),
    .b(op2),
    .diff(sub_result)
);

sp_mul u_mul (
    .a(op1),
    .b(op2),
    .product(mul_result)
);

// Choose the correct operation based on opcode
always @(*) begin
    case (opcode)
        2'b00: result = add_result; // ADD
        2'b01: result = sub_result; // SUB
        2'b10: result = mul_result; // MUL
        default: result = 32'h00000000; // Default output zero for undefined opcodes
    endcase
end

endmodule
