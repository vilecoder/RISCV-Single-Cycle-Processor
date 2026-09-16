`timescale 1ns / 1ps

module datapath(
    input wire clk,reset,
    input wire [1:0] ResultSrc,
    input wire PCSrc,ALUSrc,
    input wire RegWrite,
    input wire [1:0]ImmSrc,
    input wire [2:0]ALUControl,
    output wire Zero,
    output wire [31:0] PC,
    input wire [31:0] Instr,
    output wire [31:0] ALUResult,WriteData,
    input wire [31:0] ReadData
    );
    
    wire [31:0] PCNext,PCPlus4,PCTarget;// Internal wire connecting the architectural blocks
    wire [31:0] ImmExt;
    wire [31:0] SrcA,SrcB;
    wire [31:0] Result;
    
    // Fetch stage routing
    
    // PC multiplexer: chooses between PC+4 and branch/jump target
    mux2#(32) pcmux(
        .d0(PCPlus4),
        .d1(PCTarget),
        .s(PCSrc),
        .y(PCNext)
        );
    // PC counter register
    flopr #(32) pcreg(
        .clk(clk),
        .reset(reset),
        .d(PCNext),
        .q(PC)
        );      
    
    //PC adder => PC+4
    adder pcadd4(
        .a(PC),
        .b(32'd4),
        .y(PCPlus4)
        );
     
    // Branch target adder : PC+ sign extended immidiate
    
    adder pcaddbranch(
        .a(PC),
        .b(ImmExt),
        .y(PCTarget)
        ); 
    
    // Decode stage Routing
    
    // Register File 
    rf rf_inst(
        .clk(clk),
        .we3(RegWrite),
        .a1(Instr[19:15]),// rs1
        .a2(Instr[24:20]),// rs2
        .a3(Instr[11:7]),// rd
        .wd3(Result),
        .rd1(SrcA),
        .rd2(WriteData)
        ); 
    
    // Immidiate Generator
    extend ext(
        .instr(Instr[31:7]),
        .immsrc(ImmSrc),
        .immext(ImmExt)
        ); 
  
    // Execute stage routing
    
    //ALU source multiplier : chooses between rs2 and immidiate
    mux2 #(32) srcbmux(
        .d0(WriteData),
        .d1(ImmExt),
        .s(ALUSrc),
        .y(SrcB)
        );
    
    // ALU
    alu alu_inst(
        .SrcA(SrcA),              
        .SrcB(SrcB),               
        .ALUControl(ALUControl),   
        .ALUResult(ALUResult),     
        .Zero(Zero)                
        );
        
    // Write back stage routing
    
    // Result multiplier : chooses what gets written back to the register file
    
    mux3 #(32) resmux(
        .d0(ALUResult),
        .d1(ReadData),
        .d2(PCPlus4),
        .s(ResultSrc),
        .y(Result)
        );
        
endmodule
