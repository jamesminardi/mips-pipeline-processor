library IEEE;
use IEEE.std_logic_1164.all;

-- constants & types declaration
library work;
use work.MIPS_types.all;

entity fetch is
    port(
		i_Addr   	: in std_logic_vector(DATA_WIDTH - 1 downto 0); --input address
		i_Jump   	: in std_logic; --input 0 or 1 for jump or not jump
		i_JumpReg 	: in std_logic; -- jump reg instr or not
		i_JumpRegData:in std_logic_vector(DATA_WIDTH - 1 downto 0);
		i_Branch   	: in std_logic; --input 0 or 1 for branch or not branch
		i_Zero   	: in std_logic;
		i_BEQ   	: in std_logic; --1 = Beq, 0 = Bne
		i_BranchImm	: in std_logic_vector(DATA_WIDTH - 1 downto 0);
		i_JumpImm  	: in std_logic_vector(JADDR_WIDTH - 1 downto 0);
		o_Addr   	: out std_logic_vector(DATA_WIDTH - 1 downto 0); --output address
		o_PCPlus4	: out std_logic_vector(DATA_WIDTH - 1 downto 0));
end fetch;

architecture behavior of fetch is

	
	component mux2t1_N is --mux's
  	  	generic(N : integer);
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

	component barrel_shifter is	
		port(
			iA           : in std_logic_vector(DATA_WIDTH -1 downto 0);
			iLeft        : in std_logic;
			iArithmetic  : in std_logic;
			iShamt       : in std_logic_vector(DATA_SELECT-1 downto 0);
			oResult      : out std_logic_vector(DATA_WIDTH-1 downto 0));
	end component;
	
	
    --add this section for the sigals and begin stuff
signal s_PCPlus4 		: std_logic_vector(DATA_WIDTH - 1 downto 0);
signal s_BranchImmShift : std_logic_vector(DATA_WIDTH - 1 downto 0);
signal s_JumpImmShift 	: std_logic_vector(DATA_WIDTH - 1 downto 0); -- Only 28 lsb are used
signal s_BranchTarget	: std_logic_vector(DATA_WIDTH - 1 downto 0); -- Final branch address
signal s_JumpTarget		: std_logic_vector(DATA_WIDTH - 1 downto 0); -- Final jump address
signal s_BMuxtoJRMux			: std_logic_vector(DATA_WIDTH - 1 downto 0); -- Either Branch address or next instruction address
signal s_JRMuxtoJMux			: std_logic_vector(DATA_WIDTH - 1 downto 0); -- Either Branch address or next instruction address
-- signal s_BranchAND      : std_logic_vector(DATA_WIDTH - 1 downto 0); --Branch and BEQ AND result     
-- signal s_Br0AND			: std_logic_vector(DATA_WIDTH - 1 downto 0); -- Brnach AND with zero
-- signal s_BrN0AND		: std_logic_vector(DATA_WIDTH - 1 downto 0); -- Branch AND with not zero
-- signal s_Br_Control		: std_logic_vector(DATA_WIDTH - 1 downto 0); -- or result of Br0AND and BrN0AND

begin 
	--generic(int : integer := 4);
	--G_NBit_MUX: for i in 0 to 31 generate -- there are 32 registers that will be tried in the mux
	
	Add4: add_sub
	port map (
		iSubtract => '0',
		iA		=> i_Addr, 		-- PC input
		iB		=> x"00000004", -- 4
		oSum	=> s_PCPlus4, 	-- PC plus 4
		oCout2	=> open,
		oCout	=> open);

	Shift_JAddr: barrel_shifter
	port map (
		iA         		=> "000000" & i_JumpImm,
		iLeft      		=> '1',
		iArithmetic		=> '0',
		iShamt     		=> "00010",
		oResult    		=> s_JumpImmShift);

	Shift_BAddr: barrel_shifter
	port map (
		iA           => i_BranchImm,
		iLeft        => '1',
		iArithmetic  => '0',
		iShamt       => "00010",
		oResult      => s_BranchImmShift);

	s_JumpTarget <= s_PCPlus4(DATA_WIDTH - 1 downto 28) & s_JumpImmShift(27 downto 0);

	ADD_ALU: add_sub
	 --(pc+4) + shift2 to branch mux
	port map (
		iA			 => s_PCPlus4,
		iB			 => s_BranchImmShift, -- shift2 sign ext
		iSubtract	 => '0',
		oSum		 => s_BranchTarget, -- PC+4 + shift2 sign ext
		oCout2		 => open,
		oCout 		 => open);
	
	-- Branches_And: andg2
	-- --anding the two branch inputs
	-- port map (
	-- 	i_A			=> i_Branch,
	-- 	i_B			=> i_BEQ,
	-- 	o_F			=> s_BranchAND);
	-- B_And_0: andg2
	-- -- anding the previous with ALU zero
	-- port map (
	-- 	i_A         => s_BranchAND,
	-- 	i_B         => i_Zero,
	-- 	o_F         => s_Br0AND);

	-- B_And_not_0: andg2
	-- -- anding branches and and not zero
	-- port map (
	-- 	i_A          => s_BranchAND, 
	-- 	i_B          => not i_Zero,
	-- 	o_F          => s_BrN0AND);

	-- Branches_OR: org2
	-- -- oring the previous two and results
	-- port(
	-- 	i_A          => s_Br0AND
	-- 	i_B          => s_BrN0AND
	-- 	o_F          => s_Br_Control);	

	B_MUX: mux2t1_N
	--determines if we are branching or not
	generic map(N => DATA_WIDTH)
	port map (
		i_S          => (i_Branch AND i_BEQ AND i_Zero) OR (i_Branch AND (NOT i_BEQ) AND (NOT i_Zero)), -- control is determined by branch and then BNE/BEQ
		i_D0         => s_PCPlus4, -- 0 = result of add4
	    i_D1         => s_BranchTarget, -- 1 = result of add alu (add4 + shifted sign ext)
		o_O          => s_BMuxtoJRMux);	-- goes to jump mux
	
		-- needed: jump register for jump reg mux
	JR_MUX: mux2t1_N
	generic map(N => DATA_WIDTH)
	port map (
		i_S          => i_JumpReg, --jump register select
		   i_D0         => s_BMuxtoJRMux, --0 = result of the branch mux
		i_D1         => i_JumpRegData,
		o_O          => s_JRMuxtoJMux); --output goes to Jump mux
	
	J_MUX: mux2t1_N
	generic map(N => DATA_WIDTH)
	port map (
		i_S          => i_Jump, --jump select = alu control jump
   	    i_D0         => s_JRMuxtoJMux, --0 = result of the branch mux
        i_D1         => s_JumpTarget, --1 = jump addr (31-0)
	    o_O          => o_Addr); --output goes to PC (next inst addr in processor)


	o_PCPlus4 <= s_PCPlus4;

end behavior;
