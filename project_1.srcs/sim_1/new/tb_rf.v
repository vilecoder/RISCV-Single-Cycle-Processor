`timescale 1ns / 1ps

module tb_rf();
    reg clk;
    reg we3;
    reg [4:0] a1,a2,a3;
    reg [31:0] wd3;

    wire [31:0] rd1,rd2;

    rf dut (
        .clk(clk),.we3(we3),.a1(a1),.a2(a2),.a3(a3),.wd3(wd3),.rd1(rd1),.rd2(rd2)
        );
    initial begin 
        clk=0;
    end
    always #5 clk = ~clk;
    
    initial begin
        we3=0;a1=0;a2=0;a3=0;wd3=0;
        #10;
        a3=5;
        wd3 = 32'hAABBCCDD;
        we3=1;
        #10;
        we3=0;
        a1 = 5;
        #10;
        if( rd1 !== 32'hAABBCCDD)
            $display("Test 1 Failed : Expected AABBCCDD , got %h",rd1);
        else
            $display("Test 1 passed : Register 5 read successful");
      
        a3 = 0; 
        wd3 = 32'hFFFFFFFF; 
        we3 = 1;
        #10;
        
        we3 = 0;
        
        // Read combinationally from address 0 on port 2
        a2 = 0;
        #10;
        
        if (rd2 !== 32'b0) 
            $display("Test 2 Failed: Register 0 is not hardwired to 0!");
        else 
            $display("Test 2 Passed: Register 0 successfully blocked write.");

        // End simulation
        $display("Simulation complete.");
        $stop;
        
    end
    
endmodule
