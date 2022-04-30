library IEEE;
use IEEE.std_logic_1164.all;

-- constants & types declaration
library work;
use work.MIPS_types.all;

entity MEMWB_reg is
	generic(N : integer := 32);
		port(
			i_CLK		: in std_logic;	-- Clock input
			i_RST		: in std_logic;	-- Reset input
			i_WE		: in std_logic;	-- Write enable

			i_Rd		: in std_logic_vector(DATA_SELECT - 1 downto 0);
			i_PCPlus4	: in std_logic_vector(N-1 downto 0);	-- PC + 4
			i_MemtoReg	: in std_logic_vector(MEMTOREG_WIDTH - 1 downto 0);
			i_DMemOut	: in std_logic_vector(N-1 downto 0);
			i_RegWrite	: in std_logic;
			i_Halt 		: in std_logic;
			i_ALUResult : in std_logic_vector(N-1 downto 0);
			i_Ovfl		: in std_logic;
			o_Ovfl		: out std_logic;

			o_Rd		: out std_logic_vector(DATA_SELECT - 1 downto 0);
			o_PCPlus4	: out std_logic_vector(N-1 downto 0);
			o_MemtoReg 	: out std_logic_vector(MEMTOREG_WIDTH - 1 downto 0);
			o_DMemOut	: out std_logic_vector(N-1 downto 0);
			o_RegWrite 	: out std_logic;
			o_Halt 		: out std_logic;
			o_ALUResult : out std_logic_vector(N-1 downto 0));
end MEMWB_reg;

architecture behavior of MEMWB_reg is

	component dffg is
		--generic(N : integer := 32);
		port(
			i_CLK        : in std_logic;     -- Clock input
			i_RST        : in std_logic;     -- Reset input
			i_WE		 : in std_logic;	 -- Write enable
       		i_D          : in std_logic;     -- Data value input
       		o_Q          : out std_logic);   -- Data value output
	end component;

begin

	-- Ovfl
	g_Ovfl: for i in 0 to 1-1 generate
	Ovfl_i: dffg
			--generic map (N => 1)
			port map (
				i_CLK	=> i_CLK,
				i_RST	=> i_RST,
				i_WE	=> i_WE,
				i_D		=> i_Ovfl,
				o_Q		=> o_Ovfl);
	end generate g_Ovfl;


	-- Rd
	g_Rd: for i in 0 to DATA_SELECT-1 generate
	Rd_i: dffg
			--generic map (N => DATA_SELECT)
			port map (
				i_CLK	=> i_CLK,
				i_RST	=> i_RST,
				i_WE	=> i_WE,
				i_D		=> i_Rd(i),
				o_Q		=> o_Rd(i));
	end generate g_Rd;


	-- PCPlus4
	g_PCPlus4: for i in 0 to N-1 generate
	PCPlus4_i: dffg
			--generic map (N => N)
			port map (
				i_CLK	=> i_CLK,
				i_RST	=> i_RST,
				i_WE	=> i_WE,
				i_D		=> i_PCPlus4(i),
				o_Q		=> o_PCPlus4(i));
	end generate g_PCPlus4;

	-- MemtoReg
	g_MemtoReg: for i in 0 to MEMTOREG_WIDTH-1 generate
	MemtoReg_i: dffg
			--generic map (N => MEMTOREG_WIDTH)
			port map (
				i_CLK	=> i_CLK,
				i_RST	=> i_RST,
				i_WE	=> i_WE,
				i_D		=> i_MemtoReg(i),
				o_Q		=> o_MemtoReg(i));
	end generate g_MemtoReg;


	-- DMemOut
	g_DMemOut: for i in 0 to N-1 generate
	DMemOut_i: dffg
			--generic map (N => N)
			port map (
				i_CLK	=> i_CLK,
				i_RST	=> i_RST,
				i_WE	=> i_WE,
				i_D		=> i_DMemOut(i),
				o_Q		=> o_DMemOut(i));
	end generate g_DMemOut;

	-- RegWrite
	g_RegWrite: for i in 0 to 1-1 generate
	RegWrite_i: dffg
			--generic map (N => 1)
			port map (
				i_CLK	=> i_CLK,
				i_RST	=> i_RST,
				i_WE	=> i_WE,
				i_D		=> i_RegWrite,
				o_Q		=> o_RegWrite);
	end generate g_RegWrite;

	-- Halt
	g_Halt: for i in 0 to 1-1 generate
	Halt_i: dffg
			--generic map (N => 1)
			port map (
				i_CLK	=> i_CLK,
				i_RST	=> i_RST,
				i_WE	=> i_WE,
				i_D		=> i_Halt,
				o_Q		=> o_Halt);
	end generate g_Halt;


	-- ALUResult
	g_ALUResult: for i in 0 to N-1 generate
	ALUResult_i: dffg
			--generic map (N => N)
			port map (
				i_CLK	=> i_CLK,
				i_RST	=> i_RST,
				i_WE	=> i_WE,
				i_D		=> i_ALUResult(i),
				o_Q		=> o_ALUResult(i));
	end generate g_ALUResult;
end behavior;
