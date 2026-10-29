module basys3_top_fsm(
    input clk,            // 100MHz system clock (or map to a button for manual stepping)
    input btnC,           // Center button = areset
    input [0:0] sw,       // sw[0] = input 'in'
    output [15:0] led     // LEDs for state and outputs
);

    // Internal signals
    wire [9:0] next_state;
    reg [9:0] state;
    wire out1, out2;

    // 1. State Register (Sequential logic with asynchronous reset)
    always @(posedge clk or posedge btnC) begin
        if (btnC)
            state <= 10'b0000000001; // Force back to state S0 on reset
        else
            state <= next_state;     // Update to next state on clock edge
    end

    // 2. Instantiate your HDLBits FSM combinational core logic here
    top_module fsm_core(
        .in(sw[0]),
        .state(state),
        .next_state(next_state),
        .out1(out1),
        .out2(out2)
    );

    // 3. Drive the Basys 3 onboard LEDs
    assign led[9:0]  = state;          // Watch the one-hot state move across LEDs 0-9
    assign led[10]   = 1'b0;           // Unused
    assign led[11]   = 1'b0;           // Unused
    assign led[12]   = 1'b0;           // Unused
    assign led[13]   = 1'b0;           // Unused
    assign led[14]   = out1;           // LED 14 lights up when out1 is active
    assign led[15]   = out2;           // LED 15 lights up when out2 is active

endmodule