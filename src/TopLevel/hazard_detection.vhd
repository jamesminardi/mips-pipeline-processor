
library IEEE;
use IEEE.std_logic_1164.all;

library work;
use work.MIPS_types.all;

entity hazard_detection is
	generic(N : integer := DATA_WIDTH);
	port(
		id_Rs		: in std_logic_vector(DATA_SELECT - 1 downto 0);
		id_Rt		: in std_logic_vector(DATA_SELECT - 1 downto 0);
		id_Jump		: in std_logic;
		id_JumpReg	: in std_logic;
		id_Branch	: in std_logic;
		id_Jal		: in std_logic;
		ex_Rt		: in std_logic_vector(DATA_SELECT - 1 downto 0);
		ex_Rd		: in std_logic_vector(DATA_SELECT - 1 downto 0);
		ex_RegWr	: in std_logic;
		ex_MemRead 	: in std_logic;
 
		mem_Rd		: in std_logic_vector(DATA_SELECT - 1 downto 0);
		mem_RegWr	: in std_logic;

		wb_Rd		: in std_logic_vector(DATA_SELECT - 1 downto 0);
		wb_RegWr	: in std_logic;

		o_PCWrite	: out std_logic;
		o_ifid_We	: out std_logic; -- Used in conjuction with idex_flush for stalling
		o_ifid_Flush: out std_logic; -- Link to RST, same as flush in ifid reg I guess?
		o_idex_We	: out std_logic; 
		o_idex_Flush: out std_logic); -- Set id/ex control signals to 0 (Used in stalling w/ if/id and pc WE = 0)
end hazard_detection;

architecture arch of hazard_detection is
-- Detecting the need to forward
-- Possible data hazard when:
	-- mem_Rd = ex_Rs
	-- mem_Rd = ex_Rt
	-- wb_Rd = ex_Rs
	-- wb_Rd = ex_Rt
	-- when mem_Rd / wb_Rd != 0
	-- And when mem_RegWrite / wb_RegWrite = 1

-- Data hazard for branches (Branch Rd = wb_Rd, mem_Rd, or ex_Rd)
-- Can forward if:
	-- wb_Rd = id_Rd
	-- mem_Rd = id_Rd
	-- ex_Rd = id_Rd then Stall once
	-- ex_Rd = id_Rd AND ex is a LW instruction, then stall twice

-- Stall on branch
-- Stall on jump fs
-- Stall on load use

-- Load use
	-- ex_MemRead && ((ex_Rt = id_Rs) || (ex_Rt = id_Rt))
	-- Stall if so


begin

-- STALL:
-- o_PCWrite	<= '0';
-- o_ifid_We	<= '0';
-- o_ifid_Flush	<= '0';
-- o_idex_We	<= '1';
-- o_idex_Flush	<= '1';

-- NO CHANGE:
-- o_PCWrite	<= '1';
-- o_ifid_We	<= '1';
-- o_ifid_Flush	<= '0';
-- o_idex_We	<= '1';
-- o_idex_Flush	<= '0';

process (id_Rs, id_Rt, id_Jump, id_JumpReg, id_Branch, ex_Rt, ex_Rd, ex_RegWr, ex_MemRead, mem_Rd, mem_RegWr, wb_Rd, wb_RegWr)
	begin
	-- Load-use data hazard
	if (ex_MemRead = '1' AND (id_Rs = ex_Rt OR id_Rt = ex_Rt)) then
		-- stall id
		o_PCWrite	<= '0';
		o_ifid_We	<= '0';
		o_ifid_Flush<= '0';
		o_idex_We	<= '1';
		o_idex_Flush<= '1';

	-- Jump Register data hazard
	elsif (id_JumpReg = '1' AND (id_Rs = ex_Rd AND ex_RegWr = '1')) then
		-- Stall id for 1 instruction previous
		o_PCWrite	<= '0';
		o_ifid_We	<= '0';
		o_ifid_Flush<= '0';
		o_idex_We	<= '1';
		o_idex_Flush<= '1';

	elsif (id_JumpReg = '1' AND (id_Rs = mem_Rd AND ex_RegWr = '1')) then
		-- Stall id for 2 instructions previous
		o_PCWrite	<= '0';
		o_ifid_We	<= '0';
		o_ifid_Flush<= '0';
		o_idex_We	<= '1';
		o_idex_Flush<= '1';

	elsif (id_JumpReg = '1' AND (id_Rs = wb_Rd AND ex_RegWr = '1')) then
		-- Stall id for 3 instructions previous
		o_PCWrite	<= '0';
		o_ifid_We	<= '0';
		o_ifid_Flush<= '0';
		o_idex_We	<= '1';
		o_idex_Flush<= '1';

	-- Branch data hazard
	elsif (id_Branch = '1' AND (id_Rs = ex_Rd OR id_Rt = ex_Rd) AND ex_RegWr = '1' AND ex_Rd /= "00000") then
		-- Stall id for 1 instruction previous (data hazard from ex stage)
		o_PCWrite	<= '0';
		o_ifid_We	<= '0';
		o_ifid_Flush<= '0';
		o_idex_We	<= '1';
		o_idex_Flush<= '1';
	elsif (id_Branch = '1' AND (id_Rs = mem_Rd OR id_Rt = mem_Rd) AND mem_RegWr = '1' AND mem_Rd /= "00000") then
		-- Stall id for 2 instructions previous (data hazard from mem stage)
		o_PCWrite	<= '0';
		o_ifid_We	<= '0';
		o_ifid_Flush<= '0';
		o_idex_We	<= '1';
		o_idex_Flush<= '1';
	-- elsif (id_Branch = '1' AND (id_Rs = wb_Rd OR id_Rt = wb_Rd) AND wb_RegWr = '1' AND wb_Rd /= "00000") then
	-- 	-- Stall id for 3 instructions previous (data hazard from wb stage)
	-- 	o_PCWrite	<= '0';
	-- 	o_ifid_We	<= '0';
	-- 	o_ifid_Flush<= '0';
	-- 	o_idex_We	<= '1';
	-- 	o_idex_Flush<= '1';
	
	else

		-- Check control flow hazards after data
		if (id_Branch = '1' OR id_Jump = '1' OR id_JumpReg = '1' OR id_Jal = '1') then
			-- Flush IF/ID
			o_PCWrite	<= '1';
			o_ifid_We	<= '1';
			o_ifid_Flush<= '1';
			o_idex_We	<= '1';
			o_idex_Flush<= '0';
		else
		-- No stalls needed (no hazard excluding forwarded ones)
			o_PCWrite	<= '1';
			o_ifid_We	<= '1';
			o_ifid_Flush<= '0';
			o_idex_We	<= '1';
			o_idex_Flush<= '0';
		end if;


	end if;


end process;

end arch;

		