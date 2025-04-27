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
// 32 x XLEN-bit General-Purpose Register File

`include "archerdefs.v"

module regfile (
	input clk,
	input rst_n,
	input RegWrite,
	input [`LOG2_XRF_SIZE-1:0] rs1,
	input [`LOG2_XRF_SIZE-1:0] rs2,
	input [`LOG2_XRF_SIZE-1:0] rd,
	input [`XLEN-1:0] datain,
	output [`XLEN-1:0] regA,
	output [`XLEN-1:0] regB,
	output [`XLEN-1:0] reg_x1,   // <--- NEW
    output [`XLEN-1:0] reg_x2,   // <--- NEW
    output [`XLEN-1:0] reg_x3,   // <--- NEW
    output [`XLEN-1:0] reg_x4    // <--- NEW
	);
	
  integer i;
  reg [`XLEN-1:0] RF [0:(2**(`LOG2_XRF_SIZE))-1];
  
  assign regA = RF[rs1];
  assign regB = RF[rs2];
  
  assign reg_x1 = RF[1];
  assign reg_x2 = RF[2];
  assign reg_x3 = RF[3];
  assign reg_x4 = RF[4];
  
  always @(posedge clk)
  begin
    if (rst_n == 1'b0)
      begin
        RF[0] <= `XLEN'd0;
        RF[1] <= `XLEN'd0;
        RF[2] <= {{(`XLEN-12){1'b0}}, 12'h400}; // initialize sp (x2) to data memory address 1024
        for (i = 3; i < (2**(`LOG2_XRF_SIZE)); i = i + 1) 
        begin
          RF[i] <= `XLEN'd0;
        end
      end
    else if ((RegWrite == 1'b1) && (rd != `LOG2_XRF_SIZE'd0))
      RF[rd] <= datain;
  end
  
  initial 
  begin
    RF[0] = `XLEN'd0;
    RF[1] = `XLEN'd0;
    RF[2] = {{(`XLEN-12){1'b0}}, 12'h400}; // initialize sp (x2) to data memory address 1024
    for (i = 3; i < (2**(`LOG2_XRF_SIZE)); i = i + 1) 
    begin
      RF[i] = `XLEN'd0;
    end
  end
endmodule
