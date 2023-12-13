-- tb_control.vhd
-------------------------------------------------------------------------
-- TETS: 2 (200ns)
-- REQUIRES: MIPS_types.vhd, control.vhd
-------------------------------------------------------------------------

-- library declaration
library IEEE;
use IEEE.std_logic_1164.all;

-- constants & types declaration
library work;
use work.MIPS_types.all;

entity tb_control is
end tb_control;

architecture behavior of tb_control is
    component control is
        port(
            iOpcode     : in std_logic_vector(OPCODE_WIDTH -1 downto 0); -- 6 MSB of 32bit instruction
            iFunct      : in std_logic_vector(OPCODE_WIDTH - 1 downto 0); -- only for JR
            -- iALUZero : in std_logic; -- TODO: Zero flag from ALU for PC src?
            -- oPCSrc : in std_logic; -- TODO: Selects using PC+4 or branch addy
            oRegDst     : out std_logic_vector(REGDST_WIDTH  - 1 downto 0); -- Selects r-type vs i-type vs R31 write register
            oALUSrc     : out std_logic; -- Selects source for second ALU input (Rt vs Imm)
            oMemtoReg   : out std_logic_vector(MEMTOREG_WIDTH - 1 downto 0); -- Selects ALU result vs memory result vs PC+4 to reg write
            oRegWrite   : out std_logic; -- Enable register write in datapath->registerfile
            oMemRead    : out std_logic; -- Enable reading of memory in dmem
            oMemWrite   : out std_logic; -- Enable writing to memory in dmem
            oJump       : out std_logic; -- Selects setting PC to jump value or not
            oJumpReg    : out std_logic;
            oMovn       : out std_logic;
            oBranch     : out std_logic; -- Helps select using PC+4 or branch address by being Anded with ALU Zero
            oBranchEQ   : out std_logic; -- Determines if BNE or BEQ
            oALUOp      : out std_logic_vector(ALU_OP_WIDTH - 1 downto 0); -- Selects ALU operation or to select from funct field
            oHalt       : out std_logic; -- Halt bit to stop program
            oSignExt    : out std_logic); -- Sign extend immediate value
    end component;

signal s_iOpcode    : std_logic_vector(OPCODE_WIDTH - 1 downto 0);
signal s_iFunct      : std_logic_vector(FUNCT_WIDTH - 1 downto 0);
signal s_oRegDst    : std_logic_vector(REGDST_WIDTH - 1 downto 0);
signal s_oALUSrc    : std_logic;
signal s_oMemtoReg  : std_logic_vector(MEMTOREG_WIDTH - 1 downto 0);
signal s_oRegWrite  : std_logic;
signal s_oMemRead   : std_logic;
signal s_oMemWrite  : std_logic;
signal s_oJump      : std_logic;
signal s_oJumpReg   : std_logic;
signal s_oBranch    : std_logic;
signal s_oBranchEq  : std_logic;
signal s_oALUOp     : std_logic_vector(ALU_OP_WIDTH - 1 downto 0);
signal s_oHalt      : std_logic;
signal s_oSignExt   : std_logic;

begin
DUT: control
port map(
    iOpcode     => s_iOpcode,
    iFunct      => s_iFunct,
    oRegDst     => s_oRegDst,
    oALUSrc     => s_oALUSrc,
    oMemtoReg   => s_oMemtoReg,
    oRegWrite   => s_oRegWrite,
    oMemRead    => s_oMemRead,
    oMemWrite   => s_oMemWrite,
    oJump       => s_oJump,
    oJumpReg    => s_oJumpReg,
    oBranch     => s_oBranch,
    oBranchEQ   => s_oBranchEq,
    oALUOp      => s_oALUOp,
    oHalt       => s_oHalt,
    oSignExt    => s_oSignExt);

P_TB: process
begin
    -- Test add (0-100)
    s_iOpcode   <= "000000";
    s_iFunct    <= "100000";
    -- Excepted:
    --  oRegDst     = 01
    --  oALUSrc     = 0
    --  oMemtoReg   = 00
    --  oRegWrite   = 1
    --  oMemRead    = 0
    --  oMemWrite   = 0
    --  oJump       = 0
    --  oJumpReg    = 0
    --  oBranch     = 0
    --  oBranchEQ   = x
    --  oALUOp      = 1111
    --  oHalt       = 0
    --  oSignExt    = x
    wait for 100 ns;

    -- Test addi (100-200)
    s_iOpcode <= "001000";
    s_iFunct  <= "000000";
    -- Excepted:
    --  oRegDst     = 00
    --  oALUSrc     = 1
    --  oMemtoReg   = 00
    --  oRegWrite   = 1
    --  oMemRead    = 0
    --  oMemWrite   = 0
    --  oJump       = 0
    --  oJumpReg    = 0
    --  oBranch     = 0
    --  oBranchEQ   = x
    --  oALUOp      = 0000
    --  oHalt       = 0
    --  oSignExt    = 1
    wait for 100 ns;

    -- Test addiu (200-300)
    s_iOpcode <= "001001";
    s_iFunct  <= "000000";
    -- Excepted:
    --  oRegDst     = 00
    --  oALUSrc     = 1
    --  oMemtoReg   = 00
    --  oRegWrite   = 1
    --  oMemRead    = 0
    --  oMemWrite   = 0
    --  oJump       = 0
    --  oJumpReg    = 0
    --  oBranch     = 0
    --  oBranchEQ   = x
    --  oALUOp      = 0010
    --  oHalt       = 0
    --  oSignExt    = 1
    wait for 100 ns;

    -- Test addu (300-400)
    s_iOpcode <= "000000";
    s_iFunct  <= "100001";
    -- Excepted:
    --  oRegDst     = 01
    --  oALUSrc     = 0
    --  oMemtoReg   = 00
    --  oRegWrite   = 1
    --  oMemRead    = 0
    --  oMemWrite   = 0
    --  oJump       = 0
    --  oJumpReg    = 0
    --  oBranch     = 0
    --  oBranchEQ   = x
    --  oALUOp      = 1111
    --  oHalt       = 0
    --  oSignExt    = x
    wait for 100 ns;

    -- Test and (400-500)
    s_iOpcode <= "000000";
    s_iFunct  <= "100100";
    -- Excepted:
    --  oRegDst     = 01
    --  oALUSrc     = 0
    --  oMemtoReg   = 00
    --  oRegWrite   = 1
    --  oMemRead    = 0
    --  oMemWrite   = 0
    --  oJump       = 0
    --  oJumpReg    = 0
    --  oBranch     = 0
    --  oBranchEQ   = x
    --  oALUOp      = 1111
    --  oHalt       = 0
    --  oSignExt    = x
    wait for 100 ns;

    -- Test lui (500-600)
    s_iOpcode <= "001111";
    s_iFunct  <= "000000";
    -- Excepted:
    --  oRegDst     = 00
    --  oALUSrc     = 1
    --  oMemtoReg   = 00
    --  oRegWrite   = 1
    --  oMemRead    = 0
    --  oMemWrite   = 0
    --  oJump       = 0
    --  oJumpReg    = 0
    --  oBranch     = 0
    --  oBranchEQ   = x
    --  oALUOp      = 1001
    --  oHalt       = 0
    --  oSignExt    = x
    wait for 100 ns;
 
    -- Test lw (600-700)
    s_iOpcode <= "100011";
    s_iFunct  <= "000000";
    -- Excepted:
    --  oRegDst     = 00
    --  oALUSrc     = 1
    --  oMemtoReg   = 01
    --  oRegWrite   = 1
    --  oMemRead    = 1
    --  oMemWrite   = 0
    --  oJump       = 0
    --  oJumpReg    = 0
    --  oBranch     = 0
    --  oBranchEQ   = x
    --  oALUOp      = 0010
    --  oHalt       = 0
    --  oSignExt    = 1
    wait for 100 ns;

    -- Test slt (700-800)
    s_iOpcode <= "000000";
    s_iFunct  <= "101010";
    -- Excepted:
    --  oRegDst     = 01
    --  oALUSrc     = 0
    --  oMemtoReg   = 00
    --  oRegWrite   = 1
    --  oMemRead    = 0
    --  oMemWrite   = 0
    --  oJump       = 0
    --  oJumpReg    = 0
    --  oBranch     = 0
    --  oBranchEQ   = x
    --  oALUOp      = 1111
    --  oHalt       = 0
    --  oSignExt    = x
    wait for 100 ns; 

    -- Test sw (800-900)
    s_iOpcode <= "101011";
    s_iFunct  <= "000000";
    -- Excepted:
    --  oRegDst     = xx
    --  oALUSrc     = 1
    --  oMemtoReg   = xx
    --  oRegWrite   = 0
    --  oMemRead    = 0
    --  oMemWrite   = 1
    --  oJump       = 0
    --  oJumpReg    = 0
    --  oBranch     = 0
    --  oBranchEQ   = x
    --  oALUOp      = 0010
    --  oHalt       = 0
    --  oSignExt    = 1
    wait for 100 ns; 

    -- Test j (900-1000)
    s_iOpcode <= "000010";
    s_iFunct  <= "000000";
    -- Excepted:
    --  oRegDst     = 01
    --  oALUSrc     = 1
    --  oMemtoReg   = 00
    --  oRegWrite   = 0
    --  oMemRead    = 0
    --  oMemWrite   = 0
    --  oJump       = 1
    --  oJumpReg    = 0
    --  oBranch     = 0
    --  oBranchEQ   = x
    --  oALUOp      = x
    --  oHalt       = 0
    --  oSignExt    = x
    wait for 100 ns; 

    -- Test jr (1000-1100)
    s_iOpcode <= "000000";
    s_iFunct  <= "001000";
    -- Excepted:
    --  oRegDst     = 01
    --  oALUSrc     = 1
    --  oMemtoReg   = 00
    --  oRegWrite   = 0
    --  oMemRead    = 0
    --  oMemWrite   = 0
    --  oJump       = 0
    --  oJumpReg    = 1
    --  oBranch     = 0
    --  oBranchEQ   = x
    --  oALUOp      = 1111
    --  oHalt       = 0
    --  oSignExt    = x
    wait for 100 ns; 

    -- Test movn (1100-1200)
    s_iOpcode <= "000000";
    s_iFunct  <= "001011";
    -- Excepted:
    --  oRegDst     = 01
    --  oALUSrc     = 0
    --  oMemtoReg   = 00
    --  oRegWrite   = 1
    --  oMemRead    = 0
    --  oMemWrite   = 0
    --  oJump       = 0
    --  oJumpReg    = 0
    --  oBranch     = 0
    --  oBranchEQ   = x
    --  oALUOp      = 0000
    --  oHalt       = 0
    --  oSignExt    = x
    wait for 100 ns; 




end process;
end behavior;