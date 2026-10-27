`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////
// stopwatch_core
//   Counts centiseconds / seconds / minutes in BCD, range 00:00.00 - 99:59.99
//   (then wraps to zero).
//
//   Inputs are single-cycle pulses (already debounced):
//     toggle  - start / stop
//     lap_btn - freeze / unfreeze the DISPLAY (time keeps running underneath)
//     rst     - stop and clear everything
//     tick    - one 10 ms timebase pulse
//
//   disp_bcd = {m1, m0, s1, s0, cs1, cs0}, 4 bits each.
//////////////////////////////////////////////////////////////////////////////
module stopwatch_core(
    input  wire        clk,
    input  wire        rst,
    input  wire        tick,
    input  wire        toggle,
    input  wire        lap_btn,
    output reg         running    = 1'b0,
    output reg         lap_active = 1'b0,
    output wire [23:0] disp_bcd
);
    reg [3:0] cs0 = 0, cs1 = 0, s0 = 0, s1 = 0, m0 = 0, m1 = 0;
    reg [23:0] lap_reg = 24'd0;

    wire [23:0] live_bcd = {m1, m0, s1, s0, cs1, cs0};
    assign disp_bcd = lap_active ? lap_reg : live_bcd;

    // Carry chain
    wire cs0_wrap = (cs0 == 4'd9);
    wire cs1_wrap = cs0_wrap && (cs1 == 4'd9);   // 0.99 -> 1 second
    wire s0_wrap  = cs1_wrap && (s0  == 4'd9);
    wire s1_wrap  = s0_wrap  && (s1  == 4'd5);   // 59 s -> 1 minute
    wire m0_wrap  = s1_wrap  && (m0  == 4'd9);

    always @(posedge clk) begin
        if (rst) begin
            running    <= 1'b0;
            lap_active <= 1'b0;
            {m1, m0, s1, s0, cs1, cs0} <= 24'd0;
            lap_reg    <= 24'd0;
        end else begin
            if (toggle) running <= ~running;

            if (lap_btn) begin
                if (lap_active) lap_active <= 1'b0;
                else begin
                    lap_active <= 1'b1;
                    lap_reg    <= live_bcd;
                end
            end

            if (running && tick) begin
                cs0 <= cs0_wrap ? 4'd0 : cs0 + 1'b1;
                if (cs0_wrap) cs1 <= (cs1 == 4'd9) ? 4'd0 : cs1 + 1'b1;
                if (cs1_wrap) s0  <= (s0  == 4'd9) ? 4'd0 : s0  + 1'b1;
                if (s0_wrap)  s1  <= (s1  == 4'd5) ? 4'd0 : s1  + 1'b1;
                if (s1_wrap)  m0  <= (m0  == 4'd9) ? 4'd0 : m0  + 1'b1;
                if (m0_wrap)  m1  <= (m1  == 4'd9) ? 4'd0 : m1  + 1'b1;
            end
        end
    end
endmodule
