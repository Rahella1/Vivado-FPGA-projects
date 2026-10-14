module top_module(
    input clk,
    input areset,    // Asynchronous reset to state B
    input in,
    output out);

    parameter A = 1'b0, B = 1'b1;
    reg state, next_state;

    // 1. State transition logic (combinational)
    always @(*) begin
        case (state)
            A: next_state = in ? A : B;
            B: next_state = in ? B : A;
            default: next_state = B;
        endcase
    end

    // 2. State flip-flops with asynchronous reset (sequential)
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= B;
        end else begin
            state <= next_state;
        end
    end

    // 3. Output logic (Moore machine)
    assign out = (state == B);

endmodule