`timescale 1ns / 1ps

module tb_controller();

    // 1. Declare testbench signals
    // Inputs to the DUT are 'reg'
    reg  [6:0] op;
    reg  [2:0] funct3;
    reg        funct7b5;
    reg        Zero;
    
    // Outputs from the DUT are 'wire'
    wire [1:0] ResultSrc;
    wire       MemWrite;
    wire       PCSrc;
    wire       ALUSrc;
    wire       RegWrite;
    wire       Jump;
    wire [1:0] ImmSrc;
    wire [2:0] ALUControl;

    // 2. Instantiate the Device Under Test (DUT)
    controller dut (
        .op(op),
        .funct3(funct3),
        .funct7b5(funct7b5),
        .Zero(Zero),
        .ResultSrc(ResultSrc),
        .MemWrite(MemWrite),
        .PCSrc(PCSrc),
        .ALUSrc(ALUSrc),
        .RegWrite(RegWrite),
        .Jump(Jump),
        .ImmSrc(ImmSrc),
        .ALUControl(ALUControl)
    );

    // 3. Apply test vectors sequentially
    initial begin
        // Initialize inputs
        op = 7'b0000000; 
        funct3 = 3'b000; 
        funct7b5 = 1'b0; 
        Zero = 1'b0;
        #10;
        
        // --- TEST CASE 1: lw (Load Word) ---
        // Opcode = 0000011. Should output MemWrite=0, RegWrite=1, ALUSrc=1, ALUControl=000 (Add).
        op = 7'b0000011; 
        funct3 = 3'b010; 
        funct7b5 = 1'b0; 
        Zero = 1'b0;
        #10;
        
        if (RegWrite !== 1'b1 || MemWrite !== 1'b0 || ALUSrc !== 1'b1 || ImmSrc !== 2'b00 || ALUControl !== 3'b000)
            $display("Test 1 Failed: lw decoded incorrectly.");
        else
            $display("Test 1 Passed: lw successfully verified.");
            
        // --- TEST CASE 2: R-type Subtract ---
        // Opcode = 0110011. funct3 = 000, funct7b5 = 1.
        // Should output RegWrite=1, ALUSrc=0, ALUControl=001 (Sub).
        op = 7'b0110011; 
        funct3 = 3'b000; 
        funct7b5 = 1'b1; 
        Zero = 1'b0;
        #10;
        
        if (RegWrite !== 1'b1 || MemWrite !== 1'b0 || ALUSrc !== 1'b0 || ALUControl !== 3'b001 || PCSrc !== 1'b0)
            $display("Test 2 Failed: R-type sub decoded incorrectly.");
        else
            $display("Test 2 Passed: R-type sub successfully verified.");
            
        // --- TEST CASE 3: beq (Branch Taken) ---
        // Opcode = 1100011. Zero flag is 1, indicating operands are equal.
        // Should evaluate PCSrc to 1.
        op = 7'b1100011; 
        funct3 = 3'b000; 
        funct7b5 = 1'b0; 
        Zero = 1'b1;
        #10;
        
        if (MemWrite !== 1'b0 || RegWrite !== 1'b0 || PCSrc !== 1'b1 || ALUControl !== 3'b001)
            $display("Test 3 Failed: beq (taken) decoded incorrectly.");
        else
            $display("Test 3 Passed: beq (taken) triggered PCSrc successfully.");
            
        // --- TEST CASE 4: beq (Branch Not Taken) ---
        // Opcode = 1100011. Zero flag is 0, indicating operands are NOT equal.
        // Should evaluate PCSrc to 0.
        op = 7'b1100011; 
        funct3 = 3'b000; 
        funct7b5 = 1'b0; 
        Zero = 1'b0;
        #10;
        
        if (PCSrc !== 1'b0)
            $display("Test 4 Failed: beq (not taken) falsely triggered PCSrc.");
        else
            $display("Test 4 Passed: beq (not taken) successfully blocked PCSrc.");
            
        // End simulation
        $display("Simulation complete.");
        $stop;
    end
endmodule