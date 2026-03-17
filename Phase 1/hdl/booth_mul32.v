`timescale 1ns/1ps

module booth_mul32(
    input  [31:0] a,
    input  [31:0] b,
    output [63:0] p
);
    reg signed [63:0] product;
    reg signed [63:0] multiplicand;
    reg [32:0] multiplier_ext;
    reg [2:0] bits;
    reg [32:0] b_shift;
    reg signed [63:0] partial;
    integer i;
    integer sh;

    always @* begin
        // Sign extend to 64 bit
        multiplicand = {{32{a[31]}}, a};

        // Extend B with a extra 0.
        multiplier_ext = {b, 1'b0};

        // Running sum
        product = 64'sd0;

        for (i = 0; i < 16; i = i + 1) begin
            sh = (i << 1);
            // Shift first, then take a cut.
            b_shift = (multiplier_ext >> sh);
            bits = b_shift[2:0];

            //Booth table
            case (bits)
                3'b000, 3'b111: partial = 64'sd0;
                3'b001, 3'b010: partial = multiplicand;
                3'b011:         partial = (multiplicand <<< 1);
                3'b100:         partial = -(multiplicand <<< 1);
                3'b101, 3'b110: partial = -multiplicand;
                default:        partial = 64'sd0;
            endcase

            // Shift and add
            product = product + (partial <<< sh);
        end
    end

    assign p = product;
endmodule
