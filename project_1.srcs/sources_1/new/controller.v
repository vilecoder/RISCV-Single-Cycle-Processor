`timescale 1ns / 1ps

module controller(
    input wire [6:0] op,
    input wire [2:0] funct3,
    input wire funct7b5,
    input wire Zero,
    output wire [1:0]ResultSrc,
    output wire MemWrite,
    output wire PCSrc,
    output wire ALUSrc,
    output wire RegWrite,
    output wire Jump,
    output wire [1:0] ImmSrc,
    output wire [2:0] ALUControl
    );
    
    wire [1:0] ALUOp;
    wire Branch;
    
    //instantiate main decoder
    
    maindec md(.op(op),
        .ResultSrc(ResultSrc),
        .MemWrite(MemWrite),
        .Branch(Branch),
        .ALUSrc(ALUSrc),
        .RegWrite(RegWrite),
        .Jump(Jump),
        .ImmSrc(ImmSrc),
        .ALUOp(ALUOp)
        );
        
    //instantiate ALU decoder
    aludec ad(
        .opb5(op[5]),
        .funct3(funct3),
        .funct7b5(funct7b5),
        .ALUOp(ALUOp),
        .ALUControl(ALUControl)
        );
    assign PCSrc = (Branch & Zero) | Jump;
endmodule
