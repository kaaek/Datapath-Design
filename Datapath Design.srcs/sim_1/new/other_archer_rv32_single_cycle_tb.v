`timescale 1ns / 1ps
`include "../../sources_1/imports/verilog/archerdefs.v"


module archer_rv32i_single_cycle_tb;

    reg tb_clk = 1'b0;
    reg tb_rst_n = 1'b1;

    wire [31:0] tb_imem_addr;
    wire [31:0] tb_imem_dataout;

    wire [31:0] tb_dmem_addr;
    wire [31:0] tb_dmem_datain;
    wire [31:0] tb_dmem_dataout;
    wire tb_dmem_wen;
    wire [3:0] tb_dmem_ben;

    // Instantiate processor
    archer_rv32i_single_cycle archer (
        .clk(tb_clk),
        .rst_n(tb_rst_n),
        .imem_addr(tb_imem_addr),
        .imem_datain(),
        .imem_dataout(tb_imem_dataout),
        .imem_wen(),
        .imem_ben(),
        .dmem_addr(tb_dmem_addr),
        .dmem_datain(tb_dmem_datain),
        .dmem_dataout(tb_dmem_dataout),
        .dmem_wen(tb_dmem_wen),
        .dmem_ben(tb_dmem_ben)
    );

    // Simple memory for instructions and data
    sram dmem (
        .clk(tb_clk),
        .wen(tb_dmem_wen),
        .ben(tb_dmem_ben),
        .addr(tb_dmem_addr[11:2]),  // Take only bits [11:2] for 10 bits total
        .datain(tb_dmem_datain),
        .dataout(tb_dmem_dataout)
    );

    sram imem (
        .clk(tb_clk),
        .wen(1'b0), // ROM behavior
        .ben(4'b0000),
        .addr(tb_imem_addr[31:2]),
        .datain(32'b0),
        .dataout(tb_imem_dataout)
    );

    // Clock generation
    always #5 tb_clk = ~tb_clk;

    // Stimulus
    initial begin
    // Reset pulse
        tb_rst_n = 0;
        #20;
        tb_rst_n = 1;
        #10;
    
        // Preload register values manually
        archer.RF_inst.RF[1] = 32'h3f800000; // x1 = 1.0
        archer.RF_inst.RF[2] = 32'h3f800000; // x2 = 1.0
    
        #100;
    
        // Display results
        $display("\n--- Test Results ---");
        $display("Register x1 (should be 1.0): %h", archer.reg_x1);
        $display("Register x2 (should be 1.0): %h", archer.reg_x2);
        $display("Register x3 (ADD result should be 2.0): %h", archer.reg_x3);
        $display("Register x4 (MUL result should be 1.0): %h", archer.reg_x4);
    
        $stop;
    end


endmodule
