`timescale 1ns / 1ps

module tb_top_module();
    reg clk;
    reg areset;
    reg load;
    reg ena;
    reg [3:0] data;
    wire [3:0] q;

    top_module uut (
        .clk(clk),
        .areset(areset),
        .load(load),
        .ena(ena),
        .data(data),
        .q(q)
    );

    always #5 clk = ~clk; // 10ns clock period

    initial begin
        clk = 0;
        areset = 0;
        load = 0;
        ena = 0;
        data = 4'b0;

        // 1. Reset check
        #2  areset = 1;
        #10 areset = 0;

        // 2. Load parallel data 1101
        #10 data = 4'b1101; load = 1;
        #10 load = 0;

        // 3. Enable right shift for 4 clock cycles
        #10 ena = 1;
        #40 ena = 0;

        // 4. Test load priority over enable
        #10 data = 4'b1010; load = 1; ena = 1;
        #10 load = 0; ena = 0;

        #20 $finish;
    end
endmodule