`timescale 1ns / 1ps

module tb_bcd_digit();

    reg        clk;
    reg        reset;
    reg        ena;
    wire [3:0] q;
    wire       carry;

    // Instantiate Unit Under Test (UUT)
    bcd_digit uut (
        .clk(clk),
        .reset(reset),
        .ena(ena),
        .q(q),
        .carry(carry)
    );

    // 100 MHz clock generation (10 ns period)
    always #5 clk = ~clk;

    initial begin
        clk   = 0;
        reset = 1;
        ena   = 0;

        #20;
        reset = 0;
        #10;

        // Enable counter for 15 cycles to test 0-9 count and carry output
        ena = 1;
        #150;

        // Test disabling enable line
        ena = 0;
        #50;

        // Test reset logic
        ena = 1;
        #40;
        reset = 1;
        #20;
        reset = 0;

        #50;
        $finish;
    end

endmodule