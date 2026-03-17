`timescale 1ns/1ps

module phase2tb;
    reg Clock;
    reg Clear;

    reg PCout;
    reg MDRout;
    reg Zlowout;
    reg Zhighout;
    reg HIout;
    reg LOout;
    reg InPortout;
    reg Cout;

    reg Gra;
    reg Grb;
    reg Grc;
    reg Rin;
    reg Rout;
    reg BAout;

    reg PCin;
    reg PCinIfCON;
    reg IRin;
    reg MARin;
    reg MDRin;
    reg Yin;
    reg Zin;
    reg HIin;
    reg LOin;
    reg CONin;
    reg OutPortin;

    reg IncPC;
    reg ADD;
    reg SUB;
    reg AND_op;
    reg OR_op;
    reg SHR;
    reg SHRA;
    reg SHL;
    reg ROR;
    reg ROL;
    reg NEG;
    reg NOT_op;
    reg MUL;
    reg DIV;

    reg Read;
    reg Write;
    reg [31:0] InPortData;
    reg InPortStrobe;

    wire [31:0] BusMuxOut;
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
    wire [31:0] R12;
    wire [31:0] OutPort;
    wire CON;

    localparam [4:0] OP_LD   = 5'b10000;
    localparam [4:0] OP_LDI  = 5'b10001;
    localparam [4:0] OP_ST   = 5'b10010;
    localparam [4:0] OP_ADDI = 5'b10011;
    localparam [4:0] OP_ANDI = 5'b10100;
    localparam [4:0] OP_ORI  = 5'b10101;
    localparam [4:0] OP_BR   = 5'b10110;
    localparam [4:0] OP_JR   = 5'b10111;
    localparam [4:0] OP_JAL  = 5'b11000;
    localparam [4:0] OP_MFHI = 5'b11001;
    localparam [4:0] OP_MFLO = 5'b11010;
    localparam [4:0] OP_OUT  = 5'b11011;
    localparam [4:0] OP_IN   = 5'b11100;

    Datapath DUT(
        .PCout(PCout),
        .MDRout(MDRout),
        .Zlowout(Zlowout),
        .Zhighout(Zhighout),
        .HIout(HIout),
        .LOout(LOout),
        .InPortout(InPortout),
        .Cout(Cout),
        .Gra(Gra),
        .Grb(Grb),
        .Grc(Grc),
        .Rin(Rin),
        .Rout(Rout),
        .BAout(BAout),
        .PCin(PCin),
        .PCinIfCON(PCinIfCON),
        .IRin(IRin),
        .MARin(MARin),
        .MDRin(MDRin),
        .Yin(Yin),
        .Zin(Zin),
        .HIin(HIin),
        .LOin(LOin),
        .CONin(CONin),
        .OutPortin(OutPortin),
        .IncPC(IncPC),
        .ADD(ADD),
        .SUB(SUB),
        .AND_op(AND_op),
        .OR_op(OR_op),
        .SHR(SHR),
        .SHRA(SHRA),
        .SHL(SHL),
        .ROR(ROR),
        .ROL(ROL),
        .NEG(NEG),
        .NOT_op(NOT_op),
        .MUL(MUL),
        .DIV(DIV),
        .Read(Read),
        .Write(Write),
        .InPortData(InPortData),
        .InPortStrobe(InPortStrobe),
        .Clock(Clock),
        .Clear(Clear)
    );

    assign BusMuxOut = DUT.BusMuxOut;
    assign PC = DUT.PC;
    assign IR = DUT.IR;
    assign MAR = DUT.MAR;
    assign MDR = DUT.MDR;
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
    assign R12 = DUT.R12;
    assign OutPort = DUT.OutPort;
    assign CON = DUT.CON;

    function [18:0] imm19;
        input integer value;
        begin
            imm19 = value[18:0];
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

    function [31:0] instr_r;
        input [4:0] op;
        input [3:0] ra;
        input [3:0] rb;
        input [3:0] rc;
        begin
            instr_r = {op, ra, rb, rc, 15'b0};
        end
    endfunction

    function [31:0] instr_branch;
        input [4:0] op;
        input [3:0] ra;
        input [3:0] cond;
        input [18:0] imm;
        begin
            instr_branch = {op, ra, cond, imm};
        end
    endfunction

    task deassert_all;
        begin
            PCout = 0;
            MDRout = 0;
            Zlowout = 0;
            Zhighout = 0;
            HIout = 0;
            LOout = 0;
            InPortout = 0;
            Cout = 0;
            Gra = 0;
            Grb = 0;
            Grc = 0;
            Rin = 0;
            Rout = 0;
            BAout = 0;
            PCin = 0;
            PCinIfCON = 0;
            IRin = 0;
            MARin = 0;
            MDRin = 0;
            Yin = 0;
            Zin = 0;
            HIin = 0;
            LOin = 0;
            CONin = 0;
            OutPortin = 0;
            IncPC = 0;
            ADD = 0;
            SUB = 0;
            AND_op = 0;
            OR_op = 0;
            SHR = 0;
            SHRA = 0;
            SHL = 0;
            ROR = 0;
            ROL = 0;
            NEG = 0;
            NOT_op = 0;
            MUL = 0;
            DIV = 0;
            Read = 0;
            Write = 0;
            InPortStrobe = 0;
        end
    endtask

    task preload_reg;
        input integer regnum;
        input [31:0] value;
        begin
            case (regnum)
                0: DUT.u_r0.q = value;
                1: DUT.u_r1.q = value;
                2: DUT.u_r2.q = value;
                3: DUT.u_r3.q = value;
                4: DUT.u_r4.q = value;
                5: DUT.u_r5.q = value;
                6: DUT.u_r6.q = value;
                7: DUT.u_r7.q = value;
                8: DUT.u_r8.q = value;
                9: DUT.u_r9.q = value;
                10: DUT.u_r10.q = value;
                11: DUT.u_r11.q = value;
                12: DUT.u_r12.q = value;
                13: DUT.u_r13.q = value;
                14: DUT.u_r14.q = value;
                15: DUT.u_r15.q = value;
                default: ;
            endcase
        end
    endtask

    task preload_pc;
        input [31:0] value;
        begin
            DUT.u_pc.q = value;
        end
    endtask

    task preload_hi;
        input [31:0] value;
        begin
            DUT.u_hi.q = value;
        end
    endtask

    task preload_lo;
        input [31:0] value;
        begin
            DUT.u_lo.q = value;
        end
    endtask

    task preload_mem;
        input [8:0] address;
        input [31:0] value;
        begin
            DUT.u_ram.mem[address] = value;
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

    task pulse_input_port;
        input [31:0] value;
        begin
            @(negedge Clock);
            InPortData <= value;
            InPortStrobe <= 1'b1;
            @(posedge Clock);
            @(negedge Clock);
            InPortStrobe <= 1'b0;
        end
    endtask

    task fetch_instruction;
        input [31:0] pc_addr;
        input [31:0] instruction;
        begin
            preload_pc(pc_addr);
            preload_mem(pc_addr[8:0], instruction);

            @(negedge Clock);
            deassert_all();
            PCout <= 1'b1;
            MARin <= 1'b1;
            IncPC <= 1'b1;
            Zin <= 1'b1;
            @(posedge Clock);

            @(negedge Clock);
            deassert_all();
            Zlowout <= 1'b1;
            PCin <= 1'b1;
            Read <= 1'b1;
            MDRin <= 1'b1;
            @(posedge Clock);

            @(negedge Clock);
            deassert_all();
            MDRout <= 1'b1;
            IRin <= 1'b1;
            @(posedge Clock);

            @(negedge Clock);
            deassert_all();
        end
    endtask

    task exec_ld;
        input [31:0] pc_addr;
        input [3:0] ra;
        input [3:0] rb;
        input [18:0] imm;
        begin
            fetch_instruction(pc_addr, instr_i(OP_LD, ra, rb, imm));

            @(negedge Clock);
            deassert_all();
            Grb <= 1'b1;
            BAout <= 1'b1;
            Yin <= 1'b1;
            @(posedge Clock);

            @(negedge Clock);
            deassert_all();
            Cout <= 1'b1;
            ADD <= 1'b1;
            Zin <= 1'b1;
            @(posedge Clock);

            @(negedge Clock);
            deassert_all();
            Zlowout <= 1'b1;
            MARin <= 1'b1;
            @(posedge Clock);

            @(negedge Clock);
            deassert_all();
            Read <= 1'b1;
            MDRin <= 1'b1;
            @(posedge Clock);

            @(negedge Clock);
            deassert_all();
            MDRout <= 1'b1;
            Gra <= 1'b1;
            Rin <= 1'b1;
            @(posedge Clock);

            @(negedge Clock);
            deassert_all();
        end
    endtask

    task exec_ldi;
        input [31:0] pc_addr;
        input [3:0] ra;
        input [3:0] rb;
        input [18:0] imm;
        begin
            fetch_instruction(pc_addr, instr_i(OP_LDI, ra, rb, imm));

            @(negedge Clock);
            deassert_all();
            Grb <= 1'b1;
            BAout <= 1'b1;
            Yin <= 1'b1;
            @(posedge Clock);

            @(negedge Clock);
            deassert_all();
            Cout <= 1'b1;
            ADD <= 1'b1;
            Zin <= 1'b1;
            @(posedge Clock);

            @(negedge Clock);
            deassert_all();
            Zlowout <= 1'b1;
            Gra <= 1'b1;
            Rin <= 1'b1;
            @(posedge Clock);

            @(negedge Clock);
            deassert_all();
        end
    endtask

    task exec_st;
        input [31:0] pc_addr;
        input [3:0] ra;
        input [3:0] rb;
        input [18:0] imm;
        begin
            fetch_instruction(pc_addr, instr_i(OP_ST, ra, rb, imm));

            @(negedge Clock);
            deassert_all();
            Grb <= 1'b1;
            BAout <= 1'b1;
            Yin <= 1'b1;
            @(posedge Clock);

            @(negedge Clock);
            deassert_all();
            Cout <= 1'b1;
            ADD <= 1'b1;
            Zin <= 1'b1;
            @(posedge Clock);

            @(negedge Clock);
            deassert_all();
            Zlowout <= 1'b1;
            MARin <= 1'b1;
            @(posedge Clock);

            @(negedge Clock);
            deassert_all();
            Gra <= 1'b1;
            Rout <= 1'b1;
            MDRin <= 1'b1;
            @(posedge Clock);

            @(negedge Clock);
            deassert_all();
            Write <= 1'b1;
            @(posedge Clock);

            @(negedge Clock);
            deassert_all();
        end
    endtask

    task exec_immediate;
        input [31:0] pc_addr;
        input [4:0] op;
        input [3:0] ra;
        input [3:0] rb;
        input [18:0] imm;
        begin
            fetch_instruction(pc_addr, instr_i(op, ra, rb, imm));

            @(negedge Clock);
            deassert_all();
            Grb <= 1'b1;
            Rout <= 1'b1;
            Yin <= 1'b1;
            @(posedge Clock);

            @(negedge Clock);
            deassert_all();
            Cout <= 1'b1;
            Zin <= 1'b1;
            case (op)
                OP_ADDI: ADD <= 1'b1;
                OP_ANDI: AND_op <= 1'b1;
                OP_ORI: OR_op <= 1'b1;
                default: ADD <= 1'b1;
            endcase
            @(posedge Clock);

            @(negedge Clock);
            deassert_all();
            Zlowout <= 1'b1;
            Gra <= 1'b1;
            Rin <= 1'b1;
            @(posedge Clock);

            @(negedge Clock);
            deassert_all();
        end
    endtask

    task exec_branch;
        input [31:0] pc_addr;
        input [3:0] ra;
        input [3:0] cond;
        input [18:0] imm;
        begin
            fetch_instruction(pc_addr, instr_branch(OP_BR, ra, cond, imm));

            @(negedge Clock);
            deassert_all();
            Gra <= 1'b1;
            Rout <= 1'b1;
            CONin <= 1'b1;
            @(posedge Clock);

            @(negedge Clock);
            deassert_all();
            PCout <= 1'b1;
            Yin <= 1'b1;
            @(posedge Clock);

            @(negedge Clock);
            deassert_all();
            Cout <= 1'b1;
            ADD <= 1'b1;
            Zin <= 1'b1;
            @(posedge Clock);

            @(negedge Clock);
            deassert_all();
            Zlowout <= 1'b1;
            PCinIfCON <= 1'b1;
            @(posedge Clock);

            @(negedge Clock);
            deassert_all();
        end
    endtask

    task exec_jr;
        input [31:0] pc_addr;
        input [3:0] ra;
        begin
            fetch_instruction(pc_addr, instr_i(OP_JR, ra, 4'd0, 19'd0));

            @(negedge Clock);
            deassert_all();
            Gra <= 1'b1;
            Rout <= 1'b1;
            PCin <= 1'b1;
            @(posedge Clock);

            @(negedge Clock);
            deassert_all();
        end
    endtask

    task exec_jal;
        input [31:0] pc_addr;
        input [3:0] target_reg;
        input [3:0] return_reg;
        begin
            fetch_instruction(pc_addr, instr_r(OP_JAL, target_reg, 4'd0, return_reg));

            @(negedge Clock);
            deassert_all();
            PCout <= 1'b1;
            Grc <= 1'b1;
            Rin <= 1'b1;
            @(posedge Clock);

            @(negedge Clock);
            deassert_all();
            Gra <= 1'b1;
            Rout <= 1'b1;
            PCin <= 1'b1;
            @(posedge Clock);

            @(negedge Clock);
            deassert_all();
        end
    endtask

    task exec_mfhi;
        input [31:0] pc_addr;
        input [3:0] ra;
        begin
            fetch_instruction(pc_addr, instr_i(OP_MFHI, ra, 4'd0, 19'd0));

            @(negedge Clock);
            deassert_all();
            HIout <= 1'b1;
            Gra <= 1'b1;
            Rin <= 1'b1;
            @(posedge Clock);

            @(negedge Clock);
            deassert_all();
        end
    endtask

    task exec_mflo;
        input [31:0] pc_addr;
        input [3:0] ra;
        begin
            fetch_instruction(pc_addr, instr_i(OP_MFLO, ra, 4'd0, 19'd0));

            @(negedge Clock);
            deassert_all();
            LOout <= 1'b1;
            Gra <= 1'b1;
            Rin <= 1'b1;
            @(posedge Clock);

            @(negedge Clock);
            deassert_all();
        end
    endtask

    task exec_out;
        input [31:0] pc_addr;
        input [3:0] ra;
        begin
            fetch_instruction(pc_addr, instr_i(OP_OUT, ra, 4'd0, 19'd0));

            @(negedge Clock);
            deassert_all();
            Gra <= 1'b1;
            Rout <= 1'b1;
            OutPortin <= 1'b1;
            @(posedge Clock);

            @(negedge Clock);
            deassert_all();
        end
    endtask

    task exec_in;
        input [31:0] pc_addr;
        input [3:0] ra;
        begin
            fetch_instruction(pc_addr, instr_i(OP_IN, ra, 4'd0, 19'd0));

            @(negedge Clock);
            deassert_all();
            InPortout <= 1'b1;
            Gra <= 1'b1;
            Rin <= 1'b1;
            @(posedge Clock);

            @(negedge Clock);
            deassert_all();
        end
    endtask

    initial begin
        Clock = 1'b0;
        forever #10 Clock = ~Clock;
    end

    initial begin
        InPortData = 32'b0;
        deassert_all();
        Clear = 1'b1;
        @(posedge Clock);
        @(negedge Clock);
        Clear = 1'b0;

        preload_reg(0, 32'h99999999);
        preload_mem(9'h065, 32'h00000084);
        exec_ld(32'h00000000, 4'd7, 4'd0, imm19(16'h65));
        expect32(R7, 32'h00000084, "ld R7,0x65");
        expect32(MAR, 32'h00000065, "ld R7 MAR address");

        preload_reg(2, 32'h00000057);
        preload_mem(9'h0C9, 32'h0000002B);
        exec_ld(32'h00000004, 4'd0, 4'd2, imm19(16'h72));
        expect32(R0, 32'h0000002B, "ld R0,0x72(R2)");
        expect32(MAR, 32'h000000C9, "ld indexed MAR address");

        preload_reg(0, 32'hAAAAAAAA);
        exec_ldi(32'h00000008, 4'd7, 4'd0, imm19(16'h65));
        expect32(R7, 32'h00000065, "ldi R7,0x65");

        preload_reg(2, 32'h00000057);
        exec_ldi(32'h0000000C, 4'd0, 4'd2, imm19(16'h72));
        expect32(R0, 32'h000000C9, "ldi R0,0x72(R2)");

        preload_reg(0, 32'hDEADBEEF);
        preload_reg(6, 32'h00000063);
        preload_mem(9'h01F, 32'h000000D4);
        exec_st(32'h00000010, 4'd6, 4'd0, imm19(16'h1F));
        expect32(DUT.u_ram.mem[9'h01F], 32'h00000063, "st 0x1F,R6");

        preload_reg(6, 32'h00000063);
        preload_mem(9'h082, 32'h000000A7);
        exec_st(32'h00000014, 4'd6, 4'd6, imm19(16'h1F));
        expect32(DUT.u_ram.mem[9'h082], 32'h00000063, "st 0x1F(R6),R6");

        preload_reg(4, 32'h00000020);
        exec_immediate(32'h00000018, OP_ADDI, 4'd7, 4'd4, imm19(-9));
        expect32(R7, 32'h00000017, "addi R7,R4,-9");

        preload_reg(4, 32'h00000073);
        exec_immediate(32'h0000001C, OP_ANDI, 4'd7, 4'd4, imm19(16'h71));
        expect32(R7, 32'h00000071, "andi R7,R4,0x71");

        preload_reg(4, 32'h00000002);
        exec_immediate(32'h00000020, OP_ORI, 4'd7, 4'd4, imm19(16'h71));
        expect32(R7, 32'h00000073, "ori R7,R4,0x71");

        preload_reg(3, 32'h00000000);
        exec_branch(32'h00000030, 4'd3, 4'b0000, imm19(48));
        expect1(CON, 1'b1, "brzr taken CON");
        expect32(PC, 32'h00000061, "brzr taken PC");

        preload_reg(3, 32'h00000005);
        exec_branch(32'h00000034, 4'd3, 4'b0000, imm19(48));
        expect1(CON, 1'b0, "brzr not taken CON");
        expect32(PC, 32'h00000035, "brzr not taken PC");

        preload_reg(3, 32'h00000005);
        exec_branch(32'h00000038, 4'd3, 4'b0001, imm19(48));
        expect1(CON, 1'b1, "brnz taken CON");
        expect32(PC, 32'h00000069, "brnz taken PC");

        preload_reg(3, 32'h00000001);
        exec_branch(32'h0000003C, 4'd3, 4'b0010, imm19(48));
        expect1(CON, 1'b1, "brpl taken CON");
        expect32(PC, 32'h0000006D, "brpl taken PC");

        preload_reg(3, 32'hFFFFFFFF);
        exec_branch(32'h00000040, 4'd3, 4'b0011, imm19(48));
        expect1(CON, 1'b1, "brmi taken CON");
        expect32(PC, 32'h00000071, "brmi taken PC");

        preload_reg(12, 32'h000000FF);
        exec_jr(32'h00000050, 4'd12);
        expect32(PC, 32'h000000FF, "jr R12");

        preload_reg(4, 32'h00000080);
        preload_reg(12, 32'h00000000);
        exec_jal(32'h00000060, 4'd4, 4'd12);
        expect32(R12, 32'h00000061, "jal return address");
        expect32(PC, 32'h00000080, "jal target PC");

        preload_hi(32'hABCDEF01);
        exec_mfhi(32'h00000070, 4'd5);
        expect32(R5, 32'hABCDEF01, "mfhi R5");

        preload_lo(32'h12345678);
        exec_mflo(32'h00000074, 4'd1);
        expect32(R1, 32'h12345678, "mflo R1");

        preload_reg(7, 32'hCAFEBABE);
        exec_out(32'h00000078, 4'd7);
        expect32(OutPort, 32'hCAFEBABE, "out R7");

        pulse_input_port(32'h0BADF00D);
        exec_in(32'h0000007C, 4'd5);
        expect32(R5, 32'h0BADF00D, "in R5");

        $display("Phase 2 testbench passed.");
        $finish;
    end
endmodule
