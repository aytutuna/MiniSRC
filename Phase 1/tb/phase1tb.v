`timescale 1ns/1ps

module phase1tb;
    // Clock/reset
    reg Clock;
    reg Clear;

    // Memory input
    reg [31:0] Mdatain;
    reg Read;

    // Bus source control
    reg PCout, MDRout, Zlowout, Zhighout, HIout, LOout;
    reg R0out, R1out, R2out, R3out, R4out, R5out, R6out, R7out;
    reg R8out, R9out, R10out, R11out, R12out, R13out, R14out, R15out;

    // Register load control
    reg PCin, IRin, MARin, MDRin, Yin, Zin, HIin, LOin;
    reg R0in, R1in, R2in, R3in, R4in, R5in, R6in, R7in;
    reg R8in, R9in, R10in, R11in, R12in, R13in, R14in, R15in;

    // ALU control
    reg IncPC, ADD, SUB, AND_op, OR_op, SHR, SHRA, SHL, ROR, ROL, NEG, NOT_op, MUL, DIV;

    // DUT signals
    wire [31:0] BusMuxOut;
    wire [63:0] Z;
    wire [31:0] PC, IR, MAR, MDR, Y, HI, LO;
    wire [31:0] R0, R1, R2, R3, R4, R5, R6, R7;
    wire [31:0] R8, R9, R10, R11, R12, R13, R14, R15;

    Datapath DUT(
        .PCout(PCout), .MDRout(MDRout), .Zlowout(Zlowout), .Zhighout(Zhighout),
        .HIout(HIout), .LOout(LOout),
        .R0out(R0out), .R1out(R1out), .R2out(R2out), .R3out(R3out), .R4out(R4out), .R5out(R5out), .R6out(R6out), .R7out(R7out),
        .R8out(R8out), .R9out(R9out), .R10out(R10out), .R11out(R11out), .R12out(R12out), .R13out(R13out), .R14out(R14out), .R15out(R15out),

        .PCin(PCin), .IRin(IRin), .MARin(MARin), .MDRin(MDRin), .Yin(Yin), .Zin(Zin), .HIin(HIin), .LOin(LOin),
        .R0in(R0in), .R1in(R1in), .R2in(R2in), .R3in(R3in), .R4in(R4in), .R5in(R5in), .R6in(R6in), .R7in(R7in),
        .R8in(R8in), .R9in(R9in), .R10in(R10in), .R11in(R11in), .R12in(R12in), .R13in(R13in), .R14in(R14in), .R15in(R15in),

        .IncPC(IncPC), .ADD(ADD), .SUB(SUB), .AND_op(AND_op), .OR_op(OR_op), .SHR(SHR), .SHRA(SHRA), .SHL(SHL),
        .ROR(ROR), .ROL(ROL), .NEG(NEG), .NOT_op(NOT_op), .MUL(MUL), .DIV(DIV),

        .Read(Read), .Mdatain(Mdatain),
        .Clock(Clock), .Clear(Clear)
    );

    // internal DUT signals
    assign BusMuxOut = DUT.BusMuxOut;
    assign Z  = DUT.Z;
    assign PC = DUT.PC;
    assign IR = DUT.IR;
    assign MAR = DUT.MAR;
    assign MDR = DUT.MDR;
    assign Y = DUT.Y;
    assign HI = DUT.HI;
    assign LO = DUT.LO;
    assign R0 = DUT.R0;
    assign R1 = DUT.R1;
    assign R2 = DUT.R2;
    assign R3 = DUT.R3;
    assign R4 = DUT.R4;
    assign R5 = DUT.R5;
    assign R6 = DUT.R6;
    assign R7 = DUT.R7;
    assign R8 = DUT.R8;
    assign R9 = DUT.R9;
    assign R10 = DUT.R10;
    assign R11 = DUT.R11;
    assign R12 = DUT.R12;
    assign R13 = DUT.R13;
    assign R14 = DUT.R14;
    assign R15 = DUT.R15;

    // Opcode helpers
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
        begin
            instr_i = {op, ra, rb, 19'b0};
        end
    endfunction

    task deassert_all;
        begin
            PCout=0; MDRout=0; Zlowout=0; Zhighout=0; HIout=0; LOout=0;
            R0out=0; R1out=0; R2out=0; R3out=0; R4out=0; R5out=0; R6out=0; R7out=0;
            R8out=0; R9out=0; R10out=0; R11out=0; R12out=0; R13out=0; R14out=0; R15out=0;

            PCin=0; IRin=0; MARin=0; MDRin=0; Yin=0; Zin=0; HIin=0; LOin=0;
            R0in=0; R1in=0; R2in=0; R3in=0; R4in=0; R5in=0; R6in=0; R7in=0;
            R8in=0; R9in=0; R10in=0; R11in=0; R12in=0; R13in=0; R14in=0; R15in=0;

            IncPC=0; ADD=0; SUB=0; AND_op=0; OR_op=0; SHR=0; SHRA=0; SHL=0; ROR=0; ROL=0;
            NEG=0; NOT_op=0; MUL=0; DIV=0;

            Read=0;
        end
    endtask

    task mdr_load;
        input [31:0] value;
        begin
            deassert_all();
            @(negedge Clock);
            Mdatain <= value;
            Read <= 1'b1;
            MDRin <= 1'b1;
            @(posedge Clock);
            @(negedge Clock);
            Read <= 1'b0;
            MDRin <= 1'b0;
        end
    endtask

    task write_reg_from_mdr;
        input integer regnum;
        begin
            deassert_all();
            @(negedge Clock);
            MDRout <= 1'b1;
            case (regnum)
                0: R0in <= 1'b1;
                1: R1in <= 1'b1;
                2: R2in <= 1'b1;
                3: R3in <= 1'b1;
                4: R4in <= 1'b1;
                5: R5in <= 1'b1;
                6: R6in <= 1'b1;
                7: R7in <= 1'b1;
                default: ;
            endcase
            @(posedge Clock);
            @(negedge Clock);
            MDRout <= 1'b0;
            case (regnum)
                0: R0in <= 1'b0;
                1: R1in <= 1'b0;
                2: R2in <= 1'b0;
                3: R3in <= 1'b0;
                4: R4in <= 1'b0;
                5: R5in <= 1'b0;
                6: R6in <= 1'b0;
                7: R7in <= 1'b0;
                default: ;
            endcase
        end
    endtask

    // Standard fetch used in all
    task fetch;
        input [31:0] instruction;
        begin
            // T0: PCout, MARin, IncPC, Zin
            @(negedge Clock);
            deassert_all();
            PCout <= 1'b1;
            MARin <= 1'b1;
            IncPC <= 1'b1;
            Zin   <= 1'b1;
            @(posedge Clock);

            // T1: Zlowout, PCin, Read, Mdatain, MDRin
            @(negedge Clock);
            deassert_all();
            Zlowout <= 1'b1;
            PCin    <= 1'b1;
            Read    <= 1'b1;
            MDRin   <= 1'b1;
            Mdatain <= instruction;
            @(posedge Clock);

            // T2: MDRout, IRin
            @(negedge Clock);
            deassert_all();
            MDRout <= 1'b1;
            IRin   <= 1'b1;
            @(posedge Clock);

            @(negedge Clock);
            deassert_all();
        end
    endtask

    // Clock
    initial begin
        Clock = 0;
        forever #10 Clock = ~Clock;
    end

    initial begin
        // Init
        Mdatain = 32'h0;
        deassert_all();
        Clear = 1'b1;
        @(posedge Clock);
        @(negedge Clock);
        Clear = 1'b0;

        // Seed registers using MDR path (as in the provided example)
        mdr_load(32'h00000034); write_reg_from_mdr(5); // R5 = 0x34
        mdr_load(32'h00000045); write_reg_from_mdr(6); // R6 = 0x45

        // For mul/div: R3 and R1
        mdr_load(32'h00000014); write_reg_from_mdr(3); // R3 = 20
        mdr_load(32'h00000003); write_reg_from_mdr(1); // R1 = 3

        // For shifts/rotates: R0 value and R4 shift count
        mdr_load(32'h80000001); write_reg_from_mdr(0); // R0 = 0x80000001
        mdr_load(32'h00000004); write_reg_from_mdr(4); // R4 = 4

        // For neg/not: R7 value
        mdr_load(32'h0000000F); write_reg_from_mdr(7); // R7 = 15

        // 3.1 AND: and R2,R5,R6
        fetch(instr_r(5'b00010, 4'd2, 4'd5, 4'd6));
        // T3: R5out, Yin
        @(negedge Clock); deassert_all(); R5out<=1; Yin<=1; @(posedge Clock);
        // T4: R6out, AND, Zin
        @(negedge Clock); deassert_all(); R6out<=1; AND_op<=1; Zin<=1; @(posedge Clock);
        // T5: Zlowout, R2in
        @(negedge Clock); deassert_all(); Zlowout<=1; R2in<=1; @(posedge Clock);
        @(negedge Clock); deassert_all();
        if (R2 !== (32'h00000034 & 32'h00000045)) $fatal(1, "AND failed: R2=%h", R2);

        // 3.2 OR: or R2,R5,R6
        fetch(instr_r(5'b00011, 4'd2, 4'd5, 4'd6));
        @(negedge Clock); deassert_all(); R5out<=1; Yin<=1; @(posedge Clock);
        @(negedge Clock); deassert_all(); R6out<=1; OR_op<=1; Zin<=1; @(posedge Clock);
        @(negedge Clock); deassert_all(); Zlowout<=1; R2in<=1; @(posedge Clock);
        @(negedge Clock); deassert_all();
        if (R2 !== (32'h00000034 | 32'h00000045)) $fatal(1, "OR failed: R2=%h", R2);

        // 3.3 ADD: add R2,R5,R6
        fetch(instr_r(5'b00000, 4'd2, 4'd5, 4'd6));
        @(negedge Clock); deassert_all(); R5out<=1; Yin<=1; @(posedge Clock);
        @(negedge Clock); deassert_all(); R6out<=1; ADD<=1; Zin<=1; @(posedge Clock);
        @(negedge Clock); deassert_all(); Zlowout<=1; R2in<=1; @(posedge Clock);
        @(negedge Clock); deassert_all();
        if (R2 !== (32'h00000034 + 32'h00000045)) $fatal(1, "ADD failed: R2=%h", R2);

        // 3.4 SUB: sub R2,R5,R6
        fetch(instr_r(5'b00001, 4'd2, 4'd5, 4'd6));
        @(negedge Clock); deassert_all(); R5out<=1; Yin<=1; @(posedge Clock);
        @(negedge Clock); deassert_all(); R6out<=1; SUB<=1; Zin<=1; @(posedge Clock);
        @(negedge Clock); deassert_all(); Zlowout<=1; R2in<=1; @(posedge Clock);
        @(negedge Clock); deassert_all();
        if (R2 !== (32'h00000034 - 32'h00000045)) $fatal(1, "SUB failed: R2=%h", R2);

        // 3.5 MUL: mul R3,R1  (HI,LO <- R3 * R1)
        fetch(instr_i(5'b01101, 4'd3, 4'd1));
        @(negedge Clock); deassert_all(); R3out<=1; Yin<=1; @(posedge Clock);
        @(negedge Clock); deassert_all(); R1out<=1; MUL<=1; Zin<=1; @(posedge Clock);
        @(negedge Clock); deassert_all(); Zlowout<=1; LOin<=1; @(posedge Clock);
        @(negedge Clock); deassert_all(); Zhighout<=1; HIin<=1; @(posedge Clock);
        @(negedge Clock); deassert_all();
        if ({HI,LO} !== ($signed(32'sd20) * $signed(32'sd3))) $fatal(1, "MUL failed: HI=%h LO=%h", HI, LO);

        // 3.6 DIV: div R3,R1  (HI,LO <- R3 / R1) remainder in HI, quotient in LO
        fetch(instr_i(5'b01100, 4'd3, 4'd1));
        @(negedge Clock); deassert_all(); R3out<=1; Yin<=1; @(posedge Clock);
        @(negedge Clock); deassert_all(); R1out<=1; DIV<=1; Zin<=1; @(posedge Clock);
        // Load quotient to LO, remainder to HI
        @(negedge Clock); deassert_all(); Zlowout<=1; LOin<=1; @(posedge Clock);
        @(negedge Clock); deassert_all(); Zhighout<=1; HIin<=1; @(posedge Clock);
        @(negedge Clock); deassert_all();
        if (LO !== 32'd6 || HI !== 32'd2) $fatal(1, "DIV failed: HI=%h LO=%h", HI, LO);

        // 3.7 SHR: shr R7,R0,R4
        fetch(instr_r(5'b00100, 4'd7, 4'd0, 4'd4));
        @(negedge Clock); deassert_all(); R0out<=1; Yin<=1; @(posedge Clock);
        @(negedge Clock); deassert_all(); R4out<=1; SHR<=1; Zin<=1; @(posedge Clock);
        @(negedge Clock); deassert_all(); Zlowout<=1; R7in<=1; @(posedge Clock);
        @(negedge Clock); deassert_all();
        if (R7 !== (32'h80000001 >> 4)) $fatal(1, "SHR failed: R7=%h", R7);

        // 3.8 SHRA: shra R7,R0,R4
        fetch(instr_r(5'b00101, 4'd7, 4'd0, 4'd4));
        @(negedge Clock); deassert_all(); R0out<=1; Yin<=1; @(posedge Clock);
        @(negedge Clock); deassert_all(); R4out<=1; SHRA<=1; Zin<=1; @(posedge Clock);
        @(negedge Clock); deassert_all(); Zlowout<=1; R7in<=1; @(posedge Clock);
        @(negedge Clock); deassert_all();
        if (R7 !== 32'hF8000000) $fatal(1, "SHRA failed: R7=%h", R7);

        // 3.9 SHL: shl R7,R0,R4
        fetch(instr_r(5'b00110, 4'd7, 4'd0, 4'd4));
        @(negedge Clock); deassert_all(); R0out<=1; Yin<=1; @(posedge Clock);
        @(negedge Clock); deassert_all(); R4out<=1; SHL<=1; Zin<=1; @(posedge Clock);
        @(negedge Clock); deassert_all(); Zlowout<=1; R7in<=1; @(posedge Clock);
        @(negedge Clock); deassert_all();
        if (R7 !== (32'h80000001 << 4)) $fatal(1, "SHL failed: R7=%h", R7);

        // 3.10 ROR: ror R7,R0,R4
        fetch(instr_r(5'b00111, 4'd7, 4'd0, 4'd4));
        @(negedge Clock); deassert_all(); R0out<=1; Yin<=1; @(posedge Clock);
        @(negedge Clock); deassert_all(); R4out<=1; ROR<=1; Zin<=1; @(posedge Clock);
        @(negedge Clock); deassert_all(); Zlowout<=1; R7in<=1; @(posedge Clock);
        @(negedge Clock); deassert_all();
        if (R7 !== ((32'h80000001 >> 4) | (32'h80000001 << (32-4)))) $fatal(1, "ROR failed: R7=%h", R7);

        // 3.11 ROL: rol R7,R0,R4
        fetch(instr_r(5'b01000, 4'd7, 4'd0, 4'd4));
        @(negedge Clock); deassert_all(); R0out<=1; Yin<=1; @(posedge Clock);
        @(negedge Clock); deassert_all(); R4out<=1; ROL<=1; Zin<=1; @(posedge Clock);
        @(negedge Clock); deassert_all(); Zlowout<=1; R7in<=1; @(posedge Clock);
        @(negedge Clock); deassert_all();
        if (R7 !== ((32'h80000001 << 4) | (32'h80000001 >> (32-4)))) $fatal(1, "ROL failed: R7=%h", R7);

        mdr_load(32'h0000000F); write_reg_from_mdr(7); // R7 = 15

        // 3.12 NEG: neg R4,R7
        fetch(instr_i(5'b01110, 4'd4, 4'd7));
        @(negedge Clock); deassert_all(); R7out<=1; NEG<=1; Zin<=1; @(posedge Clock);
        @(negedge Clock); deassert_all(); Zlowout<=1; R4in<=1; @(posedge Clock);
        @(negedge Clock); deassert_all();
        if (R4 !== (32'd0 - R7)) $fatal(1, "NEG failed: R4=%h", R4);

        // 3.13 NOT: not R4,R7
        fetch(instr_i(5'b01111, 4'd4, 4'd7));
        @(negedge Clock); deassert_all(); R7out<=1; NOT_op<=1; Zin<=1; @(posedge Clock);
        @(negedge Clock); deassert_all(); Zlowout<=1; R4in<=1; @(posedge Clock);
        @(negedge Clock); deassert_all();
        if (R4 !== ~R7) $fatal(1, "NOT failed: R4=%h", R4);
		  
		  

        // Negative MUL cases
        // MUL: (-5) * 3
        mdr_load(32'hFFFFFFFB); write_reg_from_mdr(3); // R3 = -5
        mdr_load(32'h00000003); write_reg_from_mdr(1); // R1 = 3
        fetch(instr_i(5'b01101, 4'd3, 4'd1));
        @(negedge Clock); deassert_all(); R3out<=1; Yin<=1; @(posedge Clock);
        @(negedge Clock); deassert_all(); R1out<=1; MUL<=1; Zin<=1; @(posedge Clock);
        @(negedge Clock); deassert_all(); Zlowout<=1; LOin<=1; @(posedge Clock);
        @(negedge Clock); deassert_all(); Zhighout<=1; HIin<=1; @(posedge Clock);
        @(negedge Clock); deassert_all();
        if ($signed({HI,LO}) !== ($signed(-32'sd5) * $signed(32'sd3))) $fatal(1, "MUL neg failed: HI=%h LO=%h", HI, LO);

        // MUL: 5 * (-3)
        mdr_load(32'h00000005); write_reg_from_mdr(3); // R3 = 5
        mdr_load(32'hFFFFFFFD); write_reg_from_mdr(1); // R1 = -3
        fetch(instr_i(5'b01101, 4'd3, 4'd1));
        @(negedge Clock); deassert_all(); R3out<=1; Yin<=1; @(posedge Clock);
        @(negedge Clock); deassert_all(); R1out<=1; MUL<=1; Zin<=1; @(posedge Clock);
        @(negedge Clock); deassert_all(); Zlowout<=1; LOin<=1; @(posedge Clock);
        @(negedge Clock); deassert_all(); Zhighout<=1; HIin<=1; @(posedge Clock);
        @(negedge Clock); deassert_all();
        if ($signed({HI,LO}) !== ($signed(32'sd5) * $signed(-32'sd3))) $fatal(1, "MUL neg failed: HI=%h LO=%h", HI, LO);

        // MUL: (-5) * (-3)
        mdr_load(32'hFFFFFFFB); write_reg_from_mdr(3); // R3 = -5
        mdr_load(32'hFFFFFFFD); write_reg_from_mdr(1); // R1 = -3
        fetch(instr_i(5'b01101, 4'd3, 4'd1));
        @(negedge Clock); deassert_all(); R3out<=1; Yin<=1; @(posedge Clock);
        @(negedge Clock); deassert_all(); R1out<=1; MUL<=1; Zin<=1; @(posedge Clock);
        @(negedge Clock); deassert_all(); Zlowout<=1; LOin<=1; @(posedge Clock);
        @(negedge Clock); deassert_all(); Zhighout<=1; HIin<=1; @(posedge Clock);
        @(negedge Clock); deassert_all();
        if ($signed({HI,LO}) !== ($signed(-32'sd5) * $signed(-32'sd3))) $fatal(1, "MUL neg failed: HI=%h LO=%h", HI, LO);

        // DIV by zero cases (our divider sets LO=0, HI=a)
        // DIV: 20 / 0
        mdr_load(32'h00000014); write_reg_from_mdr(3); // R3 = 20
        mdr_load(32'h00000000); write_reg_from_mdr(1); // R1 = 0
        fetch(instr_i(5'b01100, 4'd3, 4'd1));
        @(negedge Clock); deassert_all(); R3out<=1; Yin<=1; @(posedge Clock);
        @(negedge Clock); deassert_all(); R1out<=1; DIV<=1; Zin<=1; @(posedge Clock);
        @(negedge Clock); deassert_all(); Zlowout<=1; LOin<=1; @(posedge Clock);
        @(negedge Clock); deassert_all(); Zhighout<=1; HIin<=1; @(posedge Clock);
        @(negedge Clock); deassert_all();
        if (LO !== 32'd0 || $signed(HI) !== $signed(32'sd20)) $fatal(1, "DIV0 failed: HI=%h LO=%h", HI, LO);

        // DIV: (-20) / 0
        mdr_load(32'hFFFFFFEC); write_reg_from_mdr(3); // R3 = -20
        mdr_load(32'h00000000); write_reg_from_mdr(1); // R1 = 0
        fetch(instr_i(5'b01100, 4'd3, 4'd1));
        @(negedge Clock); deassert_all(); R3out<=1; Yin<=1; @(posedge Clock);
        @(negedge Clock); deassert_all(); R1out<=1; DIV<=1; Zin<=1; @(posedge Clock);
        @(negedge Clock); deassert_all(); Zlowout<=1; LOin<=1; @(posedge Clock);
        @(negedge Clock); deassert_all(); Zhighout<=1; HIin<=1; @(posedge Clock);
        @(negedge Clock); deassert_all();
        if (LO !== 32'd0 || $signed(HI) !== $signed(-32'sd20)) $fatal(1, "DIV0 failed: HI=%h LO=%h", HI, LO);

        // Division sign cases
        // DIV: 20 / (-3) => quotient=-6 remainder=2
        mdr_load(32'h00000014); write_reg_from_mdr(3); // R3 = 20
        mdr_load(32'hFFFFFFFD); write_reg_from_mdr(1); // R1 = -3
        fetch(instr_i(5'b01100, 4'd3, 4'd1));
        @(negedge Clock); deassert_all(); R3out<=1; Yin<=1; @(posedge Clock);
        @(negedge Clock); deassert_all(); R1out<=1; DIV<=1; Zin<=1; @(posedge Clock);
        @(negedge Clock); deassert_all(); Zlowout<=1; LOin<=1; @(posedge Clock);
        @(negedge Clock); deassert_all(); Zhighout<=1; HIin<=1; @(posedge Clock);
        @(negedge Clock); deassert_all();
        if ($signed(LO) !== $signed(-32'sd6) || $signed(HI) !== $signed(32'sd2)) $fatal(1, "DIV sign failed: HI=%h LO=%h", HI, LO);

        $display("all tests passed");
        #50 $finish;
    end
endmodule
