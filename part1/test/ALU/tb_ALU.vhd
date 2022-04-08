-- library declaration
library IEEE;
use IEEE.std_logic_1164.all;

-- constants & types declaration
library work;
use work.MIPS_types.all;

entity tb_ALU is
end tb_ALU;
    
architecture behavior of tb_ALU is
    component ALU is
        port(
			iA 		: in std_logic_vector(DATA_WIDTH - 1 downto 0);
			iB 		: in std_logic_vector(DATA_WIDTH - 1 downto 0);
			iShamt 	: in std_logic_vector(DATA_SELECT - 1 downto 0);
			iALUOp 	: in std_logic_vector(ALU_OP_WIDTH - 1 downto 0);
			oResult : out std_logic_vector(DATA_WIDTH - 1 downto 0);
			oCout 	: out std_logic;
			oOverflow : out std_logic;
			oZero 	: out std_logic);
    end component;


signal s_iA 		: std_logic_vector(DATA_WIDTH   - 1 downto 0);
signal s_iB 		: std_logic_vector(DATA_WIDTH   - 1 downto 0);
signal s_iShamt 	: std_logic_vector(DATA_SELECT  - 1 downto 0);
signal s_iALUOp 	: std_logic_vector(ALU_OP_WIDTH - 1 downto 0);
signal s_oResult 	: std_logic_vector(DATA_WIDTH   - 1 downto 0);
signal s_oCout 		: std_logic;
signal s_oOverflow 	: std_logic;
signal s_oZero 		: std_logic;

begin
	DUT: ALU
	port map(
		iA		 	=> s_iA,
		iB		 	=> s_iB,
		iShamt	 	=> s_iShamt,
		iALUOp	 	=> s_iALUOp,
		oResult	 	=> s_oResult,
		oCout	 	=> s_oCout,
		oOverflow	=> s_oOverflow,
		oZero	 	=> s_oZero);

P_TB: process
begin

------------------------ ADD ------------------------
-- Test add signed action 0-1
	s_iA <= x"EEEEEEEE";
	s_iB <= x"11111111";
	s_iShamt <= "00000";
	s_iALUOp <= "0000";
	-- Result = x"FFFFFFFF"
	-- Ovfl = 0
	-- Zero = 0
	wait for 100 ns;

-- Test add signed action (overflow) 1-2
	s_iA <= x"7FFFFFFF";
	s_iB <= x"0000000F";
	s_iShamt <= "00000";
	s_iALUOp <= "0000";
	-- Result = x"8000000E"
	-- Ovfl = 1
	-- Zero = 0
	wait for 100 ns;

-- Test add signed action (overflow) 2-3
	s_iA <= x"FFFFFFFF";
	s_iB <= x"00000001";
	s_iShamt <= "00000";
	s_iALUOp <= "0000";
	-- Result = x"00000000"
	-- Ovfl = 0
	-- Zero = 1
	wait for 100 ns;

-- Test add unsigned action 3-4
s_iA <= x"EEEEEEEE";
s_iB <= x"11111111";
s_iShamt <= "00000";
s_iALUOp <= "0010";
-- Result = x"FFFFFFFF"
-- Ovfl = 0
-- Zero = 0
wait for 100 ns;

-- Test add unsigned action (overflow) 4-5
s_iA <= x"7FFFFFFF";
s_iB <= x"0000000F";
s_iShamt <= "00000";
s_iALUOp <= "0010";
-- Result = x8000000E
-- Ovfl = 0
-- Zero = 0
wait for 100 ns;

-- Test add unsigned action 5-6
s_iA <= x"FFFFFFFF";
s_iB <= x"00000001";
s_iShamt <= "00000";
s_iALUOp <= "0010";
-- Result = 00000000
-- Ovfl = 0
-- Zero = 1
wait for 100 ns;


------------------------ SUB ------------------------
-- Test sub signed sub overflow 6-7
s_iA <= x"80000000";
s_iB <= x"00000001";
s_iShamt <= "00000";
s_iALUOp <= "0001";
-- Result = x"7FFFFFFF"
-- Ovfl = 1
-- Zero = 0
wait for 100 ns;

-- Test sub unsigned sub 7-8
s_iA <= x"80000000";
s_iB <= x"00000001";
s_iShamt <= "00000";
s_iALUOp <= "0011";
-- Result = x"7FFFFFFF"
-- Ovfl = 0
-- Zero = 0
wait for 100 ns;


------------------------ SHIFT ------------------------
-- Test sll 8-9
s_iA <= x"AAAAAAAA";
s_iB <= x"FFFFFFFF";
s_iShamt <= "01111";
s_iALUOp <= "1000";
-- Result = x"FFFF8000"
-- Ovfl = 0
-- Zero = 1
wait for 100 ns;

-- Test srl 9-10
s_iA <= x"AAAAAAAA";
s_iB <= x"FFFFFFFF";
s_iShamt <= "01111";
s_iALUOp <= "1000";
-- Result = x"FFFF8000"
-- Ovfl = 0
-- Zero = 1
wait for 100 ns;

-- Test sra 10-11
s_iA <= x"AAAAAAAA";
s_iB <= x"F0000000";
s_iShamt <= "11000";
s_iALUOp <= "1011";
-- Result = x"FFFFFFFD"
-- Ovfl = 0
-- Zero = 1
wait for 100 ns;


------------------------ SLT ------------------------
-- Test slt normal not LT 11-12
s_iA <= x"00000009";
s_iB <= x"00000002";
s_iShamt <= "00000";
s_iALUOp <= "1101";
-- Result = x"00000000"
-- Ovfl = 0
-- Zero = 1
wait for 100 ns;

-- Test slt normal is LT 12-13
s_iA <= x"00000002";
s_iB <= x"00000009";
s_iShamt <= "00000";
s_iALUOp <= "1101";
-- Result = x"00000001"
-- Ovfl = 0
-- Zero = 0
wait for 100 ns;

-- Test slt overflow 13-14
s_iA <= x"80000000";
s_iB <= x"00000001";
s_iShamt <= "00000";
s_iALUOp <= "1101";
-- Result = x"00000001"
-- Ovfl = 0
-- Zero = 0
wait for 100 ns;

end process;
end behavior;