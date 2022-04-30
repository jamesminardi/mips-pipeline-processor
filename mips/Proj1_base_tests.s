.data
.text
.globl main
main:

addi $t0, $zero, -25	# $t0 = -25 (0xFFFFFFE7)
addiu $t0, $t0, 10		# $t0 = -15 (0xFFFFFFF1)
addu $t0, $t0, 3		# $t0 = -12 (0xFFFFFFF4)

sub $t1, $zero, $t0		# $t1 = 12 (0x0000000C)
addi $t1, $t1, 5		# $t1 = 17 (0x00000011)

sll $t0, $t0, 2			# $t0 = (-12 * 4) = -48 (0xFFFFFFD0)

addi $t2, $zero, 20		# $t2 = 20 (0x

subu $t3, $t2, $t1		# $t3 = 3

slt $t4, $t3, $t1		# $t4 = (3 < 17) ? 1

srl $t0, $t0, 1			# $t0 = -48/2 = -24

sra $t5, $t0, 3			# $t5 = (0xFFFFFFE8) >> 3 = 0xFFFFFFFD (4294967293)
or $t5, $t5, $t3		# $t5 = 0xFFFFFFFF
and $t5, $t5, $t2		# $t5 = 0x00000014
ori $t5, $t5, 20480		# $t5 = 0x00005014 (0101 0000 0001 0010)

slti $t4, $t3, 1		# $t4 = (3<1) ? 1 : 0

addi $t0, $zero, 1431655765 # $t0 = 0x55555555

nor $t6, $t5, $t0		# $t6 = 1010 1010 1010 1010 1111 1010 1011 1000 (AAAAFAB8)

xor $t7, $t6, $t6		# $t7 = 0x00000000
xori $t7, $t7, 118		# $t7 = 118 (x00000076)
andi $t7, $t7, 3		# $t7 = 0x00000002

movn $t0, $t3, $t2		# $t0 = $t3 (3)


# Exit program
halt