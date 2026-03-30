`timescale 1ns/1ps

module mini_src_cpu(
    input Clock,
    input Reset,
    input Stop,
    input [31:0] InPortData,
    input InPortStrobe,
    output Run
);
    wire PCout;
    wire MDRout;
    wire Zlowout;
    wire Zhighout;
    wire HIout;
    wire LOout;
    wire InPortout;
    wire Cout;

    wire Gra;
    wire Grb;
    wire Grc;
    wire Rin;
    wire Rout;
    wire BAout;

    wire PCin;
    wire PCinIfCON;
    wire IRin;
    wire MARin;
    wire MDRin;
    wire Yin;
    wire Zin;
    wire HIin;
    wire LOin;
    wire CONin;
    wire OutPortin;

    wire IncPC;
    wire ADD;
    wire SUB;
    wire AND_op;
    wire OR_op;
    wire SHR;
    wire SHRA;
    wire SHL;
    wire ROR;
    wire ROL;
    wire NEG;
    wire NOT_op;
    wire MUL;
    wire DIV;

    wire Read;
    wire Write;
    wire Clear;
    wire [31:0] IR_value;
    wire [31:0] MDR_value;
    wire CON_FF;

    control_unit u_control_unit(
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
        .Clear(Clear),
        .Run(Run),
        .IR(IR_value),
        .MDR_value(MDR_value),
        .Clock(Clock),
        .Reset(Reset),
        .Stop(Stop),
        .CON_FF(CON_FF)
    );

    Datapath u_datapath(
        .IR_value(IR_value),
        .MDR_value(MDR_value),
        .CON_FF(CON_FF),
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
endmodule