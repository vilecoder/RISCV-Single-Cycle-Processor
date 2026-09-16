`timescale 1ns / 1ps

module imem(
    input wire [31:0] a,
    output wire [31:0] rd
    );
    
    reg [31:0] RAM [63:0]; // 64 element X 32 bit memory array
    
    // load machine code from text file during sim
    initial begin
        $readmemh("D:/RISC_V/project_1/riscvtest.txt", RAM);
    end
    
    // word aligned combinational read
    
    assign rd = RAM[a[31:2]];
   
endmodule
