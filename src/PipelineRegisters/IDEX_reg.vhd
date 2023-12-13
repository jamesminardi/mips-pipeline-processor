library IEEE;
use IEEE.std_logic_1164.all;

-- constants & types declaration
library work;
use work.MIPS_types.all;

entity IDEX_reg is
	generic(N : integer := 32);
		port(
			i_CLK		: in std_logic;	-- Clock input
			i_RST		: in std_logic;	-- Reset input
			i_WE		: in std_logic;	-- Write enable

			i_ReadRs	: in std_logic_vector(N-1 downto 0);	-- Read Rs
			i_ReadRt	: in std_logic_vector(N-1 downto 0);	-- Read Rt
			i_Imm32		: in std_logic_vector(N-1 downto 0);	-- Immediate (32b)
			i_ALUSrc	: in std_logic; -- Choose ALU B to be immediate or Read Rt
			i_ALUOp		: in std_logic_vector(ALU_OP_WIDTH-1 downto 0);	-- Choose ALU instruction
			i_Shamt		: in std_logic_vector(DATA_SELECT-1 downto 0);
			i_MemWrite 	: in std_logic;
			i_MemRead 	: in std_logic;
			i_MemtoReg	: in std_logic_vector(MEMTOREG_WIDTH - 1 downto 0);
			i_RegWrite	: in std_logic;
			i_Movn		: in std_logic;
			i_Halt 		: in std_logic;
			i_PCPlus4 : in std_logic_vector(N-1 downto 0);
			
			i_Rd		: in std_logic_vector(DATA_SELECT-1 downto 0);
			i_Rs		: in std_logic_vector(DATA_SELECT-1 downto 0);
			i_Rt		: in std_logic_vector(DATA_SELECT-1 downto 0);
			
			o_Rd		: out std_logic_vector(DATA_SELECT-1 downto 0);
			o_Rs		: out std_logic_vector(DATA_SELECT-1 downto 0);
			o_Rt		: out std_logic_vector(DATA_SELECT-1 downto 0);

			o_ReadRs	: out std_logic_vector(N-1 downto 0);	-- Read Rs
			o_ReadRt	: out std_logic_vector(N-1 downto 0);	-- Read Rt
			o_PCPlus4 : out std_logic_vector(N-1 downto 0);
			o_Imm32		: out std_logic_vector(N-1 downto 0);	-- Immediate (32b)
			o_ALUSrc	: out std_logic; -- Choose ALU B to be immediate or Read Rt
			o_ALUOp		: out std_logic_vector(ALU_OP_WIDTH-1 downto 0);	-- Choose ALU instruction
			o_Shamt		: out std_logic_vector(DATA_SELECT-1 downto 0);
			o_MemWrite 	: out std_logic;
			o_MemRead 	: out std_logic;
			o_MemtoReg	: out std_logic_vector(MEMTOREG_WIDTH - 1 downto 0);
			o_RegWrite	: out std_logic;
			o_Movn		: out std_logic;
			o_Halt 		: out std_logic);
end IDEX_reg;

architecture behavior of IDEX_reg is

	component dffg is
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
		PCPlus4_i: dffg
				--generic map (N => N)
				port map (
					i_CLK	=> i_CLK,
					i_RST	=> i_RST,
					i_WE	=> i_WE,
					i_D		=> i_PCPlus4(i),
					o_Q		=> o_PCPlus4(i));
		end generate g_PCPlus4;

	-- Rd
	g_Rd: for i in 0 to DATA_SELECT-1 generate
		Rd_i: dffg
			port map (
				i_CLK	=> i_CLK,
				i_RST	=> i_RST,
				i_WE	=> i_WE,
				i_D		=> i_Rd(i),
				o_Q		=> o_Rd(i));
	end generate g_Rd;

	-- Rt
	g_Rt: for i in 0 to DATA_SELECT-1 generate
		Rt_i: dffg
			port map (
				i_CLK	=> i_CLK,
				i_RST	=> i_RST,
				i_WE	=> i_WE,
				i_D		=> i_Rt(i),
				o_Q		=> o_Rt(i));
	end generate g_Rt;

	-- Rs
	g_Rs: for i in 0 to DATA_SELECT-1 generate
		Rs_i: dffg
			--generic map (N => DATA_SELECT)
			port map (
				i_CLK	=> i_CLK,
				i_RST	=> i_RST,
				i_WE	=> i_WE,
				i_D		=> i_Rs(i),
				o_Q		=> o_Rs(i));
	end generate g_Rs;


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

	-- ALUSrc
	g_ALUSrc: for i in 0 to 1-1 generate
	ALUSrc_i: dffg
			--generic map (N => 1)
			port map (
				i_CLK	=> i_CLK,
				i_RST	=> i_RST,
				i_WE	=> i_WE,
				i_D		=> i_ALUSrc,
				o_Q		=> o_ALUSrc);
	end generate g_ALUSrc;

	-- ALUOp
	g_ALUOp: for i in 0 to ALU_OP_WIDTH-1 generate
	ALUOp_i: dffg
			--generic map (N => ALU_OP_WIDTH)
			port map (
				i_CLK	=> i_CLK,
				i_RST	=> i_RST,
				i_WE	=> i_WE,
				i_D		=> i_ALUOp(i),
				o_Q		=> o_ALUOp(i));
	end generate g_ALUOp;

	-- Shamt
	g_Shamt: for i in 0 to 5-1 generate
	Shamt_i: dffg
			--generic map (N => 5)
			port map (
				i_CLK	=> i_CLK,
				i_RST	=> i_RST,
				i_WE	=> i_WE,
				i_D		=> i_Shamt(i),
				o_Q		=> o_Shamt(i));
	end generate g_Shamt;

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

end behavior;
