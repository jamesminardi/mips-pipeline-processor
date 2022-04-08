-------------------------------------------------------------------------
-- James Minardi
-- tb_mux32t1_N.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a simple VHDL testbench for the N-bit
-- 32:1 mux.
-------------------------------------------------------------------------

-- library declaration
library IEEE;
use IEEE.std_logic_1164.all;

-- entity
entity tb_mux32t1_N is
	generic(N : integer := 32);
end tb_mux32t1_N;

architecture tb of tb_mux32t1_N is
	component mux32t1_N is
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
	end component;

signal	s_S : std_logic_vector(4 downto 0) := "00000";	
signal 	s_D0,  s_D1,  s_D2,  s_D3,
		s_D4,  s_D5,  s_D6,  s_D7,
		s_D8,  s_D9,  s_D10, s_D11,
		s_D12, s_D13, s_D14, s_D15,
		s_D16, s_D17, s_D18, s_D19,
		s_D20, s_D21, s_D22, s_D23,
		s_D24, s_D25, s_D26, s_D27,
		s_D28, s_D29, s_D30, s_D31 : std_logic_vector(N-1 downto 0) := x"00000000";
signal	s_F : std_logic_vector(N-1 downto 0);

begin
DUT: mux32t1_N
	port map(
		i_S =>  s_S,
		i_D0 =>  s_D0,
		i_D1 =>  s_D1,
		i_D2 =>  s_D2,
		i_D3 =>  s_D3,
		i_D4 =>  s_D4,
		i_D5 =>  s_D5,
		i_D6 =>  s_D6,
		i_D7 =>  s_D7,
		i_D8 =>  s_D8,
		i_D9 =>  s_D9,
		i_D10 =>  s_D10,
		i_D11 =>  s_D11,
		i_D12 =>  s_D12,
		i_D13 =>  s_D13,
		i_D14 =>  s_D14,
		i_D15 =>  s_D15,
		i_D16 =>  s_D16,
		i_D17 =>  s_D17,
		i_D18 =>  s_D18,
		i_D19 =>  s_D19,
		i_D20 =>  s_D20,
		i_D21 =>  s_D21,
		i_D22 =>  s_D22,
		i_D23 =>  s_D23,
		i_D24 =>  s_D24,
		i_D25 =>  s_D25,
		i_D26 =>  s_D26,
		i_D27 =>  s_D27,
		i_D28 =>  s_D28,
		i_D29 =>  s_D29,
		i_D30 =>  s_D30,
		i_D31 =>  s_D31,
		o_F => s_F);

process
	begin
	-- Expected: s_F = x"00000000"
	s_S <= "00000";
	s_D0 <= x"00000000";
	wait for 100 ns;
	
	-- Expected: s_F = x"12345678"
	s_S <= "00000";
	s_D0 <= x"12345678";
	wait for 100 ns;

	-- Expected: s_F = x"ABABABAB"
	s_S <= "00010";
	s_D2 <= x"ABABABAB";
	wait for 100 ns;
	
	-- Expected: s_F = x"AAAAAAAA"
	s_S <= "00100";
	s_D4 <= x"AAAAAAAA";
	s_D3 <= x"BBBBBBBB";
	s_D5 <= x"CCCCCCCC";
	s_D8 <= x"DDDDDDDD";
	wait for 100 ns;
end process;

end tb;













