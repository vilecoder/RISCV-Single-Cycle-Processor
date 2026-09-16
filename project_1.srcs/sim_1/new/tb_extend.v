`timescale 1ns / 1ps

module tb_extend();
    
    // 1. Declare testbench signals
    reg  [31:7] instr;
    reg  [2:0]  immsrc;
    wire [31:0] immext;

    // 2. Instantiate the Device Under Test (DUT)
    extend dut (
        .instr(instr),
        .immsrc(immsrc),
        .immext(immext)
    );

    // 3. Apply test vectors sequentially
    initial begin
        // Initialize inputs
        instr = 25'b0; 
        immsrc = 3'b000;
        #10;

        // --- TEST CASE 1: I-type Instruction (Negative Immediate) ---
        // Simulating: lw x6, -4(x9)
        // Immediate is -4 (12-bit hex: FFC). For I-type, it is found in instr[31:20].
        immsrc = 3'b000;
        instr[31:20] = 12'hFFC; 
        #10;
        
        if (immext !== 32'hFFFFFFFC)
            $display("Test 1 Failed: I-type expected FFFFFFFC, got %h", immext);
        else
            $display("Test 1 Passed: I-type correctly sign-extended -4.");

        // --- TEST CASE 2: S-type Instruction (Positive Split Immediate) ---
        // Simulating: sw x6, 8(x9)
        // Immediate is 8 (12-bit binary: 0000000_01000). S-type splits this across two fields.
        immsrc = 3'b001;
        instr[31:25] = 7'b0000000; // Upper 7 bits
        instr[11:7]  = 5'b01000;   // Lower 5 bits
        #10;
        
        if (immext !== 32'h00000008)
            $display("Test 2 Failed: S-type expected 00000008, got %h", immext);
        else
            $display("Test 2 Passed: S-type correctly extracted and padded 8.");

        // --- TEST CASE 3: U-type Instruction (Upper Immediate) ---
        // Simulating: lui x1, 0x12345
        // Immediate is 0x12345. U-type stores this in instr[31:12] and pads 12 zeros to the right.
        immsrc = 3'b100;
        instr[31:12] = 20'h12345;
        #10;
        
        if (immext !== 32'h12345000)
            $display("Test 3 Failed: U-type expected 12345000, got %h", immext);
        else
            $display("Test 3 Passed: U-type correctly shifted and padded with zeros.");

        // End simulation
        $display("Simulation complete.");
        $stop;
    end
    
endmodule