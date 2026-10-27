`timescale 1ns / 1ps
// Self-checking testbench for stopwatch_core.
// disp_bcd = {m1,m0,s1,s0,cs1,cs0}; 1 second = 24'h000100.
module tb_stopwatch_core;
    reg clk = 0, rst = 0, tick = 0, toggle = 0, lap_btn = 0;
    wire running, lap_active;
    wire [23:0] disp_bcd;
    integer errors = 0;

    always #5 clk = ~clk;

    stopwatch_core dut (
        .clk(clk), .rst(rst), .tick(tick), .toggle(toggle), .lap_btn(lap_btn),
        .running(running), .lap_active(lap_active), .disp_bcd(disp_bcd)
    );

    task do_ticks(input integer n);
        integer k;
        begin
            for (k = 0; k < n; k = k + 1) begin
                @(posedge clk); tick <= 1;
                @(posedge clk); tick <= 0;
            end
            @(posedge clk);
        end
    endtask

    task pulse_toggle; begin @(posedge clk); toggle  <= 1; @(posedge clk); toggle  <= 0; @(posedge clk); end endtask
    task pulse_lap;    begin @(posedge clk); lap_btn <= 1; @(posedge clk); lap_btn <= 0; @(posedge clk); end endtask
    task pulse_rst;    begin @(posedge clk); rst     <= 1; @(posedge clk); rst     <= 0; @(posedge clk); end endtask

    task check(input [23:0] expected, input [255:0] label);
        begin
            if (disp_bcd !== expected) begin
                $display("FAIL [%0s]: got %h, expected %h", label, disp_bcd, expected);
                errors = errors + 1;
            end else
                $display("PASS [%0s]: %h", label, disp_bcd);
        end
    endtask

    initial begin
        pulse_rst;
        check(24'h000000, "after reset");

        do_ticks(10);
        check(24'h000000, "ticks ignored while stopped");

        pulse_toggle;                       // start
        do_ticks(150);
        check(24'h000150, "1.50 s running");

        pulse_lap;                          // freeze display
        do_ticks(50);
        check(24'h000150, "lap holds display");
        if (!lap_active) begin $display("FAIL: lap_active not set"); errors = errors + 1; end

        pulse_lap;                          // release
        check(24'h000200, "live time after lap release (2.00 s)");

        do_ticks(5800);                     // total 6000 ticks = 60.00 s
        check(24'h010000, "59.99 -> 01:00.00 rollover");

        pulse_toggle;                       // stop
        do_ticks(25);
        check(24'h010000, "stopped holds value");

        pulse_toggle;                       // resume
        do_ticks(25);
        check(24'h010025, "resume continues");

        pulse_rst;
        check(24'h000000, "reset clears");
        if (running) begin $display("FAIL: still running after reset"); errors = errors + 1; end

        if (errors == 0) $display("ALL TESTS PASSED");
        else             $display("%0d TEST(S) FAILED", errors);
        $finish;
    end
endmodule
