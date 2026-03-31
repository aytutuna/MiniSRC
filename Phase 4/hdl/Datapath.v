`timescale 1ns/1ps

module Datapath(
    output [31:0] IR_value,
    output [31:0] MDR_value,
    output CON_FF,
    output [31:0] OutPort_value,

    input PCout,
    input MDRout,
    input Zlowout,
    input Zhighout,
    input HIout,
    input LOout,
    input InPortout,
    input Cout,

    input Gra,
    input Grb,
    input Grc,
    input Rin,
    input Rout,
    input BAout,

    input PCin,
    input PCinIfCON,
    input IRin,
    input MARin,
    input MDRin,
    input Yin,
    input Zin,
    input HIin,
    input LOin,
    input CONin,
    input OutPortin,

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
    input Write,
    input [31:0] InPortData,
    input InPortStrobe,

    input Clock,
    input Clear
);
    reg [31:0] BusMuxOut;

    wire [63:0] Z;
    wire [63:0] alu_z;
    wire [31:0] PC;
    wire [31:0] IR;
    wire [31:0] MAR;
    wire [31:0] MDR;
    wire [31:0] Y;
    wire [31:0] HI;
    wire [31:0] LO;
    wire [31:0] OutPort;
    wire [31:0] InPort;
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

    wire [15:0] reg_in_sel;
    wire [15:0] reg_out_sel;
    wire [31:0] ram_data_out;
    wire [31:0] C_sign_extended;
    wire CON;
    wire pc_load_enable;

    assign C_sign_extended = {{13{IR[18]}}, IR[18:0]};
    assign pc_load_enable = PCin | (PCinIfCON & CON);

    select_encode u_select_encode(
        .ir(IR),
        .Gra(Gra),
        .Grb(Grb),
        .Grc(Grc),
        .Rin(Rin),
        .Rout(Rout),
        .BAout(BAout),
        .reg_in(reg_in_sel),
        .reg_out(reg_out_sel)
    );

    reg32 u_pc(.clk(Clock), .clr(Clear), .en(pc_load_enable), .d(BusMuxOut), .q(PC));
    reg32 u_ir(.clk(Clock), .clr(Clear), .en(IRin), .d(BusMuxOut), .q(IR));
    reg32 u_mar(.clk(Clock), .clr(Clear), .en(MARin), .d(BusMuxOut), .q(MAR));
    mdr u_mdr(.clk(Clock), .clr(Clear), .en(MDRin), .Read(Read), .bus_in(BusMuxOut), .Mdatain(ram_data_out), .q(MDR));
    reg32 u_y(.clk(Clock), .clr(Clear), .en(Yin), .d(BusMuxOut), .q(Y));
    reg64 u_z(.clk(Clock), .clr(Clear), .en(Zin), .d(alu_z), .q(Z));
    reg32 u_hi(.clk(Clock), .clr(Clear), .en(HIin), .d(BusMuxOut), .q(HI));
    reg32 u_lo(.clk(Clock), .clr(Clear), .en(LOin), .d(BusMuxOut), .q(LO));
    reg32 u_out_port(.clk(Clock), .clr(Clear), .en(OutPortin), .d(BusMuxOut), .q(OutPort));
    reg32 u_in_port(.clk(Clock), .clr(Clear), .en(InPortStrobe), .d(InPortData), .q(InPort));

    reg32 u_r0(.clk(Clock), .clr(Clear), .en(reg_in_sel[0]), .d(BusMuxOut), .q(R0));
    reg32 u_r1(.clk(Clock), .clr(Clear), .en(reg_in_sel[1]), .d(BusMuxOut), .q(R1));
    reg32 u_r2(.clk(Clock), .clr(Clear), .en(reg_in_sel[2]), .d(BusMuxOut), .q(R2));
    reg32 u_r3(.clk(Clock), .clr(Clear), .en(reg_in_sel[3]), .d(BusMuxOut), .q(R3));
    reg32 u_r4(.clk(Clock), .clr(Clear), .en(reg_in_sel[4]), .d(BusMuxOut), .q(R4));
    reg32 u_r5(.clk(Clock), .clr(Clear), .en(reg_in_sel[5]), .d(BusMuxOut), .q(R5));
    reg32 u_r6(.clk(Clock), .clr(Clear), .en(reg_in_sel[6]), .d(BusMuxOut), .q(R6));
    reg32 u_r7(.clk(Clock), .clr(Clear), .en(reg_in_sel[7]), .d(BusMuxOut), .q(R7));
    reg32 u_r8(.clk(Clock), .clr(Clear), .en(reg_in_sel[8]), .d(BusMuxOut), .q(R8));
    reg32 u_r9(.clk(Clock), .clr(Clear), .en(reg_in_sel[9]), .d(BusMuxOut), .q(R9));
    reg32 u_r10(.clk(Clock), .clr(Clear), .en(reg_in_sel[10]), .d(BusMuxOut), .q(R10));
    reg32 u_r11(.clk(Clock), .clr(Clear), .en(reg_in_sel[11]), .d(BusMuxOut), .q(R11));
    reg32 u_r12(.clk(Clock), .clr(Clear), .en(reg_in_sel[12]), .d(BusMuxOut), .q(R12));
    reg32 u_r13(.clk(Clock), .clr(Clear), .en(reg_in_sel[13]), .d(BusMuxOut), .q(R13));
    reg32 u_r14(.clk(Clock), .clr(Clear), .en(reg_in_sel[14]), .d(BusMuxOut), .q(R14));
    reg32 u_r15(.clk(Clock), .clr(Clear), .en(reg_in_sel[15]), .d(BusMuxOut), .q(R15));

    condition_ff u_condition_ff(
        .clk(Clock),
        .clr(Clear),
        .en(CONin),
        .cond_code(IR[20:19]),
        .bus_value(BusMuxOut),
        .q(CON)
    );

    ram512x32 u_ram(
        .clk(Clock),
        .read_en(Read),
        .write_en(Write),
        .address(MAR[8:0]),
        .write_data(MDR),
        .read_data(ram_data_out)
    );

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

    always @* begin
        BusMuxOut = 32'b0;

        if (reg_out_sel[0]) BusMuxOut = BAout ? 32'b0 : R0;
        else if (reg_out_sel[1]) BusMuxOut = R1;
        else if (reg_out_sel[2]) BusMuxOut = R2;
        else if (reg_out_sel[3]) BusMuxOut = R3;
        else if (reg_out_sel[4]) BusMuxOut = R4;
        else if (reg_out_sel[5]) BusMuxOut = R5;
        else if (reg_out_sel[6]) BusMuxOut = R6;
        else if (reg_out_sel[7]) BusMuxOut = R7;
        else if (reg_out_sel[8]) BusMuxOut = R8;
        else if (reg_out_sel[9]) BusMuxOut = R9;
        else if (reg_out_sel[10]) BusMuxOut = R10;
        else if (reg_out_sel[11]) BusMuxOut = R11;
        else if (reg_out_sel[12]) BusMuxOut = R12;
        else if (reg_out_sel[13]) BusMuxOut = R13;
        else if (reg_out_sel[14]) BusMuxOut = R14;
        else if (reg_out_sel[15]) BusMuxOut = R15;
        else if (HIout) BusMuxOut = HI;
        else if (LOout) BusMuxOut = LO;
        else if (Zhighout) BusMuxOut = Z[63:32];
        else if (Zlowout) BusMuxOut = Z[31:0];
        else if (PCout) BusMuxOut = PC;
        else if (MDRout) BusMuxOut = MDR;
        else if (Cout) BusMuxOut = C_sign_extended;
        else if (InPortout) BusMuxOut = InPort;
    end

    assign IR_value = IR;
    assign MDR_value = MDR;
    assign CON_FF = CON;
    assign OutPort_value = OutPort;
endmodule
