`timescale 1ns / 1ps

module tb_top_module();
    reg clk;
    reg areset;
    reg in;
    wire out;

    // Instantiate the FSM
    top_module uut (
        .clk(clk),
        .areset(areset),
        .in(in),
        .out(out)
    );

    // Generate Clock: 10ns period (100 MHz)
    always #5 clk = ~clk;

    initial begin
        // Initialize signals
        clk = 0;
        areset = 1; // Assert asynchronous reset initially
        in = 0;

        // Hold reset for 20ns, then release
        #20;
        areset = 0;

        // Apply test inputs synchronized with clock
        #15 in = 1;
        #20 in = 0;
        #10 in = 1;
        #30 in = 0;
        #20 in = 1;

        // Finish simulation
        #50;
        $finish;
    end
endmodule