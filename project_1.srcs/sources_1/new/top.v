`timescale 1ns / 1ps

module top(
    input wire clk,
    input wire reset,
    output wire [31:0] WriteData,
    output wire [31:0] DataAdr,
    output wire MemWrite
    );
    
    wire [31:0] PC,Instr,ReadData;
    
    // Instantiate processor and memories
    
    riscvsingle rvsingle(
        .clk(clk),
        .reset(reset),
        .PC(PC),
        .Instr(Instr),
        .MemWrite(MemWrite),
        .ALUResult(DataAdr),
        .WriteData(WriteData),
        .ReadData(ReadData)
        );
    
    imem imem(
        .a(PC),
        .rd(Instr)
        );
    
    dmem dmem(
        .clk(clk),
        .we(MemWrite),
        .a(DataAdr),
        .wd(WriteData),
        .rd(ReadData)
        );
endmodule
