-------------------------------------------------------------------------
-- James Minardi
-- control.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a mips Control
-- unit that sets the inputs to the datapath.
--
-- REQUIRES: MIPS_types.vhd
-------------------------------------------------------------------------

-- library declaration
library IEEE;
use IEEE.std_logic_1164.all;

-- constants & types declaration
library work;
use work.MIPS_types.all;


entity control is
    port (
		iInst		: in std_logic_vector(DATA_WIDTH - 1 downto 0);
        iOpcode     : in std_logic_vector(OPCODE_WIDTH -1 downto 0); -- 6 MSB of 32bit instruction
        iFunct      : in std_logic_vector(OPCODE_WIDTH - 1 downto 0); -- only for JR
        -- iALUZero : out std_logic; -- TODO: Zero flag from ALU for PC src?
        oPCSrc 		: out std_logic; -- TODO: Selects using PC+4 or branch addy
        oRegDst     : out std_logic_vector(REGDST_WIDTH  - 1 downto 0); -- Selects r-type vs i-type vs R31 write register
        oALUSrc     : out std_logic; -- Selects source for second ALU input (Rt vs Imm)
        oMemtoReg   : out std_logic_vector(MEMTOREG_WIDTH - 1 downto 0); -- Selects ALU result vs memory result vs PC+4 to reg write
        oRegWrite   : out std_logic; -- Enable register write in datapath->registerfile
        oMemRead    : out std_logic; -- Enable reading of memory in dmem
        oMemWrite   : out std_logic; -- Enable writing to memory in dmem
        oSignExt    : out std_logic; -- Sign extend immediate value
        oJump       : out std_logic; -- Selects setting PC to jump value or not
        oJumpReg    : out std_logic;
        oMovn       : out std_logic;
        oBranch     : out std_logic; -- Helps select using PC+4 or branch address by being Anded with ALU Zero
        oBranchEQ   : out std_logic; -- Determines if BNE or BEQ
        oALUOp      : out std_logic_vector(ALU_OP_WIDTH - 1 downto 0); -- Selects ALU operation or to select from funct field
        oHalt       : out std_logic); -- Halt bit to stop program
end control;

architecture dataflow of control is

signal s_JumpCheck : std_logic;
signal s_JumpReg : std_logic;
signal s_oALUOp : std_logic_vector(ALU_OP_WIDTH - 1 downto 0);
signal s_Action : std_logic_vector(ALU_OP_WIDTH - 1 downto 0);
signal s_PCSrc : std_logic;
signal s_OpcodeFunct : std_logic_vector(11 downto 0);
signal s_RegWritePreJrNop : std_logic;
signal s_RegWritePreNop		: std_logic;

    -- Doesn't include JAL & others
begin

	s_OpcodeFunct <= iOpcode & iFunct;
    with iOpcode select
        oRegDst <=
            "00" when "001000",  -- Addi
            "00" when "001001",  -- Addiu
            "00" when "001100",  -- Andi
            "00" when "001111",  -- Lui
            "00" when "100011",  -- Lw
            "00" when "001110",  -- Xori
            "00" when "001101",  -- Ori
            "00" when "001010", -- Slti
            "10" when "000011", -- Jal
            "01" when others;
    with iOpcode select
        oALUSrc <=
            '0' when "000000", -- r-type
            '0' when "000100", -- beq
            '0' when "000101", -- bne
            '1' when others;
    with iOpcode select
        oMemtoReg <=
            "01" when "100011", -- lw
            "10" when "000011",  -- jal
            "00" when others;

    with (s_OpcodeFunct) select
        s_JumpReg <=
            '1' when "000000001000",
            '0' when others;

    with iOpcode select
	s_RegWritePreJrNop <=
        	'1' when "000000", -- R-type (Dont for JR)
            '1' when "001000", -- addi
            '1' when "001001", -- addiu
            '1' when "001100", -- andi
            '1' when "001111", -- lui
            '1' when "100011", -- lw
            '1' when "001110", -- xori
            '1' when "001101", -- ori
            '1' when "001010", -- slti
            '1' when "000011", -- jal
            '0' when others;

	with s_OpcodeFunct select
		s_RegWritePreNop <=
			'0' when "000000001000",
			s_RegWritePreJrNop when others;

	with iInst select
		oRegWrite <=
			'0' when x"00000000",
			s_RegWritePreNop when others;

    with iOpcode select
        oMemRead <=
            '1' when "100011", -- Lw
            '0' when others;
    with iOpcode select
        oMemWrite <=
            '1' when "101011", -- sw
            '0' when others;
    with iOpcode select
        oSignExt <=
            '1' when "001000",
            '1' when "001001",
            '1' when "100011",
            '1' when "001010",
            '1' when "101011",
            '1' when "000100",  -- Beq
            '1' when "000101",  -- Bne
            '0' when others;
    with iOpcode select
        oJump <=
            '1' when "000010", -- j
            '1' when "000011", -- jal
            -- Jr sets Jump in top level from alu control
            '0' when others;
    with iOpcode select
        oBranch <=
            '1' when "000100",
            '1' when "000101",
            '0' when others;
    with iOpcode select
        oBranchEQ <=
            '1' when "000100", -- BEQ
            '0' when "000101", -- BNE
            '0' when others;
    with iOpcode select
	s_oALUOp <=
            "1111" when "000000", -- Funct
            "0000" when "001000", -- addi
            "0010" when "001001", -- addiu
            "0100" when "001100",
            "1001" when "001111", -- Lui
            "0010" when "100011",
            "0111" when "001110",
            "0101" when "001101",
            "1101" when "001010", -- Slti
            "0010" when "101011", -- sw
            "0011" when "000100", -- beq
            "0011" when "000101", -- bne
            "----" when "000010", -- J
            "0000" when others;
    with iOpcode select
        oHalt <=
            '1' when "010100",
            '0' when others;

    with s_OpcodeFunct select
        oMovn <=
            '1' when "000000001011",
            '0' when others;
    
    oJumpReg <= s_JumpReg;

	with iOpcode select
		s_PCSrc <=
			'1' when "000100",
			'1' when "000101",
			'1' when "000010",
			'1' when "000011",
			'0' when others;
	with s_OpcodeFunct select
		oPCSrc <=
			'1' when "000000001000",
			s_PCSrc when others;

    with iFunct select
        s_Action <=
        "0000" when "100000", -- Add
        "0010" when "100001", -- Add (U)
        "0001" when "100010", -- Sub
        "0011" when "100011", -- Sub (U)
        "0100" when "100100", -- And
        "0101" when "100101", -- Or
        "0110" when "100111", -- Nor
        "0111" when "100110", -- Xor
        "1000" when "000000", -- SLL
        "1010" when "000010", -- SRL
        "1011" when "000011", -- SRA
        "1101" when "101010", -- SLT
        "1110" when "001011", -- MOVN
        "0000" when others;
    with s_oALUOp select
        oALUOp <=
        s_Action when "1111", -- Funct if Opcode == "000000"
        s_oALUOp when others; -- Use OPcode instruction if opcode != "000000"

end dataflow;
