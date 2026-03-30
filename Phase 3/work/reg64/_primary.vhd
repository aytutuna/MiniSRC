library verilog;
use verilog.vl_types.all;
entity reg64 is
    port(
        clk             : in     vl_logic;
        clr             : in     vl_logic;
        en              : in     vl_logic;
        d               : in     vl_logic_vector(63 downto 0);
        q               : out    vl_logic_vector(63 downto 0)
    );
end reg64;
