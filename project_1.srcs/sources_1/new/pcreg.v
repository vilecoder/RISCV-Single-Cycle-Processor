`timescale 1ns / 1ps

module flopr#(parameter WIDTH = 32)(
    input wire clk,
    input wire reset,
    input wire [WIDTH-1:0] d,
    output reg [WIDTH-1:0]q
    );
    
    always@(posedge clk or posedge reset)begin
        if(reset)begin
            q<= 32'h00001000;
        end
        else begin
            q<=d;
        end
    end
endmodule
