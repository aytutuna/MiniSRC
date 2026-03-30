library verilog;
use verilog.vl_types.all;
entity mdr is
    port(
        clk             : in     vl_logic;
        clr             : in     vl_logic;
        en              : in     vl_logic;
        Read            : in     vl_logic;
        bus_in          : in     vl_logic_vector(31 downto 0);
        Mdatain         : in     vl_logic_vector(31 downto 0);
        q               : out    vl_logic_vector(31 downto 0)
    );
end mdr;
