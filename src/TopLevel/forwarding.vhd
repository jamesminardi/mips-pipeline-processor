
library IEEE;
use IEEE.std_logic_1164.all;

library work;
use work.MIPS_types.all;

entity forwarding is
	port(
		id_Rs		: in std_logic_vector(DATA_SELECT - 1 downto 0);
		id_Rt		: in std_logic_vector(DATA_SELECT - 1 downto 0);
		ex_Rs		: in std_logic_vector(DATA_SELECT - 1 downto 0);
		ex_Rt		: in std_logic_vector(DATA_SELECT - 1 downto 0);
		mem_RegWr	: in std_logic;
		mem_Rd		: in std_logic_vector(DATA_SELECT - 1 downto 0);
		wb_RegWr	: in std_logic;
		wb_Rd		: in std_logic_vector(DATA_SELECT - 1 downto 0);
		o_AluA 		: out std_logic_vector(1 downto 0);
		o_AluB		: out std_logic_vector(1 downto 0);
		o_ReadRs	: out std_logic;
		o_ReadRt	: out std_logic);
end forwarding;

architecture arch of forwarding is

	begin
process (ex_Rs, ex_Rt, mem_RegWr, mem_Rd, wb_RegWr, wb_Rd, id_Rs, id_Rt)
	begin


	-- Regfile Bypass
	if ( wb_Rd = id_Rs AND wb_RegWr = '1' AND wb_Rd /= "00000") then
		o_ReadRs <= '1';
	else
		o_ReadRs <= '0';
	end if;

	-- Regfile Bypass
	if ( wb_Rd = id_Rt AND wb_RegWr = '1' AND wb_Rd /= "00000") then
		o_ReadRt <= '1';
	else
		o_ReadRt <= '0';
	end if;


	-- ALU A FWD
	if ( mem_RegWr = '1' AND mem_Rd /= "00000" AND ex_Rs = mem_Rd ) then
		-- Ex Hazard
		o_AluA <= "10";
	elsif ( wb_RegWr  = '1' AND wb_Rd  /= "00000" AND ex_Rs = wb_Rd ) then
		-- Mem Hazard, must check after ex hazard
		o_AluA <= "01";
	else

		-- No forward to AluA
		o_AluA <= "00";
	end if;
 
	-- ALU B FWD
	if ( mem_RegWr = '1' AND mem_Rd /= "00000" AND ex_Rt = mem_Rd ) then
		-- Ex Hazard
		o_AluB <= "10";
	elsif ( wb_RegWr  = '1' AND wb_Rd  /= "00000" AND ex_Rt = wb_Rd ) then
		-- Mem Hazard, must check after ex hazard
		o_AluB <= "01";
	else

		-- No forward to AluB
		o_AluB <= "00";
	end if;


end process;

end arch;
