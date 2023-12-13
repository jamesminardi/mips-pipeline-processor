-------------------------------------------------------------------------
-- ALU.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a mips ALU
--
-- REQUIRES: MIPS_types.vhd
-------------------------------------------------------------------------

-- library declaration
library IEEE;
use IEEE.std_logic_1164.all;

-- constants & types declaration
library work;
use work.MIPS_types.all;


entity ALU is
    port (
        iA : in std_logic_vector(DATA_WIDTH - 1 downto 0);
        iB : in std_logic_vector(DATA_WIDTH - 1 downto 0);
        iShamt : in std_logic_vector(DATA_SELECT - 1 downto 0);
        iALUOp : in std_logic_vector(ALU_OP_WIDTH - 1 downto 0);
        oResult : out std_logic_vector(DATA_WIDTH - 1 downto 0);
        oCout : out std_logic;
        oOverflow : out std_logic;
        oZero : out std_logic);
end ALU;

architecture mixed of ALU is

    component add_sub is
        port(
            iSubtract : in std_logic;
            iA	    : in  std_logic_vector(DATA_WIDTH-1 downto 0);
            iB	    : in  std_logic_vector(DATA_WIDTH-1 downto 0);
            oSum	: out std_logic_vector(DATA_WIDTH-1 downto 0);
            oCout 	: out std_logic;
            oCout2  : out std_logic);
    end component;

    component barrel_shifter is
        port(
            iLeft       : in std_logic;
            iArithmetic : in std_logic;
            iA          : in std_logic_vector(DATA_WIDTH - 1 downto 0);
            iShamt      : in std_logic_vector(DATA_SELECT - 1 downto 0);
            oResult     : out std_logic_vector(DATA_WIDTH - 1 downto 0));
    end component;

signal s_subtract : std_logic;
signal s_add_sub_result : std_logic_vector(DATA_WIDTH - 1 downto 0);
signal s_overflow_control : std_logic;
signal s_barrel_shifter_result : std_logic_vector(DATA_WIDTH - 1 downto 0);
signal s_set_less_than_result : std_logic_vector(DATA_WIDTH - 1 downto 0);
signal s_movn_zero : std_logic;
signal s_cout, s_cout2 : std_logic;

signal s_left_shift : std_logic;
signal s_arithmetic : std_logic;
signal s_shamt : std_logic_vector(DATA_SELECT - 1 downto 0);

signal s_overflow : std_logic;
signal s_ALUZero : std_logic;
signal s_oResult : std_logic_vector(DATA_WIDTH - 1 downto 0);

begin

    -- Set parameters for ALU components
    s_subtract <= iALUOp(0);
    s_left_shift <= NOT iALUOP(1);
    s_arithmetic <= iALUOP(0);
    

    
    with iALUOp select
        s_shamt <=
            "10000" when "1001",
            iShamt when others;

    add_sub_C: add_sub
    port map(
        iSubtract => s_subtract,
        iA	    => iA,
        iB	    => iB,
        oSum	=> s_add_sub_result,
        oCout 	=> s_cout,
        oCout2  => s_cout2);

    barrel_shifter_C: barrel_shifter
    port map(
        iA => iB,
        iLeft => s_left_shift,
        iArithmetic => s_arithmetic,
        iShamt => s_shamt,
        oResult => s_barrel_shifter_result);


    
    -- Set overflow signal
    s_overflow <= s_cout XOR s_cout2;

	with iALUOp select
	s_overflow_control <=
		'1' when "0000",
		'1' when "0001",
		'0' when others;


    oOverflow <= s_overflow AND s_overflow_control;
    
    -- Set less than result using Overflow detect and result from (a-b)
    s_set_less_than_result <= "0000000000000000000000000000000" & (s_add_sub_result(DATA_WIDTH - 1) XOR s_overflow); -- XOR s_overflow)

    -- Set carry out bit
    oCout <= s_cout;

    with iB select
        s_movn_zero <=
            '1' when x"00000000",
            '0' when others;

    -- Select ALU result
    with iALUOP select
    s_oResult <=
        s_add_sub_result when "0000", -- add overflow
        s_add_sub_result when "0001", -- sub overflow
        s_add_sub_result when "0010", -- add
        s_add_sub_result when "0011", -- sub
        iA AND iB when "0100",
        iA OR iB when "0101",
        iA XOR iB when "0111",
        iA NOR iB when "0110",
        
        s_barrel_shifter_result when "1000",
        s_barrel_shifter_result when "1001",
        s_barrel_shifter_result when "1010",
        s_barrel_shifter_result when "1011",

        --s_set_less_than_result when "1100",
        s_set_less_than_result when "1101",   -- Slt & Slti
        --s_set_less_than_result when "1111",
        
        s_add_sub_result when "1110", -- Movn
        
        --x"DEADBEEF" when others;
        s_add_sub_result when others;
    
    --     -- TODOOOOO MOVN
    -- -- Set zero bit
    -- with s_movn_result select
    --     s_movn_zero <=
    --         '0' when iA,
    --         '1' when others;

    -- Set zero bit
    with s_oResult select
        s_ALUZero <=
            '1' when x"00000000",
            '0' when others;

    with iALUOP select
        oZero <=
            s_movn_zero when "1110",
            s_ALUZero when others;
    
    oResult <= s_oResult;

end mixed;