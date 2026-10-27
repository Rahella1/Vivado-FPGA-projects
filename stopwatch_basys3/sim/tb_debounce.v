`timescale 1ns / 1ps
// Self-checking testbench for debounce (uses a short 20-cycle filter).
module tb_debounce;
    reg clk = 0, noisy = 0;
    wire pulse;
    integer pulses = 0, i;

    always #5 clk = ~clk;
    always @(posedge clk) if (pulse) pulses <= pulses + 1;

    debounce #(.STABLE_CYCLES(20)) dut (.clk(clk), .noisy(noisy), .pulse(pulse));

    initial begin
        repeat (10) @(posedge clk);

        // 1) Short glitch (5 cycles) must NOT produce a pulse
        noisy = 1; repeat (5) @(posedge clk); noisy = 0;
        repeat (50) @(posedge clk);
        if (pulses !== 0) $display("FAIL: glitch produced %0d pulse(s)", pulses);
        else              $display("PASS: glitch rejected");

        // 2) Bouncy press then stable high -> exactly ONE pulse
        for (i = 0; i < 4; i = i + 1) begin
            noisy = 1; repeat (3) @(posedge clk);
            noisy = 0; repeat (2) @(posedge clk);
        end
        noisy = 1; repeat (60) @(posedge clk);
        if (pulses !== 1) $display("FAIL: expected 1 pulse, got %0d", pulses);
        else              $display("PASS: bouncy press gave exactly 1 pulse");

        // 3) Release (bouncy) must not create a pulse
        noisy = 0; repeat (3) @(posedge clk); noisy = 1; repeat (2) @(posedge clk);
        noisy = 0; repeat (60) @(posedge clk);
        if (pulses !== 1) $display("FAIL: release created extra pulse (%0d)", pulses);
        else              $display("PASS: release produced no pulse");

        $display("tb_debounce done");
        $finish;
    end
endmodule
