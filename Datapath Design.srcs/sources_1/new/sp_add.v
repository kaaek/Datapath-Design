`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/25/2025 11:47:09 PM
// Design Name: 
// Module Name: sp_add
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


module sp_add(
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] sum
    );

    wire [23:0] aSig, bSig;
    wire [7:0] aExp, bExp; // biased
    wire aSnan, aQnan, aInfinity, aZero, aSubnormal, aNormal, aSign;
    wire bSnan, bQnan, bInfinity, bZero, bSubnormal, bNormal, bSign;

    
    sp_class aClass(a, aSnan, aQnan, aInfinity, aZero, aSubnormal, aNormal, aSign, aExp, aSig);
    sp_class bClass(b, bSnan, bQnan, bInfinity, bZero, bSubnormal, bNormal, bSign, bExp, bSig);
    
    reg [24:0] alignedAMant, alignedBMant;
    reg [7:0] expDiff, resultExp;
    reg [24:0] resultMant;
    reg resultSign;
    integer i;
    
    always @(*) begin
    
    // Default to sNaN
    sum = {1'b0, {8{1'b1}}, 1'b0, {22{1'b1}}};

    if (aSnan || bSnan) begin
        sum = aSnan ? a : b;
    end else if (aQnan || bQnan) begin
        sum = aQnan ? a : b;
    end else if (aInfinity || bInfinity) begin
        if (aInfinity && bInfinity && aSign != bSign)
            sum = {1'b0, {8{1'b1}}, 1'b0, {22{1'b1}}}; // inf - inf = NaN
        else
            sum = aInfinity ? a : b; // return the infinity
    end else if (aZero && bZero) begin
        sum = (aSign & bSign) ? {1'b1, 31'b0} : 32'b0; // signed zero
    end else begin
        // Align exponents
        if (aExp > bExp) begin
            expDiff = aExp - bExp;
            alignedAMant = {1'b0, aSig};
             alignedBMant = {1'b0, bSig} >> expDiff;
            resultExp = aExp;
        end else begin
            expDiff = bExp - aExp;
            alignedAMant = {1'b0, aSig} >> expDiff;
            alignedBMant = {1'b0, bSig};
            resultExp = bExp;
        end

        // Add/Sub mantissas depending on sign
        if (aSign == bSign) begin
            resultMant = alignedAMant + alignedBMant;
            resultSign = aSign;
            if (resultMant[24]) begin
                resultMant = resultMant >> 1;
                resultExp = resultExp + 1;
            end
        end else begin
            if (alignedAMant >= alignedBMant) begin
                resultMant = alignedAMant - alignedBMant;
                resultSign = aSign;
            end else begin
                resultMant = alignedBMant - alignedAMant;
                resultSign = bSign;
            end

            // Normalize result with bounded loop
            for (i = 0; i < 24; i = i + 1) begin
                if (resultMant[23] == 0 && resultExp > 0 && resultMant != 0) begin
                    resultMant = resultMant << 1;
                    resultExp = resultExp - 1;
                end
            end
        end

        if (resultMant == 0) begin
            sum = {resultSign, 31'b0}; // final result is zero
        end else begin
            // Insert check here:
            if (resultExp > 254) begin
                sum = {resultSign, 8'hFF, 23'b0}; // Overflow
            end else if (resultExp < 1) begin
                sum = {resultSign, 31'b0}; // Underflow
            end else begin
                sum = {resultSign, resultExp, resultMant[22:0]};
            end
        end
    end
end

endmodule
