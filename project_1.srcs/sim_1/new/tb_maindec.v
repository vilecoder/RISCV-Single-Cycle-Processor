`timescale 1ns / 1ps

module tb_maindec();

    // 1. Declare testbench signals
    // Input is 'reg' because we drive it procedurally in the initial block
    reg  [6:0] op;
    
    // Outputs from DUT are 'wire'
    wire [1:0] ResultSrc;
    wire       MemWrite;
    wire       Branch;
    wire       ALUSrc;
    wire       RegWrite;
    wire       Jump;
    wire [1:0] ImmSrc;
    wire [1:0] ALUOp;

    // 2. Instantiate the Device Under Test (DUT)
    maindec dut (
        .op(op),
        .ResultSrc(ResultSrc),
        .MemWrite(MemWrite),
        .Branch(Branch),
        .ALUSrc(ALUSrc),
        .RegWrite(RegWrite),
        .Jump(Jump),
        .ImmSrc(ImmSrc),
        .ALUOp(ALUOp)
    );

    // 3. Apply test vectors sequentially
    initial begin
        // --- TEST CASE 1: lw (Load Word) ---
        // Opcode for lw is 0000011
        op = 7'b0000011; 
        #10; // Wait for combinational logic to evaluate
        
        // lw should write to a register, read from memory, and use the ALU to add the offset
        if (RegWrite !== 1'b1 || MemWrite !== 1'b0 || ALUSrc !== 1'b1 || ResultSrc !== 2'b01)
            $display("Test 1 Failed: lw decoded incorrectly.");
        else
            $display("Test 1 Passed: lw signals match expected values.");

        // --- TEST CASE 2: sw (Store Word) ---
        // Opcode for sw is 0100011
        op = 7'b0100011; 
        #10;
        
        // sw writes to memory, uses the immediate for ALU address generation, and does not write to a register
        if (MemWrite !== 1'b1 || RegWrite !== 1'b0 || ALUSrc !== 1'b1)
            $display("Test 2 Failed: sw decoded incorrectly.");
        else
            $display("Test 2 Passed: sw signals match expected values.");

        // --- TEST CASE 3: R-type (add, sub, and, etc.) ---
        // Opcode for R-type is 0110011
        op = 7'b0110011; 
        #10;
        
        // R-type writes to a register, uses registers for both ALU inputs (ALUSrc=0), and defers to ALUOp=10
        if (RegWrite !== 1'b1 || ALUSrc !== 1'b0 || ALUOp !== 2'b10)
            $display("Test 3 Failed: R-type decoded incorrectly.");
        else
            $display("Test 3 Passed: R-type signals match expected values.");

        // --- TEST CASE 4: beq (Branch if Equal) ---
        // Opcode for beq is 1100011
        op = 7'b1100011; 
        #10;
        
        // beq flags Branch=1, subtracts operands (ALUOp=01), and does not write to memory or registers
        if (Branch !== 1'b1 || ALUOp !== 2'b01 || RegWrite !== 1'b0)
            $display("Test 4 Failed: beq decoded incorrectly.");
        else
            $display("Test 4 Passed: beq signals match expected values.");

        // End simulation
        $display("Simulation complete.");
        $stop;
    end
    
endmodule