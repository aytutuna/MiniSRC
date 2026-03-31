library verilog;
use verilog.vl_types.all;
entity hex7seg is
    port(
        value           : in     vl_logic_vector(3 downto 0);
        segments        : out    vl_logic_vector(6 downto 0)
    );
end hex7seg;
