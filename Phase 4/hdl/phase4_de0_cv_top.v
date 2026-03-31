`timescale 1ns/1ps

module phase4_de0_cv_top(
    input CLOCK_50,
    input [1:0] KEY,
    input [7:0] SW,
    output [9:0] LEDR,
    output [6:0] HEX0,
    output [6:0] HEX1
);
    wire reset_in;
    wire stop_in;
    wire slow_clock;
    wire run_out;
    wire [31:0] out_port_value;

    assign reset_in = ~KEY[0];
    assign stop_in = ~KEY[1];
    assign LEDR = {4'b0000, run_out, 5'b00000};

    clock_divider #(.DIVIDE_BIT(20)) u_clock_divider(
        .clk_in(CLOCK_50),
        .reset(reset_in),
        .clk_out(slow_clock)
    );

    mini_src_cpu u_cpu(
        .Clock(slow_clock),
        .Reset(reset_in),
        .Stop(stop_in),
        .InPortData({24'b0, SW}),
        .InPortStrobe(1'b1),
        .OutPortValue(out_port_value),
        .Run(run_out)
    );

    hex7seg u_hex0(
        .value(out_port_value[3:0]),
        .segments(HEX0)
    );

    hex7seg u_hex1(
        .value(out_port_value[7:4]),
        .segments(HEX1)
    );
endmodule