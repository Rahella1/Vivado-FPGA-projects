`timescale 1ns / 1ps

module reaction_timer_tb;

    reg clk;
    reg btnC;
    reg btnU;
    wire [15:0] led;
    wire [6:0] seg;
    wire [3:0] an;

    // Instantiate Unit Under Test (UUT)
    reaction_timer uut (
        .clk(clk),
        .btnC(btnC),
        .btnU(btnU),
        .led(led),
        .seg(seg),
        .an(an)
    );

    // Generate 100 MHz clock (10 ns period)
    always #5 clk = ~clk;

    initial begin
        // Initialize Signals
        clk = 0;
        btnC = 0;
        btnU = 0;

        #200;
        
        // 1. Press Start Button (btnC)
        @(posedge clk);
        btnC = 1;
        #40;
        btnC = 0;

        // 2. Wait long enough for the delay to pass 
        // (In simulation, the LFSR generates a small value quickly, but let's wait 10 ms)
        #10000000; // 10 ms

        // 3. Press Stop Button (btnU) to record reaction time
        @(posedge clk);
        btnU = 1;
        #40;
        btnU = 0;

        // 4. Observe display state
        #5000000; // 5 ms
        
        $finish;
    end

endmodule