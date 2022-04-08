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
	port(
		iCLK            : in std_logic;
		iRST            : in std_logic;
		iInstLd         : in std_logic;
		iInstAddr       : in std_logic_vector(N-1 downto 0);
		iInstExt        : in std_logic_vector(N-1 downto 0);
		-- Done: Hook this up to the output of the ALU.
		-- It is important for synthesis that you have this
		-- output that can effectively be impacted by all
		-- other components so they are not optimized away.
		oALUOut         : out std_logic_vector(N-1 downto 0));
end MIPS_Processor;

architecture structure of MIPS_Processor is


-- Required data memory signals
signal s_DMemWr			: std_logic; -- TODO: use this signal as the final active high data memory write enable signal
signal s_DMemAddr		: std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory address input
signal s_DMemData		: std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory data input
signal s_DMemOut		: std_logic_vector(N-1 downto 0); -- TODO: use this signal as the data memory output
 
-- Required register file signals 
signal s_RegWr    		: std_logic; -- TODO: use this signal as the final active high write enable input to the register file
signal s_RegWrAddr		: std_logic_vector(4 downto 0); -- TODO: use this signal as the final destination register address input
signal s_RegWrData		: std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory data input

-- Required instruction memory signals
signal s_IMemAddr    	: std_logic_vector(N-1 downto 0); -- Do not assign this signal, assign to s_NextInstAddr instead
signal s_NextInstAddr	: std_logic_vector(N-1 downto 0); -- TODO: use this signal as your intended final instruction memory address input.
signal s_Inst        	: std_logic_vector(N-1 downto 0); -- TODO: use this signal as the instruction signal 

-- DONE: this signal indicates to the simulation that intended
-- program execution has completed. (Opcode: 01 0100)
signal s_Halt			: std_logic;

-- Required overflow signal -- for overflow exception detection
-- TODO: this signal indicates an overflow exception would have
-- been initiated
signal s_Ovfl			: std_logic;

	component mem is
		port(
			clk		: in std_logic;
			addr	: in std_logic_vector((ADDR_WIDTH-1) downto 0);
			data	: in std_logic_vector((DATA_WIDTH-1) downto 0);
			we		: in std_logic := '1';
			q		: out std_logic_vector((DATA_WIDTH -1) downto 0));
	end component;

-- TODO: You may add any additional signals or components your implementation 
--       requires below this comment

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

--------------------------  INSTRUCTION SIGNALS  --------------------------
signal s_instr_Opcode 	: std_logic_vector(OPCODE_WIDTH - 1 downto 0); -- Opcode
signal s_instr_Rs		: std_logic_vector(DATA_SELECT  - 1 downto 0); -- Rs
signal s_instr_Rt		: std_logic_vector(DATA_SELECT  - 1 downto 0); -- Rt
signal s_Instr_Rd		: std_logic_vector(DATA_SELECT  - 1 downto 0); -- Rd
signal s_instr_Shamt	: std_logic_vector(DATA_SELECT  - 1 downto 0); -- Shift amount
signal s_instr_Funct	: std_logic_vector(FUNCT_WIDTH  - 1 downto 0); -- Funct code
signal s_instr_imm16	: std_logic_vector(DATA_WIDTH/2 - 1 downto 0); -- Imm field for I-type instruction
signal s_instr_imm32	: std_logic_vector(DATA_WIDTH   - 1 downto 0); -- Immediate after extension
signal s_instr_Addr		: std_logic_vector(JADDR_WIDTH  - 1 downto 0); -- Addr width for jump instruction

--------------------------  GENERAL SIGNALS  --------------------------
signal s_UpdatePC : std_logic_vector(DATA_WIDTH - 1 downto 0);			-- Input into PC register
--signal s_WriteRegister : std_logic_vector(DATA_SELECT - 1 downto 0); 	-- Input into regfile i_Rd
signal s_RegWrite : std_logic; -- Input into movn regwrite mux
signal s_ReadRs : std_logic_vector(DATA_WIDTH - 1 downto 0); -- Output of regfile read Rs
signal s_ReadRt : std_logic_vector(DATA_WIDTH - 1 downto 0); -- Output of regfile read Rt
signal s_ALUInB : std_logic_vector(DATA_WIDTH - 1 downto 0); -- 2nd input of ALU (Imm)
signal s_ALUResult : std_logic_vector(DATA_WIDTH - 1 downto 0); -- Result from main alu
signal s_Cout : std_logic; -- Carry out from ALU
signal s_Zero : std_logic; -- Zero signal from ALU
signal s_PCPlus4 : std_logic_vector(DATA_WIDTH - 1 downto 0);
signal s_ALUPreMovn : std_logic_vector(DATA_WIDTH - 1 downto 0);
signal s_MovnZero : std_logic;

	--------------------------  COMPONENTS  --------------------------
	component pc_register is
		generic(N : integer);
			port(
				i_CLK	: in std_logic;     -- Clock input
				i_RST	: in std_logic;     -- Reset input
				i_WE	: in std_logic;		-- Write enable
	       		i_D		: in std_logic_vector(N-1 downto 0);     -- Data value input
	       		o_Q		: out std_logic_vector(N-1 downto 0));   -- Data value output
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
			-- oPCSrc : in std_logic; -- TODO: Selects using PC+4 or branch addy
			oRegDst     : out std_logic_vector(REGDST_WIDTH - 1 downto 0); -- Selects r-type vs i-type write register
			oALUSrc     : out std_logic; -- Selects source for second ALU input (Rt vs Imm)
			oMemtoReg   : out std_logic_vector(MEMTOREG_WIDTH - 1 downto 0); -- Selects ALU result or memory result to reg write
			oRegWrite   : out std_logic; -- Enable register write in datapath->registerfile
			oMemRead    : out std_logic; -- Enable reading of memory in dmem
			oMemWrite   : out std_logic; -- Enable writing to memory in dmem
			oSignExt	: out std_logic; -- Whether to sign extend the immediate or not
			oJump       : out std_logic; -- Selects setting PC to jump value or not
			oJumpReg	: out std_logic;
			oMovn       : out std_logic;
			oBranch     : out std_logic; -- Helps select using PC+4 or branch address by being Anded with ALU Zero
			oBranchEQ   : out std_logic; -- Determines if BEQ or BNE
			oALUOp      : out std_logic_vector(ALU_OP_WIDTH - 1 downto 0); -- Selects ALU operation or to select from funct field
			oHalt		: out std_logic); -- Halt port
	end component;

	component ALU_control is
		port (
			-- ALU Op given by Control Unit
			iALUOp : in std_logic_vector(ALU_OP_WIDTH - 1 downto 0);
	
			-- Instruction: "Funct" field
			iFunct : in std_logic_vector(FUNCT_WIDTH - 1 downto 0);
	
			-- Action for ALU to do
			oAction : out std_logic_vector(ALU_OP_WIDTH - 1 downto 0));
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

	component fetch is
		port(
			i_Addr		: in std_logic_vector(DATA_WIDTH - 1 downto 0); --input address
			i_Jump		: in std_logic; --input 0 or 1 for jump or not jump
			i_JumpReg	: in std_logic; -- jump register instr or not
			i_JumpRegData: in std_logic_vector(DATA_WIDTH - 1 downto 0);
			i_Branch	: in std_logic; --input 0 or 1 for branch or not branch
			i_Zero      : in std_logic;
			i_BEQ   : in std_logic; --input 0 or 1 for branchEQ or BNE
			i_BranchImm	: in std_logic_vector(DATA_WIDTH - 1 downto 0);
			i_JumpImm	: in std_logic_vector(JADDR_WIDTH - 1 downto 0);
			o_Addr		: out std_logic_vector(DATA_WIDTH - 1 downto 0);
			o_PCPlus4	: out std_logic_vector(DATA_WIDTH - 1 downto 0));
	end component;
		


-- DONE: Ensure that s_Halt is connected to an output control signal produced
--       from decoding the Halt instruction (Opcode: 01 0100)
-- DONE: Ensure that s_Ovfl is connected to the overflow output of your ALU

-- TODO: Implement the rest of your processor below this comment!
begin


	--------------------------  ASSIGN INSTRUCTION FIELDS  --------------------------	
	s_instr_Opcode	(OPCODE_WIDTH - 1 downto 0) <= s_Inst(31 downto 26);
	s_instr_Rs		(DATA_SELECT  - 1 downto 0) <= s_Inst(25 downto 21);
	s_instr_Rt		(DATA_SELECT  - 1 downto 0) <= s_Inst(20 downto 16);
	s_Instr_Rd		(DATA_SELECT  - 1 downto 0) <= s_Inst(15 downto 11);
	s_instr_Shamt	(DATA_SELECT  - 1 downto 0) <= s_Inst(10 downto 6);
	s_instr_Funct	(FUNCT_WIDTH  - 1 downto 0) <= s_Inst(5  downto 0);
	s_instr_imm16	(DATA_WIDTH/2 - 1 downto 0) <= s_Inst(15 downto 0);
	s_instr_Addr	(JADDR_WIDTH  - 1 downto 0) <= s_Inst(25 downto 0);

	s_DMemAddr <= s_ALUResult;
	s_DMemData <= s_ReadRt;
	s_DMemWr <= s_MemWrite;

	-- TODO: This is required to be your final input to your instruction memory.
	-- This provides a feasible method to externally load the memory module which
	-- means that the synthesis tool must assume it knows nothing about the values
	-- stored in the instruction memory. If this is not included, much, if not all
	-- of the design is optimized out because the synthesis tool will believe the
	-- memory to be all zeros.
	with iInstLd select
    s_IMemAddr <=
		s_NextInstAddr when '0',
    	iInstAddr 	   when others;



	IMem: mem
	port map(
		clk  => iCLK,
		addr => s_IMemAddr(11 downto 2),
		data => iInstExt,
		we   => iInstLd,
		q    => s_Inst);
		  
	DMem: mem
	port map(
		clk  => iCLK,
		addr => s_DMemAddr(11 downto 2),
		data => s_DMemData,
		we   => s_DMemWr,
		q    => s_DMemOut);

	PC_Reg: pc_register
	generic map(
		N => DATA_WIDTH)
	port map (
		i_CLK => iCLK,
		i_RST => iRST,
		i_WE => '1',
		i_D => s_UpdatePC,
		o_Q => s_NextInstAddr);

	Control_Unit: control
	port map (
		iOpcode     => s_instr_Opcode,
		iFunct		=> s_instr_Funct,
		-- iALUZero =>
		-- oPCSrc   =>
		oRegDst     => s_RegDst,
		oALUSrc     => s_ALUSrc,
		oMemtoReg   => s_MemtoReg,
		oRegWrite   => s_RegWrite,
		oMemRead    => s_MemRead,
		oMemWrite   => s_MemWrite,
		oSignExt	=> s_SignExt,
		oJump       => s_Jump,
		oJumpReg	=> s_JumpReg,
		oMovn		=> s_Movn,
		oBranch     => s_Branch,
		oBranchEQ   => s_BEQ,
		oALUOp      => s_ALUOp,
		oHalt		=> s_Halt);


	ALU_Control_Unit: ALU_control
	port map(
		iALUOp  => s_ALUOp,
		iFunct  => s_instr_Funct,
		oAction => s_ALUAction);
	

	Sign_Extender: extender
	port map(
		i_D 	 => s_instr_imm16,
		i_Extend => s_SignExt,
		o_F 	 => s_instr_imm32);

	-- Updated to a 3-1 mux using with-select below v
	-- RegDst_Mux: mux2t1_N
	-- generic map(
	-- 	N => DATA_SELECT)
	-- port map(
	-- 	i_S  => s_RegDst,
	-- 	i_D0 => s_instr_Rt,
	-- 	i_D1 => s_instr_Rd,
	-- 	o_O  => s_RegWrAddr);

	with s_RegDst select
		s_RegWrAddr <=
			s_instr_Rt when "00",
			s_instr_Rd when "01",
			"11111" when "10",
			s_instr_Rt when others;


	-- Selects reg write depending on if MOVN instruction is happening or not, otherwise use control RegWrite
	with s_Movn select
		s_RegWr <=
			(NOT s_Zero) when '1',
			s_RegWrite when others;
			

	Regfile_Unit: regfile
	generic map(
		N => DATA_WIDTH,
		REG_W => DATA_SELECT)
	port map(
		i_CLK	=> iCLK, 
		i_RST	=> iRST, 
		i_We 	=> s_RegWr, 
		i_Rs 	=> s_instr_Rs,  -- Register to read 1
		i_Rt 	=> s_instr_Rt,  -- Register to read 2
		i_Rd 	=> s_RegWrAddr, -- Reg being written to
		i_Wd 	=> s_RegWrData, -- Data to write to i_Rd
		o_Rs 	=> s_ReadRs, 	-- i_rs data output
		o_Rt 	=> s_ReadRt);	-- i_rt data output

	ALUSrc_mux: mux2t1_N
	generic map(
		N => DATA_WIDTH)
	port map(
		i_S  => s_ALUSrc,
		i_D0 => s_ReadRt,
		i_D1 => s_instr_imm32,
		o_O  => s_ALUInB);

	ALU_Main: ALU
	port map (
		iA			=> s_ReadRs,
        iB			=> s_ALUInB,
		iShamt		=> s_instr_Shamt,
        iALUOp		=> s_ALUAction,
        oResult		=> s_ALUPreMovn,
        oCout		=> s_Cout,
        oOverflow	=> s_Ovfl, -- Given Signal
        oZero		=> s_Zero);


	-- Movn mux after ALU
	with (s_Movn AND (NOT s_Zero)) select
		s_ALUResult <=
			s_ReadRs when '1',
			s_ALUPreMovn when others;



	-- Changed to 3-1 mux using with-select below
	-- MemtoReg_Mux: mux2t1_N
	-- generic map(
	-- 	N => DATA_WIDTH)
	-- port map (
	-- 	i_S  => s_MemtoReg,
	-- 	i_D0 => s_ALUResult,
	-- 	i_D1 => s_DMemOut,
	-- 	o_O  => s_RegWrData);

	with s_MemtoReg select
		s_RegWrData <=
		s_ALUResult when "00",
		s_DMemOut when "01",
		s_PCPlus4 when "10",
		s_ALUResult when others;

	Fetch_Unit: fetch
	port map(
		i_Addr		=> s_NextInstAddr,
		i_Jump		=> s_Jump,
		i_JumpReg	=> s_JumpReg,
		i_JumpRegData=> s_ReadRs,
		i_Branch	=> s_Branch,
		i_Zero      => s_Zero,
		i_BEQ       => s_BEQ,
		i_BranchImm	=> s_instr_imm32,
		i_JumpImm	=> s_instr_Addr,
		o_Addr		=> s_UpdatePC,
		o_PCPlus4	=> s_PCPlus4);


	oALUOut <= s_ALUResult;

end structure;
