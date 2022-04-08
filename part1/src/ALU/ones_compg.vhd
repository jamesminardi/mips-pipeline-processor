library IEEE;
use IEEE.std_logic_1164.all;

entity ones_compg is
	generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
		port(	i_X	: in std_logic_vector(N-1 downto 0);
  				i_OP		: in std_logic;	-- 1 takes one's complement of number (Inverts all bits)
       			o_F	: out std_logic_vector(N-1 downto 0));

end ones_compg;

architecture structural of ones_compg is

	
	component xorg2 is
  		port(i_A          : in std_logic;
       		i_B          : in std_logic;
       		o_F          : out std_logic);
	end component;



begin				
	g_complement: for i in 0 to N-1 generate
		g_invert: xorg2
			port map (
				i_A => i_X(i),
				i_B => i_OP,
				o_F => o_F(i));

end generate g_complement;
end structural;

