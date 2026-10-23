module reaction_timer (
    input wire clk,             // 100 MHz clock on Basys 3
    input wire btnC,            // Center button (Start game)
    input wire btnU,            // Up button (Stop / False start)
    output reg led,             // Single reaction LED (LD0)
    output reg [6:0] seg,       // 7-segment display segments (CA-CG)
    output reg [3:0] an         // 7-segment display anode enables (AN0-AN3)
);

    // FSM States
    parameter IDLE   = 2'b00;
    parameter WAITING = 2'b01;
    parameter TIMING  = 2'b10;
    parameter DONE    = 2'b11;

    reg [1:0] state = IDLE;

    // Debounce / Edge detection registers for buttons
    reg btnC_prev = 0, btnU_prev = 0;
    wire btnC_posedge = btnC && !btnC_prev;
    wire btnU_posedge = btnU && !btnU_prev;

    always @(posedge clk) begin
        btnC_prev <= btnC;
        btnU_prev <= btnU;
    end

    // LFSR for random delay generation
    reg [7:0] lfsr = 8'b10101010;
    always @(posedge clk) begin
        lfsr <= {lfsr[6:0], lfsr[7] ^ lfsr[5] ^ lfsr[4] ^ lfsr[3]};
    end

    reg [31:0] target_delay = 0;
    reg [31:0] delay_counter = 0;
    reg [31:0] reaction_ms = 0;
    reg [19:0] ms_counter = 0;

    // FSM Logic
    always @(posedge clk) begin
        case (state)
            IDLE: begin
                led <= 1'b0;
                reaction_ms <= 0;
                ms_counter <= 0;
                if (btnC_posedge) begin
                    // Note: Use full hardware delay (50000000 + ...) for real deployment
                    target_delay <= 50000000 + ({8'b0, lfsr} % 150000000); 
                    delay_counter <= 0;
                    state <= WAITING;
                end
            end

            WAITING: begin
                led <= 1'b0;
                delay_counter <= delay_counter + 1;
                if (btnU_posedge) begin
                    state <= IDLE; // False start
                end else if (delay_counter >= target_delay) begin
                    state <= TIMING;
                end
            end

            TIMING: begin
                led <= 1'b1;
                if (btnU_posedge) begin
                    state <= DONE;
                end else begin
                    if (ms_counter == 99999) begin
                        ms_counter <= 0;
                        reaction_ms <= reaction_ms + 1;
                    end else begin
                        ms_counter <= ms_counter + 1;
                    end
                end
            end

            DONE: begin
                led <= 1'b1;
                if (btnC_posedge) begin
                    state <= IDLE;
                end
            end
        endcase
    end

    always @(posedge clk) begin
        an <= 4'b1110;
        seg <= 7'b1000000;
    end

endmodule