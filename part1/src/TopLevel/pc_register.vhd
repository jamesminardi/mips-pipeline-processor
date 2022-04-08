library IEEE;
use IEEE.std_logic_1164.all;

entity pc_register is
	generic(N : integer := 32);
		port(
			i_CLK        : in std_logic;     -- Clock input
			i_RST        : in std_logic;     -- Reset input
			i_WE		 : in std_logic;	 -- Write enable
       		i_D          : in std_logic_vector(N-1 downto 0);     -- Data value input
       		o_Q          : out std_logic_vector(N-1 downto 0));   -- Data value output
end pc_register;

architecture behavior of pc_register is

	component pc_dffg is
		port(	i_CLK        : in std_logic;     -- Clock input
				i_RST        : in std_logic;     -- Reset input
				i_WE		 : in std_logic;	 -- Write enable
       			i_ADDR_RST   : in std_logic;
       			i_D          : in std_logic;     -- Data value input
       			o_Q          : out std_logic);   -- Data value output
	end component;

signal s_ADDR_RST : std_logic_vector(N - 1 downto 0) := x"00400000";


begin
g_pc_dffg_N: for i in 0 to N-1 generate
	pc_dffg_I: pc_dffg port map (
					i_CLK	=> i_CLK,
					i_ADDR_RST => s_ADDR_RST(i),
					i_RST	=> i_RST,
					i_WE	=> i_WE,
					i_D		=> i_D(i),
					o_Q		=> o_Q(i));
end generate g_pc_dffg_N;

end behavior;
