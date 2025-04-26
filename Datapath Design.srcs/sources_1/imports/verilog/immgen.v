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
// Immediate generator

`include "archerdefs.v"

module immgen (
	input [`XLEN-1:0] instruction,
	output reg [`XLEN-1:0] immediate
	);
	
  wire [6:0] opcode;
  wire [`XLEN-1:0] i_type_immed;
  wire [`XLEN-1:0] s_type_immed;
  wire [`XLEN-1:0] b_type_immed;
  wire [`XLEN-1:0] j_type_immed;
  wire [`XLEN-1:0] u_type_immed;
  
  assign opcode = instruction[6:0];
  assign i_type_immed = {{(`XLEN-12){instruction[31]}}, instruction[31:20]};
  assign s_type_immed = {{(`XLEN-12){instruction[31]}}, instruction[31:25], instruction[11:7]};
  assign b_type_immed = {{(`XLEN-13){instruction[31]}}, instruction[31], instruction[7], instruction[30:25], instruction[11:8], 1'b0};
  assign j_type_immed = {{(`XLEN-21){instruction[31]}}, instruction[31], instruction[19:12], instruction[20], instruction[30:21], 1'b0};
  assign u_type_immed = {instruction[31:12], 12'h000};
  
  always @(*)
  begin
    case (opcode)
      `OPCODE_IMM, `OPCODE_LOAD, `OPCODE_JALR : immediate = i_type_immed; // arithmetic immed/logic immed/shift; load; jalr
      `OPCODE_STORE : immediate = s_type_immed; // store
      `OPCODE_BRANCH : immediate = b_type_immed; // branch
      `OPCODE_JAL : immediate = j_type_immed; // jal
      `OPCODE_LUI, `OPCODE_AUIPC : immediate = u_type_immed; // lui or auipc
      default : immediate = {(`XLEN){1'b0}};
    endcase
  end
  
endmodule

