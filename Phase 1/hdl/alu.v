`timescale 1ns/1ps

module alu(
    input  [31:0] y,        // operand A (from Y register)
    input  [31:0] bus,      // operand B (from bus)

    input         IncPC,
    input         ADD,
    input         SUB,
    input         AND_op,
    input         OR_op,
    input         SHR,
    input         SHRA,
    input         SHL,
    input         ROR,
    input         ROL,
    input         NEG,
    input         NOT_op,
    input         MUL,
    input         DIV,

    output [63:0] z_out
);
    // ADD / SUB
    wire [31:0] addsub_b = SUB ? ~bus : bus;
    wire        addsub_cin = SUB ? 1'b1 : 1'b0;
    wire [31:0] addsub_sum;
    wire        addsub_cout;

    adder32 u_addsub(
        .a(y),
        .b(addsub_b),
        .cin(addsub_cin),
        .sum(addsub_sum),
        .cout(addsub_cout)
    );

    // IncPC (bus + 1)
    wire [31:0] incpc_sum;
    wire        incpc_cout;
    adder32 u_incpc(
        .a(bus),
        .b(32'b0),
        .cin(1'b1),
        .sum(incpc_sum),
        .cout(incpc_cout)
    );

    // NEG (two's complement of bus)
    wire [31:0] neg_sum;
    wire        neg_cout;
    adder32 u_neg(
        .a(~bus),
        .b(32'b0),
        .cin(1'b1),
        .sum(neg_sum),
        .cout(neg_cout)
    );

    // MUL / DIV
    wire [63:0] mul_p;
    booth_mul32 u_mul(.a(y), .b(bus), .p(mul_p));

    wire [31:0] div_q;
    wire [31:0] div_r;
    div32_signed u_div(.a(y), .b(bus), .quotient(div_q), .remainder(div_r));

    // Shifts/rotates
    // Data comes from y; shift amount comes from bus[4:0].
    wire [4:0] shamt = bus[4:0];

    wire [31:0] shr_res  = y >> shamt;
    wire [31:0] shra_res = $signed(y) >>> shamt;
    wire [31:0] shl_res  = y << shamt;

    // Rotate using {y,y}
    wire [63:0] yy = {y, y};
    wire [63:0] yy_ror = (yy >> shamt);
    wire [63:0] yy_rol = (yy << shamt);
    wire [31:0] ror_res = yy_ror[31:0];
    wire [31:0] rol_res = yy_rol[63:32];

    // Logic
    wire [31:0] and_res = y & bus;
    wire [31:0] or_res  = y | bus;
    wire [31:0] not_res = ~bus;

    reg [63:0] z;
    always @* begin
        z = 64'b0;

        if (MUL) begin
            z = mul_p;
        end else if (DIV) begin
            // Z[63:32]=remainder, Z[31:0]=quotient
            z = {div_r, div_q};
        end else if (ADD) begin
            z = {32'b0, addsub_sum};
        end else if (SUB) begin
            z = {32'b0, addsub_sum};
        end else if (AND_op) begin
            z = {32'b0, and_res};
        end else if (OR_op) begin
            z = {32'b0, or_res};
        end else if (SHR) begin
            z = {32'b0, shr_res};
        end else if (SHRA) begin
            z = {32'b0, shra_res};
        end else if (SHL) begin
            z = {32'b0, shl_res};
        end else if (ROR) begin
            z = {32'b0, ror_res};
        end else if (ROL) begin
            z = {32'b0, rol_res};
        end else if (NEG) begin
            z = {32'b0, neg_sum};
        end else if (NOT_op) begin
            z = {32'b0, not_res};
        end else if (IncPC) begin
            z = {32'b0, incpc_sum};
        end
    end

    assign z_out = z;
endmodule
