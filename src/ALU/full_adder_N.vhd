-------------------------------------------------------------------------
-- full_adder_N.vhd
-------------------------------------------------------------------------
-- REQUIRES: MIPS_types.vhd
-------------------------------------------------------------------------

-- library declaration
library IEEE;
use IEEE.std_logic_1164.all;

-- constants & types declaration
library work;
use work.MIPS_types.all;


entity full_adder_N is port(
		iA		: in 	std_logic_vector(DATA_WIDTH - 1 downto 0);
       	iB		: in 	std_logic_vector(DATA_WIDTH-1 downto 0);
       	iCin	: in 	std_logic;
       	oSum	: out 	std_logic_vector(DATA_WIDTH-1 downto 0);
	   	oCout2	: out	std_logic;
		oCout 	: out 	std_logic);
end full_adder_N;

architecture combination of full_adder_N is
  	component full_adder is
		Port (
			iA, iB, iCin : in std_logic;
			oSum 	: out std_logic;
			oCout 	: out std_logic);
  	end component;

signal s_inner_carry : std_logic_vector(DATA_WIDTH-2 downto 0); -- Carry N-1 is just cout

begin
	-- First adder
	full_adder_0: full_adder
	port map(
		iA 		=> iA(0),
		iB 		=> iB(0),
		iCin 	=> iCin,
		oSum 	=> oSum(0),
		oCout 	=> s_inner_carry(0));
	
	-- Middle adders
	nbit_full_adder: for i in 1 to DATA_WIDTH-2 generate
	full_adder_I: full_adder
	port map (
		iA 		=> iA(i),
		iB 		=> iB(i),
		iCin 	=> s_inner_carry(i-1),
		oSum 	=> oSum(i),
		oCout 	=> s_inner_carry(i));
	end generate nbit_full_adder;
 
	oCout2 <= s_inner_carry(DATA_WIDTH-2); -- cout - 1 to be used for overflow

  	-- Final adder
	full_adder_Nm1: full_adder
	port map(
		iA 		=> iA(DATA_WIDTH-1),
		iB 		=> iB(DATA_WIDTH-1),
		iCin 	=> s_inner_carry(DATA_WIDTH-2),
		oSum 	=> oSum(DATA_WIDTH-1),
		oCout 	=> oCout);
end combination;
