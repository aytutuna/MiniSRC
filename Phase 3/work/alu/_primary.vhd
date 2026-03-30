library verilog;
use verilog.vl_types.all;
entity alu is
    port(
        y               : in     vl_logic_vector(31 downto 0);
        \bus\           : in     vl_logic_vector(31 downto 0);
        IncPC           : in     vl_logic;
        ADD             : in     vl_logic;
        SUB             : in     vl_logic;
        AND_op          : in     vl_logic;
        OR_op           : in     vl_logic;
        SHR             : in     vl_logic;
        SHRA            : in     vl_logic;
        SHL             : in     vl_logic;
        \ROR\           : in     vl_logic;
        \ROL\           : in     vl_logic;
        NEG             : in     vl_logic;
        NOT_op          : in     vl_logic;
        MUL             : in     vl_logic;
        DIV             : in     vl_logic;
        z_out           : out    vl_logic_vector(63 downto 0)
    );
end alu;
