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
// Arithmetic and Logic Unit (ALU)

`include "archerdefs.v"

module alu (
	  input [`XLEN-1:0] inputA,
	  input [`XLEN-1:0] inputB,
	  input [`ALUOPS_SIZE-1:0] ALUop,
	  output reg [`XLEN-1:0] result
	);

  wire [`XLEN-1:0] add_result;
  wire [`XLEN-1:0] sub_result;
  wire [`XLEN-1:0] and_result;
  wire [`XLEN-1:0] or_result;
  wire [`XLEN-1:0] xor_result;
  wire [`XLEN-1:0] sll_result;
  wire [`XLEN-1:0] srl_result;
  wire [`XLEN-1:0] sra_result;
  wire [`XLEN-1:0] slt_result;
  wire [`XLEN-1:0] sltu_result;
  
  assign add_result = $signed(inputA) + $signed(inputB);
  assign sub_result = $signed(inputA) - $signed(inputB);
  assign and_result = inputA & inputB;
  assign or_result = inputA | inputB;
  assign xor_result = inputA ^ inputB;
  assign sll_result = inputA << inputB[4:0];
  assign srl_result = inputA >> inputB[4:0];
  assign sra_result = $signed(inputA) >>> inputB[4:0];
  assign slt_result = ($signed(inputA) < $signed(inputB)) ? {{(`XLEN-1){1'b0}},1'b1} : {(`XLEN){1'b0}};
  assign sltu_result = (inputA < inputB) ? 1 : 0;
  
  always @(*)
  begin
    case (ALUop)
      `ALU_OP_ADD : result = add_result;
      `ALU_OP_SUB : result = sub_result;
      `ALU_OP_AND : result = and_result;
      `ALU_OP_OR : result = or_result;
      `ALU_OP_XOR : result = xor_result;
      `ALU_OP_SLL : result = sll_result;
      `ALU_OP_SRL : result = srl_result;
      `ALU_OP_SRA : result = sra_result;
      `ALU_OP_SLT : result = slt_result;
      `ALU_OP_SLTU : result = sltu_result;
      default:	result = {(`XLEN){1'b0}};
    endcase
  end
	
endmodule
