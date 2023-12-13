-- library declaration
library IEEE;
use IEEE.std_logic_1164.all;



entity tb_add_sub is
	generic(N : integer := 32);
end tb_add_sub;

architecture behavior of tb_add_sub is

	component add_sub is
  		port(	A		: in 	std_logic_vector(N-1 downto 0);
       			B		: in 	std_logic_vector(N-1 downto 0);
       			nAdd_Sub	: in 	std_logic;
       			sum		: out 	std_logic_vector(N-1 downto 0);
       			cout 		: out 	std_logic);
	end component;

signal s_nAdd_Sub: std_logic;
signal s_A, s_B : std_logic_vector(N-1 downto 0);
signal s_sum : std_logic_vector(N-1 downto 0);
signal s_cout : std_logic;

begin

DUT: add_sub
port map (
	A	=> s_A,
	B	=> s_B,
	nAdd_Sub	=> s_nAdd_Sub,
	cout=> s_cout,
	sum => s_sum);


process
	begin
	-- Expected: s_sum - 00000010
	s_nAdd_Sub <= '0';
	s_A <= x"00000001";
	s_B <= x"00000001";
	
	wait for 100 ns;
	
	-- Expected: s_sum - 00000000
	s_nAdd_Sub <= '1';
	s_A <= x"00000001";
	s_B <= x"00000001";
	
	wait for 100 ns;
	
	-- Expected: s_sum - 00000000
	s_nAdd_Sub <= '1';
	s_A <= x"00000110";
	s_B <= x"00000001";
	
	wait for 100 ns;
	
	
	-- Expected: s_sum - 00000000
	s_nAdd_Sub <= '1';
	s_A <= x"FFFFFFFF";
	s_B <= x"FFFFFFFF";
	
	wait for 100 ns;
	
	
	-- Expected: s_sum - 00000000
	s_nAdd_Sub <= '0';
	s_A <= x"FFFFFFFF";
	s_B <= x"00000000";
	
	wait for 100 ns;
	
	
	-- Expected: s_sum - 00000000
	s_nAdd_Sub <= '0';
	s_A <= x"FFFFFFFF";
	s_B <= x"00000001";
	
	wait for 100 ns;
	
	-- Expected: s_sum - 00000000
	s_nAdd_Sub <= '1';
	s_A <= x"00000000";
	s_B <= x"00000001";
	
	wait for 100 ns;
	
	
	
	
end process;
end behavior;
