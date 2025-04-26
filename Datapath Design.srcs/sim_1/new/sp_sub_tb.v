`timescale 1ns / 1ps

module sp_sub_tb;

reg [31:0] a, b;
wire [31:0] diff;

sp_sub uut (
    .a(a),
    .b(b),
    .diff(diff)
);

reg [31:0] A_vals [0:9];
reg [31:0] B_vals [0:9];
integer i;

initial begin
    A_vals[0] = 32'h3F800000; B_vals[0] = 32'h3F800000; // 1 - 1
    A_vals[1] = 32'h40400000; B_vals[1] = 32'h40000000; // 3 - 2
    A_vals[2] = 32'h3F800000; B_vals[2] = 32'h00000000; // 1 - 0
    A_vals[3] = 32'h7F800000; B_vals[3] = 32'h7F800000; // inf - inf
    A_vals[4] = 32'h7F800000; B_vals[4] = 32'hFF800000; // inf - (-inf)
    A_vals[5] = 32'h3F800000; B_vals[5] = 32'hBF800000; // 1 - (-1)
    A_vals[6] = 32'h3F800000; B_vals[6] = 32'h3F000000; // 1 - 0.5
    A_vals[7] = 32'h3F800000; B_vals[7] = 32'h3F800000; // 1 - 1
    A_vals[8] = 32'h00800000; B_vals[8] = 32'h00800000; // smallest normals
    A_vals[9] = 32'h00000001; B_vals[9] = 32'h00000001; // smallest subnormals

    for (i = 0; i < 10; i = i + 1) begin
        a = A_vals[i];
        b = B_vals[i];
        #10;
        $display("a = %h, b = %h, diff = %h", a, b, diff);
    end
    $stop;
end

endmodule
