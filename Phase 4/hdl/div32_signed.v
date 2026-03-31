`timescale 1ns/1ps

module div32_signed(
    input  [31:0] a,
    input  [31:0] b,
    output [31:0] quotient,
    output [31:0] remainder
);
    reg signed [31:0] q;
    reg signed [31:0] r;
    reg sign_a;
    reg sign_b;
    reg [31:0] abs_a;
    reg [31:0] abs_b;
    reg [32:0] rem;
    reg [31:0] quot;
    integer i;

    always @* begin
        q = 32'sd0;
        r = 32'sd0;
        sign_a = 1'b0;
        sign_b = 1'b0;
        abs_a  = 32'd0;
        abs_b  = 32'd0;
        rem    = 33'd0;
        quot   = 32'd0;

        if (b == 32'b0) begin
            r = $signed(a);
        end else begin
            sign_a = a[31];
            sign_b = b[31];
            abs_a = sign_a ? (32'd0 - a) : a;
            abs_b = sign_b ? (32'd0 - b) : b;

            for (i = 0; i < 32; i = i + 1) begin
                rem = {rem[31:0], abs_a[31 - i]};
                if (rem >= {1'b0, abs_b}) begin
                    rem = rem - {1'b0, abs_b};
                    quot[31 - i] = 1'b1;
                end
            end

            q = (sign_a ^ sign_b) ? (32'sd0 - $signed(quot)) : $signed(quot);
            r = sign_a ? (32'sd0 - $signed(rem[31:0])) : $signed(rem[31:0]);
        end
    end

    assign quotient = q;
    assign remainder = r;
endmodule
