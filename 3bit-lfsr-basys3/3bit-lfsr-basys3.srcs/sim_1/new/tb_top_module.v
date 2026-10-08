`timescale 1ns / 1ps

module tb_top_module();

    // Inputs to the DUT (Device Under Test)
    reg [2:0] SW;      // R (seed input)
    reg [1:0] KEY;     // KEY[0] = clk, KEY[1] = L
    
    // Outputs from the DUT
    wire [2:0] LEDR;   // Q (LFSR state output)

    // Instantiate the top-level module
    top_module dut (
        .SW(SW),
        .KEY(KEY),
        .LEDR(LEDR)
    );

    // Clock generation: 10 ns period (100 MHz equivalent)
    initial begin
        KEY[0] = 0;
        forever #5 KEY[0] = ~KEY[0];
    end

    // Test sequence
    initial begin
        // Step 1: Initialize inputs
        SW = 3'b000;
        KEY[1] = 0;   // L = 0 (Shift mode)
        
        #15;          // Wait for initial stabilization

        // Step 2: Load non-zero seed value (e.g., 3'b001)
        SW = 3'b001;  // Set seed to 3'b001
        KEY[1] = 1;   // L = 1 (Load mode)
        #10;          // Wait 1 clock cycle to register the seed

        // Step 3: Switch back to shift mode and let LFSR cycle
        KEY[1] = 0;   // L = 0 (Shift mode)

        // Run for 10 clock cycles (3-bit maximal LFSR cycles every 7 cycles)
        #100;

        // Step 4: Test loading a different seed (e.g., 3'b110)
        SW = 3'b110;
        KEY[1] = 1;
        #10;
        KEY[1] = 0;
        #50;

        $finish;     // End simulation
    end

endmodule