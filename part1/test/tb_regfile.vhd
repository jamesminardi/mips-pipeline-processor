-------------------------------------------------------------------------
-- James Minardi
-- tb_regfile.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a simple VHDL testbench for a mips
-- register file.
-- RUN: 1200
-------------------------------------------------------------------------

-- library declaration
library IEEE;
use IEEE.std_logic_1164.all;

-- entity
entity tb_regfile is
	generic(N : integer := 32;
			REG_W : integer := 5;
			gCLK_HPER: time := 50 ns);
end tb_regfile;

-- TODO: Add RST to tests
architecture tb of tb_regfile is

  	-- Calculate the clock period as twice the half-period
  	constant cCLK_PER  : time := gCLK_HPER * 2;

	component regfile is
		port(
			i_CLK	: in  std_logic;	-- Clock input
			i_RST	: in  std_logic;	-- Reset
			i_We	: in  std_logic;	-- Write enable
			i_Rs	: in  std_logic_vector(REG_W - 1 downto 0); -- Register to read 1
			i_Rt	: in  std_logic_vector(REG_W - 1 downto 0); -- Register to read 2
			i_Rd	: in  std_logic_vector(REG_W - 1 downto 0); -- Reg being written to
			i_Wd	: in  std_logic_vector(N-1 downto 0);		-- Data to write to i_Rd
			o_Rs	: out std_logic_vector(N-1 downto 0);		-- i_rs data output
			o_Rt	: out std_logic_vector(N-1 downto 0));		-- i_rt data output
	end component;

signal s_CLK : std_logic := '0';
signal s_RST : std_logic := '0';
signal s_We : std_logic := '0';
signal s_Wd : std_logic_vector(N-1 downto 0) := (others=>'0');
signal s_Rd : std_logic_vector(REG_W - 1 downto 0) := (others=>'0');
signal si_Rs, si_Rt : std_logic_vector(REG_W - 1 downto 0) := (others=>'0');
signal so_Rs, so_Rt : std_logic_vector(N-1 downto 0) := (others=>'0');

begin
	DUT: regfile
	port map (
		i_CLK => s_CLK,
		i_RST => s_RST,
		i_We  => s_We,
		i_Rs  => si_Rs,
		i_Rt  => si_Rt,
		i_Rd  => s_Rd,
		i_Wd  => s_Wd,
		o_Rs  => so_Rs,
		o_Rt  => so_Rt);
		
	
  	--This first process is to setup the clock for the test bench
  	P_CLK: process
  	begin
    	s_CLK <= '1';         -- clock starts at 1
    	wait for gCLK_HPER; -- after half a cycle
    	s_CLK <= '0';         -- clock becomes a 0 (negative edge)
    	wait for gCLK_HPER; -- after half a cycle, process begins evaluation again
  	end process;  		
		
process
	begin
	
	--wait for gCLK_HPER/2; -- for waveform clarity, I prefer not to change inputs on clk edges
	s_RST <= '0';
	
-- Test case 1:
	-- Load 5 into $0 and read $0
	si_Rs <= "00000"; -- Output the data of this register
	si_Rt <= "00000"; -- Output the data of this register
	s_We <= '1'; -- If 1,
	s_Wd <= x"00000005"; -- Write this
	s_Rd <= "00000"; -- To this register
	wait for gCLK_HPER*2;
	si_Rs <= "00000"; -- Output the data of this register
	si_Rt <= "00000"; -- Output the data of this register
	s_We <= '0'; -- Turn off writing
	wait for gCLK_HPER*2;
	-- Expected: o_Rs and o_Rt should both be 0 since $0 cannot be written to.
	
-- Test case 2:
	-- Load 3 into $1 and read $1
	si_Rs <= "00000"; -- Output the data of this register
	si_Rt <= "00000"; -- Output the data of this register
	s_We <= '1'; -- If one,
	s_Wd <= x"00000005"; -- Write this
	s_Rd <= "00001"; -- To this register
	wait for gCLK_HPER*2;
	si_Rs <= "00001"; -- Output the data of this register
	si_Rt <= "00001"; -- Output the data of this register
	s_We <= '0'; -- Turn off writing
	wait for gCLK_HPER*2;
	-- Expected: o_Rs and o_Rt should both be 3
	
-- Test case 3:
	-- Keep reading $1 that has 3 and load 9 into $1 to show overriding a register
	si_Rs <= "00001"; -- Output the data of this register
	si_Rt <= "00001"; -- Output the data of this register
	s_We <= '1'; -- If 1,
	s_Wd <= x"00000009"; -- Write this
	s_Rd <= "00001"; -- To this register
	wait for gCLK_HPER*2;
	si_Rs <= "00001"; -- Output the data of this register
	si_Rt <= "00001"; -- Output the data of this register
	s_We <= '0'; -- Turn off writing
	wait for gCLK_HPER*2;
	-- Expected: o_Rs and o_Rt should both be 3 then switch to 9 after the next high clock

-- Test case 4:
	-- Set Write Enable = 0, and Load data to x"AAAAAAAA" into $1 and read $1.
	si_Rs <= "00000"; -- Output the data of this register
	si_Rt <= "00000"; -- Output the data of this register
	s_We <= '1'; -- If 1,
	s_Wd <= x"AAAAAAAA"; -- Write this
	s_Rd <= "00001"; -- To this register
	wait for gCLK_HPER*2;
	si_Rs <= "00001"; -- Output the data of this register
	si_Rt <= "00001"; -- Output the data of this register
	s_We <= '0'; -- Turn off writing
	wait for gCLK_HPER*2;
	-- Expected: o_Rs and o_Rt should both be x"AAAAAAAA" after this test
	
-- Test case 5: Test RESET
	wait for gCLK_HPER*2;
	s_RST <= '1';
	wait for gCLK_HPER*2;
	si_Rs <= "00001"; -- Output the data of this register
	si_Rt <= "00001"; -- Output the data of this register
	s_We <= '0'; -- Turn off writing
	s_RST <= '0';
	wait for gCLK_HPER*2;
	-- Expected: o_Rs and o_Rt should both be 0 after this test






end process;
end tb;
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		

