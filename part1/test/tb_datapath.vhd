-------------------------------------------------------------------------
-- James Minardi
-- tb_datapath.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains simple test bench for MIPS datapath.
-------------------------------------------------------------------------

-- library declaration
library IEEE;
use IEEE.std_logic_1164.all;

entity tb_datapath is
	generic(N : integer := 32;
			REG_W : integer := 5;
			DATA_WIDTH : natural := 32;
			ADDR_WIDTH : natural := 10;
			gCLK_HPER: time := 50 ns);
end tb_datapath;

architecture tb of tb_datapath is

  	-- Calculate the clock period as twice the half-period
  	constant cCLK_PER  : time := gCLK_HPER * 2;

	component datapath is
	port(
		i_CLK : in std_logic;		-- Clock input
		i_We : in std_logic;		-- Write enable
		i_Rs : in std_logic_vector(REG_W - 1 downto 0) := (others=>'0'); -- Register to read 1
		i_Rt : in std_logic_vector(REG_W - 1 downto 0) := (others=>'0'); -- Register to read 2
		i_Rd : in std_logic_vector(REG_W - 1 downto 0) := (others=>'0'); -- Reg being written to
		i_MemtoReg 	: in std_logic:= '0';		-- Mem to reg (send data to register write data)
		i_MemWrite	: in std_logic;	-- Memory Write enable
		i_Imm		: in std_logic_vector((N/2)-1 downto 0) := (others=>'0');
		i_Ex		: in std_logic := '0'; 	-- If 1, Sign extend i_Imm. 0, zero extend.
		i_nAdd_Sub	: in 	std_logic := '0';
       	i_ALUSrc	: in	std_logic := '0');
	end component;
	
signal s_CLK : std_logic := '0';
signal s_We : std_logic := '0';
signal si_Rs, si_Rt, s_Rd : std_logic_vector(REG_W - 1 downto 0) := (others=>'0');
signal s_MemtoReg : std_logic := '0';
signal s_MemWrite : std_logic := '0';
signal s_I : std_logic_vector((N/2)-1 downto 0) := (others=>'0');
signal s_Ex : std_logic := '0';
signal s_nAdd_Sub : std_logic := '0';
signal s_ALUSrc : std_logic := '0';

begin
	DUT: datapath
	port map (
		i_CLK => s_CLK,
		i_Rs  => si_Rs,
		i_Rt  => si_Rt,

		i_Rd  => s_Rd,
		i_We  => s_We,

		i_Imm => s_I,
		i_Ex => s_Ex,

		i_nAdd_Sub => s_nAdd_Sub,
		i_ALUSrc => s_ALUSrc,

		i_MemtoReg => s_MemtoReg,
		i_MemWrite => s_MemWrite
		);
		
  	--This first process is to setup the clock for the test bench
  	P_CLK: process
  	begin
    	s_CLK <= '1';         -- clock starts at 1
    	wait for gCLK_HPER; -- after half a cycle
    	s_CLK <= '0';         -- clock becomes a 0 (negative edge)
    	wait for gCLK_HPER; -- after half a cycle, process begins evaluation again
  	end process; 


	P_TB: process
	begin
	--wait for gCLK_HPER/2;




-- Test case 1:
	-- addi $25, $0, 0		-- Load &A into $25 (0 is address of A)
	si_Rs <= "00000"; 	-- Read data from reg $0
	si_Rt <= "00000"; 	-- Read data from reg $0

	s_Rd <= "11001"; 	-- Write to $25
	s_We <= '1';		-- Enable writing

	s_I <= x"0000";		-- Imm = Address 0
	s_Ex <= '1';		-- addi is sign-extended
	
	s_ALUSrc <= '1'; 	-- Use Imm val
	s_nAdd_Sub <= '0'; -- Rs + Imm (0+ImmAddr)

	-- We aren't touching memory
	s_MemtoReg <= '0';
	s_MemWrite <= '0';
	wait for gCLK_HPER*2;
	-- Expected: $25 to be 0.


-- Test case 2:
	-- addi $26, $0, 0256		-- Load &B into $26 (256 is address of B)
	si_Rs <= "00000"; 	-- Read data from reg $0
	si_Rt <= "00000"; 	-- Read data from reg $0

	s_Rd <= "11010"; 	-- Write to $25
	s_We <= '1';		-- Enable writing

	s_I <= x"0100";		-- Imm = Address 256
	s_Ex <= '1';		-- addi is sign-extended
	
	s_ALUSrc <= '1'; 	-- Use Imm val
	s_nAdd_Sub <= '0'; -- Rs + Imm (0+ImmAddr)

	-- We aren't touching memory
	s_MemtoReg <= '0';
	s_MemWrite <= '0';
	wait for gCLK_HPER*2;
	-- Expected: $26 to be 256.


-- Test case 3:
	-- lw $1, 0($25)	-- Load A[0] into $1
	si_Rs <= "11001"; 	-- Read data from reg $25
	si_Rt <= "00000"; 	-- Read data from reg $0

	s_Rd <= "00001"; 	-- Write to $1
	s_We <= '1';		-- Enable writing

	s_I <= x"0000";		-- Imm
	s_Ex <= '1';		-- lw is sign-extended
	
	s_ALUSrc <= '1'; 	-- Use Imm val
	s_nAdd_Sub <= '0'; -- Rs + Imm

	s_MemtoReg <= '1';	-- Load data from address $0 to reg
	s_MemWrite <= '0';
	wait for gCLK_HPER*2;
	-- Expected: $1 to be -1.


-- Test case 4:
	-- lw $2, 4($25)	-- Load A[1] into $2
	si_Rs <= "11001"; 	-- Read data from reg $25
	si_Rt <= "00000"; 	-- Read data from reg $0

	s_Rd <= "00010"; 	-- Write to $2
	s_We <= '1';		-- Enable writing

	s_I <= x"0001";		-- Imm
	s_Ex <= '1';		-- lw is sign-extended
	
	s_ALUSrc <= '1'; 	-- Use Imm val
	s_nAdd_Sub <= '0'; -- Rs + Imm

	s_MemtoReg <= '1';	-- Load data from address $0+imm to reg
	s_MemWrite <= '0';
	wait for gCLK_HPER*2;
	-- Expected: $2 to be 2.


-- Test case 5:
	-- add $1, $1, $2
	si_Rs <= "00001"; 	-- Read data from reg $1
	si_Rt <= "00010"; 	-- Read data from reg $2

	s_Rd <= "00001"; 	-- Write to $1
	s_We <= '1';		-- Enable writing

	s_I <= x"0000";		-- Imm
	s_Ex <= '0';		-- lw is sign-extended
	
	s_ALUSrc <= '0'; 	-- Use Imm val
	s_nAdd_Sub <= '0'; -- Rs + Imm

	s_MemtoReg <= '0';	-- Assign reg using ALU result
	s_MemWrite <= '0';
	wait for gCLK_HPER*2;
	-- Expected: $1 to be 1.


-- Test case 6:
	-- sw $1, 0($26)	# Store $1 into B[0]
	si_Rs <= "11010";
	si_Rt <= "00001";

	s_Rd <= "00000"; 	-- Write reg
	s_We <= '0';		-- Enable writing

	s_I <= x"0000";		-- Imm
	s_Ex <= '1';		-- lw is sign-extended
	
	s_ALUSrc <= '1'; 	-- Use Imm val
	s_nAdd_Sub <= '0'; -- Rs + Imm

	s_MemtoReg <= '0';	-- Assign reg using ALU result
	s_MemWrite <= '1';
	wait for gCLK_HPER*2;
	-- Expected: B[0] (256) to be 1.



-- Test case 7:
	-- lw $2, 8($25)	# Load A[2] into $2
	si_Rs <= "11001";
	si_Rt <= "00000";

	s_Rd <= "00010"; 	-- Write reg
	s_We <= '1';		-- Enable writing

	s_I <= x"0002";		-- Imm
	s_Ex <= '1';		-- lw is sign-extended
	
	s_ALUSrc <= '1'; 	-- Use Imm val
	s_nAdd_Sub <= '0'; -- Rs + Imm

	s_MemtoReg <= '1';	-- Assign reg using ALU result
	s_MemWrite <= '0';
	wait for gCLK_HPER*2;
	-- Expected: $2 to be 3.


-- Test case 8:
	-- add $1, $1, $2
	si_Rs <= "00001"; 	-- Read data from reg $1
	si_Rt <= "00010"; 	-- Read data from reg $2

	s_Rd <= "00001"; 	-- Write to $1
	s_We <= '1';		-- Enable writing

	s_I <= x"0000";		-- Imm
	s_Ex <= '0';		-- lw is sign-extended
	
	s_ALUSrc <= '0'; 	-- Use Imm val
	s_nAdd_Sub <= '0'; -- Rs + Imm

	s_MemtoReg <= '0';	-- Assign reg using ALU result
	s_MemWrite <= '0';
	wait for gCLK_HPER*2;
	-- Expected: $1 to be 4.

-- Test case 9:
	-- sw $1, 4($26)	# Store $1 into B[1]
	si_Rs <= "11010";
	si_Rt <= "00001";

	s_Rd <= "00001"; 	-- Write reg
	s_We <= '0';		-- Enable writing

	s_I <= x"0001";		-- Imm
	s_Ex <= '1';		-- lw is sign-extended
	
	s_ALUSrc <= '1'; 	-- Use Imm val
	s_nAdd_Sub <= '0'; -- Rs + Imm

	s_MemtoReg <= '0';	-- Assign reg using ALU result
	s_MemWrite <= '1';
	wait for gCLK_HPER*2;
	-- Expected: B[1] (256+4) to be 4.


-- Test case 10:
	-- lw $2, 12($25)	# Load A[3] into $2
	si_Rs <= "11001";
	si_Rt <= "00000";

	s_Rd <= "00010"; 	-- Write reg
	s_We <= '1';		-- Enable writing

	s_I <= x"0003";		-- Imm
	s_Ex <= '1';		-- lw is sign-extended
	
	s_ALUSrc <= '1'; 	-- Use Imm val
	s_nAdd_Sub <= '0'; -- Rs + Imm

	s_MemtoReg <= '1';	-- Assign reg using ALU result
	s_MemWrite <= '0';
	wait for gCLK_HPER*2;
	-- Expected: $2 to be 4.


-- Test case 11(add):
	-- add $1, $1, $2
	si_Rs <= "00001"; 	-- Read data from reg $1
	si_Rt <= "00010"; 	-- Read data from reg $2

	s_Rd <= "00001"; 	-- Write to $1
	s_We <= '1';		-- Enable writing

	s_I <= x"0000";		-- Imm
	s_Ex <= '0';		-- lw is sign-extended
	
	s_ALUSrc <= '0'; 	-- Use Imm val
	s_nAdd_Sub <= '0'; -- Rs + Imm

	s_MemtoReg <= '0';	-- Assign reg using ALU result
	s_MemWrite <= '0';
	wait for gCLK_HPER*2;
	-- Expected: $1 to be 8.


-- Test case 12:
	-- sw $1, 8($26)	# Store $1 into B[0]
	si_Rs <= "11010";
	si_Rt <= "00001";

	s_Rd <= "00000"; 	-- Write reg
	s_We <= '0';		-- Enable writing

	s_I <= x"0002";		-- Imm
	s_Ex <= '1';		-- lw is sign-extended
	
	s_ALUSrc <= '1'; 	-- Use Imm val
	s_nAdd_Sub <= '0'; -- Rs + Imm

	s_MemtoReg <= '0';	-- Assign reg using ALU result
	s_MemWrite <= '1';
	wait for gCLK_HPER*2;
	-- Expected: B[2] to be 8.


-- Test case 13:
	-- lw $2, 16($25)	# Load A[3] into $2
	si_Rs <= "11001";
	si_Rt <= "00000";

	s_Rd <= "00010"; 	-- Write reg
	s_We <= '1';		-- Enable writing

	s_I <= x"0004";		-- Imm
	s_Ex <= '1';		-- lw is sign-extended
	
	s_ALUSrc <= '1'; 	-- Use Imm val
	s_nAdd_Sub <= '0'; -- Rs + Imm

	s_MemtoReg <= '1';	-- Assign reg using ALU result
	s_MemWrite <= '0';
	wait for gCLK_HPER*2;
	-- Expected: $2 to be 5.


-- Test case 14(add):
	-- add $1, $1, $2
	si_Rs <= "00001"; 	-- Read data from reg $1
	si_Rt <= "00010"; 	-- Read data from reg $2

	s_Rd <= "00001"; 	-- Write to $1
	s_We <= '1';		-- Enable writing

	s_I <= x"0000";		-- Imm
	s_Ex <= '0';		-- lw is sign-extended
	
	s_ALUSrc <= '0'; 	-- Use Imm val
	s_nAdd_Sub <= '0'; -- Rs + Imm

	s_MemtoReg <= '0';	-- Assign reg using ALU result
	s_MemWrite <= '0';
	wait for gCLK_HPER*2;
	-- Expected: $1 to be 13.


-- Test case 15:
	-- sw $1, 12($26)	# Store $1 into B[0]
	si_Rs <= "11010";
	si_Rt <= "00001";

	s_Rd <= "00000"; 	-- Write reg
	s_We <= '0';		-- Enable writing

	s_I <= x"0003";		-- Imm
	s_Ex <= '1';		-- lw is sign-extended
	
	s_ALUSrc <= '1'; 	-- Use Imm val
	s_nAdd_Sub <= '0'; -- Rs + Imm

	s_MemtoReg <= '0';	-- Assign reg using ALU result
	s_MemWrite <= '1';
	wait for gCLK_HPER*2;
	-- Expected: B[3] (256+12) to be -3.


-- Test case 16:
	-- lw $2, 20($25)	# Load A[3] into $2
	si_Rs <= "11001";
	si_Rt <= "00000";

	s_Rd <= "00010"; 	-- Write reg
	s_We <= '1';		-- Enable writing

	s_I <= x"0005";		-- Imm
	s_Ex <= '1';		-- lw is sign-extended
	
	s_ALUSrc <= '1'; 	-- Use Imm val
	s_nAdd_Sub <= '0'; -- Rs + Imm

	s_MemtoReg <= '1';	-- Assign reg using ALU result
	s_MemWrite <= '0';
	wait for gCLK_HPER*2;
	-- Expected: $2 to be 6.


-- Test case 17(add):
	-- add $1, $1, $2
	si_Rs <= "00001"; 	-- Read data from reg $1
	si_Rt <= "00010"; 	-- Read data from reg $2

	s_Rd <= "00001"; 	-- Write to $1
	s_We <= '1';		-- Enable writing

	s_I <= x"0000";		-- Imm
	s_Ex <= '0';		-- lw is sign-extended
	
	s_ALUSrc <= '0'; 	-- Use Imm val
	s_nAdd_Sub <= '0'; -- Rs + Imm

	s_MemtoReg <= '0';	-- Assign reg using ALU result
	s_MemWrite <= '0';
	wait for gCLK_HPER*2;
	-- Expected: $1 to be 19.


-- Test case 18:
	-- sw $1, 16($26)	
	si_Rs <= "11010";
	si_Rt <= "00001";

	s_Rd <= "00000"; 	-- Write reg
	s_We <= '0';		-- Enable writing

	s_I <= x"0004";		-- Imm
	s_Ex <= '1';		-- lw is sign-extended
	
	s_ALUSrc <= '1'; 	-- Use Imm val
	s_nAdd_Sub <= '0'; -- Rs + Imm

	s_MemtoReg <= '0';	-- Assign reg using ALU result
	s_MemWrite <= '1';
	wait for gCLK_HPER*2;


-- Test case 19:
	-- lw $2, 24($25)	
	si_Rs <= "11001";
	si_Rt <= "00000";

	s_Rd <= "00010"; 	-- Write reg
	s_We <= '1';		-- Enable writing

	s_I <= x"0006";		-- Imm
	s_Ex <= '1';		-- lw is sign-extended
	
	s_ALUSrc <= '1'; 	-- Use Imm val
	s_nAdd_Sub <= '0'; -- Rs + Imm

	s_MemtoReg <= '1';	-- Assign reg using ALU result
	s_MemWrite <= '0';
	wait for gCLK_HPER*2;
	-- Expected: $2 to be -7.


-- Test case 20(add):
	-- add $1, $1, $2
	si_Rs <= "00001"; 	-- Read data from reg $1
	si_Rt <= "00010"; 	-- Read data from reg $2

	s_Rd <= "00001"; 	-- Write to $1
	s_We <= '1';		-- Enable writing

	s_I <= x"0000";		-- Imm
	s_Ex <= '0';		-- lw is sign-extended
	
	s_ALUSrc <= '0'; 	-- Use Imm val
	s_nAdd_Sub <= '0'; -- Rs + Imm

	s_MemtoReg <= '0';	-- Assign reg using ALU result
	s_MemWrite <= '0';
	wait for gCLK_HPER*2;
	-- Expected: $1 to be 12.


-- Test case 20(add):
	-- add $27, $0, 512
	si_Rs <= "00000"; 
	si_Rt <= "00000";

	s_Rd <= "11011"; 	-- Write to $27
	s_We <= '1';		-- Enable writing

	s_I <= x"0200";		-- Imm
	s_Ex <= '1';		-- lw is sign-extended
	
	s_ALUSrc <= '1'; 	-- Use Imm val
	s_nAdd_Sub <= '0'; -- Rs + Imm

	s_MemtoReg <= '0';	-- Assign reg using ALU result
	s_MemWrite <= '0';
	wait for gCLK_HPER*2;
	-- Expected: $27 to be 512.


-- Test case 21:
	-- sw $1, -4($27)	# Store $1 into B[0]
	si_Rs <= "11011";
	si_Rt <= "00001";

	s_Rd <= "00000"; 	-- Write reg
	s_We <= '0';		-- Enable writing

	s_I <= x"0001";		-- Imm
	s_Ex <= '1';		-- lw is sign-extended
	
	s_ALUSrc <= '1'; 	-- Use Imm val
	s_nAdd_Sub <= '1';  -- Rs - Imm

	s_MemtoReg <= '0';	-- Assign reg using ALU result
	s_MemWrite <= '1';
	wait for gCLK_HPER*2;
	-- Expected: B[255] to be $1.


	end process;
end tb;






















		
		
