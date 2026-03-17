`timescale 1ns/1ps

// if Read=1, load from Mdatain
// if Read=0, load from bus
module mdr(
    input         clk,
    input         clr,
    input         en,
    input         Read,
    input  [31:0] bus_in,
    input  [31:0] Mdatain,
    output reg [31:0] q
);
    // 2-to-1 mux
    wire [31:0] d;
    assign d = (Read == 1'b1) ? Mdatain : bus_in;

    always @(posedge clk) begin
        if (clr) q <= 32'b0;
        else if (en) q <= d;
    end
endmodule
