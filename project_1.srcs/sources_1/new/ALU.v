`timescale 1ns / 1ps

module alu(
    input  wire [31:0] SrcA, SrcB,
    input  wire [2:0]  ALUControl,
    output reg  [31:0] ALUResult,
    output wire        Zero
);

    always @(*) begin
        case (ALUControl)
            3'b000: ALUResult = SrcA + SrcB;       // add, addi, lw, sw
            3'b001: ALUResult = SrcA - SrcB;       // sub, beq
            3'b010: ALUResult = SrcA & SrcB;       // and, andi
            3'b011: ALUResult = SrcA | SrcB;       // or, ori
            3'b101: ALUResult = (SrcA < SrcB) ? 32'd1 : 32'd0; // slt, slti
            default: ALUResult = 32'bx;            // Prevent latches 
        endcase
    end

    assign Zero = (ALUResult == 32'b0);

endmodule