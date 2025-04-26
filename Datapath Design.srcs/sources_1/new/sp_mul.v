`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/25/2025 10:32:34 PM
// Design Name: 
// Module Name: sp_mul
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


module sp_mul(
    input [31:0] a,
    input [31:0] b,
    output [31:0] product
    );
    // classifications of operands a & b
    wire [22:0] aSig, bSig;
    wire [7:0] aExp, bExp; // biased
    wire aSign, bSign;
    wire aSnan, aQnan, aInfinity, aZero, aSubnormal, aNormal, aSign;
    wire bSnan, bQnan, bInfinity, bZero, bSubnormal, bNormal, bSign;
    
    reg pSign;
    reg [23:0] aMan, bMan;
    reg [47:0] productMant;
    reg [8:0] sumExp;
    reg [23:0] normMant;
    reg [8:0] normExp;
    reg [7:0] finalExp;
    reg [31:0] result;
    reg [31:0] pTemp;
    reg snan, qnan, infinity, zero, subnormal, normal;
    
    sp_class aClass(a, aSnan, aQnan, aInfinity, aZero, aSubnormal, aNormal, aSign, aExp, aSig);
    sp_class bClass(b, bSnan, bQnan, bInfinity, bZero, bSubnormal, bNormal, bSign, bExp, bSig);
    
    
    always @(*)
    begin
        // IEEE 754-2019: "when neither the inputs nor result are NaN, the sign of the product ... is the exclusive OR of the operads' signs."
        pSign = aSign ^ bSign;
        result = 32'h7FC00000; // initialize to sNaN.
        {snan, qnan, infinity, zero, subnormal, normal} = 6'b000000; // initialize to zero. By the end of the implementation, 1 of the flags must necessarily be set, no more and no less.
        if (aSnan || bSnan) begin
            result = aSnan ? a : b; // propagate sNaN
        end
        else if (aQnan || bQnan) begin
            result = aQnan ? a : b; // propagate qNaN
        end
        else if ((aInfinity && bZero) || (bInfinity && aZero)) begin
            result = 32'h7FC00000; // inf * 0 = NaN
        end
        else if (aInfinity || bInfinity) begin
            result = {pSign, 8'hFF, 23'b0}; // inf * finite = inf
        end
        else if (aZero || bZero) begin
            result = {pSign, 31'b0}; // 0 * anything = 0
        end 
        else begin
            // Normal multiplication (finite × finite)
            aMan = {1'b1, aSig};
            bMan = {1'b1, bSig};
            productMant = aMan * bMan;
            sumExp = aExp + bExp - 127;
    
            if (productMant[47] == 1) begin
                normMant = productMant[47:24];
                normExp = sumExp + 1;
            end
            else begin
                normMant = productMant[46:23];
                normExp = sumExp;
            end

            if (normExp > 254) begin
                result = {pSign, 8'hFF, 23'b0}; // Overflow to inf
            end
            else if (normExp < 1) begin
                result = {pSign, 31'b0}; // Underflow to zero
            end
            else begin
                finalExp = normExp[7:0];
                result = {pSign, finalExp, normMant[22:0]};
            end
        end

    end
    
    assign product = result;

endmodule
