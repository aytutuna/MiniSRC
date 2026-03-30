`timescale 1ns/1ps

module phase3tb;
    reg Clock;
    reg Reset;
    reg Stop;
    reg [31:0] InPortData;
    reg InPortStrobe;
    integer cycles;
    wire Run;

    wire [31:0] PC;
    wire [31:0] IR;
    wire [31:0] MAR;
    wire [31:0] MDR;
    wire [31:0] HI;
    wire [31:0] LO;
    wire [31:0] R0;
    wire [31:0] R1;
    wire [31:0] R2;
    wire [31:0] R3;
    wire [31:0] R4;
    wire [31:0] R5;
    wire [31:0] R6;
    wire [31:0] R7;
    wire [31:0] R8;
    wire [31:0] R9;
    wire [31:0] R10;
    wire [31:0] R11;
    wire [31:0] R12;
    wire [31:0] R13;
    wire [31:0] R14;
    wire [31:0] R15;

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

    mini_src_cpu DUT(
        .Clock(Clock),
        .Reset(Reset),
        .Stop(Stop),
        .InPortData(InPortData),
        .InPortStrobe(InPortStrobe),
        .Run(Run)
    );

    assign PC = DUT.u_datapath.PC;
    assign IR = DUT.u_datapath.IR;
    assign MAR = DUT.u_datapath.MAR;
    assign MDR = DUT.u_datapath.MDR;
    assign HI = DUT.u_datapath.HI;
    assign LO = DUT.u_datapath.LO;
    assign R0 = DUT.u_datapath.R0;
    assign R1 = DUT.u_datapath.R1;
    assign R2 = DUT.u_datapath.R2;
    assign R3 = DUT.u_datapath.R3;
    assign R4 = DUT.u_datapath.R4;
    assign R5 = DUT.u_datapath.R5;
    assign R6 = DUT.u_datapath.R6;
    assign R7 = DUT.u_datapath.R7;
    assign R8 = DUT.u_datapath.R8;
    assign R9 = DUT.u_datapath.R9;
    assign R10 = DUT.u_datapath.R10;
    assign R11 = DUT.u_datapath.R11;
    assign R12 = DUT.u_datapath.R12;
    assign R13 = DUT.u_datapath.R13;
    assign R14 = DUT.u_datapath.R14;
    assign R15 = DUT.u_datapath.R15;

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

    task clear_memory;
        integer i;
        begin
            for (i = 0; i < 512; i = i + 1) begin
                DUT.u_datapath.u_ram.mem[i] = 32'b0;
            end
        end
    endtask

    task load_program;
        begin
            clear_memory();

            DUT.u_datapath.u_ram.mem[9'h089] = 32'h000000A7;
            DUT.u_datapath.u_ram.mem[9'h0A3] = 32'h00000068;

            DUT.u_datapath.u_ram.mem[9'h000] = instr_i(OP_LDI, 4'd5, 4'd0, imm19('h43));
            DUT.u_datapath.u_ram.mem[9'h001] = instr_i(OP_LDI, 4'd5, 4'd5, imm19(6));
            DUT.u_datapath.u_ram.mem[9'h002] = instr_i(OP_LD,  4'd4, 4'd0, imm19('h89));
            DUT.u_datapath.u_ram.mem[9'h003] = instr_i(OP_LDI, 4'd4, 4'd4, imm19(4));
            DUT.u_datapath.u_ram.mem[9'h004] = instr_i(OP_LD,  4'd0, 4'd4, imm19(-8));
            DUT.u_datapath.u_ram.mem[9'h005] = instr_i(OP_LDI, 4'd2, 4'd0, imm19(4));
            DUT.u_datapath.u_ram.mem[9'h006] = instr_i(OP_LDI, 4'd5, 4'd0, imm19('h87));
            DUT.u_datapath.u_ram.mem[9'h007] = instr_branch(4'd5, CON_MI, imm19(3));
            DUT.u_datapath.u_ram.mem[9'h008] = instr_i(OP_LDI, 4'd5, 4'd5, imm19(5));
            DUT.u_datapath.u_ram.mem[9'h009] = instr_i(OP_LD,  4'd1, 4'd5, imm19(-3));
            DUT.u_datapath.u_ram.mem[9'h00A] = instr_misc(OP_NOP);
            DUT.u_datapath.u_ram.mem[9'h00B] = instr_branch(4'd1, CON_PL, imm19(2));
            DUT.u_datapath.u_ram.mem[9'h00C] = instr_i(OP_LDI, 4'd3, 4'd5, imm19(7));
            DUT.u_datapath.u_ram.mem[9'h00D] = instr_i(OP_LDI, 4'd7, 4'd3, imm19(-4));
            DUT.u_datapath.u_ram.mem[9'h00E] = instr_r(OP_ADD,  4'd7, 4'd5, 4'd2);
            DUT.u_datapath.u_ram.mem[9'h00F] = instr_i(OP_ADDI, 4'd1, 4'd1, imm19(3));
            DUT.u_datapath.u_ram.mem[9'h010] = instr_i(OP_NEG,  4'd1, 4'd1, imm19(0));
            DUT.u_datapath.u_ram.mem[9'h011] = instr_i(OP_NOT,  4'd1, 4'd1, imm19(0));
            DUT.u_datapath.u_ram.mem[9'h012] = instr_i(OP_ANDI, 4'd1, 4'd1, imm19('hF));
            DUT.u_datapath.u_ram.mem[9'h013] = instr_r(OP_ROR,  4'd4, 4'd0, 4'd2);
            DUT.u_datapath.u_ram.mem[9'h014] = instr_i(OP_ORI,  4'd1, 4'd4, imm19(5));
            DUT.u_datapath.u_ram.mem[9'h015] = instr_r(OP_SHRA, 4'd4, 4'd1, 4'd2);
            DUT.u_datapath.u_ram.mem[9'h016] = instr_r(OP_SHR,  4'd5, 4'd5, 4'd2);
            DUT.u_datapath.u_ram.mem[9'h017] = instr_i(OP_ST,   4'd5, 4'd0, imm19('hA3));
            DUT.u_datapath.u_ram.mem[9'h018] = instr_r(OP_ROL,  4'd5, 4'd0, 4'd2);
            DUT.u_datapath.u_ram.mem[9'h019] = instr_r(OP_OR,   4'd7, 4'd2, 4'd0);
            DUT.u_datapath.u_ram.mem[9'h01A] = instr_r(OP_AND,  4'd4, 4'd5, 4'd0);
            DUT.u_datapath.u_ram.mem[9'h01B] = instr_i(OP_ST,   4'd7, 4'd4, imm19('h89));
            DUT.u_datapath.u_ram.mem[9'h01C] = instr_r(OP_SUB,  4'd0, 4'd5, 4'd7);
            DUT.u_datapath.u_ram.mem[9'h01D] = instr_r(OP_SHL,  4'd4, 4'd5, 4'd2);
            DUT.u_datapath.u_ram.mem[9'h01E] = instr_i(OP_LDI,  4'd7, 4'd0, imm19(7));
            DUT.u_datapath.u_ram.mem[9'h01F] = instr_i(OP_LDI,  4'd3, 4'd0, imm19('h19));
            DUT.u_datapath.u_ram.mem[9'h020] = instr_i(OP_MUL,  4'd3, 4'd7, imm19(0));
            DUT.u_datapath.u_ram.mem[9'h021] = instr_i(OP_MFHI, 4'd1, 4'd0, imm19(0));
            DUT.u_datapath.u_ram.mem[9'h022] = instr_i(OP_MFLO, 4'd6, 4'd0, imm19(0));
            DUT.u_datapath.u_ram.mem[9'h023] = instr_i(OP_DIV,  4'd3, 4'd7, imm19(0));
            DUT.u_datapath.u_ram.mem[9'h024] = instr_i(OP_LDI,  4'd8, 4'd7, imm19(2));
            DUT.u_datapath.u_ram.mem[9'h025] = instr_i(OP_LDI,  4'd9, 4'd3, imm19(-4));
            DUT.u_datapath.u_ram.mem[9'h026] = instr_i(OP_LDI,  4'd10, 4'd6, imm19(3));
            DUT.u_datapath.u_ram.mem[9'h027] = instr_i(OP_LDI,  4'd11, 4'd1, imm19(5));
            DUT.u_datapath.u_ram.mem[9'h028] = instr_jal(4'd10);
            DUT.u_datapath.u_ram.mem[9'h029] = instr_misc(OP_HALT);

            DUT.u_datapath.u_ram.mem[9'h0B2] = instr_r(OP_ADD, 4'd14, 4'd8, 4'd10);
            DUT.u_datapath.u_ram.mem[9'h0B3] = instr_r(OP_SUB, 4'd13, 4'd9, 4'd11);
            DUT.u_datapath.u_ram.mem[9'h0B4] = instr_r(OP_SUB, 4'd14, 4'd14, 4'd13);
            DUT.u_datapath.u_ram.mem[9'h0B5] = instr_i(OP_JR,  4'd12, 4'd0, imm19(0));
        end
    endtask

    task expect32;
        input [31:0] actual;
        input [31:0] expected;
        input [255:0] label;
        begin
            if (actual !== expected) begin
                $fatal(1, "%0s failed: got %h expected %h", label, actual, expected);
            end
        end
    endtask

    task expect1;
        input actual;
        input expected;
        input [255:0] label;
        begin
            if (actual !== expected) begin
                $fatal(1, "%0s failed: got %b expected %b", label, actual, expected);
            end
        end
    endtask

    task dump_final_state;
        begin
            $display("Final state summary:");
            $display("PC=%h IR=%h MAR=%h MDR=%h Run=%b", PC, IR, MAR, MDR, Run);
            $display("R0=%h R1=%h R2=%h R3=%h", R0, R1, R2, R3);
            $display("R4=%h R5=%h R6=%h R7=%h", R4, R5, R6, R7);
            $display("R8=%h R9=%h R10=%h R11=%h", R8, R9, R10, R11);
            $display("R12=%h R13=%h R14=%h R15=%h", R12, R13, R14, R15);
            $display("HI=%h LO=%h", HI, LO);
            $display("MEM[0x89]=%h MEM[0xA3]=%h", DUT.u_datapath.u_ram.mem[9'h089], DUT.u_datapath.u_ram.mem[9'h0A3]);
        end
    endtask

    initial begin
        Clock = 1'b0;
        forever #10 Clock = ~Clock;
    end

    initial begin
        Stop = 1'b0;
        Reset = 1'b1;
        InPortData = 32'b0;
        InPortStrobe = 1'b0;

        load_program();

        repeat (2) @(posedge Clock);
        Reset = 1'b0;

        cycles = 0;
        while (Run && cycles < 500) begin
            @(posedge Clock);
            cycles = cycles + 1;
        end

        if (Run) begin
            $fatal(1, "Simulation timed out before halt after %0d cycles", cycles);
        end

        @(negedge Clock);

        expect1(Run, 1'b0, "Run low after halt");
        expect32(PC, 32'h0000002A, "PC after halt fetch");
        expect32(IR, instr_misc(OP_HALT), "IR holds halt");
        expect32(MAR, 32'h00000029, "MAR final value");
        expect32(MDR, instr_misc(OP_HALT), "MDR final value");
        expect32(R0, 32'h00000614, "R0 final");
        expect32(R1, 32'h00000000, "R1 final");
        expect32(R2, 32'h00000004, "R2 final");
        expect32(R3, 32'h00000019, "R3 final");
        expect32(R4, 32'h00006800, "R4 final");
        expect32(R5, 32'h00000680, "R5 final");
        expect32(R6, 32'h000000AF, "R6 final");
        expect32(R7, 32'h00000007, "R7 final");
        expect32(R8, 32'h00000009, "R8 final");
        expect32(R9, 32'h00000015, "R9 final");
        expect32(R10, 32'h000000B2, "R10 final");
        expect32(R11, 32'h00000005, "R11 final");
        expect32(R12, 32'h00000029, "R12 final");
        expect32(R13, 32'h00000010, "R13 final");
        expect32(R14, 32'h000000AB, "R14 final");
        expect32(R15, 32'h00000000, "R15 final");
        expect32(HI, 32'h00000004, "HI final");
        expect32(LO, 32'h00000003, "LO final");
        expect32(DUT.u_datapath.u_ram.mem[9'h089], 32'h0000006C, "memory 0x89 final");
        expect32(DUT.u_datapath.u_ram.mem[9'h0A3], 32'h00000008, "memory 0xA3 final");

        dump_final_state();
        $display("Phase 3 full-program test passed in %0d cycles.", cycles);
        $finish;
    end
endmodule