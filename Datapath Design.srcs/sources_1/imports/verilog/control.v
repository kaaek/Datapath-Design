//
// SPDX-License-Identifier: CERN-OHL-P-2.0+
//
// Copyright (C) 2021-2024 Embedded and Reconfigurable Computing Lab, American University of Beirut
// Contributed by:
// Mazen A. R. Saghir <mazen@aub.edu.lb>
//
// This source is distributed WITHOUT ANY EXPRESS OR IMPLIED WARRANTY,
// INCLUDING OF MERCHANTABILITY, SATISFACTORY QUALITY AND FITNESS FOR
// A PARTICULAR PURPOSE. Please see the CERN-OHL-P v2 for applicable
// conditions.
// Source location: https://github.com/ERCL-AUB/archer/rv32i_single_cycle
//
// Main control unit

`include "archerdefs.v"

module control (
	input [`XLEN-1:0] instruction,
	input BranchCond, // BR. COND. SATISFIED = 1; NOT SATISFIED = 0
	output Jump,
	output reg Lui,
	output PCSrc,
	output reg RegWrite,
	output reg ALUSrc1,
	output reg ALUSrc2,
	output reg [3:0] ALUOp,
	output reg MemWrite,
	output reg MemRead,
	output reg MemToReg
	);
	
  wire [6:0] opcode;
  wire [2:0] funct3;
  wire [6:0] funct7;
  wire branch_instr;
  wire jump_instr;
  
  assign opcode = instruction [6:0];
  assign funct3 = instruction [14:12];
  assign funct7 = instruction [31:25];
  assign branch_instr = (opcode == `OPCODE_BRANCH) ? 1'b1 : 1'b0;
  assign jump_instr = ((opcode == `OPCODE_JAL) || (opcode == `OPCODE_JALR)) ? 1'b1 : 1'b0;
  assign PCSrc = (branch_instr & BranchCond) | jump_instr;
  assign Jump = jump_instr;
  
  always @(*)
  begin
  
    Lui = 1'b0;
    RegWrite = 1'b0;
    ALUSrc1 = 1'b0;
    ALUSrc2 = 1'b0;
    ALUOp = 4'b0000;
    MemWrite = 1'b0;
    MemRead = 1'b0;
    MemToReg = 1'b0;
    
    case (opcode)
      `OPCODE_LUI :
        begin
          Lui = 1'b1;
          RegWrite = 1'b1;
          ALUSrc1 = 1'b1;
          ALUSrc2 = 1'b1;
          ALUOp = `ALU_OP_ADD;
        end
      
      `OPCODE_AUIPC, `OPCODE_JAL :
        begin
          RegWrite = 1'b1;
          ALUSrc1 = 1'b1;
          ALUSrc2 = 1'b1;
          ALUOp = `ALU_OP_ADD;
        end
        
      `OPCODE_JALR:
        begin
          RegWrite = 1'b1;
          ALUSrc2 = 1'b1;
          ALUOp = `ALU_OP_ADD;
        end
        
      `OPCODE_BRANCH :
        begin
          ALUSrc1 = 1'b1;
          ALUSrc2 = 1'b1;
          ALUOp = `ALU_OP_ADD;
        end
        
      `OPCODE_LOAD :
        begin
          RegWrite = 1'b1;
          ALUSrc2 = 1'b1;
          ALUOp = `ALU_OP_ADD;
          MemRead = 1'b1;
          MemToReg = 1'b1;
        end
        
      `OPCODE_STORE :
        begin
          ALUSrc2 = 1'b1;
          ALUOp = `ALU_OP_ADD;
          MemWrite = 1'b1;
        end
        
      `OPCODE_IMM :
        begin
          RegWrite = 1'b1;
          ALUSrc2 = 1'b1;
          if (funct3 == 3'b101) // SRLI/SRAI
            ALUOp = {funct7[5], funct3};
          else
            ALUOp = {1'b0, funct3};
        end
        
      `OPCODE_RTYPE :
        begin
          RegWrite = 1'b1;
          ALUOp = {funct7[5], funct3};
        end
      
      default : ;
    endcase
  end
  
endmodule
