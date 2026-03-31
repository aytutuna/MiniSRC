library verilog;
use verilog.vl_types.all;
entity booth_mul32 is
    port(
        a               : in     vl_logic_vector(31 downto 0);
        b               : in     vl_logic_vector(31 downto 0);
        p               : out    vl_logic_vector(63 downto 0)
    );
end booth_mul32;
