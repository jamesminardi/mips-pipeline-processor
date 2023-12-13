-- library declaration
library IEEE;
use IEEE.std_logic_1164.all;

entity extender is 
    generic(N : integer := 32);
    port(
        i_D : in std_logic_vector((N/2)-1 downto 0);
        i_Extend : in std_logic;
        o_F : out std_logic_vector(N-1 downto 0));
end extender;

architecture dataflow of extender is
begin
    with i_Extend select
        o_F <=
            (N-1 downto (N/2) => i_D(15)) & i_D when '1',
            (N-1 downto (N/2) => '0') & i_D when others;
end dataflow;
    