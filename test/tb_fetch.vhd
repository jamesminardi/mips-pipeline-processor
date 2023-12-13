-- library declaration
library IEEE;
use IEEE.std_logic_1164.all;

-- constants & types declaration
library work;
use work.MIPS_types.all;

entity tb_fetch is
end tb_fetch;
    
architecture behavior of tb_fetch is
	component fetch is
		port(
			i_Addr   	: in std_logic_vector(DATA_WIDTH - 1 downto 0); --input address
			i_Jump   	: in std_logic; --input 0 or 1 for jump or not jump
			i_JumpReg 	: in std_logic; -- jump reg instr or not
			i_JumpRegData:in std_logic_vector(DATA_WIDTH - 1 downto 0);
			i_Branch   	: in std_logic; --input 0 or 1 for branch or not branch
			i_Zero   	: in std_logic;
			i_BEQ   	: in std_logic; --1 = Beq, 0 = Bne
			i_BranchImm	: in std_logic_vector(DATA_WIDTH - 1 downto 0);
			i_JumpImm  	: in std_logic_vector(JADDR_WIDTH - 1 downto 0);
			o_Addr   	: out std_logic_vector(DATA_WIDTH - 1 downto 0); --output address
			o_PCPlus4	: out std_logic_vector(DATA_WIDTH - 1 downto 0));
	end component;

signal s_iAddr 			: std_logic_vector(DATA_WIDTH - 1 downto 0);
signal s_iJump 			: std_logic;
signal S_iJumpReg 		: std_logic;
signal s_iJumpRegData 	: std_logic_vector(DATA_WIDTH - 1 downto 0);
signal s_iBranch 		: std_logic;
signal s_iZero 			: std_logic;
signal s_iBEQ 			: std_logic;
signal s_iBranchImm 	: std_logic_vector(DATA_WIDTH - 1 downto 0);
signal s_iJumpImm 		: std_logic_vector(JADDR_WIDTH - 1 downto 0);
signal s_oAdder 		: std_logic_vector(DATA_WIDTH - 1 downto 0);
signal s_oPCPlus4 		: std_logic_vector(DATA_WIDTH - 1 downto 0);



begin
	DUT: fetch
	port map (
		i_Addr   		=> s_iAddr,
		i_Jump   		=> s_iJump,
		i_JumpReg 		=> S_iJumpReg,
		i_JumpRegData	=> s_iJumpRegData,
		i_Branch   		=> s_iBranch,
		i_Zero   		=> s_iZero,
		i_BEQ   		=> s_iBEQ,
		i_BranchImm		=> s_iBranchImm,
		i_JumpImm  		=> s_iJumpImm,
		o_Addr   		=> s_oAdder,
		o_PCPlus4		=> s_oPCPlus4);

P_TB: process
begin

------------------------ PC+4 ------------------------
-- Test normal pc+4 0-1
	s_iAddr 		<= x"00000000";
	s_iJump 		<= '0';
	S_iJumpReg 		<= '0';
	s_iJumpRegData 	<= x"AAAAAAAA";
	s_iBranch 		<= '0';
	s_iZero 		<= '0';
	s_iBEQ 			<= '0';
	s_iBranchImm 	<= x"0000FFFF";
	s_iJumpImm 		<= "00000000000000000010101111";
	-- PCPlus4 	= x"00000004"
	-- Addr 	= x"00000004"
	wait for 100 ns;

-- Test normal pc+4 1-2
	s_iAddr 		<= x"FF000000";
	s_iJump 		<= '0';
	S_iJumpReg 		<= '0';
	s_iJumpRegData 	<= x"AAAAAAAA";
	s_iBranch 		<= '0';
	s_iZero 		<= '0';
	s_iBEQ 			<= '0';
	s_iBranchImm 	<= x"0000FFFF";
	s_iJumpImm 		<= "00000000000000000010101111";
	-- PCPlus4 	= x"FF000004"
	-- Addr 	= x"FF000004"
	wait for 100 ns;

-- Test branch does not execute when mismatched zero and beq 2-3
	s_iAddr 		<= x"FF000000";
	s_iJump 		<= '0';
	S_iJumpReg 		<= '0';
	s_iJumpRegData 	<= x"AAAAAAAA";
	s_iBranch 		<= '1';
	s_iZero 		<= '0';
	s_iBEQ 			<= '1';
	s_iBranchImm 	<= x"0000FFFF";
	s_iJumpImm 		<= "00000000000000000010101111";
	-- PCPlus4 	= x"FF000004"
	-- Addr 	= x"FF000004"
	wait for 100 ns;

-- Test branch does not execute when mismatched zero and beq 3-4
	s_iAddr 		<= x"FF000000";
	s_iJump 		<= '0';
	S_iJumpReg 		<= '0';
	s_iJumpRegData 	<= x"AAAAAAAA";
	s_iBranch 		<= '1';
	s_iZero 		<= '1';
	s_iBEQ 			<= '0';
	s_iBranchImm 	<= x"0000FFFF";
	s_iJumpImm 		<= "00000000000000000010101111";
	-- PCPlus4 	= x"FF000004"
	-- Addr 	= x"FF000004"
	wait for 100 ns;

------------------------ Branch ------------------------
-- Test branch eq 4-5
	s_iAddr 		<= x"F0000004";
	s_iJump 		<= '0';
	S_iJumpReg 		<= '0';
	s_iJumpRegData 	<= x"AAAAAAAA";
	s_iBranch 		<= '1';
	s_iZero 		<= '1';
	s_iBEQ 			<= '1';
	s_iBranchImm 	<= x"00003FF0"; -- 0011 1111 1111 1100 -> 1111 1111 1100 0000
	s_iJumpImm 		<= "00000000000000000010101111";
	-- PCPlus4 	= x"00000008"
	-- Addr 	= x"F000FFC8"
	wait for 100 ns;

-- Test branch not eq 5-6
	s_iAddr 		<= x"F0000004";
	s_iJump 		<= '0';
	S_iJumpReg 		<= '0';
	s_iJumpRegData 	<= x"AAAAAAAA";
	s_iBranch 		<= '1';
	s_iZero 		<= '0';
	s_iBEQ 			<= '0';
	s_iBranchImm 	<= x"00003FF0";
	s_iJumpImm 		<= "00000000000000000010101111";
	-- PCPlus4 	= x"F0000008"
	-- Addr 	= x"F000FFC8"
	wait for 100 ns;

------------------------ Jump ------------------------
-- Test jump 6-7
s_iAddr 		<= x"F0000004";
s_iJump 		<= '1';
S_iJumpReg 		<= '0';
s_iJumpRegData 	<= x"AAAAAAAA";
s_iBranch 		<= '0';
s_iZero 		<= '0';
s_iBEQ 			<= '0';
s_iBranchImm 	<= x"0000FFFB";
s_iJumpImm 		<= "00000000000000000010101111"; -- 10 1011 1100
-- PCPlus4 	= x"F0000008"
-- Addr 	= x"F00002BC"
wait for 100 ns;


------------------------ JumpReg ------------------------
-- Test jumpreg 7-8
s_iAddr 		<= x"F0000004";
s_iJump 		<= '0';
S_iJumpReg 		<= '1';
s_iJumpRegData 	<= x"AAAAAAAA"; -- 1010 1010 1010 1010 1010 1010 1010 1010
s_iBranch 		<= '0';
s_iZero 		<= '0';
s_iBEQ 			<= '0';
s_iBranchImm 	<= x"0000FFFB";
s_iJumpImm 		<= "00000000000000000010101111"; -- 10 1011 1100
-- PCPlus4 	= x"F0000008"
-- Addr 	= x"AAAAAAAA"
wait for 100 ns;

end process;
end behavior;