-------------------------------------------------------------------------
-- Henry Duwe
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- MIPS_Processor.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a skeleton of a MIPS_Processor  
-- implementation.

-- 01/29/2019 by H3::Design created.
-------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;

library work;
use work.MIPS_types.all;

entity MIPS_Processor is
	generic(N : integer := DATA_WIDTH);
	port(iCLK            : in std_logic;
	    iRST            : in std_logic;
	    iInstLd         : in std_logic;
	    iInstAddr       : in std_logic_vector(N-1 downto 0);
	    iInstExt        : in std_logic_vector(N-1 downto 0);
	    oALUOut         : out std_logic_vector(N-1 downto 0)); -- TODO: Hook this up to the output of the ALU. It is important for synthesis that you have this output that can effectively be impacted by all other components so they are not optimized away.

end  MIPS_Processor;


architecture structure of MIPS_Processor is

	component mem is
		generic(ADDR_WIDTH : integer;
			DATA_WIDTH : integer);
		port(
			clk          : in std_logic;
			addr         : in std_logic_vector((ADDR_WIDTH-1) downto 0);
			data         : in std_logic_vector((DATA_WIDTH-1) downto 0);
			we           : in std_logic := '1';
			q            : out std_logic_vector((DATA_WIDTH -1) downto 0));
    end component;

	--------------------------  COMPONENTS  --------------------------
	component PC_reg is
		generic(N : integer);
		port(
			i_CLK	: in std_logic;     -- Clock input
			i_RST	: in std_logic;     -- Reset input
			i_WE	: in std_logic;		-- Write enable
			i_D		: in std_logic_vector(N-1 downto 0);     -- Data value input
			o_Q		: out std_logic_vector(N-1 downto 0));   -- Data value output
	end component;

	component IFID_reg is
		generic(N : integer := 32);
		port(
			i_CLK       : in std_logic;	-- Clock input
			i_RST       : in std_logic;	-- Reset input
			i_WE		: in std_logic;	-- Write enable
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

			i_Rd		: in std_logic_vector(DATA_SELECT-1 downto 0);	-- Instruction Rd
			i_ReadRs	: in std_logic_vector(N-1 downto 0);	-- Read Rs
			i_ReadRt	: in std_logic_vector(N-1 downto 0);	-- Read Rt
			i_Imm32		: in std_logic_vector(N-1 downto 0);	-- Immediate (32b)
			i_PCPlus4	: in std_logic_vector(N-1 downto 0);	-- PC + 4
			i_ALUSrc	: in std_logic; -- Choose ALU B to be immediate or Read Rt
			i_ALUOp		: in std_logic_vector(ALU_OP_WIDTH-1 downto 0);	-- Choose ALU instruction
			i_Shamt		: in std_logic_vector(DATA_SELECT-1 downto 0);
			i_MemWrite 	: in std_logic;
			i_MemRead 	: in std_logic;
			i_MemtoReg	: in std_logic_vector(MEMTOREG_WIDTH - 1 downto 0);
			i_RegWrite	: in std_logic;
			i_Movn		: in std_logic;
			i_Halt 		: in std_logic;
			i_Branch	: in std_logic;
			i_BranchEq	: in std_logic;
			i_JumpReg	: in std_logic;
			i_Jump		: in std_logic;
			i_JumpImm	: in std_logic_vector(JADDR_WIDTH-1 downto 0);
			
			o_Rd		: out std_logic_vector(DATA_SELECT-1 downto 0);	-- Instruction Rd
			o_ReadRs	: out std_logic_vector(N-1 downto 0);	-- Read Rs
			o_ReadRt	: out std_logic_vector(N-1 downto 0);	-- Read Rt
			o_Imm32		: out std_logic_vector(N-1 downto 0);	-- Immediate (32b)
			o_PCPlus4	: out std_logic_vector(N-1 downto 0);	-- PC + 4
			o_ALUSrc	: out std_logic; -- Choose ALU B to be immediate or Read Rt
			o_ALUOp		: out std_logic_vector(ALU_OP_WIDTH-1 downto 0);	-- Choose ALU instruction
			o_Shamt		: out std_logic_vector(DATA_SELECT-1 downto 0);
			o_MemWrite 	: out std_logic;
			o_MemRead 	: out std_logic;
			o_MemtoReg	: out std_logic_vector(MEMTOREG_WIDTH - 1 downto 0);
			o_RegWrite	: out std_logic;
			o_Movn		: out std_logic;
			o_Halt 		: out std_logic;
			o_Branch	: out std_logic;
			o_BranchEq	: out std_logic;
			o_JumpReg	: out std_logic;
			o_Jump		: out std_logic;
			o_JumpImm	: out std_logic_vector(JADDR_WIDTH-1 downto 0));
	end component;

	component EXMEM_reg is
		generic(N : integer := 32);
		port(
			i_CLK		: in std_logic;	-- Clock input
			i_RST		: in std_logic;	-- Reset input
			i_WE		: in std_logic;	-- Write enable

			i_ReadRs	: in std_logic_vector(N-1 downto 0); --------
			i_ReadRt	: in std_logic_vector(N-1 downto 0);	-- Read Rt
			i_PCPlus4	: in std_logic_vector(N-1 downto 0);	-- PC + 4
			i_Imm32 : in std_logic_vector(N-1 downto 0);
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
			i_ALUResult : in std_logic_vector(N-1 downto 0);

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
			o_Imm32 : out std_logic_vector(N-1 downto 0);
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
	
				o_Rd		: out std_logic_vector(DATA_SELECT - 1 downto 0);
				o_PCPlus4	: out std_logic_vector(N-1 downto 0);
				o_MemtoReg 	: out std_logic_vector(MEMTOREG_WIDTH - 1 downto 0);
				o_DMemOut	: out std_logic_vector(N-1 downto 0);
				o_RegWrite 	: out std_logic;
				o_Halt 		: out std_logic;
				o_ALUResult : out std_logic_vector(N-1 downto 0));
	end component;


  	component regfile is
		generic(N 	  : integer;
				REG_W : integer);
		port(
			i_CLK : in std_logic;		-- Clock input
			i_RST : in std_logic;		-- Reset
			i_We : in std_logic;		-- Write enable
			i_Rs : in std_logic_vector(REG_W - 1 downto 0); -- Register to read 1
			i_Rt : in std_logic_vector(REG_W - 1 downto 0); -- Register to read 2
			i_Rd : in std_logic_vector(REG_W - 1 downto 0); -- Reg being written to
			i_Wd : in std_logic_vector(N -1 downto 0);		-- Data to write to i_Rd
			o_Rs : out std_logic_vector(N -1 downto 0);		-- i_rs data output
			o_Rt : out std_logic_vector(N -1 downto 0));		-- i_rt data output
	end component;

	component extender is
		port(
			i_D : in std_logic_vector((DATA_WIDTH/2)-1 downto 0);
			i_Extend : in std_logic;
			o_F : out std_logic_vector(DATA_WIDTH-1 downto 0));
	end component;

	component control is
		port (
			iOpcode     : in std_logic_vector(OPCODE_WIDTH -1 downto 0); -- 6 MSB of 32bit instruction
			iFunct      : in std_logic_vector(OPCODE_WIDTH - 1 downto 0); -- only for JR
			-- iALUZero : in std_logic; -- TODO: Zero flag from ALU for PC src?
			oPCSrc 		: out std_logic; -- TODO: Selects using PC+4 or branch addy
			oRegDst     : out std_logic_vector(REGDST_WIDTH - 1 downto 0); -- Selects r-type vs i-type write register
			oALUSrc     : out std_logic; -- Selects source for second ALU input (Rt vs Imm)
			oMemtoReg   : out std_logic_vector(MEMTOREG_WIDTH - 1 downto 0); -- Selects ALU result or memory result to reg write
			oRegWrite   : out std_logic; -- Enable register write in datapath->registerfile
			oMemRead    : out std_logic; -- Enable reading of memory in dmem
			oMemWrite   : out std_logic; -- Enable writing to memory in dmem
			oSignExt	  : out std_logic; -- Whether to sign extend the immediate or not
			oJump       : out std_logic; -- Selects setting PC to jump value or not
			oJumpReg	  : out std_logic;
			oMovn       : out std_logic;
			oBranch     : out std_logic; -- Helps select using PC+4 or branch address by being Anded with ALU Zero
			oBranchEQ   : out std_logic; -- Determines if BEQ or BNE
			oALUOp      : out std_logic_vector(ALU_OP_WIDTH - 1 downto 0); -- Selects ALU operation or to select from funct field
			oHalt		: out std_logic); -- Halt port
	end component;

	component ALU is
		port(
			iA 		: in std_logic_vector(DATA_WIDTH - 1 downto 0);
			iB 		: in std_logic_vector(DATA_WIDTH - 1 downto 0);
			iShamt : in std_logic_vector(DATA_SELECT - 1 downto 0);
			iALUOp 	: in std_logic_vector(ALU_OP_WIDTH - 1 downto 0);
			oResult : out std_logic_vector(DATA_WIDTH - 1 downto 0);
			oCout 	: out std_logic;
			oOverflow : out std_logic;
			oZero 	: out std_logic);
	end component;

	component mux2t1_N is
		generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
		port(
			i_S 	: in std_logic;
			i_D0	: in std_logic_vector(N-1 downto 0);
			i_D1	: in std_logic_vector(N-1 downto 0);
			o_O 	: out std_logic_vector(N-1 downto 0));
	end component;

	component add_sub is --add feature
		port(
			iA		: in 	std_logic_vector(DATA_WIDTH - 1 downto 0);
			iB		: in 	std_logic_vector(DATA_WIDTH-1 downto 0);
			iSubtract: in   std_logic;
			oSum	: out 	std_logic_vector(DATA_WIDTH-1 downto 0);
			oCout2	: out	std_logic; -- Not needed: Cout before the last adder
		 	oCout 	: out 	std_logic);
	end component;

	component fetch is
		port(
			i_PCPlus4		: in std_logic_vector(DATA_WIDTH - 1 downto 0); --input address
			i_Jump		: in std_logic; --input 0 or 1 for jump or not jump
			i_JumpReg	: in std_logic; -- jump register instr or not
			i_JumpRegData: in std_logic_vector(DATA_WIDTH - 1 downto 0);
			i_Branch	: in std_logic; --input 0 or 1 for branch or not branch
			i_Zero      : in std_logic;
			i_BEQ   : in std_logic; --input 0 or 1 for branchEQ or BNE
			i_BranchImm	: in std_logic_vector(DATA_WIDTH - 1 downto 0);
			i_JumpImm	: in std_logic_vector(JADDR_WIDTH - 1 downto 0);
			o_Addr		: out std_logic_vector(DATA_WIDTH - 1 downto 0));
	end component;


-- Required data memory signals
signal s_DMemWr       : std_logic; -- TODO: use this signal as the final active high data memory write enable signal
signal s_DMemAddr     : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory address input
signal s_DMemData     : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory data input
signal s_DMemOut      : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the data memory output

-- Required register file signals 
signal s_RegWr        : std_logic; -- TODO: use this signal as the final active high write enable input to the register file
signal s_RegWrAddr    : std_logic_vector(4 downto 0); -- TODO: use this signal as the final destination register address input
signal s_RegWrData    : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory data input	
-- Required instruction memory signals
signal s_IMemAddr     : std_logic_vector(N-1 downto 0); -- Do not assign this signal, assign to s_NextInstAddr instead
signal s_NextInstAddr : std_logic_vector(N-1 downto 0); -- TODO: use this signal as your intended final instruction memory address input.
signal s_Inst         : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the instruction signal 	
-- Required halt signal -- for simulation
signal s_Halt         : std_logic;  -- TODO: this signal indicates to the simulation that intended program execution has completed. (Opcode: 01 0100)	
-- Required overflow signal -- for overflow exception detection
signal s_Ovfl         : std_logic;  -- TODO: this signal indicates an overflow exception would have been initiated

    
--------------------------  CONTROL OUTPUT SIGNALS  --------------------------
signal s_RegDst 	: std_logic_vector(REGDST_WIDTH - 1 downto 0);
signal s_ALUSrc 	: std_logic;
signal s_MemtoReg 	: std_logic_vector(MEMTOREG_WIDTH - 1 downto 0);
-- signal s_RegWrite 	: std_logic; -- s_RegWr replaces this
signal s_MemRead 	: std_logic;
signal s_MemWrite 	: std_logic;
signal s_SignExt	: std_logic;
signal s_Jump 		: std_logic;
signal s_JumpReg	: std_logic;
signal s_Movn		: std_logic;
signal s_Branch 	: std_logic;
signal s_BEQ		: std_logic;
signal s_ALUOp 		: std_logic_vector(ALU_OP_WIDTH - 1 downto 0);
signal s_ALUAction : std_logic_vector(ALU_OP_WIDTH - 1 downto 0);

--------------------------  GENERAL SIGNALS  --------------------------
signal s_UpdatePC : std_logic_vector(DATA_WIDTH - 1 downto 0);			-- Input into PC register
--signal s_WriteRegister : std_logic_vector(DATA_SELECT - 1 downto 0); 	-- Input into regfile i_Rd
signal s_RegWrite : std_logic; -- Input into movn regwrite mux
signal s_ReadRs   : std_logic_vector(DATA_WIDTH - 1 downto 0); -- Output of regfile read Rs
signal s_ReadRt   : std_logic_vector(DATA_WIDTH - 1 downto 0); -- Output of regfile read Rt
signal s_ALUInB   : std_logic_vector(DATA_WIDTH - 1 downto 0); -- 2nd input of ALU (Imm)
signal s_ALUResult: std_logic_vector(DATA_WIDTH - 1 downto 0); -- Result from main alu
signal s_Cout     : std_logic; -- Carry out from ALU
signal s_Zero     : std_logic; -- Zero signal from ALU
signal s_PCPlus4  : std_logic_vector(DATA_WIDTH - 1 downto 0);
signal s_ALUPreMovn:std_logic_vector(DATA_WIDTH - 1 downto 0);
signal s_MovnZero : std_logic;

--------------------------  IF SIGNALS  --------------------------
-- These signals go INTO IF/ID
signal if_Inst    	: std_logic_vector(N-1 downto 0);
signal if_PCPlus4 	: std_logic_vector(N-1 downto 0); -- PC+4 value generated within this stage and input into PC input mux
signal if_NewPC		: std_logic_vector(N-1 downto 0 ); -- New PC after selecting from control flow or PC+4. Goes into PC

--------------------------  ID SIGNALS  --------------------------
-- From IF/ID and consumed
signal id_Inst    : std_logic_vector(N-1 downto 0);

-- Created Instruction signals
signal id_Opcode: std_logic_vector(OPCODE_WIDTH - 1 downto 0); -- Opcode
signal id_Funct	: std_logic_vector(FUNCT_WIDTH  - 1 downto 0); -- Funct code
signal id_Imm16	: std_logic_vector(DATA_WIDTH/2 - 1 downto 0); -- Imm field for I-type instruction
signal id_Addr  : std_logic_vector(JADDR_WIDTH  - 1 downto 0); -- Addr width for jump instruction
signal id_Rs : std_logic_vector(DATA_SELECT - 1 downto 0);
signal id_Rt : std_logic_vector(DATA_SELECT - 1 downto 0);
-- Created instruction signals from control not passed on
signal id_SignExt 	: std_logic;

-- Go to IF/ID
signal id_PCSrc		: std_logic;

-- These signals go INTO ID/EX
signal id_Rd       	: std_logic_vector(DATA_SELECT-1 downto 0);
signal id_ReadRs   	: std_logic_vector(N-1 downto 0);
signal id_ReadRt   	: std_logic_vector(N-1 downto 0);
signal id_Imm32    	: std_logic_vector(N-1 downto 0);
signal id_PCPlus4  	: std_logic_vector(N-1 downto 0);
signal id_ALUSrc   	: std_logic;
signal id_ALUOp    	: std_logic_vector(ALU_OP_WIDTH-1 downto 0);
signal id_Shamt    	: std_logic_vector(DATA_SELECT-1 downto 0);
signal id_MemWrite 	: std_logic;
signal id_MemRead  	: std_logic;
signal id_MemtoReg 	: std_logic_vector(MEMTOREG_WIDTH-1 downto 0);
signal id_RegWrite 	: std_logic;
signal id_RegDst	: std_logic_vector(REGDST_WIDTH - 1 downto 0);
signal id_Movn     	: std_logic;
signal id_Halt     	: std_logic;
signal id_Branch	: std_logic;
signal id_BranchEq	: std_logic;
signal id_JumpReg	: std_logic;
signal id_Jump		: std_logic;
signal id_JumpImm	: std_logic_vector(JADDR_WIDTH-1 downto 0);

--------------------------  EX SIGNALS  --------------------------
-- From ID/EX and consumed
signal ex_Rd       : std_logic_vector(DATA_SELECT-1 downto 0);
signal ex_ALUSrc   : std_logic;
signal ex_ALUOp    : std_logic_vector(ALU_OP_WIDTH-1 downto 0);
signal ex_Shamt    : std_logic_vector(DATA_SELECT-1 downto 0);

-- Created and consumed
signal ex_ALUInB : std_logic_vector(N-1 downto 0);

-- These signals go INTO EX/MEM
signal ex_Imm32    : std_logic_vector(N-1 downto 0);
signal ex_ReadRs	: std_logic_vector(N-1 downto 0);
signal ex_ReadRt	  : std_logic_vector(N-1 downto 0);
signal ex_PCPlus4	  : std_logic_vector(N-1 downto 0);
signal ex_MemWrite 	: std_logic;
signal ex_MemRead 	: std_logic;
signal ex_MemtoReg	: std_logic_vector(MEMTOREG_WIDTH - 1 downto 0);
signal ex_RegWrite	: std_logic;
signal ex_Movn		  : std_logic;
signal ex_Halt 		  : std_logic;
signal ex_Branch	:  std_logic;
signal ex_BranchEQ	:  std_logic;
signal ex_JumpReg	:  std_logic;
signal ex_Jump		:  std_logic;
signal ex_JumpImm	:  std_logic_vector(JADDR_WIDTH-1 downto 0);
signal ex_ALUResult : std_logic_vector(N-1 downto 0);
signal ex_Zero		: std_logic;

--------------------------  MEM SIGNALS  --------------------------
-- From EX/MEM reg and consumed
signal mem_ReadRt	  : std_logic_vector(N-1 downto 0);
signal mem_MemWrite : std_logic;
signal mem_MemRead 	: std_logic;
signal mem_Imm32    : std_logic_vector(N-1 downto 0);
signal mem_ALUResult : std_logic_vector(N-1 downto 0);

signal mem_NewPC : std_logic_vector(N-1 downto 0);

-- These signals go INTO MEM/WB
signal mem_PCPlus4	: std_logic_vector(N-1 downto 0);
signal mem_MemtoReg	: std_logic_vector(MEMTOREG_WIDTH - 1 downto 0);
signal mem_RegWrite	: std_logic;
signal mem_RegDst	  : std_logic_vector(REGDST_WIDTH - 1 downto 0);
signal mem_Movn		  : std_logic;
--signal mem i_Jal	: std_logic;
signal mem_Halt 		: std_logic;

signal memwb_RegWrite : std_logic;
signal memwb_ALUResult : std_logic_vector(N-1 downto 0);


signal mem_Rd		: std_logic_vector(DATA_SELECT - 1 downto 0);
signal mem_ReadRs : std_logic_vector(N-1 downto 0);
signal mem_Branch : std_logic;
signal mem_BranchEQ : std_logic;
signal mem_JumpReg : std_logic;
signal mem_Jump : std_logic;
signal mem_JumpImm : std_logic_vector(JADDR_WIDTH-1 downto 0);
signal mem_Zero : std_logic;

--------------------------  WB SIGNALS  --------------------------
-- From MEM/WB reg and consumed
-- These signals go INTO IF/ID


-- From Previous stage
signal wb_Rd : std_logic_vector(DATA_SELECT - 1 downto 0);
signal wb_DMemOut : std_logic_vector(N-1 downto 0);
signal wb_PCPlus4 : std_logic_vector(N-1 downto 0);
signal wb_MemtoReg : std_logic_vector(MEMTOREG_WIDTH - 1 downto 0);
signal wb_RegWrite : std_logic;
signal wb_Halt :std_logic;
signal wb_ALUResult : std_logic_vector(N-1 downto 0);

signal wb_WriteData : std_logic_vector(N-1 downto 0);

begin

  -- TODO: Ensure that s_Halt is connected to an output control signal produced from decoding the Halt instruction (Opcode: 01 0100)
  -- TODO: Ensure that s_Ovfl is connected to the overflow output of your ALU

  --------------------------  INSTRUCTION FETCH (IF) STAGE  --------------------------	
  	with iInstLd select
  	s_IMemAddr <=
	  	s_NextInstAddr when '0',
    	iInstAddr when others;


	-- Selects control flow or pc+4
	with id_PCSrc select
	if_NewPC <=
		mem_NewPC when '1',
		if_PCPlus4 when others;

	PC: PC_reg
	generic map(
		N => DATA_WIDTH)
	port map (
		i_CLK => iCLK,
		i_RST => iRST,
		i_WE => '1',
		i_D => if_NewPC,
		o_Q => s_NextInstAddr);


	Add4: add_sub
	port map (
		iSubtract => '0',
		iA		=> s_NextInstAddr, 		-- PC input
		iB		=> x"00000004", -- 4
		oSum	=> if_PCPlus4, 	-- PC plus 4
		oCout2	=> open,
		oCout	=> open);

	IMem: mem
	generic map(
		ADDR_WIDTH => ADDR_WIDTH,
		DATA_WIDTH => N)
	port map(
		clk  => iCLK,
		addr => s_IMemAddr(11 downto 2),
		data => iInstExt,
		we   => iInstLd,
		q    => s_Inst);

  if_Inst <= s_Inst;
  --------------------------  INSTRUCTION DECODE (ID) STAGE  --------------------------	
  IFID: IFID_reg
    generic map (N => N)
      port map(
        i_CLK     => iCLK,
        i_RST     => iRST,
        i_WE      => '1',
        i_Inst    => if_Inst,
        i_PCPlus4 => if_PCPlus4,
        o_Inst    => id_Inst,
        o_PCPlus4 => id_PCPlus4);
  

	id_Opcode(OPCODE_WIDTH - 1 downto 0) <= id_Inst(31 downto 26);
	id_Funct(FUNCT_WIDTH - 1 downto 0) <= id_Inst(5  downto 0);
	id_Rs(DATA_SELECT - 1 downto 0) <= id_Inst(25 downto 21);
	id_Rt(DATA_SELECT - 1 downto 0) <= id_Inst(20 downto 16);
	id_Rd(DATA_SELECT  - 1 downto 0) <= id_Inst(15 downto 11);
	id_Shamt(DATA_SELECT - 1 downto 0) <= id_Inst(10 downto 6);
	id_Addr(JADDR_WIDTH - 1 downto 0) <= id_Inst(25 downto 0);
	id_Imm16(DATA_WIDTH/2 - 1 downto 0) <= id_Inst(15 downto 0);
	id_JumpImm <= id_Addr;

  Control_Unit: control
	port map (
		iOpcode     => id_Opcode,
		iFunct		  => id_Funct,
		-- iALUZero =>
		oPCSrc   	=> id_PCSrc,
		oRegDst     => id_RegDst,
		oALUSrc     => id_ALUSrc,
		oMemtoReg   => id_MemtoReg,
		oRegWrite   => id_RegWrite,
		oMemRead    => id_MemRead,
		oMemWrite   => id_MemWrite,
		oSignExt	=> id_SignExt,
		oJump       => id_Jump,
		oJumpReg	=> id_JumpReg,
		oMovn		=> id_Movn,
		oBranch     => id_Branch,
		oBranchEQ   => id_BranchEQ,
		oALUOp      => id_ALUOp,
		oHalt		=> id_Halt);
  
    -- with id_RegDst select
	-- 	s_RegWrAddr <=
    --   		id_Rs   when "00",
	-- 		id_Rd   when "01",
	-- 		"11111" when "10",
	-- 		id_Rs   when others;
	with id_RegDst select
	s_RegWrAddr <=
		id_Rt   when "00",
		id_Rd   when "01",
		"11111" when "10",
		id_Rt   when others;
			

	s_RegWrAddr <= wb_Rd;
	s_RegWrData <= wb_WriteData;

	Regfile_Unit: regfile
	generic map(
		N     => DATA_WIDTH,
		REG_W => DATA_SELECT)
	port map(
		i_CLK	=> iCLK, 
		i_RST	=> iRST, 
		i_We 	=> wb_RegWrite, 
		i_Rs 	=> id_Rs,  -- Register to read 1
		i_Rt 	=> id_Rt,  -- Register to read 2
		i_Rd 	=> s_RegWrAddr, -- Reg being written to
		i_Wd 	=> s_RegWrData, -- Data to write to i_Rd
		o_Rs 	=> id_ReadRs, 	-- i_rs data output
		o_Rt 	=> id_ReadRt);	-- i_rt data output

	Sign_Extender: extender
	port map(
		i_D 	 => id_Imm16,
		i_Extend => id_SignExt,
		o_F 	 => id_Imm32);

  --------------------------  EXECUTE (EX) STAGE  --------------------------	
  IDEX: IDEX_reg
    generic map(N => N)
      port map(
        i_CLK => iCLK,
        i_RST => iRST,
        i_WE => '1',
  
        i_Rd      	=> id_Rd,
        i_ReadRs  	=> id_ReadRs,
        i_ReadRt  	=> id_ReadRt,
        i_Imm32   	=> id_Imm32,
        i_PCPlus4 	=> id_PCPlus4,
        i_ALUSrc  	=> id_ALUSrc,
        i_ALUOp   	=> id_ALUOp,
        i_Shamt   	=> id_Shamt,
        i_MemWrite	=> id_MemWrite,
        i_MemRead 	=> id_MemRead,
        i_MemtoReg	=> id_MemtoReg,
        i_RegWrite	=> id_RegWrite,
        i_Movn    	=> id_Movn,
        i_Halt    	=> id_Halt,
		i_Branch	=> id_Branch,
		i_BranchEq	=> id_BranchEQ,
		i_JumpReg	=> id_JumpReg,
		i_Jump		=> id_Jump,
		i_JumpImm	=> id_JumpImm,
  
        o_Rd      	=> ex_Rd,
        o_ReadRs  	=> ex_ReadRs,
        o_ReadRt  	=> ex_ReadRt,
        o_Imm32   	=> ex_Imm32,
        o_PCPlus4 	=> ex_PCPlus4,
        o_ALUSrc  	=> ex_ALUSrc,
        o_ALUOp   	=> ex_ALUOp,
        o_Shamt   	=> ex_Shamt,
        o_MemWrite	=> ex_MemWrite,
        o_MemRead 	=> ex_MemRead,
        o_MemtoReg	=> ex_MemtoReg,
        o_RegWrite	=> ex_RegWrite,
        o_Movn    	=> ex_Movn,
        o_Halt    	=> ex_Halt,
		o_Branch	=> ex_Branch,
		o_BranchEq	=> ex_BranchEQ,
		o_JumpReg	=> ex_JumpReg,
		o_Jump		=> ex_Jump,
		o_JumpImm	=> ex_JumpImm);


  	ALUSrc_mux: mux2t1_N
	generic map(
		N => DATA_WIDTH)
	port map(
		i_S  => ex_ALUSrc,
		i_D0 => ex_ReadRt,
		i_D1 => ex_Imm32,
		o_O  => ex_ALUInB);

	ALU_Main: ALU
	port map (
		iA			=> ex_ReadRs,
		iB			=> ex_ALUInB,
		iShamt		=> ex_Shamt,
		iALUOp		=> ex_ALUOp,
		oResult		=> ex_ALUResult,
		oCout		=> open,
		oOverflow	=> s_Ovfl, -- TODO: Send to end of pipeline first???
		oZero		=> ex_Zero);


	--oALUOut <= s_ALUResult; TODO?

	--------------------------  MEMORY (MEM) STAGE  --------------------------	
	
	EXMEM: EXMEM_reg
	generic map(N => N)
	port map(
		i_CLK => iCLK,
		i_RST => iRST,
		i_WE => '1',

		i_ReadRs	=> ex_ReadRs,
		i_ReadRt	=> ex_ReadRt,
		i_PCPlus4	=> ex_PCPlus4,
		i_MemWrite 	=> ex_MemWrite,
		i_MemRead 	=> ex_MemRead,
		i_MemtoReg	=> ex_MemtoReg,
		i_RegWrite	=> ex_RegWrite,
		i_Movn		=> ex_Movn,
		i_Halt 		=> ex_Halt,
		i_Branch	=> ex_Branch,
		i_BranchEQ	=> ex_BranchEQ,
		i_JumpReg	=> ex_JumpReg,
		i_Jump		=> ex_Jump,
		i_JumpImm	=> ex_JumpImm,
		i_Zero		=> ex_Zero,
		i_Imm32		=> ex_Imm32,
		i_ALUResult => ex_ALUResult,

		o_ReadRs	=> mem_ReadRs,
		o_Branch	=> mem_Branch,
		o_BranchEQ	=> mem_BranchEQ,
		o_JumpReg	=> mem_JumpReg,
		o_Jump		=> mem_Jump,
		o_JumpImm	=> mem_JumpImm,
		o_Zero		=> mem_Zero,
		o_ReadRt	=> mem_ReadRt,
		o_PCPlus4	=> mem_PCPlus4,
		o_MemWrite 	=> mem_MemWrite,
		o_MemRead 	=> mem_MemRead,
		o_MemtoReg	=> mem_MemtoReg,
		o_RegWrite	=> mem_RegWrite,
		o_Movn		=> mem_Movn,
		o_Halt 		=> mem_Halt,
		o_Imm32		=> mem_Imm32,
		o_ALUResult => mem_ALUResult);

	-- Selects reg write depending on if MOVN instruction is happening or not, otherwise use control RegWrite
	with mem_Movn select
		memwb_RegWrite <=
			(NOT mem_Zero) when '1',
			mem_RegWrite when others;

	-- Movn mux after ALU
	with (mem_Movn AND (NOT mem_Zero)) select
		memwb_ALUResult <=
			mem_ReadRs when '1',
			mem_ALUResult when others;
	

	s_DMemAddr <= memwb_ALUResult; 
	s_DMemData <= mem_ReadRt;
	s_DMemWr <= mem_MemWrite;

	DMem: mem
	generic map(ADDR_WIDTH => ADDR_WIDTH,
				DATA_WIDTH => N)
	port map(
		clk  => iCLK,
		addr => s_DMemAddr(11 downto 2),
		data => s_DMemData,
		we   => s_DMemWr,
		q    => s_DMemOut);


	Fetch_Unit: fetch
	port map(
		i_PCPlus4	  	=> mem_PCPlus4,
		i_Jump		  	=> mem_Jump,
		i_JumpReg	  	=> mem_JumpReg,
		i_JumpRegData	=> mem_ReadRs,
		i_Branch	  	=> mem_Branch,
		i_Zero      	=> mem_Zero,
		i_BEQ       	=> mem_BranchEq,
		i_BranchImm		=> mem_Imm32,
		i_JumpImm	  	=> mem_JumpImm,
		o_Addr		  	=> mem_NewPC);


  --------------------------  WRITE BACK (WB) STAGE  --------------------------	
  MEMWB: MEMWB_reg
  generic map(N => N)
	port map(
		i_CLK => iCLK,
		i_RST => iRST,
		i_WE => '1',

		i_Rd 		=> mem_Rd,
		i_PCPlus4 	=> mem_PCPlus4,
		i_MemtoReg	=> mem_MemtoReg,
		i_RegWrite	=> memwb_RegWrite,
		i_Halt    	=> mem_Halt,
		i_ALUResult => memwb_ALUResult,
		i_DMemOut	=> s_DMemOut,

		o_Rd		=> wb_Rd,
		o_PCPlus4 	=> wb_PCPlus4,
		o_MemtoReg	=> wb_MemtoReg,
		o_RegWrite	=> wb_RegWrite,
		o_Halt    	=> wb_Halt,
		o_ALUResult => wb_ALUResult,
		o_DMemOut	=> wb_DMemOut);

	with wb_MemtoReg select
		wb_WriteData <=
			wb_ALUResult when "00",
			wb_DMemOut when "01",
			wb_PCPlus4 when "10",
			wb_ALUResult when others;

	s_Halt <= wb_Halt;


end structure;

