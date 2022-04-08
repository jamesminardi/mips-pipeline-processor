-------------------------------------------------------------------------
-- Author: Braedon Giblin
-- Date: 2022.02.12
-- Files: MIPS_types.vhd
-------------------------------------------------------------------------
-- Description: This file contains a skeleton for some types that 381 students
-- may want to use. This file is guarenteed to compile first, so if any types,
-- constants, functions, etc., etc., are wanted, students should declare them
-- here.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

package MIPS_types is

  -- Instruction field width constants
  constant FUNCT_WIDTH : integer := 6;
  constant OPCODE_WIDTH : integer := 6;
  constant JADDR_WIDTH : integer := 26;

  -- Width of data
  constant DATA_WIDTH : integer := 32;
  -- Select bits to select from data_width
  constant DATA_SELECT : integer := 5;

  -- Width of addresses
  constant ADDR_WIDTH : integer := 10;
  -- Width of ALU Op out of Control Unit and Action for ALU
  constant ALU_OP_WIDTH : integer := 4;

  constant REGDST_WIDTH : integer := 2;
  constant MEMTOREG_WIDTH : integer := 2;

  -- Example record type. Declare whatever types you need here
  type control_t is record
    reg_wr : std_logic;
    reg_to_mem : std_logic;
  end record control_t;

end package MIPS_types;

package body MIPS_types is
  -- Probably won't need anything here... function bodies, etc.
end package body MIPS_types;
