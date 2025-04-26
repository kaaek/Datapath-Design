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
// 2-to-1 XLEN-bit multiplexer

`include "archerdefs.v"

module mux2to1 (
	input sel,
	input [`XLEN-1:0] input0,
	input [`XLEN-1:0] input1,
	output [`XLEN-1:0] muxout
	);
	
  assign muxout = (sel == 1'b0) ? input0 : input1;
  
endmodule

