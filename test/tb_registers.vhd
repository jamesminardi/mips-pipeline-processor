-- library declaration
library IEEE;
use IEEE.std_logic_1164.all;

-- constants & types declaration
library work;
use work.MIPS_types.all;


entity tb_registers is 
	generic( gCLK_HPER: time := 50 ns );
end tb_registers;

architecture tb of tb_registers is

  	-- Calculate the clock period as twice the half-period
  	constant cCLK_PER  : time := gCLK_HPER * 2;

	component IFID_reg is
		generic(N : integer := 32);
			port(
				i_CLK       : in std_logic;	-- Clock input
				i_RST       : in std_logic;	-- Reset input
				i_WE		: in std_logic;	-- Write enable / Stall
				i_Flush		: in std_logic; -- Changes to NOP in pipeline
				i_Inst		: in std_logic_vector(N-1 downto 0);	-- Full instruction
				i_PCPlus4	: in std_logic_vector(N-1 downto 0);	-- PC + 4
				o_Inst		: out std_logic_vector(N-1 downto 0);
				o_PCPlus4	: out std_logic_vector(N-1 downto 0));
	end component;

	component IDEX_reg is
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
	end component;

	component EXMEM_reg is
		generic(N : integer := 32);
			port(
				i_CLK		: in std_logic;	-- Clock input
				i_RST		: in std_logic;	-- Reset input
				i_WE		: in std_logic;	-- Write enable
	
				i_Rd		: in std_logic_vector(DATA_SELECT - 1 downto 0);
				i_ReadRs	: in std_logic_vector(N-1 downto 0); --------
				i_ReadRt	: in std_logic_vector(N-1 downto 0);	-- Read Rt
				i_MemWrite 	: in std_logic;
				i_MemRead 	: in std_logic;
				i_MemtoReg	: in std_logic_vector(MEMTOREG_WIDTH - 1 downto 0);
				i_RegWrite	: in std_logic;
				i_Movn		: in std_logic;
				i_Halt 		: in std_logic;
				i_Zero		: in std_logic;
				i_Imm32		: in std_logic_vector(N-1 downto 0);	-- Immediate (32b)
				i_ALUResult : in std_logic_vector(N-1 downto 0);
				i_PCPlus4 : in std_logic_vector(N-1 downto 0);
				i_Ovfl		: in std_logic;
				o_Ovfl		: out std_logic;
				
				o_PCPlus4 : out std_logic_vector(N-1 downto 0);
				o_Rd		: out std_logic_vector(DATA_SELECT - 1 downto 0);
				o_ReadRs	: out std_logic_vector(N-1 downto 0); --------
				o_ReadRt	: out std_logic_vector(N-1 downto 0);
				o_MemWrite 	: out std_logic;
				o_MemRead 	: out std_logic;
				o_MemtoReg 	: out std_logic_vector(MEMTOREG_WIDTH - 1 downto 0);
				o_RegWrite 	: out std_logic;
				o_Movn 		: out std_logic;
				o_Halt 		: out std_logic;
				o_Zero		: out std_logic;
				o_Imm32		: out std_logic_vector(N-1 downto 0);	-- Immediate (32b)
				o_ALUResult : out std_logic_vector(N-1 downto 0));
	end component;

	component MEMWB_reg is
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
	end component;


-- signals


signal s_CLK : std_logic := '0';
signal if_Rd  : std_logic_vector(DATA_SELECT - 1 downto 0) := (others => '0');
signal id_Rd  : std_logic_vector(DATA_SELECT - 1 downto 0) := (others => '0');
signal ex_Rd  : std_logic_vector(DATA_SELECT - 1 downto 0) := (others => '0');
signal mem_Rd  : std_logic_vector(DATA_SELECT - 1 downto 0) := (others => '0');
signal wb_Rd  : std_logic_vector(DATA_SELECT - 1 downto 0) := (others => '0');
signal id_Inst : std_logic_vector(DATA_WIDTH - 1 downto 0) := (others => '0');

signal if_Inst : std_logic_vector(DATA_WIDTH - 1 downto 0) := (others => '0');
signal ifid_Flush : std_logic := '0';
signal ifid_We : std_logic := '0';
signal ifid_Rst : std_logic := '0';
signal idex_We : std_logic := '0';
signal idex_Rst : std_logic := '0';


begin

	if_Rd <= if_Inst(15 downto 11);
	id_Rd <= id_Inst(15 downto 11);

	IFID: IFID_reg
	port map (
		i_CLK       => s_CLK,
		i_RST       => ifid_Rst,
		i_WE		=> ifid_We,
		i_Flush		=> ifid_Flush,
		i_Inst		=> if_Inst,
		i_PCPlus4	=> (others => '0'),
		o_Inst 		=> id_Inst,
		o_PCPlus4 	=> open);

	IDEX: IDEX_reg
	port map (
		i_CLK		=> s_CLK,
		i_RST		=> idex_Rst,
		i_WE		=> idex_We,

		i_Rd		=> id_Inst(15 downto 11),
		i_ReadRs	=> (others => '0'),
		i_ReadRt	=> (others => '0'),
		i_Imm32		=> (others => '0'),
		i_PCPlus4	=> (others => '0'),
		i_ALUSrc	=> '0',
		i_ALUOp		=> (others => '0'),
		i_Shamt		=> (others => '0'),
		i_MemWrite 	=> '0',
		i_MemRead 	=> '0',
		i_MemtoReg	=> (others => '0'),
		i_RegWrite	=> '0',
		i_Movn		=> '0',
		i_Halt 		=> '0',
		
		i_Rs		=> (others => '0'),
		i_Rt		=> (others => '0'),
		o_Rs		=> open,
		o_Rt		=> open,
		o_Rd		=> ex_Rd,
		o_ReadRs	=> open,
		o_ReadRt	=> open,
		o_Imm32		=> open,
		o_PCPlus4	=> open,
		o_ALUSrc	=> open,
		o_ALUOp		=> open,
		o_Shamt		=> open,
		o_MemWrite 	=> open,
		o_MemRead 	=> open,
		o_MemtoReg	=> open,
		o_RegWrite	=> open,
		o_Movn		=> open,
		o_Halt 		=> open);
	
	EXMEM: EXMEM_reg
	port map (
		i_CLK		=> s_CLK,
		i_RST		=> '0',
		i_WE		=> '1',

		i_Rd		=> ex_Rd,
		i_ReadRs	=> (others => '0'),
		i_ReadRt	=> (others => '0'),
		i_PCPlus4	=> (others => '0'),
		i_MemWrite 	=> '0',
		i_MemRead 	=> '0',
		i_MemtoReg	=> (others => '0'),
		i_RegWrite	=> '0',
		i_Movn		=> '0',
		i_Halt 		=> '0',
		i_Zero		=> '0',
		i_Imm32		=> (others => '0'),
		i_ALUResult => (others => '0'),
		i_Ovfl => '0',

		o_Ovfl => open,
		o_Rd		=> mem_Rd,
		o_ReadRs	=> open,
		o_ReadRt	=> open,
		o_PCPlus4	=> open,
		o_MemWrite 	=> open,
		o_MemRead 	=> open,
		o_MemtoReg 	=> open,
		o_RegWrite 	=> open,
		o_Movn 		=> open,
		o_Halt 		=> open,
		o_Zero		=> open,
		o_Imm32		=> open,
		o_ALUResult => open);

	MEMWB: MEMWB_reg
	port map (
		i_CLK		=> s_CLK,
		i_RST		=> '0',
		i_WE		=> '1',

		i_Rd		=> mem_Rd,
		i_PCPlus4	=> (others => '0'),
		i_MemtoReg	=> (others => '0'),
		i_DMemOut	=> (others => '0'),
		i_RegWrite	=> '0',
		i_Halt 		=> '0',
		i_ALUResult => (others => '0'),
		i_Ovfl => '0',

		o_Ovfl => open,
		o_Rd		=> open,
		o_PCPlus4	=> open,
		o_MemtoReg 	=> open,
		o_DMemOut	=> open,
		o_RegWrite 	=> open,
		o_Halt 		=> open,
		o_ALUResult => open);
	

	--This first process is to setup the clock for the test bench
	P_CLK: process
	begin
		s_CLK <= '1';         -- clock starts at 1
		wait for gCLK_HPER; -- after half a cycle
		s_CLK <= '0';         -- clock becomes a 0 (negative edge)
		wait for gCLK_HPER; -- after half a cycle, process begins evaluation again
	end process;  
	
P_TB: process
	begin

-- Reset
	if_Inst		<= (others => '0');
	ifid_Flush	<= '0';
	ifid_We		<= '0';
	ifid_Rst	<= '1';
	idex_We		<= '0';
	idex_Rst	<= '1';
	wait for gCLK_HPER*2;
	
-- -- Propogate instr "AAAAAAAA" through pipeline
-- 	if_Inst		<= x"AAAAAAAA";
-- 	ifid_Flush	<= '0';
-- 	ifid_We		<= '1';
-- 	ifid_Rst	<= '0';
-- 	idex_We		<= '0';
-- 	idex_Rst	<= '0';
-- 	exmem_We	<= '0';
-- 	exmem_Rst	<= '0';
-- 	memwb_We	<= '0';
-- 	memwb_Rst	<= '0';
-- 	wait for gCLK_HPER*2;
-- 	if_Inst		<= x"00000000";
-- 	ifid_Flush	<= '1';
-- 	ifid_We		<= '0';
-- 	ifid_Rst	<= '0';
-- 	idex_We		<= '1';
-- 	idex_Rst	<= '0';
-- 	exmem_We	<= '0';
-- 	exmem_Rst	<= '0';
-- 	memwb_We	<= '0';
-- 	memwb_Rst	<= '0';
-- 	wait for gCLK_HPER*2;
-- 	if_Inst		<= x"00000000";
-- 	ifid_Flush	<= '1';
-- 	ifid_We		<= '0';
-- 	ifid_Rst	<= '0';
-- 	idex_We		<= '0';
-- 	idex_Rst	<= '0';
-- 	exmem_We	<= '1';
-- 	exmem_Rst	<= '0';
-- 	memwb_We	<= '0';
-- 	memwb_Rst	<= '0';
-- 	wait for gCLK_HPER*2;
-- 	if_Inst		<= x"00000000";
-- 	ifid_Flush	<= '1';
-- 	ifid_We		<= '0';
-- 	ifid_Rst	<= '0';
-- 	idex_We		<= '0';
-- 	idex_Rst	<= '0';
-- 	exmem_We	<= '0';
-- 	exmem_Rst	<= '0';
-- 	memwb_We	<= '1';
-- 	memwb_Rst	<= '0';
-- 	wait for gCLK_HPER*2;
-- 	if_Inst		<= x"00000000";
-- 	ifid_Flush	<= '1';
-- 	ifid_We		<= '0';
-- 	ifid_Rst	<= '0';
-- 	idex_We		<= '0';
-- 	idex_Rst	<= '0';
-- 	exmem_We	<= '0';
-- 	exmem_Rst	<= '0';
-- 	memwb_We	<= '0';
-- 	memwb_Rst	<= '0';
-- 	wait for gCLK_HPER*2;
-- -- Reset
-- if_Inst		<= (others => '0');
-- ifid_Flush	<= '0';
-- ifid_We		<= '0';
-- ifid_Rst	<= '1';
-- idex_We		<= '0';
-- idex_Rst	<= '1';
-- exmem_We	<= '0';
-- exmem_Rst	<= '1';
-- memwb_We	<= '0';
-- memwb_Rst	<= '1';
-- wait for gCLK_HPER*2;

-- 	-- Instructions: A, B, F. Stall B
-- 	if_Inst		<= x"AAAAAAAA";
-- 	ifid_Flush	<= '0';
-- 	ifid_We		<= '1';
-- 	ifid_Rst	<= '0';
-- 	idex_We		<= '0';
-- 	idex_Rst	<= '0';
-- 	exmem_We	<= '0';
-- 	exmem_Rst	<= '0';
-- 	memwb_We	<= '0';
-- 	memwb_Rst	<= '0';
-- 	wait for gCLK_HPER*2;
-- 	if_Inst		<= x"BBBBBBBB";
-- 	ifid_Flush	<= '0';
-- 	ifid_We		<= '1';
-- 	ifid_Rst	<= '0';
-- 	idex_We		<= '1';
-- 	idex_Rst	<= '0';
-- 	exmem_We	<= '0';
-- 	exmem_Rst	<= '0';
-- 	memwb_We	<= '0';
-- 	memwb_Rst	<= '0';
-- 	wait for gCLK_HPER*2;
-- 	-- B in decode stage, stall it
-- 	if_Inst		<= x"FFFFFFFF";
-- 	ifid_Flush	<= '0';
-- 	ifid_We		<= '0';
-- 	ifid_Rst	<= '0';
-- 	idex_We		<= '0';
-- 	idex_Rst	<= '0';
-- 	exmem_We	<= '1';
-- 	exmem_Rst	<= '0';
-- 	memwb_We	<= '0';
-- 	memwb_Rst	<= '0';
-- 	wait for gCLK_HPER*2;
-- 	if_Inst		<= x"FFFFFFFF";
-- 	ifid_Flush	<= '0';
-- 	ifid_We		<= '1';
-- 	ifid_Rst	<= '0';
-- 	idex_We		<= '1';
-- 	idex_Rst	<= '0';
-- 	exmem_We	<= '1';
-- 	exmem_Rst	<= '0';
-- 	memwb_We	<= '1';
-- 	memwb_Rst	<= '0';
-- 	wait for gCLK_HPER*2;
-- 	if_Inst		<= x"00000000";
-- 	ifid_Flush	<= '1';
-- 	ifid_We		<= '0';
-- 	ifid_Rst	<= '0';
-- 	idex_We		<= '0';
-- 	idex_Rst	<= '0';
-- 	exmem_We	<= '0';
-- 	exmem_Rst	<= '0';
-- 	memwb_We	<= '0';
-- 	memwb_Rst	<= '0';
-- 	wait for gCLK_HPER*2;
-- -- Reset
-- if_Inst		<= (others => '0');
-- ifid_Flush	<= '0';
-- ifid_We		<= '0';
-- ifid_Rst	<= '1';
-- idex_We		<= '0';
-- idex_Rst	<= '1';
-- exmem_We	<= '0';
-- exmem_Rst	<= '1';
-- memwb_We	<= '0';
-- memwb_Rst	<= '1';
-- wait for gCLK_HPER*2;


-- Flush:
-- ifid_Flush	<= '0';
-- ifid_We		<= '1';
-- ifid_Rst		<= '1';
-- idex_We		<= '1';
-- idex_Rst		<= '0';

-- Instructions: A, B, F. Flush b
if_Inst		<= x"AAAAAAAA";
ifid_Flush	<= '0';
ifid_We		<= '1';
ifid_Rst	<= '0';
idex_We		<= '1';
idex_Rst	<= '0';
wait for gCLK_HPER*2;
-- B in fetch stage, flush it to a nop
if_Inst		<= x"BBBBBBBB";
ifid_Flush	<= '1';
ifid_We		<= '1';
ifid_Rst	<= '0';
idex_We		<= '1';
idex_Rst	<= '0';
wait for gCLK_HPER*2;
if_Inst		<= x"FFFFFFFF";
ifid_Flush	<= '0';
ifid_We		<= '1';
ifid_Rst	<= '0';
idex_We		<= '1';
idex_Rst	<= '0';
wait for gCLK_HPER*2;
if_Inst		<= x"FFFFFFFF";
ifid_Flush	<= '0';
ifid_We		<= '1';
ifid_Rst	<= '0';
idex_We		<= '1';
idex_Rst	<= '0';
wait for gCLK_HPER*2;

-- Reset
if_Inst		<= (others => '0');
ifid_Flush	<= '0';
ifid_We		<= '0';
ifid_Rst	<= '1';
idex_We		<= '0';
idex_Rst	<= '1';
wait for gCLK_HPER*2;


end process;
end tb;