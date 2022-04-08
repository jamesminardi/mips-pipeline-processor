-- library declaration
library IEEE;
use IEEE.std_logic_1164.all;

-- entity
entity full_adder is
	Port (
		iA		: in std_logic;
		iB	 	: in std_logic;
		iCin 	: in std_logic;
		oSum 	: out std_logic;
		oCout   : out std_logic);
end full_adder;

-- architecture
architecture dataflow of full_adder is
begin
	oSum <= iA XOR iB XOR iCin;
	oCout <= (iA AND iB) OR (iCin AND iA) OR (iCin AND iB);
end dataflow;
	
	
	
	
	
	
	
	
	
	
	
	

