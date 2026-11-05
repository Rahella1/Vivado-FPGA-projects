`timescale 1ns/1ps

module tb;
    reg  clk = 0, in = 1, reset = 1;
    wire done;

    top_module dut (.clk(clk), .in(in), .reset(reset), .done(done));

    // 10 ns clock
    always #5 clk = ~clk;

    // Count done pulses
    integer done_count = 0;
    integer errors = 0;
    always @(posedge clk)
        if (done) begin
            done_count = done_count + 1;
            $display("[%0t ns] done = 1", $time);
        end

    // Send one frame: start bit, 8 data bits (LSB first), then stop bit
    task send_byte(input [7:0] data, input stop);
        integer i;
        begin
            @(negedge clk) in = 0;                    // start bit
            for (i = 0; i < 8; i = i + 1)
                @(negedge clk) in = data[i];          // data bits
            @(negedge clk) in = stop;                 // stop bit
        end
    endtask

    // Hold the line at a fixed value for n clocks
    task hold(input val, input integer n);
        begin
            repeat (n) @(negedge clk) in = val;
        end
    endtask

    // Compare the number of done pulses with the expected number
    task check(input integer test_num, input integer expected);
        begin
            if (done_count == expected)
                $display("Test %0d PASS (done pulses = %0d)", test_num, done_count);
            else begin
                $display("Test %0d FAIL (expected %0d, got %0d)", test_num, expected, done_count);
                errors = errors + 1;
            end
            done_count = 0;   // reset counter for next test
        end
    endtask

    initial begin
        // Reset
        repeat (2) @(negedge clk);
        reset = 0;
        hold(1, 3);

        // Test 1: single good byte 'A' (0x41)
        send_byte(8'h41, 1);
        hold(1, 3);
        check(1, 1);

        // Test 2: bad stop bit, no done expected
        send_byte(8'h55, 0);
        hold(1, 4);
        check(2, 0);

        // Test 3: back-to-back bytes, no idle between them
        send_byte(8'hA5, 1);
        send_byte(8'h3C, 1);
        hold(1, 4);
        check(3, 2);

        // Test 4: bad stop bit followed by extra 0s, then recovery.
        // FSM must wait for a 1, then correctly receive the next byte.
        send_byte(8'hFF, 0);
        hold(0, 3);              // line still low: FSM stays in ERR
        hold(1, 2);              // line goes high: back to IDLE
        send_byte(8'h41, 1);     // this one must be received
        hold(1, 3);
        check(4, 1);

        // Test 5: synchronous reset in the middle of a frame
        @(negedge clk) in = 0;                   // start bit
        hold(1, 3);                              // a few data bits
        @(negedge clk) reset = 1;                // reset mid-frame
        @(negedge clk) reset = 0;
        hold(1, 12);                             // line idle, no byte should be reported
        check(5, 0);

        // Test 6: good byte works normally after the reset
        send_byte(8'hC3, 1);
        hold(1, 3);
        check(6, 1);

        if (errors == 0) $display("ALL TESTS PASSED");
        else             $display("%0d TEST(S) FAILED", errors);
        $finish;
    end
endmodule