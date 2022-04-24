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

			i_Rd		: in std_logic_vector(DATA_SELECT - 1 downto 0);
			i_ReadRs	: in std_logic_vector(N-1 downto 0); --------
			i_ReadRt	: in std_logic_vector(N-1 downto 0);	-- Read Rt
			i_PCPlus4	: in std_logic_vector(N-1 downto 0);	-- PC + 4
			i_MemWrite 	: in std_logic;
			i_MemRead 	: in std_logic;
			i_MemtoReg	: in std_logic_vector(MEMTOREG_WIDTH - 1 downto 0);
			i_RegWrite	: in std_logic;
			i_Movn		: in std_logic;
			i_Halt 		: in std_logic;
			i_Branch	: in std_logic;
			i_BranchEQ	: in std_logic;
			i_JumpReg	: in std_logic;
			i_Jump		: in std_logic;
			i_JumpImm	: in std_logic_vector(JADDR_WIDTH-1 downto 0);
			i_Zero		: in std_logic;
			i_Imm32		: in std_logic_vector(N-1 downto 0);	-- Immediate (32b)
			i_ALUResult : in std_logic_vector(N-1 downto 0);


			o_Rd		: out std_logic_vector(DATA_SELECT - 1 downto 0);
			o_ReadRs	: out std_logic_vector(N-1 downto 0); --------
			o_ReadRt	: out std_logic_vector(N-1 downto 0);
			o_PCPlus4	: out std_logic_vector(N-1 downto 0);
			o_MemWrite 	: out std_logic;
			o_MemRead 	: out std_logic;
			o_MemtoReg 	: out std_logic_vector(MEMTOREG_WIDTH - 1 downto 0);
			o_RegWrite 	: out std_logic;
			o_Movn 		: out std_logic;
			o_Halt 		: out std_logic;
			o_Branch	: out std_logic;
			o_BranchEQ	: out std_logic;
			o_JumpReg	: out std_logic;
			o_Jump		: out std_logic;
			o_JumpImm	: out std_logic_vector(JADDR_WIDTH-1 downto 0);
			o_Zero		: out std_logic;
			o_Imm32		: out std_logic_vector(N-1 downto 0);	-- Immediate (32b)
			o_ALUResult : out std_logic_vector(N-1 downto 0));
end EXMEM_reg;

architecture behavior of EXMEM_reg is

	component dffg is
		port(
			i_CLK        : in std_logic;     -- Clock input
			i_RST        : in std_logic;     -- Reset input
			i_WE		 : in std_logic;	 -- Write enable
       		i_D          : in std_logic;     -- Data value input
       		o_Q          : out std_logic);   -- Data value output
	end component;

begin

	-- Rd
	g_Rd: for i in 0 to DATA_SELECT - 1 generate
	Rd_i: dffg
			--generic map (N => N)
			port map (
				i_CLK	=> i_CLK,
				i_RST	=> i_RST,
				i_WE	=> i_WE,
				i_D		=> i_Rd(i),
				o_Q		=> o_Rd(i));
	end generate g_Rd;

	-- ReadRs
	g_ReadRs: for i in 0 to N-1 generate
		ReadRs_i: dffg
			--generic map (N => N)
			port map (
				i_CLK	=> i_CLK,
				i_RST	=> i_RST,
				i_WE	=> i_WE,
				i_D		=> i_ReadRs(i),
				o_Q		=> o_ReadRs(i));
	end generate g_ReadRs;

	-- Imm32
	g_Imm32: for i in 0 to N-1 generate
	Imm32_i: dffg
			--generic map (N => N)
			port map (
				i_CLK	=> i_CLK,
				i_RST	=> i_RST,
				i_WE	=> i_WE,
				i_D		=> i_Imm32(i),
				o_Q		=> o_Imm32(i));
	end generate g_Imm32;

	-- ReadRt
	g_ReadRt: for i in 0 to N-1 generate
		ReadRt_i: dffg
			--generic map (N => N)
			port map (
				i_CLK	=> i_CLK,
				i_RST	=> i_RST,
				i_WE	=> i_WE,
				i_D		=> i_ReadRt(i),
				o_Q		=> o_ReadRt(i));
	end generate g_ReadRt;

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

	-- MemWrite
	g_MemWrite: for i in 0 to 1-1 generate
	MemWrite_i: dffg
			--generic map (N => 1)
			port map (
				i_CLK	=> i_CLK,
				i_RST	=> i_RST,
				i_WE	=> i_WE,
				i_D		=> i_MemWrite,
				o_Q		=> o_MemWrite);
	end generate g_MemWrite;

	-- MemRead
	g_MemRead: for i in 0 to 1-1 generate
	MemRead_i: dffg
			--generic map (N => 1)
			port map (
				i_CLK	=> i_CLK,
				i_RST	=> i_RST,
				i_WE	=> i_WE,
				i_D		=> i_MemRead,
				o_Q		=> o_MemRead);
	end generate g_MemRead;

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

	-- Movn
	g_Movn: for i in 0 to 1-1 generate
	Movn_i: dffg
			--generic map (N => 1)
			port map (
				i_CLK	=> i_CLK,
				i_RST	=> i_RST,
				i_WE	=> i_WE,
				i_D		=> i_Movn,
				o_Q		=> o_Movn);
	end generate g_Movn;

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

	-- Branch
	g_Branch: for i in 0 to 1-1 generate
	Branch_i: dffg
			--generic map (N => 1)
			port map (
				i_CLK	=> i_CLK,
				i_RST	=> i_RST,
				i_WE	=> i_WE,
				i_D		=> i_Branch,
				o_Q		=> o_Branch);
	end generate g_Branch;

	-- BranchEq
	g_BranchEq: for i in 0 to 1-1 generate
	BranchEq_i: dffg
			--generic map (N => 1)
			port map (
				i_CLK	=> i_CLK,
				i_RST	=> i_RST,
				i_WE	=> i_WE,
				i_D		=> i_BranchEq,
				o_Q		=> o_BranchEq);
	end generate g_BranchEq;

	-- JumpReg
	g_JumpReg: for i in 0 to 1-1 generate
	JumpReg_i: dffg
			--generic map (N => 1)
			port map (
				i_CLK	=> i_CLK,
				i_RST	=> i_RST,
				i_WE	=> i_WE,
				i_D		=> i_JumpReg,
				o_Q		=> o_JumpReg);
	end generate g_JumpReg;

	-- Jump
	g_Jump: for i in 0 to 1-1 generate
	Jump_i: dffg
			--generic map (N => 1)
			port map (
				i_CLK	=> i_CLK,
				i_RST	=> i_RST,
				i_WE	=> i_WE,
				i_D		=> i_Jump,
				o_Q		=> o_Jump);
	end generate g_Jump;
	
	-- JumpImm
	g_JumpImm: for i in 0 to JADDR_WIDTH-1 generate
	JumpImm_i: dffg
			--generic map (N => JADDR_WIDTH)
			port map (
				i_CLK	=> i_CLK,
				i_RST	=> i_RST,
				i_WE	=> i_WE,
				i_D		=> i_JumpImm(i),
				o_Q		=> o_JumpImm(i));
	end generate g_JumpImm;

	-- Zero
	g_Zero: for i in 0 to 1-1 generate
	Zero_i: dffg
			--generic map (N => 1)
			port map (
				i_CLK	=> i_CLK,
				i_RST	=> i_RST,
				i_WE	=> i_WE,
				i_D		=> i_Zero,
				o_Q		=> o_Zero);
	end generate g_Zero;


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
