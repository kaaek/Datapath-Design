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
// Data Memory (SRAM module)
//

`include "archerdefs.v"

module sram (
	input clk,
	input [`ADDRLEN-1:0] addr,
	input [`XLEN-1:0] datain,
	output [`XLEN-1:0] dataout,
	input wen,
	input [3:0] ben
	);
	
  integer i;
  reg [7:0] ram [0:(2**(`ADDRLEN))-1];
  wire [`ADDRLEN-1:0] word_addr;
  
  assign word_addr = {addr[`ADDRLEN-1:2], 2'b00};
  assign dataout = {ram[word_addr+3], ram[word_addr+2], ram[word_addr+1], ram[word_addr]};

  
  always@(posedge clk)
  begin
    if (wen == 1'b1)
    begin
      case (ben)
        4'b0001: ram[word_addr] <= datain[7:0];
        4'b0010: ram[word_addr+1] <= datain[7:0];
        4'b0100: ram[word_addr+2] <= datain[7:0];
        4'b1000: ram[word_addr+3] <= datain[7:0];
        4'b0011:
        begin
          ram[word_addr] <= datain[7:0];
          ram[word_addr+1] <= datain[15:8];
        end
        4'b1100:
        begin
          ram[word_addr+2] <= datain[7:0];
          ram[word_addr+3] <= datain[15:8];
        end
        4'b1111:
        begin
          ram[word_addr] <= datain[7:0];
          ram[word_addr+1] <= datain[15:8];
          ram[word_addr+2] <= datain[23:16];
          ram[word_addr+3] <= datain[31:24];
        end
        default: ;
      endcase
    end
  end
  
  initial
  begin
    for (i = 0; i < 2**(`ADDRLEN); i = i + 1)
    begin
      ram[i] = 8'h00;
    end
  end
endmodule
