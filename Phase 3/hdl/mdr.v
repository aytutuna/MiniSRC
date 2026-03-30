`timescale 1ns/1ps

module mdr(
    input         clk,
    input         clr,
    input         en,
    input         Read,
    input  [31:0] bus_in,
    input  [31:0] Mdatain,
    output reg [31:0] q
);
    wire [31:0] d;
    assign d = Read ? Mdatain : bus_in;

    always @(posedge clk) begin
        if (clr) q <= 32'b0;
        else if (en) q <= d;
    end
endmodule
