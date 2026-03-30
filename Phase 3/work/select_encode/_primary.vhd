library verilog;
use verilog.vl_types.all;
entity select_encode is
    port(
        ir              : in     vl_logic_vector(31 downto 0);
        Gra             : in     vl_logic;
        Grb             : in     vl_logic;
        Grc             : in     vl_logic;
        Rin             : in     vl_logic;
        Rout            : in     vl_logic;
        BAout           : in     vl_logic;
        reg_in          : out    vl_logic_vector(15 downto 0);
        reg_out         : out    vl_logic_vector(15 downto 0)
    );
end select_encode;
