library verilog;
use verilog.vl_types.all;
entity div32_signed is
    port(
        a               : in     vl_logic_vector(31 downto 0);
        b               : in     vl_logic_vector(31 downto 0);
        quotient        : out    vl_logic_vector(31 downto 0);
        remainder       : out    vl_logic_vector(31 downto 0)
    );
end div32_signed;
