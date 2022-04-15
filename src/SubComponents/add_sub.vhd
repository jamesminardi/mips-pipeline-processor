-------------------------------------------------------------------------
-- add_sub.vhd
-------------------------------------------------------------------------
-- REQUIRES: MIPS_types.vhd, full_adder_N.vhd
-------------------------------------------------------------------------

-- library declaration
library IEEE;
use IEEE.std_logic_1164.all;

-- constants & types declaration
library work;
use work.MIPS_types.all;

entity add_sub is
	port(
	  	iSubtract : in std_logic;
		iA	: in  std_logic_vector(DATA_WIDTH-1 downto 0);
       	iB	: in  std_logic_vector(DATA_WIDTH-1 downto 0);
       	oSum	: out std_logic_vector(DATA_WIDTH-1 downto 0);
       	oCout 	: out std_logic;
		oCout2  : out std_logic);
end add_sub;

architecture behavior of add_sub is

	component full_adder_N is
		port(
			iA		: in 	std_logic_vector(DATA_WIDTH - 1 downto 0);
       		iB		: in 	std_logic_vector(DATA_WIDTH-1 downto 0);
       		iCin	: in 	std_logic;
       		oSum	: out 	std_logic_vector(DATA_WIDTH-1 downto 0);
	   		oCout2	: out	std_logic;
			oCout 	: out 	std_logic);
	end component;
	
signal s_inner_carry : std_logic_vector(DATA_WIDTH-2 downto 0); -- Carry N-1 is just cout
signal s_complement : std_logic_vector(DATA_WIDTH-1 downto 0);

begin
	-- Ones complement
	with iSubtract select
	s_complement <=
		not iB when '1',
		iB when others;
		
	adder_g: full_adder_N port map(
		iA => iA,
		iB => s_complement,
		-- Need to flip bits and add 1 for two's complement
		-- When subtracting, iSubtract is 1, so add that to the adder
		iCin 	=> iSubtract,		
		oSum 	=> oSum,
		oCout 	=> oCout,
		oCout2 	=> oCout2);


end behavior;
