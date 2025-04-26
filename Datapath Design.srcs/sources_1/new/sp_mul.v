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
        if (aSnan | bSnan) 
            begin
            // a or b is an sNan, set the product to that value
                pTemp = aSnan == 1'b1 ? a : b;
                snan = 1;
                
            end
        else if (aQnan | bQnan)
        // In this implementation, qNans and sNans are passed the same way, even though the sNaN should raise an exception. Checking both types is separated for the purpose of making it
        // easy for such an integration to occur.
            begin
                pTemp = aQnan == 1'b1 ? a : b;
                qnan = 1;
            end
        else if ((aInfinity | bInfinity) == 1'b1)
            begin
                qnan = aZero | bZero; // inf * zero = NaN or infinity depending on the value of bit 22
                infinity = ~qnan;
                pTemp = {pSign, {8{1'b1}}, qnan, {22{1'b0}}};
            end
        else if ((aZero | bZero) == 1'b1)
            begin
                pTemp = {pSign, {31{1'b0}}}; // +/- zero
                zero = 1;
            end
        
        else if ((aZero | bZero) == 1'b1 || (aSubnormal & bSubnormal) == 1'b1)
        // two subnormals give zero
            begin
                pTemp = {pSign, {31{1'b0}}};
                zero = 1;
            end
        // We're left with subnormal and normal number multiplication, do:
        // Normalize then multiply the mantissas
        // Add exponents
        // Normalize product and truncate if needed
        else begin
            aMan = {1'b1, aSig}; // MSB 1 is implied.
            bMan = {1'b1, bSig};
            productMant = aMan * bMan; // 24 x 24 = 48 bits
            sumExp = aExp + bExp - 127;
            if (productMant[47] == 1)
                begin
                    normMant = productMant[47:24]; // top 24 bits
                    normExp = sumExp + 1; // shift left, increase exponent
                end
            else
                begin
                    normMant = productMant[46:23];
                    normExp = sumExp; // no shift needed
                end
            
            if (normExp > 254)
                begin
                    finalExp = 255;
                    result = {pSign, 8'hFF,23'b0}; // Overflow
                end
            else if (normExp < 1)
                begin
                    result = 32'b0; // Underflow    
                end
            else
                begin
                    finalExp = normExp[7:0];
                    result = {pSign, finalExp, normMant[22:0]};
                end
        end
    end
    
    assign product = result;

endmodule
