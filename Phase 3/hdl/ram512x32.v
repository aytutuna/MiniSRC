`timescale 1ns/1ps

module ram512x32(
    input         clk,
    input         read_en,
    input         write_en,
    input  [8:0]  address,
    input  [31:0] write_data,
    output [31:0] read_data
);
    reg [31:0] mem [0:511];
    integer i;

    initial begin
        for (i = 0; i < 512; i = i + 1) begin
            mem[i] = 32'b0;
        end
    end

    assign read_data = read_en ? mem[address] : 32'b0;

    always @(posedge clk) begin
        if (write_en) begin
            mem[address] <= write_data;
        end
    end
endmodule
