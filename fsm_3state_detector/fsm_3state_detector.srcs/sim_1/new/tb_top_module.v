`timescale 1ns / 1ps

module tb_top_module();

    // Inputs
    reg clk;
    reg reset;
    reg in;

    // Outputs
    wire out;

    // Instantiate the Unit Under Test (UUT)
    top_module uut (
        .clk(clk), 
        .reset(reset), 
        .in(in), 
        .out(out)
    );

    // 1. Generate Clock: 10ns period (5ns high, 5ns low)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // 2. Drive Stimulus
    initial begin
        // Initialize inputs
        reset = 0;
        in = 0;
        
        // Wait 15ns, then assert synchronous reset (1)
        #15;
        reset = 1;
        
        // Hold reset for two clock cycles
        #20;
        reset = 0;
        
        // Test input transitions
        #20; in = 1;  // Send input high
        #40; in = 0;  // Send input low
        #30; in = 1;  // Send input high again
        #50; in = 0;
        
        // End simulation
        #100;
        $finish;
    end

endmodule