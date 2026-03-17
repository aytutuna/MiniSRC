`timescale 1ns/1ps

module condition_ff(
    input         clk,
    input         clr,
    input         en,
    input  [1:0]  cond_code,
    input  [31:0] bus_value,
    output reg    q
);
    reg cond_match;

    always @* begin
        case (cond_code)
            2'b00: cond_match = (bus_value == 32'b0);
            2'b01: cond_match = (bus_value != 32'b0);
            2'b10: cond_match = (bus_value[31] == 1'b0);
            2'b11: cond_match = (bus_value[31] == 1'b1);
            default: cond_match = 1'b0;
        endcase
    end

    always @(posedge clk) begin
        if (clr) q <= 1'b0;
        else if (en) q <= cond_match;
    end
endmodule
