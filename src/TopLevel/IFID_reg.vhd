library IEEE;
use IEEE.std_logic_1164.all;

-- constants & types declaration
library work;
use work.MIPS_types.all;

entity IFID_reg is
	generic(N : integer := 32);
		port(
			i_CLK       : in std_logic;	-- Clock input
			i_RST       : in std_logic;	-- Reset input
			i_WE		: in std_logic;	-- Write enable
			i_Inst		: in std_logic_vector(N-1 downto 0);	-- Full instruction
			i_PCPlus4	: in std_logic_vector(N-1 downto 0);	-- PC + 4
			o_Inst		: out std_logic_vector(N-1 downto 0);
			o_PCPlus4	: out std_logic_vector(N-1 downto 0));
end IFID_reg;

architecture behavior of IFID_reg is

	component dffg_N is
		generic(N : integer := 32);
		port(
			i_CLK        : in std_logic;     -- Clock input
			i_RST        : in std_logic;     -- Reset input
			i_WE		 : in std_logic;	 -- Write enable
       		i_D          : in std_logic;     -- Data value input
       		o_Q          : out std_logic);   -- Data value output
	end component;

begin
	-- Instruction [31:0]
	g_Inst: for i in 0 to N-1 generate
		Inst_i: dffg_N 
			generic map (N => N)
			port map (
				i_CLK	=> i_CLK,
				i_RST	=> i_RST,
				i_WE	=> i_WE,
				i_D		=> i_Inst(i),
				o_Q		=> o_Inst(i));
	end generate g_Inst;

	-- PC + 4 [31:0]
	g_PCPlus4: for i in 0 to N-1 generate
		PCPlus4_i: dffg_N
			generic map (N => N)
			port map (
				i_CLK	=> i_CLK,
				i_RST	=> i_RST,
				i_WE	=> i_WE,
				i_D		=> i_PCPlus4(i),
				o_Q		=> o_PCPlus4(i));
	end generate g_PCPlus4;

	-- -- IF_Flush What is this
	-- g_dffg_N: for i in 0 to N-1 generate
	-- 	dffg_N_I: pc_dffg port map (
	-- 					i_CLK	=> i_CLK,
	-- 					i_ADDR_RST => s_ADDR_RST(i),
	-- 					i_RST	=> i_RST,
	-- 					i_WE	=> i_WE,
	-- 					i_D		=> i_D(i),
	-- 					o_Q		=> o_Q(i));
	-- end generate g_dffg_N;

end behavior;
