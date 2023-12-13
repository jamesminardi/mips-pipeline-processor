-------------------------------------------------------------------------
-- James Minardi
-- tb_dmem.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a simple VHDL testbench for memory
-------------------------------------------------------------------------

-- library declaration
library IEEE;
use IEEE.std_logic_1164.all;

-- entity
entity tb_dmem is  
    generic(gCLK_HPER : time := 50 ns;
            DATA_WIDTH : natural := 32;
            ADDR_WIDTH : natural := 10);
end tb_dmem;

architecture tb of tb_dmem is


    

    constant cCLK_PER : time := gCLK_HPER * 2;

    component dmem is  

        generic (DATA_WIDTH : natural := 32;
		        ADDR_WIDTH : natural := 10);
        port (
            clk : in std_logic;
            addr : in std_logic_vector(ADDR_WIDTH -1 downto 0);
            data : in std_logic_vector(DATA_WIDTH -1 downto 0);
            we : in std_logic := '1';
            q : out std_logic_vector(DATA_WIDTH -1 downto 0));
    end component;

signal CLK : std_logic := '0';

signal s_addr : std_logic_vector(ADDR_WIDTH-1 downto 0) := (others => '0');
signal s_data : std_logic_vector(DATA_WIDTH-1 downto 0) := (others => '0');
signal s_we : std_logic := '0';
signal s_q : std_logic_vector(DATA_WIDTH-1 downto 0) := (others => '0');

begin
DUT: dmem
    port map (
        clk => CLK,
        addr => s_addr,
        data => s_data,
        we => s_we,
        q => s_q);
P_CLK: process
begin
    CLK <= '1';
    wait for gCLK_HPER;
    CLK <= '0';
    wait for gCLK_HPER;
end process;
  
P_TB: process
begin 
    --wait for gCLK_HPER/2;


-- Read initial 10 values stored in memory
-- Write values to 0x100 in order and read them back
-- Test 1:
    s_addr <= "0000000000"; -- Read data from 0x0
    s_data <= (others => '0');
    s_we <= '0';
    wait for gCLK_HPER*2;
    s_addr <= "0100000000"; -- Write data at 0x0 to 0x100
    s_data <= s_q;
    s_we <= '1';
    wait for gCLK_HPER*2;


-- Test 2:
    s_addr <= "0000000001"; -- Read data from 0x001
    s_data <= (others => '0');
    s_we <= '0';
    wait for gCLK_HPER*2;
    s_addr <= "0100000001"; -- Write data at 0x001 to 0x101
    s_data <= s_q;
    s_we <= '1';
    wait for gCLK_HPER*2;


-- Test 3:
    s_addr <= "0000000010"; -- Read data from memory
    s_data <= (others => '0');
    s_we <= '0';
    wait for gCLK_HPER*2;
    s_addr <= "0100000010"; -- Write that data to 0x102
    s_data <= s_q;
    s_we <= '1';
    wait for gCLK_HPER*2;


-- Test 4:
    s_addr <= "0000000011"; -- Read data from memory
    s_data <= (others => '0');
    s_we <= '0';
    wait for gCLK_HPER*2;
    s_addr <= "0100000011"; -- Write that data to 0x103
    s_data <= s_q;
    s_we <= '1';
    wait for gCLK_HPER*2;


-- Test 5:
    s_addr <= "0000000100"; -- Read data from memory
    s_data <= (others => '0');
    s_we <= '0';
    wait for gCLK_HPER*2;
    s_addr <= "0100000100"; -- Write that data to 0x104
    s_data <= s_q;
    s_we <= '1';
    wait for gCLK_HPER*2;



-- Test 6:
    s_addr <= "0000000101"; -- Read data from memory
    s_data <= (others => '0');
    s_we <= '0';
    wait for gCLK_HPER*2;
    s_addr <= "0100000101"; -- Write that data to 0x105
    s_data <= s_q;
    s_we <= '1';
    wait for gCLK_HPER*2;


-- Test 7:
    s_addr <= "0000000110"; -- Read data from memory
    s_data <= (others => '0');
    s_we <= '0';
    wait for gCLK_HPER*2;
    s_addr <= "0100000110"; -- Write that data to 0x106
    s_data <= s_q;
    s_we <= '1';
    wait for gCLK_HPER*2;


-- Test 8:
    s_addr <= "0000000111"; -- Read data from memory
    s_data <= (others => '0');
    s_we <= '0';
    wait for gCLK_HPER*2;
    s_addr <= "0100000111"; -- Write that data to 0x107
    s_data <= s_q;
    s_we <= '1';
    wait for gCLK_HPER*2;


-- Test 9:
    s_addr <= "0000001000"; -- Read data from memory
    s_data <= (others => '0');
    s_we <= '0';
    wait for gCLK_HPER*2;
    s_addr <= "0100001000"; -- Write that data to 0x108
    s_data <= s_q;
    s_we <= '1';
    wait for gCLK_HPER*2;


-- Test 10:
    s_addr <= "0000001001"; -- Read data from memory
    s_data <= (others => '0');
    s_we <= '0';
    wait for gCLK_HPER*2;
    s_addr <= "0100001001"; -- Write that data to 0x109
    s_data <= s_q;
    s_we <= '1';
    wait for gCLK_HPER*2;



-- Test All
    

    s_addr <= "0100000000"; -- Read data at 0x100
    s_data <= (others => '0');
    s_we <= '0';
    wait for gCLK_HPER*2;
    -- s_q = data from 0x100 (-1)

    s_addr <= "0100000001"; -- Read data at 0x101
    s_data <= (others => '0');
    s_we <= '0';
    wait for gCLK_HPER*2;
    -- s_q = data from 0x101 (2)

    s_addr <= "0100000010"; -- Read to double check
    s_data <= (others => '0');
    s_we <= '0';
    wait for gCLK_HPER*2;
    -- s_q = data from 0x102 (-3)

    s_addr <= "0100000011"; -- Read to double check
    s_data <= (others => '0');
    s_we <= '0';
    wait for gCLK_HPER*2;
    -- s_q = data from 0x103 (4)

    s_addr <= "0100000100"; -- Read to double check
    s_data <= (others => '0');
    s_we <= '0';
    wait for gCLK_HPER*2;
    -- s_q = data from 0x104 (5)

    s_addr <= "0100000101"; -- Read to double check
    s_data <= (others => '0');
    s_we <= '0';
    wait for gCLK_HPER*2;
    -- s_q = data from 0x105 (6)

    s_addr <= "0100000110"; -- Read to double check
    s_data <= (others => '0');
    s_we <= '0';
    wait for gCLK_HPER*2;
    -- s_q = data from 0x106 (-7)

    s_addr <= "0100000111"; -- Read to double check
    s_data <= (others => '0');
    s_we <= '0';
    wait for gCLK_HPER*2;
    -- s_q = data from 0x107 (-8)

    s_addr <= "0100001000"; -- Read to double check
    s_data <= (others => '0');
    s_we <= '0';
    wait for gCLK_HPER*2;
    -- s_q = datda from 0x108 (9)


    s_addr <= "0100001001"; -- Read to double check
    s_data <= (others => '0');
    s_we <= '0';
    wait for gCLK_HPER*2;
    -- s_q = data from 0x109 (-10)


end process;
end tb;