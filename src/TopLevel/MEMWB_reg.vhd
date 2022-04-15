library IEEE;
use IEEE.std_logic_1164.all;

-- constants & types declaration
library work;
use work.MIPS_types.all;

entity EXMEM_reg is
	generic(N : integer := 32);
		port(
			i_CLK		: in std_logic;	-- Clock input
			i_RST		: in std_logic;	-- Reset input
			i_WE		: in std_logic;	-- Write enable

			i_PCPlus4	: in std_logic_vector(N-1 downto 0);	-- PC + 4
			i_MemtoReg	: in std_logic_vector(MEMTOREG_WIDTH - 1 downto 0);
			i_RegWrite	: in std_logic;
			i_RegDst	: in std_logic_vector(REGDST_WIDTH - 1 downto 0);
			i_Movn		: in std_logic;
			--i_Jal		: in std_logic; -- Not needed?
			i_Halt 		: in std_logic;

			o_PCPlus4	: out std_logic_vector(N-1 downto 0);
			o_MemtoReg 	: out std_logic_vector(MEMTOREG_WIDTH - 1 downto 0);
			o_RegWrite 	: out std_logic;
			o_RegDst 	: out std_logic_vector(REGDST_WIDTH - 1 downto 0);
			o_Movn 		: out std_logic;
			--o_Jal 	: out std_logic;
			o_Halt 		: out std_logic);
end EXMEM_reg;

architecture behavior of EXMEM_reg is

	component dffg_N is
		generic(N : integer := 32);
		port(
			i_CLK        : in std_logic;     -- Clock input
			i_RST        : in std_logic;     -- Reset input
			i_WE		 : in std_logic;	 -- Write enable
       		i_D          : in std_logic;     -- Data value input
       		o_Q          : out std_logic);   -- Data value output
	end component;

begin

	-- PCPlus4
	g_PCPlus4: for i in 0 to N-1 generate
	PCPlus4_i: dffg_N
			generic map (N => N)
			port map (
				i_CLK	=> i_CLK,
				i_RST	=> i_RST,
				i_WE	=> i_WE,
				i_D		=> i_PCPlus4(i),
				o_Q		=> o_PCPlus4(i));
	end generate g_PCPlus4;

	-- MemtoReg
	g_MemtoReg: for i in 0 to MEMTOREG_WIDTH-1 generate
	MemtoReg_i: dffg_N
			generic map (N => MEMTOREG_WIDTH)
			port map (
				i_CLK	=> i_CLK,
				i_RST	=> i_RST,
				i_WE	=> i_WE,
				i_D		=> i_MemtoReg(i),
				o_Q		=> o_MemtoReg(i));
	end generate g_MemtoReg;

	-- RegWrite
	g_RegWrite: for i in 0 to 1-1 generate
	RegWrite_i: dffg_N
			generic map (N => 1)
			port map (
				i_CLK	=> i_CLK,
				i_RST	=> i_RST,
				i_WE	=> i_WE,
				i_D		=> i_RegWrite,
				o_Q		=> o_RegWrite);
	end generate g_RegWrite;

	-- RegDst
	g_RegDst: for i in 0 to REGDST_WIDTH-1 generate
	RegDst_i: dffg_N
			generic map (N => REGDST_WIDTH)
			port map (
				i_CLK	=> i_CLK,
				i_RST	=> i_RST,
				i_WE	=> i_WE,
				i_D		=> i_RegDst(i),
				o_Q		=> o_RegDst(i));
	end generate g_RegDst;

	-- Movn
	g_Movn: for i in 0 to 1-1 generate
	Movn_i: dffg_N
			generic map (N => 1)
			port map (
				i_CLK	=> i_CLK,
				i_RST	=> i_RST,
				i_WE	=> i_WE,
				i_D		=> i_Movn,
				o_Q		=> o_Movn);
	end generate g_Movn;

	-- -- Jal
	-- g_Jal: for i in 0 to 1-1 generate
	-- Jal_i: dffg_N
	-- 		generic map (N => 1)
	-- 		port map (
	-- 			i_CLK	=> i_CLK,
	-- 			i_RST	=> i_RST,
	-- 			i_WE	=> i_WE,
	-- 			i_D		=> i_Jal,
	-- 			o_Q		=> o_Jal);
	-- end generate g_Jal;

	-- Halt
	g_Halt: for i in 0 to 1-1 generate
	Halt_i: dffg_N
			generic map (N => 1)
			port map (
				i_CLK	=> i_CLK,
				i_RST	=> i_RST,
				i_WE	=> i_WE,
				i_D		=> i_Halt,
				o_Q		=> o_Halt);
	end generate g_Halt;
end behavior;
