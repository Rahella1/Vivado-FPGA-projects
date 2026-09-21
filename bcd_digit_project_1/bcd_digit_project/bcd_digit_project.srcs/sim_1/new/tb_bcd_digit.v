`timescale 1ns / 1ps

module tb_bcd_digit();

    reg clk;
    reg reset;
    reg ena;

    wire [3:0] q;
    wire carry;

    // Instantiate the Unit Under Test (UUT)
    bcd_digit uut (
        .clk(clk),
        .reset(reset),
        .ena(ena),
        .q(q),
        .carry(carry)
    );

    // 100 MHz Clock Generation (10ns period)
    always #5 clk = ~clk;

    initial begin
        // Initialize inputs
        clk = 0;
        reset = 1;
        ena = 0;

        #20;
        reset = 0;
        #10;

        // Enable counting
        ena = 1;
        #150; // Watch 0 -> 9 -> 0 rollover

        // Pause counting
        ena = 0;
        #40;

        // Resume counting
        ena = 1;
        #50;

        $finish;
    end

endmodule