`timescale 1ns / 1ps

module basys3_4digit_top (
    input  wire       clk,        // 100 MHz onboard oscillator
    input  wire       reset,      // Center button (BTNC)
    input  wire       ena_sw,     // Rightmost switch (SW0)
    output wire [3:0] an,         // 4-digit display anodes (active LOW)
    output reg  [6:0] seg,        // 7-segment cathodes (active LOW)
    output wire [3:0] led         // Binary output for Digit 0
);

    // -------------------------------------------------------------
    // 1. Clock Dividers (1 Hz counting, 1 kHz multiplexing)
    // -------------------------------------------------------------
    reg [26:0] clk_div_1hz = 0;
    wire tick_1hz = (clk_div_1hz == 27'd99_999_999);

    always @(posedge clk) begin
        if (reset || tick_1hz)
            clk_div_1hz <= 0;
        else if (ena_sw)
            clk_div_1hz <= clk_div_1hz + 1'b1;
    end

    reg [16:0] clk_div_1khz = 0;
    wire tick_1khz = (clk_div_1khz == 17'd99_999);

    always @(posedge clk) begin
        if (reset || tick_1khz)
            clk_div_1khz <= 0;
        else
            clk_div_1khz <= clk_div_1khz + 1'b1;
    end

    // -------------------------------------------------------------
    // 2. Instantiate & Cascade 4 BCD Counter Modules
    // -------------------------------------------------------------
    wire [3:0] q0, q1, q2, q3;
    wire c0, c1, c2, c3;

    // Digit 0 (Ones)
    bcd_digit d0 (
        .clk(clk),
        .reset(reset),
        .ena(tick_1hz),
        .q(q0),
        .carry(c0)
    );

    // Digit 1 (Tens)
    bcd_digit d1 (
        .clk(clk),
        .reset(reset),
        .ena(tick_1hz && c0),
        .q(q1),
        .carry(c1)
    );

    // Digit 2 (Hundreds)
    bcd_digit d2 (
        .clk(clk),
        .reset(reset),
        .ena(tick_1hz && c0 && c1),
        .q(q2),
        .carry(c2)
    );

    // Digit 3 (Thousands)
    bcd_digit d3 (
        .clk(clk),
        .reset(reset),
        .ena(tick_1hz && c0 && c1 && c2),
        .q(q3),
        .carry(c3)
    );

    assign led = q0; // Show lower digit on board LEDs

    // -------------------------------------------------------------
    // 3. Display Multiplexer (~1 kHz)
    // -------------------------------------------------------------
    reg [1:0] disp_select = 0;

    always @(posedge clk) begin
        if (reset)
            disp_select <= 0;
        else if (tick_1khz)
            disp_select <= disp_select + 1'b1;
    end

    reg [3:0] current_digit_val;
    reg [3:0] active_anode;

    always @(*) begin
        case (disp_select)
            2'b00: begin
                active_anode      = 4'b1110; // Rightmost digit
                current_digit_val = q0;
            end
            2'b01: begin
                active_anode      = 4'b1101;
                current_digit_val = q1;
            end
            2'b10: begin
                active_anode      = 4'b1011;
                current_digit_val = q2;
            end
            2'b11: begin
                active_anode      = 4'b0111; // Leftmost digit
                current_digit_val = q3;
            end
        endcase
    end

    assign an = active_anode;

    // -------------------------------------------------------------
    // 4. Active-LOW 7-Segment Decoder
    // -------------------------------------------------------------
    always @(*) begin
        case (current_digit_val)
            4'h0: seg = 7'b100_0000;
            4'h1: seg = 7'b111_1001;
            4'h2: seg = 7'b010_0100;
            4'h3: seg = 7'b011_0000;
            4'h4: seg = 7'b001_1001;
            4'h5: seg = 7'b001_0010;
            4'h6: seg = 7'b000_0010;
            4'h7: seg = 7'b111_1000;
            4'h8: seg = 7'b000_0000;
            4'h9: seg = 7'b001_0000;
            default: seg = 7'b111_1111;
        endcase
    end

endmodule