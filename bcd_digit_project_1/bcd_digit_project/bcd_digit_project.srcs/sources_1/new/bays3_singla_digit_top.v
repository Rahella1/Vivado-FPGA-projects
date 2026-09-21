module basys3_single_digit_top (
    input wire clk,           // W5 (100 MHz clock)
    input wire reset,         // U18 (Center push button)
    input wire ena_sw,        // V17 (SW0 - Enable switch)
    output wire [3:0] led,    // U16, E19, U19, V19 (4 LEDs showing raw 4-bit BCD)
    output wire carry_led,    // P3 (LED15 showing carry output)
    output reg [3:0] an,      // W4, V4, U4, U2 (Anode selection for 7-segment display)
    output reg [6:0] seg      // W7, W6, U8, V8, U5, V5, U7 (7-segment cathodes)
);

    // 1. Clock Divider: 100 MHz -> 1 Hz pulse (1 pulse every second)
    reg [26:0] clk_div = 0;
    wire tick_1hz = (clk_div == 100_000_000 - 1);

    always @(posedge clk) begin
        if (reset || tick_1hz)
            clk_div <= 0;
        else
            clk_div <= clk_div + 1'b1;
    end

    // Combine 1Hz tick with switch input so counter steps once per second when SW0 is ON
    wire slow_ena = tick_1hz && ena_sw;

    // 2. Instantiate your single-digit BCD counter
    wire [3:0] q_digit;
    wire carry_out;

    bcd_digit digit_inst (
        .clk(clk),
        .reset(reset),
        .ena(slow_ena),
        .q(q_digit),
        .carry(carry_out)
    );

    // Drive onboard LEDs
    assign led = q_digit;         // Displays q[3:0] on LED0 - LED3 in binary
    assign carry_led = carry_out; // Displays carry out on LED15

    // 3. Drive 7-Segment Display (Rightmost digit only)
    always @(*) begin
        an = 4'b1110; // Turn on only rightmost digit (AN0), turn off AN1-AN3
    end

    // BCD to 7-segment decoder (Active LOW)
    always @(*) begin
        case (q_digit)
            4'h0: seg = 7'b100_0000; // 0
            4'h1: seg = 7'b111_1001; // 1
            4'h2: seg = 7'b010_0100; // 2
            4'h3: seg = 7'b011_0000; // 3
            4'h4: seg = 7'b001_1001; // 4
            4'h5: seg = 7'b001_0010; // 5
            4'h6: seg = 7'b000_0010; // 6
            4'h7: seg = 7'b111_1000; // 7
            4'h8: seg = 7'b000_0000; // 8
            4'h9: seg = 7'b001_0000; // 9
            default: seg = 7'b111_1111; // Off
        endcase
    end

endmodule