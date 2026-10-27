`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////
// debounce
//   1) Two-flop synchronizer: safely brings the asynchronous button signal
//      into the clk domain (avoids metastability).
//   2) Stability filter: the synchronized input must differ from the current
//      debounced state for STABLE_CYCLES consecutive clocks before the state
//      changes (default 1,000,000 cycles = 10 ms at 100 MHz).
//   3) Outputs a single-cycle pulse on each debounced RISING edge (button
//      press), which is what the rest of the design consumes.
//////////////////////////////////////////////////////////////////////////////
module debounce #(
    parameter integer STABLE_CYCLES = 1_000_000
)(
    input  wire clk,
    input  wire noisy,
    output reg  pulse = 1'b0
);
    localparam integer W = $clog2(STABLE_CYCLES + 1);

    reg sync0 = 1'b0, sync1 = 1'b0;
    always @(posedge clk) begin
        sync0 <= noisy;
        sync1 <= sync0;
    end

    reg         state = 1'b0;
    reg [W-1:0] cnt   = 0;

    always @(posedge clk) begin
        pulse <= 1'b0;
        if (sync1 == state) begin
            cnt <= 0;                       // input agrees with state: idle
        end else if (cnt == STABLE_CYCLES - 1) begin
            cnt   <= 0;                     // input stable long enough
            state <= sync1;
            if (sync1) pulse <= 1'b1;       // rising edge = a real press
        end else begin
            cnt <= cnt + 1'b1;
        end
    end
endmodule
