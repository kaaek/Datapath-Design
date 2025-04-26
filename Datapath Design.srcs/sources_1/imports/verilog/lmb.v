//
// SPDX-License-Identifier: CERN-OHL-P-2.0+
//
// Copyright (C) 2021 Embedded and Reconfigurable Computing Lab, American University of Beirut
// Contributed by:
// Mazen A. R. Saghir <mazen@aub.edu.lb>
//
// This source is distributed WITHOUT ANY EXPRESS OR IMPLIED WARRANTY,
// INCLUDING OF MERCHANTABILITY, SATISFACTORY QUALITY AND FITNESS FOR
// A PARTICULAR PURPOSE. Please see the CERN-OHL-P v2 for applicable
// conditions.
// Source location: https://github.com/ERCL-AUB/archer/rv32i_single_cycle
//
// Local memory bus interface
//

`include "archerdefs.v"

module lmb (
	input [`XLEN-1:0] proc_addr,
	input [`XLEN-1:0] proc_data_send,
	output reg [`XLEN-1:0] proc_data_receive,
	input [1:0] proc_byte_mask, // "00" = byte; "01" = half-word; "10" = word
	input proc_sign_ext_n,
	input proc_mem_write,
	input proc_mem_read,
	output [`ADDRLEN-1:0] mem_addr,
	output [`XLEN-1:0] mem_datain,
	input [`XLEN-1:0] mem_dataout,
	output mem_wen, // write enable signal
	output reg [3:0] mem_ben // byte enable signals
	);
	
  wire [1:0] lsab; // least-significant address bits
  reg MSB = 1'b0;
  reg [7:0] data_byte = 8'h00;
  reg [15:0] data_half_word = 16'h0000;
  
  assign mem_addr = proc_addr[`ADDRLEN-1:0];
  assign mem_datain = proc_data_send;
  assign mem_wen = ((proc_mem_write == 1'b1) && (proc_mem_read == 1'b0)) ? 1'b1: 1'b0;
  assign lsab = proc_addr[1:0];
  
  always @(*)
  begin
    mem_ben = 4'b0000;
    case (proc_byte_mask)
      2'b00 :
        begin
          case (lsab)
            2'b00 : mem_ben = 4'b0001;
            2'b01 : mem_ben = 4'b0010;
            2'b10 : mem_ben = 4'b0100;
            2'b11 : mem_ben = 4'b1000;
            default : ;
          endcase
        end
      2'b01 :
        begin
          case (lsab)
            2'b00, 2'b01 : mem_ben = 4'b0011;
            2'b10, 2'b11 : mem_ben = 4'b1100;
            default : ;
          endcase
        end
      2'b10 : mem_ben = 4'b1111;
      default : ;
    endcase
  end
  
  always @(*)
  begin
    proc_data_receive = {(`XLEN){1'b0}};
    data_byte = 8'h00;
    data_half_word = 16'h0000;
    
    if ((proc_mem_write == 1'b0) && (proc_mem_read == 1'b1))
      begin
        proc_data_receive = mem_dataout;
        case (proc_byte_mask)
          2'b00:
            begin
              case (lsab)
                2'b00: data_byte = mem_dataout[7:0];
                2'b01: data_byte = mem_dataout[15:8];
                2'b10: data_byte = mem_dataout[23:16];
                2'b11: data_byte = mem_dataout[31:24];
                default: data_byte = 8'h00;
              endcase
              
              if (proc_sign_ext_n == 1'b0)
                MSB = data_byte[7];
              else
                MSB = 1'b0;
                
              proc_data_receive = {{(`XLEN-8){MSB}},data_byte};
              
            end
            
          2'b01:
            begin
              case (lsab)
                2'b00, 2'b01: data_half_word = mem_dataout[15:0];
                2'b10, 2'b11: data_half_word = mem_dataout[31:16];
                default: data_half_word = 16'h0000;
              endcase
              
              if (proc_sign_ext_n == 1'b0)
                MSB = data_half_word[15];
              else
                MSB = 1'b0;
                
              proc_data_receive = {{(`XLEN-16){MSB}},data_half_word};
              
            end
            
          default: ;
        endcase
      end
  end
  
endmodule

