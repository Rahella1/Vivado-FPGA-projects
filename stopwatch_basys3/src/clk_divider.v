`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////
// clk_divider
//   Emits a single-cycle "tick" every DIVIDER input clocks.
//   100 MHz / 1,000,000 = 100 Hz tick (one tick = 10 ms = 1 centisecond).
//   rst restarts the count so the first interval after a start is full length.
//////////////////////////////////////////////////////////////////////////////
module clk_divider #(
    parameter integer DIVIDER = 1_000_000
)(
    input  wire clk,
    input  wire rst,
    output reg  tick = 1'b0
);
    localparam integer W = $clog2(DIVIDER);
    reg [W-1:0] count = 0;

    always @(posedge clk) begin
        if (rst) begin
            count <= 0;
            tick  <= 1'b0;
        end else if (count == DIVIDER - 1) begin
            count <= 0;
            tick  <= 1'b1;
        end else begin
            count <= count + 1'b1;
            tick  <= 1'b0;
        end
    end
endmodule
