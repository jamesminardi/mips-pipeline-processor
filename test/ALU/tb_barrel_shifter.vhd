-- tb_barrel_shifter.vhd
-------------------------------------------------------------------------
-- TETS: 4 (400ns)
-- REQUIRES: MIPS_types.vhd, barrel_shifter.vhd
-------------------------------------------------------------------------

-- library declaration
library IEEE;
use IEEE.std_logic_1164.all;

-- constants & types declaration
library work;
use work.MIPS_types.all;

entity tb_barrel_shifter is
end tb_barrel_shifter;
    
architecture behavior of tb_barrel_shifter is
    component barrel_shifter is
        port(
            iA : in std_logic_vector(DATA_WIDTH - 1 downto 0);
            iLeft : in std_logic;
            iArithmetic : in std_logic;
            iShamt : in std_logic_vector(DATA_SELECT - 1 downto 0);
            oResult : out std_logic_vector(DATA_WIDTH - 1 downto 0));
    end component;

signal s_iA : std_logic_vector(DATA_WIDTH-1 downto 0);
signal s_iLeft : std_logic;
signal s_iArithmetic : std_logic;
signal s_iShamt : std_logic_vector(DATA_SELECT-1 downto 0);
signal s_oResult : std_logic_vector(DATA_WIDTH-1 downto 0);


begin
    DUT: barrel_shifter
    port map(
        iA => s_iA,
        iLeft => s_iLeft,
        iArithmetic => s_iArithmetic,
        iShamt => s_iShamt,
        oResult => s_oResult);
    
    P_TB: process
    begin


------------------------ SHIFT RIGHT ARITHMETIC ------------------------

-- Test shift right arithmetic (0-1)
        s_iA <= x"80000000";
        s_iLeft <= '0';
        s_iArithmetic <= '1';
        s_iShamt <= "00000"; -- Shift 0
        -- Expected:
        --  oResult = x"80000000"
        wait for 100 ns;

-- Test shift right arithmetic (1-2)
        s_iA <= x"80000000";
        s_iLeft <= '0';
        s_iArithmetic <= '1';
        s_iShamt <= "00001"; -- Shift 1
        -- Expected:
        --  oResult = x"C0000000"
        wait for 100 ns;

-- Test shift right arithmetic (2-3)
        s_iA <= x"80000000";
        s_iLeft <= '0';
        s_iArithmetic <= '1';
        s_iShamt <= "00010"; -- Shift 2
        -- Expected:
        --  oResult = x"E0000000"
        wait for 100 ns;

-- Test shift right arithmetic (3-4)
        s_iA <= x"80000000";
        s_iLeft <= '0';
        s_iArithmetic <= '1';
        s_iShamt <= "00100"; -- Shift 4
        -- Expected:
        --  oResult = x"F8000000"
        wait for 100 ns;

-- Test shift right arithmetic (4-5)
        s_iA <= x"80000000";
        s_iLeft <= '0';
        s_iArithmetic <= '1';
        s_iShamt <= "01000"; -- Shift 8
        -- Expected:
        --  oResult = x"FF800000"
        wait for 100 ns;

-- Test shift right arithmetic (5-6)
        s_iA <= x"80000000";
        s_iLeft <= '0';
        s_iArithmetic <= '1';
        s_iShamt <= "10000"; -- Shift 16
        -- Expected:
        --  oResult = x"FFFF8000"
        wait for 100 ns;


------------------------ SHIFT RIGHT LOGICAL ------------------------

-- Test shift right logical (0 bit) 6-7
        s_iA <= x"80000000";
        s_iLeft <= '0';
        s_iArithmetic <= '0';
        s_iShamt <= "00000"; -- Shift 0
        -- Expected:
        --  oResult = x"80000000"
        wait for 100 ns;

-- Test shift right logical (1 bit) 7-8
        s_iA <= x"80000000";
        s_iLeft <= '0';
        s_iArithmetic <= '0';
        s_iShamt <= "00001"; -- Shift 1
        -- Expected:
        --  oResult = x"40000000"
        wait for 100 ns;

-- Test shift right logical (2 bit) 8-9
        s_iA <= x"80000000";
        s_iLeft <= '0';
        s_iArithmetic <= '0';
        s_iShamt <= "00010"; -- Shift 2
        -- Expected:
        --  oResult = x"20000000"
        wait for 100 ns;

-- Test shift right logical (4 bit) 9-10
        s_iA <= x"80000000";
        s_iLeft <= '0';
        s_iArithmetic <= '0';
        s_iShamt <= "00100"; -- Shift 4
        -- Expected:
        --  oResult = x"080000000"
        wait for 100 ns;

-- Test shift right logical (8 bit) 10-11
        s_iA <= x"80000000";
        s_iLeft <= '0';
        s_iArithmetic <= '0';
        s_iShamt <= "01000"; -- Shift 8
        -- Expected:
        --  oResult = x"00800000"
        wait for 100 ns;

-- Test shift right logical (16 bit) 11-12
        s_iA <= x"80000000";
        s_iLeft <= '0';
        s_iArithmetic <= '0';
        s_iShamt <= "10000"; -- Shift 16
        -- Expected:
        --  oResult = x"00008000"
        wait for 100 ns;


------------------------ SHIFT LEFT LOGICAL ------------------------

-- Test shift left logical (0 bit) 12-13
        s_iA <= x"00000001";
        s_iLeft <= '1';
        s_iArithmetic <= '0';
        s_iShamt <= "00000"; -- Shift 0
        -- Expected:
        --  oResult = x"00000001"
        wait for 100 ns;


-- Test shift left logical (1 bit) 13-14
        s_iA <= x"00000001";
        s_iLeft <= '1';
        s_iArithmetic <= '0';
        s_iShamt <= "00001"; -- Shift 1
        -- Expected:
        --  oResult = x"00000002"
        wait for 100 ns;

-- Test shift left logical (2 bit) 14-15
        s_iA <= x"00000001";
        s_iLeft <= '1';
        s_iArithmetic <= '0';
        s_iShamt <= "00010"; -- Shift 2
        -- Expected:
        --  oResult = x"00000004"
        wait for 100 ns;

-- Test shift left logical (4 bit) 15-16
        s_iA <= x"00000001";
        s_iLeft <= '1';
        s_iArithmetic <= '0';
        s_iShamt <= "00100"; -- Shift 4
        -- Expected:
        --  oResult = x"00000010"
        wait for 100 ns;

-- Test shift left logical (8 bit) 16-17
        s_iA <= x"00000001";
        s_iLeft <= '1';
        s_iArithmetic <= '0';
        s_iShamt <= "01000"; -- Shift 8
        -- Expected:
        --  oResult = x"00000100"
        wait for 100 ns;


-- Test shift left logical (16 bit) 17-18
        s_iA <= x"00000001";
        s_iLeft <= '1';
        s_iArithmetic <= '0';
        s_iShamt <= "10000"; -- Shift 16
        -- Expected:
        --  oResult = x"00010000"
        wait for 100 ns;



    end process;

end behavior;
