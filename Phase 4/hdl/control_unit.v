`timescale 1ns/1ps

module control_unit(
    output reg PCout,
    output reg MDRout,
    output reg Zlowout,
    output reg Zhighout,
    output reg HIout,
    output reg LOout,
    output reg InPortout,
    output reg Cout,

    output reg Gra,
    output reg Grb,
    output reg Grc,
    output reg Rin,
    output reg Rout,
    output reg BAout,

    output reg PCin,
    output reg PCinIfCON,
    output reg IRin,
    output reg MARin,
    output reg MDRin,
    output reg Yin,
    output reg Zin,
    output reg HIin,
    output reg LOin,
    output reg CONin,
    output reg OutPortin,

    output reg IncPC,
    output reg ADD,
    output reg SUB,
    output reg AND_op,
    output reg OR_op,
    output reg SHR,
    output reg SHRA,
    output reg SHL,
    output reg ROR,
    output reg ROL,
    output reg NEG,
    output reg NOT_op,
    output reg MUL,
    output reg DIV,

    output reg Read,
    output reg Write,
    output reg Clear,
    output Run,

    input [31:0] IR,
    input [31:0] MDR_value,
    input Clock,
    input Reset,
    input Stop,
    input CON_FF
);
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

    localparam [5:0] S_FETCH0     = 6'd0;
    localparam [5:0] S_FETCH1     = 6'd1;
    localparam [5:0] S_FETCH2     = 6'd2;
    localparam [5:0] S_RR_T3      = 6'd3;
    localparam [5:0] S_RR_T4      = 6'd4;
    localparam [5:0] S_RR_T5      = 6'd5;
    localparam [5:0] S_IMM_T3     = 6'd6;
    localparam [5:0] S_IMM_T4     = 6'd7;
    localparam [5:0] S_IMM_T5     = 6'd8;
    localparam [5:0] S_MULDIV_T3  = 6'd9;
    localparam [5:0] S_MULDIV_T4  = 6'd10;
    localparam [5:0] S_MULDIV_T5  = 6'd11;
    localparam [5:0] S_MULDIV_T6  = 6'd12;
    localparam [5:0] S_UNARY_T3   = 6'd13;
    localparam [5:0] S_UNARY_T4   = 6'd14;
    localparam [5:0] S_LD_T3      = 6'd15;
    localparam [5:0] S_LD_T4      = 6'd16;
    localparam [5:0] S_LD_T5      = 6'd17;
    localparam [5:0] S_LD_T6      = 6'd18;
    localparam [5:0] S_LD_T7      = 6'd19;
    localparam [5:0] S_LDI_T3     = 6'd20;
    localparam [5:0] S_LDI_T4     = 6'd21;
    localparam [5:0] S_LDI_T5     = 6'd22;
    localparam [5:0] S_ST_T3      = 6'd23;
    localparam [5:0] S_ST_T4      = 6'd24;
    localparam [5:0] S_ST_T5      = 6'd25;
    localparam [5:0] S_ST_T6      = 6'd26;
    localparam [5:0] S_ST_T7      = 6'd27;
    localparam [5:0] S_BR_T3      = 6'd28;
    localparam [5:0] S_BR_T4      = 6'd29;
    localparam [5:0] S_BR_T5      = 6'd30;
    localparam [5:0] S_BR_T6      = 6'd31;
    localparam [5:0] S_JR_T3      = 6'd32;
    localparam [5:0] S_JAL_T3     = 6'd33;
    localparam [5:0] S_JAL_T4     = 6'd34;
    localparam [5:0] S_MFHI_T3    = 6'd35;
    localparam [5:0] S_MFLO_T3    = 6'd36;
    localparam [5:0] S_IN_T3      = 6'd37;
    localparam [5:0] S_OUT_T3     = 6'd38;
    localparam [5:0] S_HALT       = 6'd39;

    reg [5:0] present_state;
    reg [5:0] next_state;
    reg run_reg;

    wire [4:0] decode_opcode = (present_state == S_FETCH2) ? MDR_value[31:27] : IR[31:27];

    assign Run = run_reg;

    always @(posedge Clock or posedge Reset) begin
        if (Reset) begin
            present_state <= S_FETCH0;
            run_reg <= 1'b1;
        end else if (Stop) begin
            present_state <= S_HALT;
            run_reg <= 1'b0;
        end else if (run_reg) begin
            present_state <= next_state;
            if (next_state == S_HALT) begin
                run_reg <= 1'b0;
            end
        end else begin
            present_state <= S_HALT;
        end
    end

    always @* begin
        next_state = present_state;

        case (present_state)
            S_FETCH0: next_state = S_FETCH1;
            S_FETCH1: next_state = S_FETCH2;
            S_FETCH2: begin
                case (decode_opcode)
                    OP_ADD, OP_SUB, OP_AND, OP_OR, OP_SHR, OP_SHRA, OP_SHL, OP_ROR, OP_ROL:
                        next_state = S_RR_T3;
                    OP_ADDI, OP_ANDI, OP_ORI:
                        next_state = S_IMM_T3;
                    OP_DIV, OP_MUL:
                        next_state = S_MULDIV_T3;
                    OP_NEG, OP_NOT:
                        next_state = S_UNARY_T3;
                    OP_LD:
                        next_state = S_LD_T3;
                    OP_LDI:
                        next_state = S_LDI_T3;
                    OP_ST:
                        next_state = S_ST_T3;
                    OP_BR:
                        next_state = S_BR_T3;
                    OP_JR:
                        next_state = S_JR_T3;
                    OP_JAL:
                        next_state = S_JAL_T3;
                    OP_MFHI:
                        next_state = S_MFHI_T3;
                    OP_MFLO:
                        next_state = S_MFLO_T3;
                    OP_IN:
                        next_state = S_IN_T3;
                    OP_OUT:
                        next_state = S_OUT_T3;
                    OP_NOP:
                        next_state = S_FETCH0;
                    OP_HALT:
                        next_state = S_HALT;
                    default:
                        next_state = S_HALT;
                endcase
            end
            S_RR_T3: next_state = S_RR_T4;
            S_RR_T4: next_state = S_RR_T5;
            S_RR_T5: next_state = S_FETCH0;
            S_IMM_T3: next_state = S_IMM_T4;
            S_IMM_T4: next_state = S_IMM_T5;
            S_IMM_T5: next_state = S_FETCH0;
            S_MULDIV_T3: next_state = S_MULDIV_T4;
            S_MULDIV_T4: next_state = S_MULDIV_T5;
            S_MULDIV_T5: next_state = S_MULDIV_T6;
            S_MULDIV_T6: next_state = S_FETCH0;
            S_UNARY_T3: next_state = S_UNARY_T4;
            S_UNARY_T4: next_state = S_FETCH0;
            S_LD_T3: next_state = S_LD_T4;
            S_LD_T4: next_state = S_LD_T5;
            S_LD_T5: next_state = S_LD_T6;
            S_LD_T6: next_state = S_LD_T7;
            S_LD_T7: next_state = S_FETCH0;
            S_LDI_T3: next_state = S_LDI_T4;
            S_LDI_T4: next_state = S_LDI_T5;
            S_LDI_T5: next_state = S_FETCH0;
            S_ST_T3: next_state = S_ST_T4;
            S_ST_T4: next_state = S_ST_T5;
            S_ST_T5: next_state = S_ST_T6;
            S_ST_T6: next_state = S_ST_T7;
            S_ST_T7: next_state = S_FETCH0;
            S_BR_T3: next_state = S_BR_T4;
            S_BR_T4: next_state = S_BR_T5;
            S_BR_T5: next_state = S_BR_T6;
            S_BR_T6: next_state = S_FETCH0;
            S_JR_T3: next_state = S_FETCH0;
            S_JAL_T3: next_state = S_JAL_T4;
            S_JAL_T4: next_state = S_FETCH0;
            S_MFHI_T3: next_state = S_FETCH0;
            S_MFLO_T3: next_state = S_FETCH0;
            S_IN_T3: next_state = S_FETCH0;
            S_OUT_T3: next_state = S_FETCH0;
            S_HALT: next_state = S_HALT;
            default: next_state = S_HALT;
        endcase
    end

    always @* begin
        PCout = 1'b0;
        MDRout = 1'b0;
        Zlowout = 1'b0;
        Zhighout = 1'b0;
        HIout = 1'b0;
        LOout = 1'b0;
        InPortout = 1'b0;
        Cout = 1'b0;

        Gra = 1'b0;
        Grb = 1'b0;
        Grc = 1'b0;
        Rin = 1'b0;
        Rout = 1'b0;
        BAout = 1'b0;

        PCin = 1'b0;
        PCinIfCON = 1'b0;
        IRin = 1'b0;
        MARin = 1'b0;
        MDRin = 1'b0;
        Yin = 1'b0;
        Zin = 1'b0;
        HIin = 1'b0;
        LOin = 1'b0;
        CONin = 1'b0;
        OutPortin = 1'b0;

        IncPC = 1'b0;
        ADD = 1'b0;
        SUB = 1'b0;
        AND_op = 1'b0;
        OR_op = 1'b0;
        SHR = 1'b0;
        SHRA = 1'b0;
        SHL = 1'b0;
        ROR = 1'b0;
        ROL = 1'b0;
        NEG = 1'b0;
        NOT_op = 1'b0;
        MUL = 1'b0;
        DIV = 1'b0;

        Read = 1'b0;
        Write = 1'b0;
        Clear = Reset;

        if (!Reset && run_reg) begin
            case (present_state)
                S_FETCH0: begin
                    PCout = 1'b1;
                    MARin = 1'b1;
                    IncPC = 1'b1;
                    Zin = 1'b1;
                end
                S_FETCH1: begin
                    Zlowout = 1'b1;
                    PCin = 1'b1;
                    Read = 1'b1;
                    MDRin = 1'b1;
                end
                S_FETCH2: begin
                    MDRout = 1'b1;
                    IRin = 1'b1;
                end
                S_RR_T3: begin
                    Grb = 1'b1;
                    Rout = 1'b1;
                    Yin = 1'b1;
                end
                S_RR_T4: begin
                    Grc = 1'b1;
                    Rout = 1'b1;
                    Zin = 1'b1;
                    case (IR[31:27])
                        OP_ADD: ADD = 1'b1;
                        OP_SUB: SUB = 1'b1;
                        OP_AND: AND_op = 1'b1;
                        OP_OR: OR_op = 1'b1;
                        OP_SHR: SHR = 1'b1;
                        OP_SHRA: SHRA = 1'b1;
                        OP_SHL: SHL = 1'b1;
                        OP_ROR: ROR = 1'b1;
                        OP_ROL: ROL = 1'b1;
                        default: ;
                    endcase
                end
                S_RR_T5: begin
                    Zlowout = 1'b1;
                    Gra = 1'b1;
                    Rin = 1'b1;
                end
                S_IMM_T3: begin
                    Grb = 1'b1;
                    Rout = 1'b1;
                    Yin = 1'b1;
                end
                S_IMM_T4: begin
                    Cout = 1'b1;
                    Zin = 1'b1;
                    case (IR[31:27])
                        OP_ADDI: ADD = 1'b1;
                        OP_ANDI: AND_op = 1'b1;
                        OP_ORI: OR_op = 1'b1;
                        default: ;
                    endcase
                end
                S_IMM_T5: begin
                    Zlowout = 1'b1;
                    Gra = 1'b1;
                    Rin = 1'b1;
                end
                S_MULDIV_T3: begin
                    Gra = 1'b1;
                    Rout = 1'b1;
                    Yin = 1'b1;
                end
                S_MULDIV_T4: begin
                    Grb = 1'b1;
                    Rout = 1'b1;
                    Zin = 1'b1;
                    if (IR[31:27] == OP_MUL) begin
                        MUL = 1'b1;
                    end else begin
                        DIV = 1'b1;
                    end
                end
                S_MULDIV_T5: begin
                    Zlowout = 1'b1;
                    LOin = 1'b1;
                end
                S_MULDIV_T6: begin
                    Zhighout = 1'b1;
                    HIin = 1'b1;
                end
                S_UNARY_T3: begin
                    Grb = 1'b1;
                    Rout = 1'b1;
                    Zin = 1'b1;
                    if (IR[31:27] == OP_NEG) begin
                        NEG = 1'b1;
                    end else begin
                        NOT_op = 1'b1;
                    end
                end
                S_UNARY_T4: begin
                    Zlowout = 1'b1;
                    Gra = 1'b1;
                    Rin = 1'b1;
                end
                S_LD_T3: begin
                    Grb = 1'b1;
                    BAout = 1'b1;
                    Yin = 1'b1;
                end
                S_LD_T4: begin
                    Cout = 1'b1;
                    ADD = 1'b1;
                    Zin = 1'b1;
                end
                S_LD_T5: begin
                    Zlowout = 1'b1;
                    MARin = 1'b1;
                end
                S_LD_T6: begin
                    Read = 1'b1;
                    MDRin = 1'b1;
                end
                S_LD_T7: begin
                    MDRout = 1'b1;
                    Gra = 1'b1;
                    Rin = 1'b1;
                end
                S_LDI_T3: begin
                    Grb = 1'b1;
                    BAout = 1'b1;
                    Yin = 1'b1;
                end
                S_LDI_T4: begin
                    Cout = 1'b1;
                    ADD = 1'b1;
                    Zin = 1'b1;
                end
                S_LDI_T5: begin
                    Zlowout = 1'b1;
                    Gra = 1'b1;
                    Rin = 1'b1;
                end
                S_ST_T3: begin
                    Grb = 1'b1;
                    BAout = 1'b1;
                    Yin = 1'b1;
                end
                S_ST_T4: begin
                    Cout = 1'b1;
                    ADD = 1'b1;
                    Zin = 1'b1;
                end
                S_ST_T5: begin
                    Zlowout = 1'b1;
                    MARin = 1'b1;
                end
                S_ST_T6: begin
                    Gra = 1'b1;
                    Rout = 1'b1;
                    MDRin = 1'b1;
                end
                S_ST_T7: begin
                    Write = 1'b1;
                end
                S_BR_T3: begin
                    Gra = 1'b1;
                    Rout = 1'b1;
                    CONin = 1'b1;
                end
                S_BR_T4: begin
                    PCout = 1'b1;
                    Yin = 1'b1;
                end
                S_BR_T5: begin
                    Cout = 1'b1;
                    ADD = 1'b1;
                    Zin = 1'b1;
                end
                S_BR_T6: begin
                    Zlowout = 1'b1;
                    if (CON_FF) begin
                        PCinIfCON = 1'b1;
                    end
                end
                S_JR_T3: begin
                    Gra = 1'b1;
                    Rout = 1'b1;
                    PCin = 1'b1;
                end
                S_JAL_T3: begin
                    PCout = 1'b1;
                    Grc = 1'b1;
                    Rin = 1'b1;
                end
                S_JAL_T4: begin
                    Gra = 1'b1;
                    Rout = 1'b1;
                    PCin = 1'b1;
                end
                S_MFHI_T3: begin
                    HIout = 1'b1;
                    Gra = 1'b1;
                    Rin = 1'b1;
                end
                S_MFLO_T3: begin
                    LOout = 1'b1;
                    Gra = 1'b1;
                    Rin = 1'b1;
                end
                S_IN_T3: begin
                    InPortout = 1'b1;
                    Gra = 1'b1;
                    Rin = 1'b1;
                end
                S_OUT_T3: begin
                    Gra = 1'b1;
                    Rout = 1'b1;
                    OutPortin = 1'b1;
                end
                default: ;
            endcase
        end
    end
endmodule