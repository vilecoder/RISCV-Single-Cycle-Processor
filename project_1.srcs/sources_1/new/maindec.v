`timescale 1ns / 1ps
//Verilog implementation for the Main Decoder, mapped directly from the RISC-V enhanced truth table (Table 7.6)
module maindec(
    input wire [6:0]op,
    output reg [1:0] ResultSrc,
    output reg MemWrite,
    output reg Branch,
    output reg ALUSrc,
    output reg RegWrite,
    output reg Jump,
    output reg [1:0] ImmSrc,
    output reg [1:0] ALUOp
    );
    
    always@(*)begin
        case(op)
            7'b0000011: begin //lw( load word)
                RegWrite = 1'b1;ImmSrc=2'b00;ALUSrc=1'b1;MemWrite =1'b0;
                ResultSrc = 2'b01;Branch=1'b0;ALUOp=2'b00;Jump=1'b0;
            end
            7'b0100011: begin //sw( store word)
                RegWrite = 1'b0;ImmSrc=2'b01;ALUSrc=1'b1;MemWrite =1'b1;
                ResultSrc = 2'b00;Branch=1'b0;ALUOp=2'b00;Jump=1'b0;
            end
            7'b0110011: begin // R-type (add, sub, and, or, slt)
                RegWrite = 1'b1;ImmSrc=2'b00;ALUSrc=1'b1;MemWrite =1'b0;
                ResultSrc = 2'b00;Branch=1'b0;ALUOp=2'b10;Jump=1'b0;
            end
            7'b1100011: begin // beq (branch if equal)
                RegWrite = 1'b0;ImmSrc=2'b10;ALUSrc=1'b0;MemWrite =1'b0;
                ResultSrc = 2'b00;Branch=1'b1;ALUOp=2'b01;Jump=1'b0;
            end
            7'b0010011: begin // I-type ALU (addi)
                RegWrite = 1'b1;ImmSrc=2'b00;ALUSrc=1'b0;MemWrite =1'b0;
                ResultSrc = 2'b10;Branch=1'b0;ALUOp=2'b01;Jump=1'b1;
            end
            7'b1101111: begin // jal (jump and link)
                RegWrite = 1'b1;ImmSrc=2'b11;ALUSrc=1'b0;MemWrite =1'b0;
                ResultSrc = 2'b10;Branch=1'b0;ALUOp=2'b00;Jump=1'b1;
            end
            default: begin
                RegWrite = 1'b0; ImmSrc = 2'b00; ALUSrc = 1'b0; MemWrite = 1'b0; 
                ResultSrc = 2'b00; Branch = 1'b0; ALUOp = 2'b00; Jump = 1'b0;
            end
        endcase          
    end
endmodule
