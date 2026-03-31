`timescale 1ns/1ps

module phase4tb;
    reg Clock;
    reg Reset;
    reg Stop;
    reg [31:0] InPortData;
    reg InPortStrobe;
    reg capture_out;
    integer cycles;
    integer output_count;
    integer index;
    integer repeat_index;

    wire Run;
    wire [31:0] OutPortValue;

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

    reg [7:0] expected_outputs [0:40];
    reg [7:0] observed_outputs [0:40];

    localparam [31:0] SWITCH_INPUT = 32'h000000E0;
    localparam [31:0] SIM_DELAY_VALUE = 32'h0000000F;
    localparam [4:0] OP_HALT = 5'b11011;

    mini_src_cpu DUT(
        .Clock(Clock),
        .Reset(Reset),
        .Stop(Stop),
        .InPortData(InPortData),
        .InPortStrobe(InPortStrobe),
        .OutPortValue(OutPortValue),
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

    function [31:0] instr_misc;
        input [4:0] op;
        begin
            instr_misc = {op, 27'b0};
        end
    endfunction

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

    task expect8;
        input [7:0] actual;
        input [7:0] expected;
        input [255:0] label;
        begin
            if (actual !== expected) begin
                $fatal(1, "%0s failed: got %h expected %h", label, actual, expected);
            end
        end
    endtask

    task dump_final_state;
        begin
            $display("Final state summary:");
            $display("PC=%h IR=%h MAR=%h MDR=%h Run=%b OutPort=%h", PC, IR, MAR, MDR, Run, OutPortValue);
            $display("R0=%h R1=%h R2=%h R3=%h", R0, R1, R2, R3);
            $display("R4=%h R5=%h R6=%h R7=%h", R4, R5, R6, R7);
            $display("R8=%h R9=%h R10=%h R11=%h", R8, R9, R10, R11);
            $display("R12=%h R13=%h R14=%h R15=%h", R12, R13, R14, R15);
            $display("HI=%h LO=%h", HI, LO);
            $display("MEM[0x77]=%h MEM[0x88]=%h MEM[0x89]=%h MEM[0xA3]=%h",
                DUT.u_datapath.u_ram.mem[9'h077],
                DUT.u_datapath.u_ram.mem[9'h088],
                DUT.u_datapath.u_ram.mem[9'h089],
                DUT.u_datapath.u_ram.mem[9'h0A3]);
        end
    endtask

    always @(posedge Clock) begin
        capture_out = DUT.u_control_unit.OutPortin;
        #1;
        if (capture_out) begin
            if (output_count > 40) begin
                $fatal(1, "Observed more output writes than expected");
            end
            observed_outputs[output_count] = OutPortValue[7:0];
            output_count = output_count + 1;
        end
    end

    initial begin
        Clock = 1'b0;
        forever #10 Clock = ~Clock;
    end

    initial begin
        for (repeat_index = 0; repeat_index < 5; repeat_index = repeat_index + 1) begin
            expected_outputs[(repeat_index * 8) + 0] = 8'hE0;
            expected_outputs[(repeat_index * 8) + 1] = 8'h70;
            expected_outputs[(repeat_index * 8) + 2] = 8'h38;
            expected_outputs[(repeat_index * 8) + 3] = 8'h1C;
            expected_outputs[(repeat_index * 8) + 4] = 8'h0E;
            expected_outputs[(repeat_index * 8) + 5] = 8'h07;
            expected_outputs[(repeat_index * 8) + 6] = 8'h03;
            expected_outputs[(repeat_index * 8) + 7] = 8'h01;
        end
        expected_outputs[40] = 8'h63;
    end

    initial begin
        Stop = 1'b0;
        Reset = 1'b1;
        InPortData = SWITCH_INPUT;
        InPortStrobe = 1'b1;
        capture_out = 1'b0;
        cycles = 0;
        output_count = 0;

        repeat (2) @(posedge Clock);
        DUT.u_datapath.u_ram.mem[9'h088] = SIM_DELAY_VALUE;
        Reset = 1'b0;

        while (Run && cycles < 30000) begin
            @(posedge Clock);
            cycles = cycles + 1;
        end

        if (Run) begin
            $fatal(1, "Simulation timed out before halt after %0d cycles", cycles);
        end

        @(negedge Clock);

        expect32(output_count, 32'd41, "output count");
        for (index = 0; index < 41; index = index + 1) begin
            expect8(observed_outputs[index], expected_outputs[index], "output sequence");
        end

        expect32(PC, 32'h0000003C, "PC after halt fetch");
        expect32(IR, instr_misc(OP_HALT), "IR holds halt");
        expect32(MAR, 32'h0000003B, "MAR final value");
        expect32(MDR, instr_misc(OP_HALT), "MDR final value");
        expect32(OutPortValue, 32'h00000063, "OutPort final");
        expect32(R0, 32'h00000614, "R0 final");
        expect32(R1, 32'h00000000, "R1 final");
        expect32(R2, 32'h00000000, "R2 final");
        expect32(R3, 32'h0000002E, "R3 final");
        expect32(R4, 32'h00006800, "R4 final");
        expect32(R5, 32'h00000001, "R5 final");
        expect32(R6, 32'h00000063, "R6 final");
        expect32(R7, 32'h00000000, "R7 final");
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
        expect32(DUT.u_datapath.u_ram.mem[9'h077], SWITCH_INPUT, "memory 0x77 final");
        expect32(DUT.u_datapath.u_ram.mem[9'h088], SIM_DELAY_VALUE, "memory 0x88 simulation override");
        expect32(DUT.u_datapath.u_ram.mem[9'h089], 32'h0000006C, "memory 0x89 final");
        expect32(DUT.u_datapath.u_ram.mem[9'h0A3], 32'h00000008, "memory 0xA3 final");

        dump_final_state();
        $display("Phase 4 full-program test passed in %0d cycles.", cycles);
        $finish;
    end
endmodule