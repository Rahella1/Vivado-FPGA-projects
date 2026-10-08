module MUXDFF (
    input clk,
    input w,
    input R,
    input L,
    output reg Q
);
    always @(posedge clk) begin
        Q <= L ? R : w;
    end
endmodule

module top_module (
    input [2:0] SW,      // R inputs
    input [1:0] KEY,     // KEY[0] = clk, KEY[1] = L
    output [2:0] LEDR    // Q outputs
);

    wire clk = KEY[0];
    wire L   = KEY[1];
    wire [2:0] R = SW;
    wire [2:0] Q;

    assign LEDR = Q;

    MUXDFF stage0 (clk, Q[2],        R[0], L, Q[0]);
    MUXDFF stage1 (clk, Q[0],        R[1], L, Q[1]);
    MUXDFF stage2 (clk, Q[1] ^ Q[2], R[2], L, Q[2]);

endmodule