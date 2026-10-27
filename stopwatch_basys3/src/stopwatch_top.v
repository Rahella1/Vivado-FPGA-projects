`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////
// stopwatch_top  -  Basys3 digital stopwatch
//
//   btnC  : Start / Stop
//   btnU  : Lap (freeze display; press again to release)
//   btnD  : Reset (stops and clears)
//   sw0   : 0 = show SS.cc (seconds.hundredths)
//           1 = show MM.SS (minutes.seconds)
//   led0  : running      led1 : lap display frozen
//////////////////////////////////////////////////////////////////////////////
module stopwatch_top(
    input  wire       clk,      // 100 MHz
    input  wire       btnC,
    input  wire       btnU,
    input  wire       btnD,
    input  wire       sw0,
    output wire [1:0] led,
    output wire [6:0] seg,
    output wire       dp,
    output wire [3:0] an
);
    // ---- Debounced button pulses ----
    wire start_pulse, lap_pulse, reset_pulse;
    debounce u_db_start (.clk(clk), .noisy(btnC), .pulse(start_pulse));
    debounce u_db_lap   (.clk(clk), .noisy(btnU), .pulse(lap_pulse));
    debounce u_db_reset (.clk(clk), .noisy(btnD), .pulse(reset_pulse));

    // ---- 100 Hz timebase (phase restarts on start/stop/reset) ----
    wire tick_100hz;
    clk_divider #(.DIVIDER(1_000_000)) u_tick (
        .clk (clk),
        .rst (start_pulse | reset_pulse),
        .tick(tick_100hz)
    );

    // ---- Stopwatch core ----
    wire [23:0] bcd;
    wire        running, lap_active;
    stopwatch_core u_core (
        .clk       (clk),
        .rst       (reset_pulse),
        .tick      (tick_100hz),
        .toggle    (start_pulse),
        .lap_btn   (lap_pulse),
        .running   (running),
        .lap_active(lap_active),
        .disp_bcd  (bcd)
    );

    // ---- Display mode select (switch synchronized to clk) ----
    reg sw_s0 = 1'b0, sw_s1 = 1'b0;
    always @(posedge clk) begin
        sw_s0 <= sw0;
        sw_s1 <= sw_s0;
    end

    // bcd = {m1,m0,s1,s0,cs1,cs0}
    wire [15:0] shown = sw_s1 ? bcd[23:8]    // MM.SS
                              : bcd[15:0];   // SS.cc

    seg7_display u_disp (
        .clk   (clk),
        .digits(shown),
        .dp_n  (4'b1011),        // decimal point after digit 2 (XX.XX)
        .seg   (seg),
        .dp    (dp),
        .an    (an)
    );

    assign led = {lap_active, running};
endmodule
