`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/26/2025 02:26:54 AM
// Design Name: 
// Module Name: sp_sub
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module sp_sub(
    input [31:0] a,
    input [31:0] b,
    output [31:0] diff
    );

    wire [31:0] negB;
    wire [31:0] sumResult;

    // Flip the sign bit of b to perform subtraction
    assign negB = {~b[31], b[30:0]};

    // Use sp_add to compute a + (-b)
    sp_add adder(
        .a(a),
        .b(negB),
        .sum(sumResult)
    );

    assign diff = sumResult;

endmodule

