`timescale 1ns/1ps

module Datapath(
    input PCout,
    input MDRout,
    input Zlowout,
    input Zhighout,
    input HIout,
    input LOout,
    input R0out,
    input R1out,
    input R2out,
    input R3out,
    input R4out,
    input R5out,
    input R6out,
    input R7out,
    input R8out,
    input R9out,
    input R10out,
    input R11out,
    input R12out,
    input R13out,
    input R14out,
    input R15out,

    input PCin,
    input IRin,
    input MARin,
    input MDRin,
    input Yin,
    input Zin,
    input HIin,
    input LOin,
    input R0in,
    input R1in,
    input R2in,
    input R3in,
    input R4in,
    input R5in,
    input R6in,
    input R7in,
    input R8in,
    input R9in,
    input R10in,
    input R11in,
    input R12in,
    input R13in,
    input R14in,
    input R15in,

    input IncPC,
    input ADD,
    input SUB,
    input AND_op,
    input OR_op,
    input SHR,
    input SHRA,
    input SHL,
    input ROR,
    input ROL,
    input NEG,
    input NOT_op,
    input MUL,
    input DIV,

    input Read,
    input [31:0] Mdatain,

    input Clock,
    input Clear
);

    // Internal signals
    reg [31:0] BusMuxOut;
    wire [63:0] Z;
    wire [31:0] PC, IR, MAR, MDR, Y, HI, LO;
    wire [31:0] R0, R1, R2, R3, R4, R5, R6, R7;
    wire [31:0] R8, R9, R10, R11, R12, R13, R14, R15;

    wire [63:0] alu_z;

    //all load from the bus, except Z which loads from the ALU
    reg32 u_pc  (.clk(Clock), .clr(Clear), .en(PCin),  .d(BusMuxOut), .q(PC));
    reg32 u_ir  (.clk(Clock), .clr(Clear), .en(IRin),  .d(BusMuxOut), .q(IR));
    reg32 u_mar (.clk(Clock), .clr(Clear), .en(MARin), .d(BusMuxOut), .q(MAR));

    mdr  u_mdr  (.clk(Clock), .clr(Clear), .en(MDRin), .Read(Read), .bus_in(BusMuxOut), .Mdatain(Mdatain), .q(MDR));

    reg32 u_y   (.clk(Clock), .clr(Clear), .en(Yin),   .d(BusMuxOut), .q(Y));
    reg64 u_z   (.clk(Clock), .clr(Clear), .en(Zin),   .d(alu_z),     .q(Z));

    reg32 u_hi  (.clk(Clock), .clr(Clear), .en(HIin),  .d(BusMuxOut), .q(HI));
    reg32 u_lo  (.clk(Clock), .clr(Clear), .en(LOin),  .d(BusMuxOut), .q(LO));

    reg32 u_r0  (.clk(Clock), .clr(Clear), .en(R0in),  .d(BusMuxOut), .q(R0));
    reg32 u_r1  (.clk(Clock), .clr(Clear), .en(R1in),  .d(BusMuxOut), .q(R1));
    reg32 u_r2  (.clk(Clock), .clr(Clear), .en(R2in),  .d(BusMuxOut), .q(R2));
    reg32 u_r3  (.clk(Clock), .clr(Clear), .en(R3in),  .d(BusMuxOut), .q(R3));
    reg32 u_r4  (.clk(Clock), .clr(Clear), .en(R4in),  .d(BusMuxOut), .q(R4));
    reg32 u_r5  (.clk(Clock), .clr(Clear), .en(R5in),  .d(BusMuxOut), .q(R5));
    reg32 u_r6  (.clk(Clock), .clr(Clear), .en(R6in),  .d(BusMuxOut), .q(R6));
    reg32 u_r7  (.clk(Clock), .clr(Clear), .en(R7in),  .d(BusMuxOut), .q(R7));
    reg32 u_r8  (.clk(Clock), .clr(Clear), .en(R8in),  .d(BusMuxOut), .q(R8));
    reg32 u_r9  (.clk(Clock), .clr(Clear), .en(R9in),  .d(BusMuxOut), .q(R9));
    reg32 u_r10 (.clk(Clock), .clr(Clear), .en(R10in), .d(BusMuxOut), .q(R10));
    reg32 u_r11 (.clk(Clock), .clr(Clear), .en(R11in), .d(BusMuxOut), .q(R11));
    reg32 u_r12 (.clk(Clock), .clr(Clear), .en(R12in), .d(BusMuxOut), .q(R12));
    reg32 u_r13 (.clk(Clock), .clr(Clear), .en(R13in), .d(BusMuxOut), .q(R13));
    reg32 u_r14 (.clk(Clock), .clr(Clear), .en(R14in), .d(BusMuxOut), .q(R14));
    reg32 u_r15 (.clk(Clock), .clr(Clear), .en(R15in), .d(BusMuxOut), .q(R15));

    // Bus mux. Only one should be 1 at a time.
    always @* begin
        BusMuxOut = 32'b0;

        if (R0out)       BusMuxOut = R0;
        else if (R1out)  BusMuxOut = R1;
        else if (R2out)  BusMuxOut = R2;
        else if (R3out)  BusMuxOut = R3;
        else if (R4out)  BusMuxOut = R4;
        else if (R5out)  BusMuxOut = R5;
        else if (R6out)  BusMuxOut = R6;
        else if (R7out)  BusMuxOut = R7;
        else if (R8out)  BusMuxOut = R8;
        else if (R9out)  BusMuxOut = R9;
        else if (R10out) BusMuxOut = R10;
        else if (R11out) BusMuxOut = R11;
        else if (R12out) BusMuxOut = R12;
        else if (R13out) BusMuxOut = R13;
        else if (R14out) BusMuxOut = R14;
        else if (R15out) BusMuxOut = R15;
        else if (HIout)  BusMuxOut = HI;
        else if (LOout)  BusMuxOut = LO;
        else if (Zhighout) BusMuxOut = Z[63:32];
        else if (Zlowout)  BusMuxOut = Z[31:0];
        else if (PCout)    BusMuxOut = PC;
        else if (MDRout)   BusMuxOut = MDR;
    end

    // ALU
    alu u_alu(
        .y(Y),
        .bus(BusMuxOut),
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
        .z_out(alu_z)
    );

endmodule
