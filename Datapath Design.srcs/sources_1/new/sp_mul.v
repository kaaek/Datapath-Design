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
    //input snan,
    //input qnan,
    //input infinity,
    //input zero,
    //input subnormal,
    //input normal,
    output [31:0] product
    );
    
    wire aSnan, aQnan, aInfinity, aZero, aSubnormal, aNormal;
    wire bSnan, bQnan, bInfinity, bZero, bSubnormal, bNormal;
    
    sp_class aClass(a, aSnan, aQnan, aInfinity, aZero, aSubnormal, aNormal);
    sp_class bClass(b, bSnan, bQnan, bInfinity, bZero, bSubnormal, bNormal);
    
    reg [31:0] pTemp;
    reg snan, qnan, infinity, zero, subnormal, normal, pSign;
    
    always @(*)
    begin
        // IEEE 754-2019: "when neither the inputs nor result are NaN, the sign of the product ... is the exclusive OR of the operads' signs."
        pSign = a[31] ^ b[31];
        pTemp = {1'b0, {8{1'b1}}, 1'b0, {22{1'b1}}}; // initialize to sNaN.
        {snan, qnan, infinity, zero, subnormal, normal} = 6'b000000; // initialize to zero. By the end of the implementation, 1 of the flags must necessarily be set, no more and no less.
        if ((aSnan | bSnan) == 1'b1) 
            begin
            // a or b is an sNan, set the product to that value
                pTemp = aSnan == 1'b1 ? a : b;
                snan = 1;
            end
        else if ((aQnan | bQnan) == 1'b1)
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
    end
    
    
endmodule
