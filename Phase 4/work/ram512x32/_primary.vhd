library verilog;
use verilog.vl_types.all;
entity ram512x32 is
    port(
        clk             : in     vl_logic;
        read_en         : in     vl_logic;
        write_en        : in     vl_logic;
        address         : in     vl_logic_vector(8 downto 0);
        write_data      : in     vl_logic_vector(31 downto 0);
        read_data       : out    vl_logic_vector(31 downto 0)
    );
end ram512x32;
