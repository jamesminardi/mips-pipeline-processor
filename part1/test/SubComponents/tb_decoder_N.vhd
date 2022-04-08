library IEEE;
use IEEE.std_logic_1164.all;

entity tb_decoder_N is
    generic(SEL_WIDTH: integer := 5);
end tb_decoder_N;

architecture behavior of tb_decoder_N is
    component decoder_N is
            port(
                i_D : in std_logic_vector(SEL_WIDTH - 1 downto 0);
                o_F : out std_logic_vector(2**(SEL_WIDTH)-1 downto 0)
            );
    end component;

signal s_D : std_logic_vector(SEL_WIDTH - 1 downto 0);
signal s_F : std_logic_vector(2**(Sel_WIDTH) - 1 downto 0);

begin 
DUT: decoder_N
port map(
    i_D => s_D,
    o_F => s_F);
P_TB: process
begin
    -- 
    s_D <= b"00000";
    wait for 100 ns;

    s_D <= b"00001";
    wait for 100 ns;

    s_D <= b"00010";
    wait for 100 ns;

    s_D <= b"00011";
    wait for 100 ns;

    s_D <= b"00100";
    wait for 100 ns;

    s_D <= b"00101";
    wait for 100 ns;

    s_D <= b"00110";
    wait for 100 ns;

    s_D <= b"00111";
    wait for 100 ns;

    s_D <= b"01000";
    wait for 100 ns;

    s_D <= b"01001";
    wait for 100 ns;

    s_D <= b"01010";
    wait for 100 ns;

    s_D <= b"01011";
    wait for 100 ns;

    s_D <= b"01100";
    wait for 100 ns;

    s_D <= b"01101";
    wait for 100 ns;

    s_D <= b"01110";
    wait for 100 ns;

    s_D <= b"01111";
    wait for 100 ns;

    s_D <= b"11111";
    wait for 100 ns;



end process;
end behavior;
