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

    wire aSnan, aQnan, aInfinity, aZero, aSubnormal, aNormal;
    wire bSnan, bQnan, bInfinity, bZero, bSubnormal, bNormal;

    sp_class aClass(a, aSnan, aQnan, aInfinity, aZero, aSubnormal, aNormal);
    sp_class bClass(b, bSnan, bQnan, bInfinity, bZero, bSubnormal, bNormal);

    wire aSign = a[31];
    wire bSign = b[31];
    wire [7:0] aExp = a[30:23];
    wire [7:0] bExp = b[30:23];
    wire [23:0] aMant = {1'b1, a[22:0]};
    wire [23:0] bMant = {1'b1, b[22:0]};

    reg [24:0] alignedAMant, alignedBMant;
    reg [7:0] expDiff, resultExp;
    reg [24:0] resultMant;
    reg resultSign;

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
                alignedAMant = aMant;
                alignedBMant = bMant >> expDiff;
                resultExp = aExp;
            end else begin
                expDiff = bExp - aExp;
                alignedAMant = aMant >> expDiff;
                alignedBMant = bMant;
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

                // Normalize result
                while (resultMant[23] == 0 && resultExp > 0 && resultMant != 0)
                begin
                    resultMant = resultMant << 1;
                    resultExp = resultExp - 1;
                end
            end

            if (resultMant == 0) begin
                sum = {resultSign, 31'b0}; // final result is zero
            end else begin
                sum = {resultSign, resultExp, resultMant[22:0]};
            end
        end
    end

endmodule
