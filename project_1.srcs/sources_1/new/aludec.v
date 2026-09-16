`timescale 1ns / 1ps

module aludec(
    input wire opb5,
    input wire [2:0] funct3,
    input wire funct7b5,
    input wire [1:0] ALUOp,
    output reg [2:0] ALUControl
    );
    
    wire RtypeSub;
    assign RtypeSub = funct7b5 & opb5;
    
    always@(*) begin
        case (ALUOp)
            2'b00: ALUControl = 3'b000; //addition : for lw,sw,jal
            2'b01: ALUControl = 3'b001; //subtraction : for beq
            default:begin // covers R type and I type begin
                case(funct3)
                    3'b000:begin
                        if(RtypeSub)
                            ALUControl = 3'b001;//sub
                        else
                            ALUControl = 3'b000;//add
                    end
                    3'b010: ALUControl = 3'b101;//slt
                    3'b110: ALUControl = 3'b011;//or
                    3'b111: ALUControl = 3'b010;//and
                    default: ALUControl = 3'bxxx; // Prevent latches
                endcase
            end
        endcase
        end
endmodule
