-------------------------------------------------------------------------
-- barrel_shifter.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a right
-- barrel shifter of DATA_WIDTH bits wide.
-- 
-- TODO: Add left/right functionality and
-- arithmatic vs logical functionality
--
-- REQUIRES: MIPS_types.vhd mux2t1_N.vhd mux2t1.vhd
-------------------------------------------------------------------------

-- library declaration
library IEEE;
use IEEE.std_logic_1164.all;

-- constants & types declaration
library work;
use work.MIPS_types.all;

entity barrel_shifter is
generic(N : integer := 32);
    port(
        iA : in std_logic_vector(DATA_WIDTH - 1 downto 0);
        iLeft : in std_logic;
        iArithmetic : in std_logic;
        iShamt : in std_logic_vector(DATA_SELECT - 1 downto 0);
        oResult : out std_logic_vector(DATA_WIDTH -1 downto 0));
end barrel_shifter;

architecture mixed of barrel_shifter is
    component mux2t1_N is
        port(
        i_S    : in std_logic;
        i_D0   : in std_logic_vector(N-1 downto 0);
        i_D1   : in std_logic_vector(N-1 downto 0);
        o_O    : out std_logic_vector(N-1 downto 0));
    end component;

signal s_ext : std_logic;
signal s_iA : std_logic_vector(DATA_WIDTH - 1 downto 0); -- Data after being shifted
signal s_result_16b : std_logic_vector(DATA_WIDTH - 1 downto 0);
signal s_result_8b : std_logic_vector(DATA_WIDTH - 1 downto 0);
signal s_result_4b : std_logic_vector(DATA_WIDTH - 1 downto 0);
signal s_result_2b : std_logic_vector(DATA_WIDTH - 1 downto 0);
signal s_result_1b : std_logic_vector(DATA_WIDTH - 1 downto 0);
signal s_shifted_16b : std_logic_vector(DATA_WIDTH - 1 downto 0);
signal s_shifted_8b : std_logic_vector(DATA_WIDTH - 1 downto 0);
signal s_shifted_4b : std_logic_vector(DATA_WIDTH - 1 downto 0);
signal s_shifted_2b : std_logic_vector(DATA_WIDTH - 1 downto 0);
signal s_shifted_1b : std_logic_vector(DATA_WIDTH - 1 downto 0);

begin

    with iArithmetic select
        s_ext <=
            iA(DATA_WIDTH - 1) when '1',
            '0' when others;

    with iLeft select
        s_iA <=
             iA(0) &iA(1) &iA(2) &iA(3) &iA(4) &iA(5) &iA(6) &iA(7)
            &iA(8) &iA(9) &iA(10)&iA(11)&iA(12)&iA(13)&iA(14)&iA(15)
            &iA(16)&iA(17)&iA(18)&iA(19)&iA(20)&iA(21)&iA(22)&iA(23)
            &iA(24)&iA(25)&iA(26)&iA(27)&iA(28)&iA(29)&iA(30)&iA(31) when '1',
            iA when others;

    s_shifted_16b(31 downto 16) <= (others => s_ext);
    s_shifted_16b(15 downto 0)  <= s_iA(31 downto 16);

    s_shifted_8b(31 downto 24)  <= (others => s_ext);
    s_shifted_8b(23 downto 0)   <= s_result_16b(31 downto 8);

    s_shifted_4b(31 downto 28)  <= (others => s_ext);
    s_shifted_4b(27 downto 0)   <= s_result_8b(31 downto 4);

    s_shifted_2b(31 downto 30)  <= (others => s_ext);
    s_shifted_2b(29 downto 0)   <= s_result_4b(31 downto 2);

    s_shifted_1b(31)            <= s_ext;
    s_shifted_1b(30 downto 0)   <= s_result_2b(31 downto 1);


    MUX2t1_N_16b: mux2t1_N
        port map(
            i_S  => iShamt(4),
            i_D0 => s_iA,
            i_D1 => s_shifted_16b,
            o_O  => s_result_16b);

    MUX2t1_N_8b: mux2t1_N
        port map(
            i_S  => iShamt(3),
            i_D0 => s_result_16b,
            i_D1 => s_shifted_8b,
            o_O  => s_result_8b);

    MUX2t1_N_4b: mux2t1_N
        port map(
            i_S  => iShamt(2),
            i_D0 => s_result_8b,
            i_D1 => s_shifted_4b,
            o_O  => s_result_4b);

    MUX2t1_N_2b: mux2t1_N
        port map(
            i_S  => iShamt(1),
            i_D0 => s_result_4b,
            i_D1 => s_shifted_2b,
            o_O  => s_result_2b);

    MUX2t1_N_1b: mux2t1_N
        port map(
            i_S  => iShamt(0),
            i_D0 => s_result_2b,
            i_D1 => s_shifted_1b,
            o_O  => s_result_1b);

    with iLeft select
        oResult <=
             s_result_1b(0) &s_result_1b(1) &s_result_1b(2) &s_result_1b(3) &s_result_1b(4) &s_result_1b(5) &s_result_1b(6) &s_result_1b(7)
            &s_result_1b(8) &s_result_1b(9) &s_result_1b(10)&s_result_1b(11)&s_result_1b(12)&s_result_1b(13)&s_result_1b(14)&s_result_1b(15)
            &s_result_1b(16)&s_result_1b(17)&s_result_1b(18)&s_result_1b(19)&s_result_1b(20)&s_result_1b(21)&s_result_1b(22)&s_result_1b(23)
            &s_result_1b(24)&s_result_1b(25)&s_result_1b(26)&s_result_1b(27)&s_result_1b(28)&s_result_1b(29)&s_result_1b(30)&s_result_1b(31) when '1',
            s_result_1b when others;

end mixed;