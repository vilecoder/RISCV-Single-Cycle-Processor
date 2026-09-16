`timescale 1ns / 1ps

module tb_riscvsingle();

    // 1. Declare signals
    reg         clk;
    reg         reset;
    wire [31:0] PC;
    reg  [31:0] Instr;
    wire        MemWrite;
    wire [31:0] ALUResult;
    wire [31:0] WriteData;
    reg  [31:0] ReadData;

    // 2. Instantiate the CPU Core (Device Under Test)
    riscvsingle dut (
        .clk(clk),
        .reset(reset),
        .PC(PC),
        .Instr(Instr),
        .MemWrite(MemWrite),
        .ALUResult(ALUResult),
        .WriteData(WriteData),
        .ReadData(ReadData)
    );

    // 3. Generate Clock (10 ns period)
    always begin
        clk = 1; #5;
        clk = 0; #5;
    end

    // 4. Mock Instruction Memory (Combinational lookup based on PC)
    // We simulate an external imem.v directly in the testbench to feed the CPU
    always @(PC) begin
        case (PC)
            // addi x2, x0, 5 
            32'h00001000: Instr = 32'h00500113; 
            
            // addi x3, x0, 12
            32'h00001004: Instr = 32'h00C00193; 
            
            // add x4, x2, x3 (5 + 12 = 17)
            32'h00001008: Instr = 32'h00310233; 
            
            // sw x4, 100(x0) (Store 17 at memory address 100)
            32'h0000100C: Instr = 32'h06402223; 
            
            // default to NOP (addi x0, x0, 0)
            default:      Instr = 32'h00000013; 
        endcase
    end

    // 5. Apply reset and monitor the final Store Word instruction
    initial begin
        // Initialize
        ReadData = 32'b0; // Mock an empty data memory output
        reset = 1;
        #10;
        
        reset = 0;
        
        // Wait enough cycles for the 'sw' instruction to execute
        // Cycle 1: addi, Cycle 2: addi, Cycle 3: add, Cycle 4: sw
        #40; 
        
        // The 4th instruction (sw) should trigger MemWrite high, 
        // calculate address 100 in the ALU, and place 17 on the WriteData bus.
        if (MemWrite === 1'b1 && ALUResult === 32'd100 && WriteData === 32'd17)
            $display("Test Passed: CPU successfully fetched, decoded, executed, and stored the result!");
        else
            $display("Test Failed: Check CPU wiring. MemWrite=%b, Addr=%d, Data=%d", MemWrite, ALUResult, WriteData);

        $display("Simulation complete.");
        $stop;
    end

endmodule