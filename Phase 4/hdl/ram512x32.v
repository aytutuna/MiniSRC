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

    localparam [4:0] OP_ADD  = 5'b00000;
    localparam [4:0] OP_SUB  = 5'b00001;
    localparam [4:0] OP_AND  = 5'b00010;
    localparam [4:0] OP_OR   = 5'b00011;
    localparam [4:0] OP_SHR  = 5'b00100;
    localparam [4:0] OP_SHRA = 5'b00101;
    localparam [4:0] OP_SHL  = 5'b00110;
    localparam [4:0] OP_ROR  = 5'b00111;
    localparam [4:0] OP_ROL  = 5'b01000;
    localparam [4:0] OP_ADDI = 5'b01001;
    localparam [4:0] OP_ANDI = 5'b01010;
    localparam [4:0] OP_ORI  = 5'b01011;
    localparam [4:0] OP_DIV  = 5'b01100;
    localparam [4:0] OP_MUL  = 5'b01101;
    localparam [4:0] OP_NEG  = 5'b01110;
    localparam [4:0] OP_NOT  = 5'b01111;
    localparam [4:0] OP_LD   = 5'b10000;
    localparam [4:0] OP_LDI  = 5'b10001;
    localparam [4:0] OP_ST   = 5'b10010;
    localparam [4:0] OP_JAL  = 5'b10011;
    localparam [4:0] OP_JR   = 5'b10100;
    localparam [4:0] OP_BR   = 5'b10101;
    localparam [4:0] OP_IN   = 5'b10110;
    localparam [4:0] OP_OUT  = 5'b10111;
    localparam [4:0] OP_MFHI = 5'b11000;
    localparam [4:0] OP_MFLO = 5'b11001;
    localparam [4:0] OP_NOP  = 5'b11010;
    localparam [4:0] OP_HALT = 5'b11011;

    localparam [3:0] CON_ZR = 4'b0000;
    localparam [3:0] CON_NZ = 4'b0001;
    localparam [3:0] CON_PL = 4'b0010;
    localparam [3:0] CON_MI = 4'b0011;

    integer i;

    function [18:0] imm19;
        input integer value;
        begin
            imm19 = value[18:0];
        end
    endfunction

    function [31:0] instr_r;
        input [4:0] op;
        input [3:0] ra;
        input [3:0] rb;
        input [3:0] rc;
        begin
            instr_r = {op, ra, rb, rc, 15'b0};
        end
    endfunction

    function [31:0] instr_i;
        input [4:0] op;
        input [3:0] ra;
        input [3:0] rb;
        input [18:0] imm;
        begin
            instr_i = {op, ra, rb, imm};
        end
    endfunction

    function [31:0] instr_branch;
        input [3:0] ra;
        input [3:0] cond;
        input [18:0] imm;
        begin
            instr_branch = {OP_BR, ra, cond, imm};
        end
    endfunction

    function [31:0] instr_jal;
        input [3:0] target_reg;
        begin
            instr_jal = {OP_JAL, target_reg, 4'd0, 4'd12, 15'b0};
        end
    endfunction

    function [31:0] instr_misc;
        input [4:0] op;
        begin
            instr_misc = {op, 27'b0};
        end
    endfunction

    initial begin
        for (i = 0; i < 512; i = i + 1) begin
            mem[i] = 32'b0;
        end

        mem[9'h088] = 32'h0000FFFF;
        mem[9'h089] = 32'h000000A7;
        mem[9'h0A3] = 32'h00000068;

        mem[9'h000] = instr_i(OP_LDI, 4'd5, 4'd0, imm19('h43));
        mem[9'h001] = instr_i(OP_LDI, 4'd5, 4'd5, imm19(6));
        mem[9'h002] = instr_i(OP_LD,  4'd4, 4'd0, imm19('h89));
        mem[9'h003] = instr_i(OP_LDI, 4'd4, 4'd4, imm19(4));
        mem[9'h004] = instr_i(OP_LD,  4'd0, 4'd4, imm19(-8));
        mem[9'h005] = instr_i(OP_LDI, 4'd2, 4'd0, imm19(4));
        mem[9'h006] = instr_i(OP_LDI, 4'd5, 4'd0, imm19('h87));
        mem[9'h007] = instr_branch(4'd5, CON_MI, imm19(3));
        mem[9'h008] = instr_i(OP_LDI, 4'd5, 4'd5, imm19(5));
        mem[9'h009] = instr_i(OP_LD,  4'd1, 4'd5, imm19(-3));
        mem[9'h00A] = instr_misc(OP_NOP);
        mem[9'h00B] = instr_branch(4'd1, CON_PL, imm19(2));
        mem[9'h00C] = instr_i(OP_LDI, 4'd3, 4'd5, imm19(7));
        mem[9'h00D] = instr_i(OP_LDI, 4'd7, 4'd3, imm19(-4));
        mem[9'h00E] = instr_r(OP_ADD,  4'd7, 4'd5, 4'd2);
        mem[9'h00F] = instr_i(OP_ADDI, 4'd1, 4'd1, imm19(3));
        mem[9'h010] = instr_i(OP_NEG,  4'd1, 4'd1, imm19(0));
        mem[9'h011] = instr_i(OP_NOT,  4'd1, 4'd1, imm19(0));
        mem[9'h012] = instr_i(OP_ANDI, 4'd1, 4'd1, imm19('hF));
        mem[9'h013] = instr_r(OP_ROR,  4'd4, 4'd0, 4'd2);
        mem[9'h014] = instr_i(OP_ORI,  4'd1, 4'd4, imm19(5));
        mem[9'h015] = instr_r(OP_SHRA, 4'd4, 4'd1, 4'd2);
        mem[9'h016] = instr_r(OP_SHR,  4'd5, 4'd5, 4'd2);
        mem[9'h017] = instr_i(OP_ST,   4'd5, 4'd0, imm19('hA3));
        mem[9'h018] = instr_r(OP_ROL,  4'd5, 4'd0, 4'd2);
        mem[9'h019] = instr_r(OP_OR,   4'd7, 4'd2, 4'd0);
        mem[9'h01A] = instr_r(OP_AND,  4'd4, 4'd5, 4'd0);
        mem[9'h01B] = instr_i(OP_ST,   4'd7, 4'd4, imm19('h89));
        mem[9'h01C] = instr_r(OP_SUB,  4'd0, 4'd5, 4'd7);
        mem[9'h01D] = instr_r(OP_SHL,  4'd4, 4'd5, 4'd2);
        mem[9'h01E] = instr_i(OP_LDI,  4'd7, 4'd0, imm19(7));
        mem[9'h01F] = instr_i(OP_LDI,  4'd3, 4'd0, imm19('h19));
        mem[9'h020] = instr_i(OP_MUL,  4'd3, 4'd7, imm19(0));
        mem[9'h021] = instr_i(OP_MFHI, 4'd1, 4'd0, imm19(0));
        mem[9'h022] = instr_i(OP_MFLO, 4'd6, 4'd0, imm19(0));
        mem[9'h023] = instr_i(OP_DIV,  4'd3, 4'd7, imm19(0));
        mem[9'h024] = instr_i(OP_LDI,  4'd8, 4'd7, imm19(2));
        mem[9'h025] = instr_i(OP_LDI,  4'd9, 4'd3, imm19(-4));
        mem[9'h026] = instr_i(OP_LDI,  4'd10, 4'd6, imm19(3));
        mem[9'h027] = instr_i(OP_LDI,  4'd11, 4'd1, imm19(5));
        mem[9'h028] = instr_jal(4'd10);
        mem[9'h029] = instr_i(OP_IN,   4'd6, 4'd0, imm19(0));
        mem[9'h02A] = instr_i(OP_ST,   4'd6, 4'd0, imm19('h77));
        mem[9'h02B] = instr_i(OP_LDI,  4'd3, 4'd0, imm19('h2E));
        mem[9'h02C] = instr_i(OP_LDI,  4'd5, 4'd0, imm19(1));
        mem[9'h02D] = instr_i(OP_LDI,  4'd2, 4'd0, imm19(40));
        mem[9'h02E] = instr_i(OP_OUT,  4'd6, 4'd0, imm19(0));
        mem[9'h02F] = instr_i(OP_LDI,  4'd2, 4'd2, imm19(-1));
        mem[9'h030] = instr_branch(4'd2, CON_ZR, imm19(8));
        mem[9'h031] = instr_i(OP_LD,   4'd7, 4'd0, imm19('h88));
        mem[9'h032] = instr_i(OP_LDI,  4'd7, 4'd7, imm19(-1));
        mem[9'h033] = instr_misc(OP_NOP);
        mem[9'h034] = instr_branch(4'd7, CON_NZ, imm19(-3));
        mem[9'h035] = instr_r(OP_SHR,  4'd6, 4'd6, 4'd5);
        mem[9'h036] = instr_branch(4'd6, CON_NZ, imm19(-9));
        mem[9'h037] = instr_i(OP_LD,   4'd6, 4'd0, imm19('h77));
        mem[9'h038] = instr_i(OP_JR,   4'd3, 4'd0, imm19(0));
        mem[9'h039] = instr_i(OP_LDI,  4'd6, 4'd0, imm19('h63));
        mem[9'h03A] = instr_i(OP_OUT,  4'd6, 4'd0, imm19(0));
        mem[9'h03B] = instr_misc(OP_HALT);

        mem[9'h0B2] = instr_r(OP_ADD,  4'd14, 4'd8, 4'd10);
        mem[9'h0B3] = instr_r(OP_SUB,  4'd13, 4'd9, 4'd11);
        mem[9'h0B4] = instr_r(OP_SUB,  4'd14, 4'd14, 4'd13);
        mem[9'h0B5] = instr_i(OP_JR,   4'd12, 4'd0, imm19(0));
    end

    assign read_data = read_en ? mem[address] : 32'b0;

    always @(posedge clk) begin
        if (write_en) begin
            mem[address] <= write_data;
        end
    end
endmodule
