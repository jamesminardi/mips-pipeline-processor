library IEEE;
use IEEE.std_logic_1164.all;

entity tb_dffg_N is
	generic(N : integer := 32; gCLK_HPER : time := 50 ns);
end tb_dffg_N;

architecture behavior of tb_dffg_N is

	constant cCLK_PER	: time := gCLK_HPER * 2;

	component dffg_N is
			port(
				i_CLK        : in std_logic;     -- Clock input
				i_RST        : in std_logic;     -- Reset input
       			i_WE         : in std_logic;     -- Write enable input
       			i_D          : in std_logic_vector(N-1 downto 0);     -- Data value input
       			o_Q          : out std_logic_vector(N-1 downto 0));   -- Data value output
	end component;
	
signal s_CLK : std_logic;
signal s_RST : std_logic;
signal s_WE	 : std_logic;
signal s_D	 : std_logic_vector(N-1 downto 0);
signal s_Q	 : std_logic_vector(N-1 downto 0);

begin
DUT: dffg_N
port map (
	i_CLK	=> s_CLK,
	i_RST	=> s_RST,
	i_WE	=> s_WE,
	i_D		=> s_D,
	o_Q		=> s_Q);
	
P_CLK: process
  begin
    s_CLK <= '0';
    wait for gCLK_HPER;
    s_CLK <= '1';
    wait for gCLK_HPER;
  end process;


P_TB: process
begin
    -- Reset the FF
    s_RST <= '1';
    s_WE  <= '0';
    s_D   <= x"00000000";
    wait for cCLK_PER;

    -- Store EEEEEEEE
    s_RST <= '0';
    s_WE  <= '1';
    s_D   <= x"EEEEEEEE";
    wait for cCLK_PER;  

    -- Keep EEEEEEEE
    s_RST <= '0';
    s_WE  <= '0';
    s_D   <= x"FFFFFFFF";
    wait for cCLK_PER;  

    -- Reset FF
    s_RST <= '1';
    s_WE  <= '0';
    s_D   <= x"22222222";
    wait for cCLK_PER;

    -- Store 00000005    
    s_RST <= '0';
    s_WE  <= '1';
    s_D   <= x"00000005";
    wait for cCLK_PER;   

    -- Store 0000AAAA    
    s_RST <= '0';
    s_WE  <= '1';
    s_D   <= x"0000AAAA";
    wait for cCLK_PER;  

    -- Undefined? (It just resets to 0)
    s_RST <= '1';
    s_WE  <= '1';
    s_D   <= x"FFFFFFFF";
    wait for cCLK_PER; 



    wait;
  end process;
end behavior;



