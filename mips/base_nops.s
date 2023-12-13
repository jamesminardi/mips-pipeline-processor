.data
.text
.globl main
main:
	addi $t0, $zero, -25	# $t0 = -25 (0xFFFFFFE7)
		nop
		nop
		nop
	addiu $t0, $t0, 10		# $t0 = -15 (0xFFFFFFF1)
		nop
		nop
		nop
	addi $t8, $zero, 3
		nop
		nop
		nop
	addu $t0, $t0, $t8		# $t0 = -12 (0xFFFFFFF4)
		nop
		nop
		nop

	sub $t1, $zero, $t0		# $t1 = 12 (0x0000000C)
		nop
		nop
		nop
	addi $t1, $t1, 5		# $t1 = 17 (0x00000011)

	sll $t0, $t0, 2			# $t0 = (-12 * 4) = -48 (0xFFFFFFD0)

	addi $t2, $zero, 20		# $t2 = 20 (0x
		nop
		nop
		nop

	subu $t3, $t2, $t1		# $t3 = 3
		nop
		nop
		nop

	slt $t4, $t3, $t1		# $t4 = (3 < 17) ? 1
		nop
		nop
		nop
	srl $t0, $t0, 1			# $t0 = -48/2 = -24
		nop
		nop
		nop
	sra $t5, $t0, 3			# $t5 = (0xFFFFFFE8) >> 3 = 0xFFFFFFFD (4294967293)
		nop
		nop
		nop
	or $t5, $t5, $t3		# $t5 = 0xFFFFFFFF
		nop
		nop
		nop
	and $t5, $t5, $t2		# $t5 = 0x00000014
		nop
		nop
		nop
	ori $t5, $t5, 20480		# $t5 = 0x00005014 (0101 0000 0001 0010)

	slti $t4, $t3, 1		# $t4 = (3<1) ? 1 : 0

	lui $1,21845
	nop
	nop
	nop
	ori $1,$1,21845
	nop
	nop
	nop
	add $8,$0,$1
		nop
		nop
		nop

	nor $t6, $t5, $t0		# $t6 = 1010 1010 1010 1010 1111 1010 1011 1000 (AAAAFAB8)
		nop
		nop
		nop

	xor $t7, $t6, $t6		# $t7 = 0x00000000
		nop
		nop
		nop
	xori $t7, $t7, 118		# $t7 = 118 (x00000076)
		nop
		nop
		nop
	andi $t7, $t7, 3		# $t7 = 0x00000002
		nop
		nop
		nop

	movn $t0, $t3, $t2		# $t0 = $t3 (3)

		nop
		nop
		nop

	lui $t9, 0x1000
		nop
		nop
		nop
	sw $t0, 0($t9)
		nop
	lw $t0, 0($t9)


	addi $t1, $0, 8
	addi $t2, $0, 16		

test1:
		nop
		nop
	addi $t3, $t1, 8
		nop
		nop
		nop
	beq $t3, $t2, test4
		nop
		nop
		nop

test2:
	bne $t3, $t1, test3
		nop
		nop
		nop
test3:
	jal test7
		nop
		nop
		nop
test4:	
	j test2
		nop
		nop
		nop
test5:
	jr $ra
		nop
		nop
		nop

test6:
	ori $t2, 27
test7:
	andi $t3, $t1, 24
		nop
		nop
		nop
	bne $t3, $t1, end
		nop
		nop
		nop
end:
	
	halt
