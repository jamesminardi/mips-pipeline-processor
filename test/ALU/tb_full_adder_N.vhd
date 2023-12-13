-- library declaration
library IEEE;
use IEEE.std_logic_1164.all;



entity tb_full_adder_N is
	generic(N : integer := 32);
end tb_full_adder_N;

architecture behavior of tb_full_adder_N is
	component full_adder_N is
  	port(x1		: in 	std_logic_vector(N-1 downto 0);
       x2		: in 	std_logic_vector(N-1 downto 0);
       cin		: in 	std_logic;
       sum		: out 	std_logic_vector(N-1 downto 0);
       cout 	: out 	std_logic);
	end component;

signal s_cin, s_cout : std_logic;
signal s_x1, s_x2 : std_logic_vector(N-1 downto 0);
signal s_sum : std_logic_vector(N-1 downto 0);

begin

DUT: full_adder_N
port map (
	x1	=> s_x1,
	x2	=> s_x2,
	cin	=> s_cin,
	cout=> s_cout,
	sum => s_sum);


process
	begin
	-- Expected: s_sum = 0000000000000010, s_cout = 0
	s_x1 <= b"0000000000000001";
	s_x2 <= b"0000000000000001";
	s_cin <=  '0';

	wait for 100 ns;


	-- Expected: s_sum = 0000000000000001, s_cout = 0
	s_x1 <= b"0000000000000001";
	s_x2 <= b"0000000000000000";
	s_cin <=  '0';

	wait for 100 ns;

	-- Expected: s_sum = 1111111111111111, s_cout = 0
	s_x1 <= b"1111111111111110";
	s_x2 <= b"0000000000000001";
	s_cin <=  '0';

	wait for 100 ns;

	-- Expected: s_sum = 0000000000001011, s_cout = 0
	s_x1 <= b"0000000000001000";
	s_x2 <= b"0000000000000010";
	s_cin <=  '1';

	wait for 100 ns;
	
	-- Expected: s_sum = 0000000000000111, s_cout = 0
	s_x1 <= b"0000000000000011";
	s_x2 <= b"0000000000000011";
	s_cin <=  '1';

	wait for 100 ns;
	
	-- Expected: s_sum = 0000000000000000, s_cout = 1
	s_x1 <= b"1111111111111111";
	s_x2 <= b"0000000000000001";
	s_cin <=  '0';

	wait for 100 ns;
	
	-- Expected: s_sum = 0000000000000001, s_cout = 1
	s_x1 <= b"1111111111111111";
	s_x2 <= b"0000000000000001";
	s_cin <=  '1';

	wait for 100 ns;



end process;
end behavior;
	
