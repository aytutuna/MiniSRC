library verilog;
use verilog.vl_types.all;
entity condition_ff is
    port(
        clk             : in     vl_logic;
        clr             : in     vl_logic;
        en              : in     vl_logic;
        cond_code       : in     vl_logic_vector(1 downto 0);
        bus_value       : in     vl_logic_vector(31 downto 0);
        q               : out    vl_logic
    );
end condition_ff;
