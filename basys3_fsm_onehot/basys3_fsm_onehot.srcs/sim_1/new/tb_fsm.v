`timescale 1ns / 1ps

module tb_fsm();

    // Inputs
    reg clk;
    reg areset;
    reg in;
    reg [9:0] state;

    // Outputs
    wire [9:0] next_state;
    wire out1;
    wire out2;

    // Instantiate the FSM core combinational logic
    top_module uut (
        .in(in),
        .state(state),
        .next_state(next_state),
        .out1(out1),
        .out2(out2)
    );

    // Sequential state register with asynchronous reset (to test in simulation)
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 10'b0000000001; // Reset to S0
        else
            state <= next_state;     // Update state on clock edge
    end

    // Clock generation (10ns period = 100MHz)
    always #5 clk = ~clk;

    // Stimulus process
    initial begin
        // Initialize signals
        clk = 0;
        areset = 1;
        in = 0;
        #20;
        
        // Release reset
        areset = 0;
        #10;

        // Test sequence: Push in=1 through multiple states, then drop to 0
        in = 1; #40; // Should step through S0 -> S1 -> S2 -> S3 -> S4
        in = 0; #20; // Should drop back to S0
        in = 1; #60; // Step up again
        in = 1; #40; // Reach S8/S9 where out1 and out2 assert
        
        #50;
        $finish;
    end

endmodule