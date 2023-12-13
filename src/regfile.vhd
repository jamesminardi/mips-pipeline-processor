-------------------------------------------------------------------------
-- James Minardi
-- regfile.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a 32-bit register
-- file for a mips processor.
-------------------------------------------------------------------------

-- library declaration
library IEEE;
use IEEE.std_logic_1164.all;

entity regfile is
	generic(N : integer := 32; REG_W : integer := 5);
	port(
		i_CLK : in std_logic;		-- Clock input
		i_RST : in std_logic;		-- Reset
		i_We : in std_logic;		-- Write enable
		i_Rs : in std_logic_vector(REG_W - 1 downto 0); -- Register to read 1
		i_Rt : in std_logic_vector(REG_W - 1 downto 0); -- Register to read 2
		i_Rd : in std_logic_vector(REG_W - 1 downto 0); -- Reg being written to
		i_Wd : in std_logic_vector(N-1 downto 0);		-- Data to write to i_Rd
		o_Rs : out std_logic_vector(N-1 downto 0);		-- i_rs data output
		o_Rt : out std_logic_vector(N-1 downto 0));		-- i_rt data output
end regfile;

architecture structural of regfile is
	component dffg_N
		port(
			i_CLK        : in std_logic;     -- Clock input
			i_RST        : in std_logic;     -- Reset input
       		i_WE         : in std_logic;     -- Write enable input
       		i_D          : in std_logic_vector(N-1 downto 0);     -- Data input
       		o_Q          : out std_logic_vector(N-1 downto 0));   -- Data output
    end component;

	component decoder_N
		port (
			i_D : in std_logic_vector(REG_W -1 downto 0);
			o_F : out std_logic_vector(N - 1 downto 0));
	end component;
	
	component mux32t1_N
		port(
			i_S : in std_logic_vector(4 downto 0);
			i_D0,	i_D1,
			i_D2,	i_D3,
			i_D4,	i_D5,
			i_D6,	i_D7,
			i_D8,	i_D9,
			i_D10,	i_D11,
			i_D12,	i_D13,
			i_D14,	i_D15,
			i_D16,	i_D17,
			i_D18,	i_D19,
			i_D20,	i_D21,
			i_D22,	i_D23,
			i_D24,	i_D25,
			i_D26,	i_D27,
			i_D28,	i_D29,
			i_D30,	i_D31 : in std_logic_vector(N-1 downto 0);
			o_F 		  : out std_logic_vector(N-1 downto 0));
	end component;

-- connection from decoder to registers after being anded with the global i_We
signal s_We : std_logic_vector(N-1 downto 0) := (others=>'0');

-- Connection from registers to multiplexers
signal 	s_D0,  s_D1,  s_D2,  s_D3,
		s_D4,  s_D5,  s_D6,  s_D7,
		s_D8,  s_D9,  s_D10, s_D11,
		s_D12, s_D13, s_D14, s_D15,
		s_D16, s_D17, s_D18, s_D19,
		s_D20, s_D21, s_D22, s_D23,
		s_D24, s_D25, s_D26, s_D27,
		s_D28, s_D29, s_D30, s_D31 : std_logic_vector(N-1 downto 0);
		
begin
	DECODER: decoder_N
		port map (
			i_D => i_Rd,
			o_F => s_We);

	-- Register 0 will always be 0: That's why RST is 1 and Write enable is 0.
	REG_0: dffg_N
		port map (
			i_CLK => i_CLK,
			i_RST => '1',
			i_WE => '0',
			i_D => x"00000000",
			o_Q => s_D0);
	REG_1: dffg_N
		port map(
			i_CLK => i_CLK,
			i_RST => i_RST,
			i_WE => s_We(1) and i_We,
			i_D => i_Wd,
			o_Q => s_D1);
	REG_2: dffg_N
		port map(
			i_CLK => i_CLK,
			i_RST => i_RST,
			i_WE => s_We(2) and i_We,
			i_D => i_Wd,
			o_Q => s_D2);
	REG_3: dffg_N
		port map(
			i_CLK => i_CLK,
			i_RST => i_RST,
			i_WE => s_We(3) and i_We,
			i_D => i_Wd,
			o_Q => s_D3);
	REG_4: dffg_N
		port map(
			i_CLK => i_CLK,
			i_RST => i_RST,
			i_WE => s_We(4) and i_We,
			i_D => i_Wd,
			o_Q => s_D4);
	REG_5: dffg_N
		port map(
			i_CLK => i_CLK,
			i_RST => i_RST,
			i_WE => s_We(5) and i_We,
			i_D => i_Wd,
			o_Q => s_D5);
	REG_6: dffg_N
		port map(
			i_CLK => i_CLK,
			i_RST => i_RST,
			i_WE => s_We(6) and i_We,
			i_D => i_Wd,
			o_Q => s_D6);
	REG_7: dffg_N
		port map(
			i_CLK => i_CLK,
			i_RST => i_RST,
			i_WE => s_We(7) and i_We,
			i_D => i_Wd,
			o_Q => s_D7);
	REG_8: dffg_N
		port map(
			i_CLK => i_CLK,
			i_RST => i_RST,
			i_WE => s_We(8) and i_We,
			i_D => i_Wd,
			o_Q => s_D8);
	REG_9: dffg_N
		port map(
			i_CLK => i_CLK,
			i_RST => i_RST,
			i_WE => s_We(9) and i_We,
			i_D => i_Wd,
			o_Q => s_D9);
	REG_10: dffg_N
		port map(
			i_CLK => i_CLK,
			i_RST => i_RST,
			i_WE => s_We(10) and i_We,
			i_D => i_Wd,
			o_Q => s_D10);
	REG_11: dffg_N
		port map(
			i_CLK => i_CLK,
			i_RST => i_RST,
			i_WE => s_We(11) and i_We,
			i_D => i_Wd,
			o_Q => s_D11);
	REG_12: dffg_N
		port map(
			i_CLK => i_CLK,
			i_RST => i_RST,
			i_WE => s_We(12) and i_We,
			i_D => i_Wd,
			o_Q => s_D12);
	REG_13: dffg_N
		port map(
			i_CLK => i_CLK,
			i_RST => i_RST,
			i_WE => s_We(13) and i_We,
			i_D => i_Wd,
			o_Q => s_D13);
	REG_14: dffg_N
		port map(
			i_CLK => i_CLK,
			i_RST => i_RST,
			i_WE => s_We(14) and i_We,
			i_D => i_Wd,
			o_Q => s_D14);
	REG_15: dffg_N
		port map(
			i_CLK => i_CLK,
			i_RST => i_RST,
			i_WE => s_We(15) and i_We,
			i_D => i_Wd,
			o_Q => s_D15);
	REG_16: dffg_N
		port map(
			i_CLK => i_CLK,
			i_RST => i_RST,
			i_WE => s_We(16) and i_We,
			i_D => i_Wd,
			o_Q => s_D16);
	REG_17: dffg_N
		port map(
			i_CLK => i_CLK,
			i_RST => i_RST,
			i_WE => s_We(17) and i_We,
			i_D => i_Wd,
			o_Q => s_D17);
	REG_18: dffg_N
		port map(
			i_CLK => i_CLK,
			i_RST => i_RST,
			i_WE => s_We(18) and i_We,
			i_D => i_Wd,
			o_Q => s_D18);
	REG_19: dffg_N
		port map(
			i_CLK => i_CLK,
			i_RST => i_RST,
			i_WE => s_We(19) and i_We,
			i_D => i_Wd,
			o_Q => s_D19);
	REG_20: dffg_N
		port map(
			i_CLK => i_CLK,
			i_RST => i_RST,
			i_WE => s_We(20) and i_We,
			i_D => i_Wd,
			o_Q => s_D20);
	REG_21: dffg_N
		port map(
			i_CLK => i_CLK,
			i_RST => i_RST,
			i_WE => s_We(21) and i_We,
			i_D => i_Wd,
			o_Q => s_D21);
	REG_22: dffg_N
		port map(
			i_CLK => i_CLK,
			i_RST => i_RST,
			i_WE => s_We(22) and i_We,
			i_D => i_Wd,
			o_Q => s_D22);
	REG_23: dffg_N
		port map(
			i_CLK => i_CLK,
			i_RST => i_RST,
			i_WE => s_We(23) and i_We,
			i_D => i_Wd,
			o_Q => s_D23);
	REG_24: dffg_N
		port map(
			i_CLK => i_CLK,
			i_RST => i_RST,
			i_WE => s_We(24) and i_We,
			i_D => i_Wd,
			o_Q => s_D24);
	REG_25: dffg_N
		port map(
			i_CLK => i_CLK,
			i_RST => i_RST,
			i_WE => s_We(25) and i_We,
			i_D => i_Wd,
			o_Q => s_D25);
	REG_26: dffg_N
		port map(
			i_CLK => i_CLK,
			i_RST => i_RST,
			i_WE => s_We(26) and i_We,
			i_D => i_Wd,
			o_Q => s_D26);
	REG_27: dffg_N
		port map(
			i_CLK => i_CLK,
			i_RST => i_RST,
			i_WE => s_We(27) and i_We,
			i_D => i_Wd,
			o_Q => s_D27);
	REG_28: dffg_N
		port map(
			i_CLK => i_CLK,
			i_RST => i_RST,
			i_WE => s_We(28) and i_We,
			i_D => i_Wd,
			o_Q => s_D28);
	REG_29: dffg_N
		port map(
			i_CLK => i_CLK,
			i_RST => i_RST,
			i_WE => s_We(29) and i_We,
			i_D => i_Wd,
			o_Q => s_D29);
	REG_30: dffg_N
		port map(
			i_CLK => i_CLK,
			i_RST => i_RST,
			i_WE => s_We(30) and i_We,
			i_D => i_Wd,
			o_Q => s_D30);
	REG_31: dffg_N
		port map(
			i_CLK => i_CLK,
			i_RST => i_RST,
			i_WE => s_We(31) and i_We,
			i_D => i_Wd,
			o_Q => s_D31);
			
	
	MUX1: mux32t1_N
		port map(
			i_S		=>	i_Rs,
			i_D0	=>	s_D0,
			i_D1	=>	s_D1,
			i_D2	=>	s_D2,
			i_D3	=>	s_D3,
			i_D4	=>	s_D4,
			i_D5	=>	s_D5,
			i_D6	=>	s_D6,
			i_D7	=>	s_D7,
			i_D8	=>	s_D8,
			i_D9	=>	s_D9,
			i_D10	=>	s_D10,
			i_D11	=>	s_D11,
			i_D12	=>	s_D12,
			i_D13	=>	s_D13,
			i_D14	=>	s_D14,
			i_D15	=>	s_D15,
			i_D16	=>	s_D16,
			i_D17	=>	s_D17,
			i_D18	=>	s_D18,
			i_D19	=>	s_D19,
			i_D20	=>	s_D20,
			i_D21	=>	s_D21,
			i_D22	=>	s_D22,
			i_D23	=>	s_D23,
			i_D24	=>	s_D24,
			i_D25	=>	s_D25,
			i_D26	=>	s_D26,
			i_D27	=>	s_D27,
			i_D28	=>	s_D28,
			i_D29	=>	s_D29,
			i_D30	=>	s_D30,
			i_D31	=>	s_D31,
			o_F		=>	o_Rs);
			
	MUX2: mux32t1_N
		port map(
			i_S		=>	i_Rt,
			i_D0	=>	s_D0,
			i_D1	=>	s_D1,
			i_D2	=>	s_D2,
			i_D3	=>	s_D3,
			i_D4	=>	s_D4,
			i_D5	=>	s_D5,
			i_D6	=>	s_D6,
			i_D7	=>	s_D7,
			i_D8	=>	s_D8,
			i_D9	=>	s_D9,
			i_D10	=>	s_D10,
			i_D11	=>	s_D11,
			i_D12	=>	s_D12,
			i_D13	=>	s_D13,
			i_D14	=>	s_D14,
			i_D15	=>	s_D15,
			i_D16	=>	s_D16,
			i_D17	=>	s_D17,
			i_D18	=>	s_D18,
			i_D19	=>	s_D19,
			i_D20	=>	s_D20,
			i_D21	=>	s_D21,
			i_D22	=>	s_D22,
			i_D23	=>	s_D23,
			i_D24	=>	s_D24,
			i_D25	=>	s_D25,
			i_D26	=>	s_D26,
			i_D27	=>	s_D27,
			i_D28	=>	s_D28,
			i_D29	=>	s_D29,
			i_D30	=>	s_D30,
			i_D31	=>	s_D31,
			o_F		=>	o_Rt);
				
end structural;
			
			
			







































