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
// Instruction Memory (program initialized ROM)

`include "archerdefs.v"

module rom (
	input [`ADDRLEN-1:0] addr,
	output [`XLEN-1:0] dataout
	);
	
  integer i;
  reg [7:0] rom_array [0:(2**(`ADDRLEN))-1];
  wire [(`ADDRLEN-1):0] word_addr;
  
  assign word_addr = {addr[(`ADDRLEN-1):2], 2'b00};
  assign dataout = {rom_array[word_addr+3], rom_array[word_addr+2], rom_array[word_addr+1], rom_array[word_addr]};
  
  initial 
  begin
//    rom_array[0] = 8'hB3;
//    rom_array[1] = 8'h02;
//    rom_array[2] = 8'h00;
//    rom_array[3] = 8'h00;
    
//    rom_array[4] = 8'h13;
//    rom_array[5] = 8'h03;
//    rom_array[6] = 8'hB0;
//    rom_array[7] = 8'h00;
    
//    rom_array[8] = 8'h97;
//    rom_array[9] = 8'h03;
//    rom_array[10] = 8'h00;
//    rom_array[11] = 8'h10;
    
//    rom_array[12] = 8'h93;
//    rom_array[13] = 8'h83;
//    rom_array[14] = 8'h83;
//    rom_array[15] = 8'hFF;
    
//    rom_array[16] = 8'h63;
//    rom_array[17] = 8'hDE;
//    rom_array[18] = 8'h62;
//    rom_array[19] = 8'h00;
    
//    rom_array[20] = 8'h13;
//    rom_array[21] = 8'h85;
//    rom_array[22] = 8'h02;
//    rom_array[23] = 8'h00;
    
//    rom_array[24] = 8'hEF;
//    rom_array[25] = 8'h00;
//    rom_array[26] = 8'hC0;
//    rom_array[27] = 8'h01;
    
//    rom_array[28] = 8'h23;
//    rom_array[29] = 8'hA0;
//    rom_array[30] = 8'hA3;
//    rom_array[31] = 8'h00;
    
//    rom_array[32] = 8'h93;
//    rom_array[33] = 8'h83;
//    rom_array[34] = 8'h43;
//    rom_array[35] = 8'h00;
    
//    rom_array[36] = 8'h93;
//    rom_array[37] = 8'h82;
//    rom_array[38] = 8'h12;
//    rom_array[39] = 8'h00;
    
//    rom_array[40] = 8'h6F;
//    rom_array[41] = 8'hF0;
//    rom_array[42] = 8'h9F;
//    rom_array[43] = 8'hFE;
    
//    rom_array[44] = 8'h13;
//    rom_array[45] = 8'h05;
//    rom_array[46] = 8'hA0;
//    rom_array[47] = 8'h00;
    
//    rom_array[48] = 8'h73;
//    rom_array[49] = 8'h00;
//    rom_array[50] = 8'h00;
//    rom_array[51] = 8'h00;
    
//    rom_array[52] = 8'h13;
//    rom_array[53] = 8'h01;
//    rom_array[54] = 8'h41;
//    rom_array[55] = 8'hFF;
    
//    rom_array[56] = 8'h23;
//    rom_array[57] = 8'h20;
//    rom_array[58] = 8'h11;
//    rom_array[59] = 8'h00;
    
//    rom_array[60] = 8'h23;
//    rom_array[61] = 8'h22;
//    rom_array[62] = 8'hA1;
//    rom_array[63] = 8'h00;
    
//    rom_array[64] = 8'h13;
//    rom_array[65] = 8'h0E;
//    rom_array[66] = 8'h10;
//    rom_array[67] = 8'h00;
    
//    rom_array[68] = 8'h63;
//    rom_array[69] = 8'h44;
//    rom_array[70] = 8'hAE;
//    rom_array[71] = 8'h00;
    
//    rom_array[72] = 8'h6F;
//    rom_array[73] = 8'h00;
//    rom_array[74] = 8'h40;
//    rom_array[75] = 8'h02;
    
//    rom_array[76] = 8'h13;
//    rom_array[77] = 8'h05;
//    rom_array[78] = 8'hF5;
//    rom_array[79] = 8'hFF;
    
//    rom_array[80] = 8'hEF;
//    rom_array[81] = 8'hF0;
//    rom_array[82] = 8'h5F;
//    rom_array[83] = 8'hFE;
    
//    rom_array[84] = 8'h23;
//    rom_array[85] = 8'h24;
//    rom_array[86] = 8'hA1;
//    rom_array[87] = 8'h00;
    
//    rom_array[88] = 8'h03;
//    rom_array[89] = 8'h25;
//    rom_array[90] = 8'h41;
//    rom_array[91] = 8'h00;
    
//    rom_array[92] = 8'h13;
//    rom_array[93] = 8'h05;
//    rom_array[94] = 8'hE5;
//    rom_array[95] = 8'hFF;
    
//    rom_array[96] = 8'hEF;
//    rom_array[97] = 8'hF0;
//    rom_array[98] = 8'h5F;
//    rom_array[99] = 8'hFD;
    
//    rom_array[100] = 8'h83;
//    rom_array[101] = 8'h25;
//    rom_array[102] = 8'h81;
//    rom_array[103] = 8'h00;
    
//    rom_array[104] = 8'h33;
//    rom_array[105] = 8'h05;
//    rom_array[106] = 8'hB5;
//    rom_array[107] = 8'h00;
    
//    rom_array[108] = 8'h83;
//    rom_array[109] = 8'h20;
//    rom_array[110] = 8'h01;
//    rom_array[111] = 8'h00;
    
//    rom_array[112] = 8'h13;
//    rom_array[113] = 8'h01;
//    rom_array[114] = 8'hC1;
//    rom_array[115] = 8'h00;
    
//    rom_array[116] = 8'h67;
//    rom_array[117] = 8'h80;
//    rom_array[118] = 8'h00;
//    rom_array[119] = 8'h00;
        
      rom_array[0] = 8'h10;
      rom_array[1] = 8'h00;
      rom_array[2] = 8'h00;
      rom_array[3] = 8'hB7;
      
      rom_array[4] = 8'h3F;
      rom_array[5] = 8'h80;
      rom_array[6] = 8'h01;
      rom_array[7] = 8'h37;
      
      rom_array[8] = 8'h00;
      rom_array[9] = 8'h01;
      rom_array[10] = 8'h01;
      rom_array[11] = 8'h13;
      
      rom_array[12] = 8'h00;
      rom_array[13] = 8'h20;
      rom_array[14] = 8'hA0;
      rom_array[15] = 8'h23;
      
      rom_array[16] = 8'h04;
      rom_array[17] = 8'h0E;
      rom_array[18] = 8'h01;
      rom_array[19] = 8'h37;
      
      rom_array[20] = 8'h00;
      rom_array[21] = 8'h01;
      rom_array[22] = 8'h01;
      rom_array[23] = 8'h13;
      
      rom_array[24] = 8'h00;
      rom_array[25] = 8'h20;
      rom_array[26] = 8'hA2;
      rom_array[27] = 8'h23;
      
      rom_array[28] = 8'h00;
      rom_array[29] = 8'h00;
      rom_array[30] = 8'hA0;
      rom_array[31] = 8'h87;
      
      rom_array[32] = 8'h00;
      rom_array[33] = 8'h40;
      rom_array[34] = 8'hA1;
      rom_array[35] = 8'h07;
      
      rom_array[36] = 8'h00;
      rom_array[37] = 8'h20;
      rom_array[38] = 8'h81;
      rom_array[39] = 8'hD3;
      
      rom_array[40] = 8'h08;
      rom_array[41] = 8'h11;
      rom_array[42] = 8'h02;
      rom_array[43] = 8'h53;
      
      rom_array[44] = 8'h10;
      rom_array[45] = 8'h20;
      rom_array[46] = 8'h82;
      rom_array[47] = 8'hD3;
      
      rom_array[48] = 8'h00;
      rom_array[49] = 8'h30;
      rom_array[50] = 8'hA4;
      rom_array[51] = 8'h27;
      
      rom_array[52] = 8'h00;
      rom_array[53] = 8'h40;
      rom_array[54] = 8'hA6;
      rom_array[55] = 8'h27;
      
      rom_array[56] = 8'h00;
      rom_array[57] = 8'h50;
      rom_array[58] = 8'hA8;
      rom_array[59] = 8'h27;
      
    for (i = 60; i < 2**(`ADDRLEN); i = i + 1) 
    begin
      rom_array[i] = 8'h00;
    end
    
  end
endmodule
