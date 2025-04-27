`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
// 
// Create Date: 04/25/2025 06:51:52 PM
// Design Name: 
// Module Name: sp_class
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
// This module here takes a float and classifies it according to the IEEE-754 as
// either: a signaling NaN, quiet NaN, infinity, zero, subnormal, or normal.
// https://en.wikipedia.org/wiki/IEEE_754
//////////////////////////////////////////////////////////////////////////////////


module sp_class(
    input [31:0] float,
    output snan,
    output qnan,
    output infinity,
    output zero,
    output subnormal,
    output normal,
    output sign,
    output [7:0] exp,
    output [23:0] significand
    );
    
    wire expOnes, expZeroes, manZeroes;
    
    
    assign expOnes = &float[30:23]; // Check if all biased exponent bits are set.
    // Note: the above operation is known as a Verilog reduction operator: reduces a bit vector into one bit. '&' does logical AND with 1. Hence, sets expOnes if all the exponent bets are set.
    assign expZeroes = ~|float[30:23]; // Check if the biased exp = zero.
    assign manZeroes = ~|float[22:0]; // Check if mantissa = zero.
    
    // Categorize input float:
    assign snan = expOnes & ~manZeroes & ~float[22];
    assign qnan = expOnes & ~manZeroes & float[22];
    assign infinity = expOnes & manZeroes;
    assign zero = expZeroes & manZeroes;
    assign subnormal = expZeroes & ~manZeroes;
    assign normal = ~expOnes & ~expZeroes;
    assign sign = float[31];
    assign exp = float [30:23];
    assign significand = (exp == 8'b0) ? {1'b0, float[22:0]} : {1'b1, float[22:0]};
    
endmodule
