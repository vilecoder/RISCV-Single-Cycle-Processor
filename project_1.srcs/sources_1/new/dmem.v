`timescale 1ns / 1ps

module dmem(
    input  wire        clk,
    input  wire        we,
    input  wire [31:0] a,
    input  wire [31:0] wd,
    output wire [31:0] rd
);

    // 64-element x 32-bit memory array
    reg [31:0] RAM [63:0];

    // Word-aligned combinational read
    assign rd = RAM[a[31:2]];

    // Synchronous write
    always @(posedge clk) begin
        if (we) begin
            RAM[a[31:2]] <= wd;
        end
    end

endmodule