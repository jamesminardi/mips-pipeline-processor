-- library declaration
library IEEE;
use IEEE.std_logic_1164.all;

entity tb_extender is 
    generic(N : integer := 32);
end tb_extender;

architecture tb of tb_extender is
    component extender is
        port(
            i_D : in std_logic_vector((N/2)-1 downto 0);
            i_Extend : in std_logic;
            o_F : out std_logic_vector(N-1 downto 0));
    end component;

signal s_D : std_logic_vector((N/2)-1 downto 0);
signal s_Extend : std_logic;
signal s_F : std_logic_vector(N-1 downto 0);

begin

DUT: extender
    port map(
        i_D => s_D,
        i_Extend => s_Extend,
        o_F => s_F);

process
    begin

    -- Expect "0000FAAA"
    s_D <= x"FAAA";
    s_Extend <= '0';
    wait for 100 ns;

    -- Expect "FFFFFAAA"
    s_D <= x"FAAA";
    s_Extend <= '1';
    wait for 100 ns;

    -- Expect "00001111"
    s_D <= x"1111";
    s_Extend <= '0';
    wait for 100 ns;

    -- Expect "00001111"
    s_D <= x"1111";
    s_Extend <= '1';
    wait for 100 ns;


end process;
end tb;