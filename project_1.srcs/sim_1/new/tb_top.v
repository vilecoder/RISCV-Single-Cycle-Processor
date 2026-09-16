`timescale 1ns / 1ps

module tb_top();

    reg clk;
    reg reset;
    wire [31:0] WriteData;
    wire [31:0] DataAdr;
    wire MemWrite;
    
    top dut (
        .clk(clk),
        .reset(reset),
        .WriteData(WriteData),
        .DataAdr(DataAdr),
        .MemWrite(MemWrite)
        );
    
    // clk
    initial begin
        clk=0;
    end
    always #5 clk = ~ clk;
    
    // rst
    initial begin
        reset = 1;
        #22
        reset =0;
    end
    
    always@(negedge clk) begin
        if(MemWrite)begin
            if(DataAdr == 32'd100 && WriteData == 32'd25)begin
                $display("Simulation success : CPU successfully wrote 25 to memory address 100");
                $stop;
            end
            
            else if(DataAdr !== 32'd96)begin
                $display(" Simulation failed : Unexpected memory write . addr = %d, data = %d",DataAdr,WriteData);
                $stop;
            end
        end
    end
endmodule
