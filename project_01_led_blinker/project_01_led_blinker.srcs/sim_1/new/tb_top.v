`timescale 1ns/1ps

module tb_top;
    reg clk;
    wire led;

    // Instantiate your design
    top uut (
        .clk(clk),
        .led(led)
    );

    // Generate a 100 MHz clock: toggle every 5ns -> 10ns period
    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        // Run long enough to see counter behavior
        #100000; // 100,000 ns
        $finish;
    end
endmodule