module top_module(
    input clk,
    input in,
    input reset,    // Synchronous reset
    output done
);

    localparam IDLE  = 4'd0,
               D0    = 4'd1,
               D1    = 4'd2,
               D2    = 4'd3,
               D3    = 4'd4,
               D4    = 4'd5,
               D5    = 4'd6,
               D6    = 4'd7,
               D7    = 4'd8,
               STOP  = 4'd9,
               DONE  = 4'd10,
               ERR   = 4'd11;

    reg [3:0] state, next;

    // State transition logic
    always @(*) begin
        case (state)
            IDLE: next = in ? IDLE : D0;      // in==0 is the start bit
            D0:   next = D1;
            D1:   next = D2;
            D2:   next = D3;
            D3:   next = D4;
            D4:   next = D5;
            D5:   next = D6;
            D6:   next = D7;
            D7:   next = STOP;
            STOP: next = in ? DONE : ERR;     // stop bit must be 1
            DONE: next = in ? IDLE : D0;      // in==0 is the next start bit
            ERR:  next = in ? IDLE : ERR;     // wait for a 1 before looking for a new start
            default: next = IDLE;
        endcase
    end

    // State register (synchronous reset)
    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            state <= next;
    end

    // Moore output
    assign done = (state == DONE);

endmodule