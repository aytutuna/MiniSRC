`timescale 1ns/1ps

module clock_divider #(
    parameter DIVIDE_BIT = 20
)(
    input clk_in,
    input reset,
    output clk_out
);
    reg [31:0] counter;

    always @(posedge clk_in or posedge reset) begin
        if (reset) begin
            counter <= 32'b0;
        end else begin
            counter <= counter + 32'd1;
        end
    end

    assign clk_out = counter[DIVIDE_BIT];
endmodule