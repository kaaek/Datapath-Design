//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/26/2025 11:35:40 PM
// Design Name: 
// Module Name: fregfile
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

`include "archerdefs.v"

module fregfile (
    input wire clk,
    input wire rst_n,
    input wire RegWrite,
    input wire [`LOG2_FRF_SIZE-1:0] rs1,
    input wire [`LOG2_FRF_SIZE-1:0] rs2,
    input wire [`LOG2_FRF_SIZE-1:0] rd,
    input wire [`XLEN-1:0] datain,
    output wire [`XLEN-1:0] regA,
    output wire [`XLEN-1:0] regB
);

    reg [`XLEN-1:0] registers [0:2**`LOG2_FRF_SIZE-1];
    integer i;

    // Read ports
    assign regA = registers[rs1];
    assign regB = registers[rs2];

    // Write port
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < 2**`LOG2_FRF_SIZE; i = i + 1)
                registers[i] <= `XLEN'd0;
        end else if (RegWrite) begin
            registers[rd] <= datain;
        end
    end

endmodule 