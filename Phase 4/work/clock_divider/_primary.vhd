library verilog;
use verilog.vl_types.all;
entity clock_divider is
    generic(
        DIVIDE_BIT      : integer := 20
    );
    port(
        clk_in          : in     vl_logic;
        reset           : in     vl_logic;
        clk_out         : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of DIVIDE_BIT : constant is 1;
end clock_divider;
