-- libraru declaration
library IEEE;
use IEEE.std_logic_1164.all;

-- entity
entity mux2t1 is
	Port (	i_D0, i_D1, i_S	: in std_logic;
		o_O	: out std_logic);
end mux2t1;

-- architecture
architecture behavior of mux2t1 is

	-- AND gate
	component andg2 is
		port (	i_A, i_B : in std_logic;
			o_F : out std_logic);
	end component;

	-- OR gate
	component org2 is
  		port (	i_A          : in std_logic;
       			i_B          : in std_logic;
       			o_F          : out std_logic);
	end component;
	
	-- NOT gate
	component invg is

  		port (	i_A : in std_logic;
       			o_F : out std_logic);
	end component;

signal s_nS : std_logic;
signal s_and1 : std_logic;
signal s_and2 : std_logic;


begin
	-- Structural
--	i_nS: invg port map (	i_A => i_S,
--				o_F => s_nS);	
--
--	and1: andg2 port map (	i_A => i_D1,
--			 	i_B => i_S,
--				o_F => s_and1);
--
--	and2: andg2 port map (	i_A => i_D0,
--				i_B => s_nS,
--				o_F => s_and2);
--	
--	or1: org2 port map (	i_A => s_and1,
--				i_B => s_and2,
--				o_F => o_O);

	-- Dataflow
	o_O <= i_D0 when (i_S = '0') else
		i_D1;

end behavior;

	

