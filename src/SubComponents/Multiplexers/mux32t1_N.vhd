-------------------------------------------------------------------------
-- James Minardi
-- mux32t1_N.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of an N-bit wide 32:1
-- mux using dataflow VHDL, generics, and generate statements.
-------------------------------------------------------------------------

-- library declaration
library IEEE;
use IEEE.std_logic_1164.all;

entity mux32t1_N is
	generic(N : integer := 32);
		Port(
			i_S : in std_logic_vector(4 downto 0);
			i_D0,	i_D1,
			i_D2,	i_D3,
			i_D4,	i_D5,
			i_D6,	i_D7,
			i_D8,	i_D9,
			i_D10,	i_D11,
			i_D12,	i_D13,
			i_D14,	i_D15,
			i_D16,	i_D17,
			i_D18,	i_D19,
			i_D20,	i_D21,
			i_D22,	i_D23,
			i_D24,	i_D25,
			i_D26,	i_D27,
			i_D28,	i_D29,
			i_D30,	i_D31 : in std_logic_vector(N-1 downto 0);
			o_F 		  : out std_logic_vector(N-1 downto 0));
end mux32t1_N;


architecture structural of mux32t1_N is
	component mux32t1 is
		Port(
			i_S : in std_logic_vector(4 downto 0);
			i_D0,	i_D1,
			i_D2,	i_D3,
			i_D4,	i_D5,
			i_D6,	i_D7,
			i_D8,	i_D9,
			i_D10,	i_D11,
			i_D12,	i_D13,
			i_D14,	i_D15,
			i_D16,	i_D17,
			i_D18,	i_D19,
			i_D20,	i_D21,
			i_D22,	i_D23,
			i_D24,	i_D25,
			i_D26,	i_D27,
			i_D28,	i_D29,
			i_D30,	i_D31 : in std_logic;
			o_F 		  : out std_logic);
	end component;

begin

	-- Instantiate N mux instances.
	G_mux_N: for i in 0 to N-1 generate
		MUX_i: mux32t1 port map (
			i_S => i_S,
			i_D0  => i_D0(i),
			i_D1  => i_D1(i),
			i_D2  => i_D2(i),
			i_D3  => i_D3(i),
			i_D4  => i_D4(i),
			i_D5  => i_D5(i),
			i_D6  => i_D6(i),
			i_D7  => i_D7(i),
			i_D8  => i_D8(i),
			i_D9  => i_D9(i),
			i_D10 => i_D10(i),
			i_D11 => i_D11(i),
			i_D12 => i_D12(i),
			i_D13 => i_D13(i),
			i_D14 => i_D14(i),
			i_D15 => i_D15(i),
			i_D16 => i_D16(i),
			i_D17 => i_D17(i),
			i_D18 => i_D18(i),
			i_D19 => i_D19(i),
			i_D20 => i_D20(i),
			i_D21 => i_D21(i),
			i_D22 => i_D22(i),
			i_D23 => i_D23(i),
			i_D24 => i_D24(i),
			i_D25 => i_D25(i),
			i_D26 => i_D26(i),
			i_D27 => i_D27(i),
			i_D28 => i_D28(i),
			i_D29 => i_D29(i),
			i_D30 => i_D30(i),
			i_D31 => i_D31(i),
			o_F => o_F(i));
			
	end generate G_mux_N;
end structural;











