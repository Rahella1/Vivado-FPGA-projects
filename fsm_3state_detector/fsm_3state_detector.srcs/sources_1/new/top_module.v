module top_module(clk, reset, in, out);
    input clk;
    input reset;
    input in;
    output reg out;

    parameter S0 = 2'b00;
    parameter S1 = 2'b01;
    parameter S2 = 2'b10;

    reg [1:0] present_state, next_state;

    always @(posedge clk) begin
        if (reset) begin
            present_state <= S0;
            out <= 1'b0;
        end else begin
            // 1. Determine next state
            case (present_state)
                S0: next_state = in ? S1 : S0;
                S1: next_state = in ? S2 : S0;
                S2: next_state = in ? S2 : S0;
                default: next_state = S0;
            endcase

            // 2. Update state flip-flop
            present_state = next_state;

            // 3. Assign Moore output based on current state
            case (present_state)
                S0: out = 1'b0;
                S1: out = 1'b0;
                S2: out = 1'b1;
                default: out = 1'b0;
            endcase
        end
    end
endmodule