`timescale 1ns / 1ps

module tb_aludec();

    // 1. Declare testbench signals
    // Inputs to the DUT are 'reg' because they are procedurally driven
    reg        opb5;
    reg  [2:0] funct3;
    reg        funct7b5;
    reg  [1:0] ALUOp;
    
    // Output from the DUT is 'wire'
    wire [2:0] ALUControl;

    // 2. Instantiate the Device Under Test (DUT)
    aludec dut (
        .opb5(opb5),
        .funct3(funct3),
        .funct7b5(funct7b5),
        .ALUOp(ALUOp),
        .ALUControl(ALUControl)
    );

    // 3. Apply test vectors sequentially
    initial begin
        // Initialize inputs
        opb5 = 1'b0; 
        funct3 = 3'b000; 
        funct7b5 = 1'b0; 
        ALUOp = 2'b00;
        #10; // Wait for logic to evaluate

        // --- TEST CASE 1: Memory Operation (lw / sw / jal) ---
        // ALUOp = 00 should force addition (000), ignoring all other inputs
        ALUOp = 2'b00; 
        funct3 = 3'b111; // Pass garbage to funct3 to prove it is ignored
        #10;
        
        if (ALUControl !== 3'b000)
            $display("Test 1 Failed: Memory operation did not force addition.");
        else
            $display("Test 1 Passed: Memory operation forces Add (000).");

        // --- TEST CASE 2: Branch Operation (beq) ---
        // ALUOp = 01 should force subtraction (001)
        ALUOp = 2'b01;
        #10;
        
        if (ALUControl !== 3'b001)
            $display("Test 2 Failed: Branch operation did not force subtraction.");
        else
            $display("Test 2 Passed: Branch operation forces Sub (001).");

        // --- TEST CASE 3: R-type Subtract (sub) ---
        // ALUOp = 10, op[5] = 1, funct3 = 000, funct7[5] = 1
        ALUOp = 2'b10; 
        opb5 = 1'b1; 
        funct3 = 3'b000; 
        funct7b5 = 1'b1;
        #10;
        
        if (ALUControl !== 3'b001)
            $display("Test 3 Failed: R-type Subtract failed.");
        else
            $display("Test 3 Passed: R-type Subtract correctly decoded (001).");

        // --- TEST CASE 4: The 'addi' Garbage funct7 Trap ---
        // Simulating addi: ALUOp = 10, op[5] = 0, funct3 = 000
        // We set funct7[5] = 1 to simulate garbage data that could accidentally trigger a subtract
        ALUOp = 2'b10; 
        opb5 = 1'b0; // This 0 should kill the RtypeSub flag
        funct3 = 3'b000; 
        funct7b5 = 1'b1;
        #10;
        
        if (ALUControl !== 3'b000)
            $display("Test 4 Failed: I-type addi was fooled by garbage funct7 data.");
        else
            $display("Test 4 Passed: I-type addi successfully ignored garbage funct7 (RtypeSub trap worked).");

        // --- TEST CASE 5: R-type Set Less Than (slt) ---
        // ALUOp = 10, funct3 = 010
        ALUOp = 2'b10; 
        funct3 = 3'b010;
        #10;
        
        if (ALUControl !== 3'b101)
            $display("Test 5 Failed: R-type SLT failed.");
        else
            $display("Test 5 Passed: R-type SLT correctly decoded (101).");

        // End simulation
        $display("Simulation complete.");
        $stop;
    end
    
endmodule