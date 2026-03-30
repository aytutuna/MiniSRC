`timescale 1ns/1ps

module select_encode(
    input  [31:0] ir,
    input         Gra,
    input         Grb,
    input         Grc,
    input         Rin,
    input         Rout,
    input         BAout,
    output [15:0] reg_in,
    output [15:0] reg_out
);
    reg [3:0] selected_reg;
    reg [15:0] decoded;

    always @* begin
        selected_reg = 4'b0000;
        if (Gra) selected_reg = ir[26:23];
        else if (Grb) selected_reg = ir[22:19];
        else if (Grc) selected_reg = ir[18:15];
    end

    always @* begin
        decoded = 16'b0;
        decoded[selected_reg] = Gra | Grb | Grc;
    end

    assign reg_in = Rin ? decoded : 16'b0;
    assign reg_out = (Rout | BAout) ? decoded : 16'b0;
endmodule
