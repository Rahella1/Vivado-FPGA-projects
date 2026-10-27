`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////
// seg7_display
//   Time-multiplexes 4 BCD digits onto the Basys3 common-anode 7-segment
//   display. an[] and seg[]/dp are all ACTIVE-LOW.
//   dp_n[i] = 0 turns on the decimal point of digit i.
//   Refresh: 100 MHz / 2^18 per step -> ~381 Hz per digit, flicker-free.
//////////////////////////////////////////////////////////////////////////////
module seg7_display(
    input  wire        clk,
    input  wire [15:0] digits,   // {d3, d2, d1, d0}
    input  wire [3:0]  dp_n,
    output reg  [6:0]  seg,
    output reg         dp,
    output reg  [3:0]  an
);
    reg [17:0] refresh = 0;
    always @(posedge clk) refresh <= refresh + 1'b1;

    wire [1:0] sel = refresh[17:16];
    reg  [3:0] value;

    always @(*) begin
        case (sel)
            2'd0: begin an = 4'b1110; value = digits[3:0];   end
            2'd1: begin an = 4'b1101; value = digits[7:4];   end
            2'd2: begin an = 4'b1011; value = digits[11:8];  end
            default: begin an = 4'b0111; value = digits[15:12]; end
        endcase
        dp = dp_n[sel];
    end

    always @(*) begin
        case (value)
            4'h0: seg = 7'b1000000;
            4'h1: seg = 7'b1111001;
            4'h2: seg = 7'b0100100;
            4'h3: seg = 7'b0110000;
            4'h4: seg = 7'b0011001;
            4'h5: seg = 7'b0010010;
            4'h6: seg = 7'b0000010;
            4'h7: seg = 7'b1111000;
            4'h8: seg = 7'b0000000;
            4'h9: seg = 7'b0010000;
            default: seg = 7'b1111111;
        endcase
    end
endmodule
