`timescale 1ns / 1ps

module tb_alu();

    // 1. Declare testbench signals
    // Inputs are driven procedurally, so they must be declared as 'reg'
    reg  [31:0] SrcA, SrcB;
    reg  [2:0]  ALUControl;
    
    // Outputs are driven continuously by the DUT, so they must be 'wire'
    wire [31:0] ALUResult;
    wire        Zero;

    // 2. Instantiate the Device Under Test (DUT)
    alu dut (
        .SrcA(SrcA),
        .SrcB(SrcB),
        .ALUControl(ALUControl),
        .ALUResult(ALUResult),
        .Zero(Zero)
    );

    // 3. Apply test vectors sequentially
    initial begin
        // Initialize inputs
        SrcA = 32'b0; 
        SrcB = 32'b0; 
        ALUControl = 3'b000;
        #10;

        // --- TEST CASE 1: Addition (add, addi, lw, sw) ---
        SrcA = 32'd15; 
        SrcB = 32'd10; 
        ALUControl = 3'b000;
        #10;
        
        if (ALUResult !== 32'd25 || Zero !== 1'b0)
            $display("Test 1 Failed: ADD expected 25 (Zero=0), got %d (Zero=%b)", ALUResult, Zero);
        else
            $display("Test 1 Passed: Addition verified.");

        // --- TEST CASE 2: Subtraction & Zero Flag (sub, beq) ---
        // Simulating equal operands to verify the Zero flag triggers for branch checks
        SrcA = 32'd100; 
        SrcB = 32'd100; 
        ALUControl = 3'b001;
        #10;
        
        if (ALUResult !== 32'd0 || Zero !== 1'b1)
            $display("Test 2 Failed: SUB expected 0 (Zero=1), got %d (Zero=%b)", ALUResult, Zero);
        else
            $display("Test 2 Passed: Subtraction and Zero flag verified.");

        // --- TEST CASE 3: Logical AND (and, andi) ---
        SrcA = 32'hFFFF0000; 
        SrcB = 32'h0F0F0F0F; 
        ALUControl = 3'b010;
        #10;
        
        if (ALUResult !== 32'h0F0F0000)
            $display("Test 3 Failed: AND expected 0F0F0000, got %h", ALUResult);
        else
            $display("Test 3 Passed: Logical AND verified.");

        // --- TEST CASE 4: Logical OR (or, ori) ---
        SrcA = 32'hAA00AA00; 
        SrcB = 32'h00BB00BB; 
        ALUControl = 3'b011;
        #10;
        
        if (ALUResult !== 32'hAABBAABB)
            $display("Test 4 Failed: OR expected AABBAABB, got %h", ALUResult);
        else
            $display("Test 4 Passed: Logical OR verified.");

        // --- TEST CASE 5: Set Less Than (slt, slti) ---
        // Test 5a: SrcA is less than SrcB (Should output 1)
        SrcA = 32'd50; 
        SrcB = 32'd75; 
        ALUControl = 3'b101;
        #10;
        
        if (ALUResult !== 32'd1)
            $display("Test 5a Failed: SLT (50 < 75) expected 1, got %d", ALUResult);
        else
            $display("Test 5a Passed: SLT (True condition) verified.");

        // Test 5b: SrcA is greater than SrcB (Should output 0)
        SrcA = 32'd75; 
        SrcB = 32'd50;
        #10;
        
        if (ALUResult !== 32'd0)
            $display("Test 5b Failed: SLT (75 < 50) expected 0, got %d", ALUResult);
        else
            $display("Test 5b Passed: SLT (False condition) verified.");

        // End simulation
        $display("Simulation complete.");
        $stop;
    end
    
endmodule