library verilog;
use verilog.vl_types.all;
entity mini_src_cpu is
    port(
        Clock           : in     vl_logic;
        Reset           : in     vl_logic;
        Stop            : in     vl_logic;
        InPortData      : in     vl_logic_vector(31 downto 0);
        InPortStrobe    : in     vl_logic;
        Run             : out    vl_logic
    );
end mini_src_cpu;
