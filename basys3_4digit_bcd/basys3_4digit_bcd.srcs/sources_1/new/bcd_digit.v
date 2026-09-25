`timescale 1ns / 1ps

module bcd_digit (
    input  wire       clk,     // 100 MHz board clock
    input  wire       reset,   // Synchronous reset signal
    input  wire       ena,     // Enable tick pulse (1 Hz for digit 0, carry pulse for higher digits)
    output reg  [3:0] q,       // 4-bit BCD output value (0 to 9)
    output wire       carry    // Carry signal to trigger the next higher digit
);

    // Generate a carry pulse for 1 clock cycle when the digit is at 9 and enabled
    assign carry = (q == 4'd9) && ena;

    always @(posedge clk) begin
        if (reset) begin
            q <= 4'd0;
        end else if (ena) begin
            if (q == 4'd9)
                q <= 4'd0;     // Roll over back to 0
            else
                q <= q + 1'b1; // Increment count
        end
    end

endmodule