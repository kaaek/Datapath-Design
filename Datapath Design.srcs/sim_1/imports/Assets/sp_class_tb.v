`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/25/2025 07:52:34 PM
// Design Name: 
// Module Name: sp_class_tb
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


module sp_class_tb;

reg [31:0] float;
wire snan, qnan, infinity, zero, subnormal, normal;
integer i, countSnans, countQnans, countInfinities, countZeroes, countSubnormals, countNormals;

sp_class inst1 (
    .float(float),
    .snan(snan),
    .qnan(qnan),
    .infinity(infinity),
    .zero(zero),
    .subnormal(subnormal),
    .normal(normal)
);

reg [31:0] testcases [0:9];

initial
    begin
        float = 0;
        countSnans = 0;
        countQnans = 0;
        countInfinities = 0;
        countZeroes = 0;
        countSubnormals = 0;
        countNormals = 0;
        
        testcases[0] = 32'h00000000; // +0
        testcases[1] = 32'h80000000; // -0
        testcases[2] = 32'h7F800000; // +inf
        testcases[3] = 32'hFF800000; // -inf
        testcases[4] = 32'h7FC00000; // qNaN
        testcases[5] = 32'h7FA00000; // sNaN
        testcases[6] = 32'h00400000; // subnormal
        testcases[7] = 32'h3F800000; // 1.0
        testcases[8] = 32'hBF800000; // -1.0
        testcases[9] = 32'h00000001; // smallest subnormal

        for(i = 0; i < 10; i=i+1)
            begin
                float = testcases[i];
                #10;
                if((snan & ~qnan & ~infinity & ~zero & ~subnormal & ~normal) == 1)
                    countSnans = countSnans + 1;
                else if ((~snan & qnan & ~infinity & ~zero & ~subnormal & ~normal) == 1)
                    countQnans = countQnans + 1;
                else if ((~snan & ~qnan & infinity & ~zero & ~subnormal & ~normal) == 1)
                    countInfinities = countInfinities + 1;
                else if ((~snan & ~qnan & ~infinity & zero & ~subnormal & ~normal) == 1)
                    countZeroes = countZeroes + 1;                    
                else if ((~snan & ~qnan & ~infinity & ~zero & subnormal & ~normal) == 1)
                    countSubnormals = countSubnormals + 1;
                else if ((~snan & ~qnan & ~infinity & ~zero & ~subnormal & normal) == 1)
                    countNormals = countNormals + 1;
                else
                    begin
                        $display("Error: float = %x, class = %b", float, {snan, qnan, infinity, zero, subnormal, normal});
                        $stop;
                    end
        end
                
                
            $display("     Number of sNaNs: ", countSnans);
            $display("     Number of qNaNs: ", countQnans);
            $display("Number of infinities: ", countInfinities);
            $display("    Number of Zeroes: ", countZeroes);
            $display("Number of Subnormals: ", countSubnormals);
            $display("   Number of Normals: ", countNormals);
            $display("               Total: ", countSnans+countQnans+countInfinities+countZeroes+countSubnormals+countNormals);
                
                
            $stop;
    end
endmodule
