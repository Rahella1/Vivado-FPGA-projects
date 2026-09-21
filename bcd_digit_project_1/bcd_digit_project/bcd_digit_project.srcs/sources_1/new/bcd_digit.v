module bcd_digit (
    input wire clk,
    input wire reset,
    input wire ena,
    output reg [3:0] q,
    output wire carry
);

    always @(posedge clk) begin
        if (reset) begin
            q <= 4'd0;
        end else if (ena) begin
            if (q == 4'd9) begin
                q <= 4'd0;
            end else begin
                q <= q + 1'b1;
            end
        end
    end

    // Carry output signal when counter reaches 9 while enabled
    assign carry = (q == 4'd9) && ena;

endmodule