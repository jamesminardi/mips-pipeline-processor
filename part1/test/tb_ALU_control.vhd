-- tb_ALU_control.vhd
-------------------------------------------------------------------------
-- TETS: 2 (200ns)
-- REQUIRES: MIPS_types.vhd, ALU_control.vhd
-------------------------------------------------------------------------

-- library declaration
library IEEE;
use IEEE.std_logic_1164.all;

-- constants & types declaration
library work;
use work.MIPS_types.all;

entity tb_ALU_control is
end tb_ALU_control;

architecture behavior of tb_ALU_control is
    component ALU_control is
        port (
            -- ALU Op given by Control Unit
            iALUOp : in std_logic_vector(ALU_OP_WIDTH - 1 downto 0);
    
            -- Instruction: "Funct" field
            iFunct : in std_logic_vector(FUNCT_WIDTH - 1 downto 0);
    
            -- Action for ALU to do
            oAction : out std_logic_vector(ALU_OP_WIDTH - 1 downto 0));
    end component;

signal s_iALUOp : std_logic_vector(ALU_OP_WIDTH - 1 downto 0);
signal s_iFunct : std_logic_vector(FUNCT_WIDTH - 1 downto 0);
signal s_oAction : std_logic_vector(ALU_OP_WIDTH - 1 downto 0);

begin 
DUT: ALU_control
port map(
    iALUOp => s_iALUOp,
    iFunct => s_iFunct,
    oAction => s_oAction);

P_TB: process
begin

-- NOTE: 1111 is "Use Funct", otherwise, decode
    -- add 0-1
    s_iALUOp <= "1111"; -- Use Funct
    s_iFunct <= "100000";
    -- Excepted: oAction = 0000 (add signed)
    wait for 100 ns;

    -- addi 1-2
    s_iALUOp <= "0000"; -- Add signed
    s_iFunct <= "000000";
    -- Excepted: oAction = 0000 (add signed)
    wait for 100 ns;

    -- addiu 2-3
    s_iALUOp <= "0010"; -- Add unsigned
    s_iFunct <= "000000";
    -- Excepted: oAction = 0010 (add unsigned)
    wait for 100 ns;

    -- addu 3-4
    s_iALUOp <= "1111"; -- Use funct
    s_iFunct <= "100001";
    -- Excepted: oAction = 0010 (add unsigned)
    wait for 100 ns;

    -- and 4-5
    s_iALUOp <= "1111"; -- Use funct
    s_iFunct <= "100100";
    -- Excepted: oAction = 0100 (and)
    wait for 100 ns;

    -- lui 5-6
    s_iALUOp <= "1001"; -- Shift LL
    s_iFunct <= "000000";
    -- Excepted: oAction = 1001 (sll)
    wait for 100 ns;

    -- lw 6-7
    s_iALUOp <= "0010"; -- Add unsigned
    s_iFunct <= "000000";
    -- Excepted: oAction = 0010
    wait for 100 ns;

    -- nor 7-8
    s_iALUOp <= "1111"; -- funct
    s_iFunct <= "100111";
    -- Excepted: oAction = 0110 (nor)
    wait for 100 ns;

    -- xor 8-9
    s_iALUOp <= "1111"; -- funct
    s_iFunct <= "100110";
    -- Excepted: oAction = 0111 (xor)
    wait for 100 ns;

    -- or 9-10
    s_iALUOp <= "1111"; -- funct
    s_iFunct <= "100101";
    -- Excepted: oAction = 0101 (or)
    wait for 100 ns;

    -- slt 10-11
    s_iALUOp <= "1111"; -- funct
    s_iFunct <= "101010";
    -- Excepted: oAction = 1101 (slt)
    wait for 100 ns;

    -- slti 11-12
    s_iALUOp <= "1101";
    s_iFunct <= "000000";
    -- Excepted: oAction = 1101 (slt)
    wait for 100 ns;

    -- sw 12-13
    s_iALUOp <= "0010";
    s_iFunct <= "101010";
    -- Excepted: oAction = 0010 (add)
    wait for 100 ns;

    -- beq 13-14
    s_iALUOp <= "0011";
    s_iFunct <= "000000";
    -- Excepted: oAction = 0011 (sub unisgned)
    wait for 100 ns;

    -- jr 14-15
    s_iALUOp <= "1111";
    s_iFunct <= "001000";
    -- Excepted: oAction = 0000 (add signed)
    wait for 100 ns;

    -- movn 15-16
    s_iALUOp <= "1111";
    s_iFunct <= "001011";
    -- Excepted: oAction = 1110 (movn)
    wait for 100 ns;


end process;
end behavior;