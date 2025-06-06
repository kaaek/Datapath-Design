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
// Archer datapath test bench

//`include "archerdefs.v"
`timescale 1ns / 1ns

module archer_rv321_single_cycle_tb;

    integer i;

    reg tb_clk = 1'b0;
    reg tb_rst_n = 1'b1;

    wire [`ADDRLEN-1:0] tb_imem_addr;
    wire [`XLEN-1:0] tb_imem_dataout;

    wire [`ADDRLEN-1:0] tb_dmem_addr;
    wire [`XLEN-1:0] tb_dmem_datain;
    wire [`XLEN-1:0] tb_dmem_dataout;
    wire tb_dmem_wen;
    wire [3:0] tb_dmem_ben;
    
    archer_rv32i_single_cycle archer (.clk(tb_clk),
    				      .rst_n(tb_rst_n),
    				      .imem_addr(tb_imem_addr),
    				      .imem_datain(), //open port
    				      .imem_dataout(tb_imem_dataout),
    				      .imem_wen(), // open port
    				      .imem_ben(), // open port
    				      .dmem_addr(tb_dmem_addr),
    				      .dmem_datain(tb_dmem_datain),
    				      .dmem_dataout(tb_dmem_dataout),
    				      .dmem_wen(tb_dmem_wen),
    				      .dmem_ben(tb_dmem_ben));
    				   
     sram dmem (.clk(tb_clk),
                .addr(tb_dmem_addr),
                .datain(tb_dmem_datain),
                .dataout(tb_dmem_dataout),
                .wen(tb_dmem_wen),
                .ben(tb_dmem_ben));
                
     rom imem (.addr(tb_imem_addr),
               .dataout(tb_imem_dataout));


     initial
     begin
       #7; tb_rst_n = 1'b0;
       #6; tb_rst_n = 1'b1;
     end
     
     initial
     begin
       for (i = 1; i < 11414; i = i + 1)
       begin
         #10;
         tb_clk = ~tb_clk;
       end
     end

endmodule



