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
// Program Counter (PC) Register

`include "archerdefs.v"

module pc (
	input clk,
	input rst_n,
	input [`XLEN-1:0] datain,
	output reg [`XLEN-1:0] dataout
	);
  
  always @(posedge clk) 
  begin
    if (rst_n == 1'b0)
      dataout <= `XLEN'd0;
    else
      dataout <= datain;
  end
  
endmodule
