-------------------------------------------------------------------------
-- James Minardi
-- ALU_control.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of an ALU Control
-- module that selects the operation to be used by the ALU. Abstracts the
-- funct field of the instruction from the Control Unit.
--
-- REQUIRES: MIPS_types.vhd
-------------------------------------------------------------------------

-- library declaration
library IEEE;
use IEEE.std_logic_1164.all;

-- constants & types declaration
library work;
use work.MIPS_types.all;


entity ALU_control is
    port (
        -- ALU Op given by Control Unit
        iALUOp : in std_logic_vector(ALU_OP_WIDTH - 1 downto 0);

        -- Instruction: "Funct" field
        iFunct : in std_logic_vector(FUNCT_WIDTH - 1 downto 0);

        -- Action for ALU to do
        oAction : out std_logic_vector(ALU_OP_WIDTH - 1 downto 0));
end ALU_control;

architecture dataflow of ALU_control is

-- Carries action selected from funct mux to 0000 of ALUOp mux
signal s_oAction : std_logic_vector(ALU_OP_WIDTH - 1 downto 0);

begin
    with iFunct select
        s_oAction <=
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
    with iALUOp select
        oAction <=
        s_oAction when "1111", -- Funct if Opcode == "000000"
        iALUOp when others; -- Use OPcode instruction if opcode != "000000"

end dataflow;

