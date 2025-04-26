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
// Branch comparator

`include "archerdefs.v"

module branch_cmp (
	  input [`XLEN-1:0] inputA,
	  input [`XLEN-1:0] inputB,
	  input [2:0] cond,
	  output reg result
	);
	
  wire res_eq; 	// equal
  wire res_ne; 	// not equal
  wire res_lt; 	// less than
  wire res_ge; 	// greater than or equal
  wire res_ltu; // less than unsigned
  wire res_geu;	// greater than or equal unsigned
  
  assign res_eq = (inputA == inputB) ? 1'b1 : 1'b0;
  assign res_ne = (inputA != inputB) ? 1'b1 : 1'b0;
  assign res_lt = ($signed(inputA) < $signed(inputB)) ? 1'b1 : 1'b0;
  assign res_ge = ($signed(inputA) >= $signed(inputB)) ? 1'b1 : 1'b0;
  assign res_ltu = ($unsigned(inputA) < $unsigned(inputB)) ? 1'b1 : 1'b0;
  assign res_geu = ($unsigned(inputA) >= $unsigned(inputB)) ? 1'b1 : 1'b0;
  
  always @(*)
  begin
    // cond values match func3 field values for corresponding RV32I branch instructions
    case (cond)
      `BR_COND_EQ : result <= res_eq;
      `BR_COND_NE : result <= res_ne;
      `BR_COND_LT : result <= res_lt;
      `BR_COND_GE : result <= res_ge;
      `BR_COND_LTU : result <= res_ltu;
      `BR_COND_GEU : result <= res_geu;
      default : result <= 1'b0;
    endcase
  end

endmodule
