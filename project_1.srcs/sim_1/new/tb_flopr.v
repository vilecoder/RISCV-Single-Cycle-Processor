`timescale 1ns / 1ps

module tb_flopr();

    // 1. Declare testbench signals
    // Inputs to the DUT are 'reg' because they are procedurally driven
    reg         clk;
    reg         reset;
    reg  [31:0] d;
    
    // Outputs from the DUT are 'wire'
    wire [31:0] q;

    // 2. Instantiate the Device Under Test (DUT)
    // Here we use #() to override the default parameter to 32 bits
    flopr #(32) dut (
        .clk(clk),
        .reset(reset),
        .d(d),
        .q(q)
    );

    // 3. Generate a continuous clock (10 ns period)
    always begin
        clk = 1; #5; 
        clk = 0; #5;
    end

    // 4. Apply test vectors sequentially
    initial begin
        // --- TEST CASE 1: System Reset ---
        // Verify that the PC initializes to the boot address regardless of the 'd' input
        reset = 1; 
        d = 32'hFFFFFFFF; // Dummy data; should be ignored while reset is high
        #10; // Wait for one full clock cycle
        
        if (q !== 32'h00001000)
            $display("Test 1 Failed: Expected reset value 00001000, got %h", q);
        else
            $display("Test 1 Passed: PC correctly initialized to 00001000.");

        // --- TEST CASE 2: Standard PC Increment (PC + 4) ---
        // Simulating standard sequential execution
        reset = 0;
        d = 32'h00001004; 
        #10; // Wait for the positive clock edge to latch the new address
        
        if (q !== 32'h00001004)
            $display("Test 2 Failed: Expected 00001004, got %h", q);
        else
            $display("Test 2 Passed: PC successfully advanced to 00001004.");

        // --- TEST CASE 3: Branch/Jump Target ---
        // Simulating the PC being redirected by a calculated target
        d = 32'h00001020; 
        #10; 
        
        if (q !== 32'h00001020)
            $display("Test 3 Failed: Expected 00001020, got %h", q);
        else
            $display("Test 3 Passed: PC successfully jumped to branch target 00001020.");

        // End simulation
        $display("Simulation complete.");
        $stop;
    end

endmodule