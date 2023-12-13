.data
val: .word 0x8, 0x10, 0x12
val2: .word 0xc, 0x12, 0x14
.text
.globl main
main:
	# This test verifies a "general case" usage of the lw instruction. These instructions
	# represent the vast majority of lw applications and this test acts as a basic 
	#functionality check.

	# Start Test
	#la $t0, val              # using $t0 to hold memory address
	lui $1,4097
	nop
	nop
	nop
	ori $8,$1,0
	nop
	nop
	nop

	lw $t1, 0($t0)			# verify that lw addressing works


	addi $t0, $t0, 4		# increment address
	nop
	nop
	nop
	lw $t2, 0($t0)			# verify that lw addressing works (with incremented address)


	addi $t0, $t0, 4		# increment address
	nop
	nop
	nop
	lw $t3, 0($t0)			# verify that lw addressing works (with incremented address)



	lasw $t0, val2             # reset address register
	nop
	nop
	nop
	lw $t4, 4($t0)			# verify that lw addressing works (with offset)


	lw $t5, 8($t0)			# verify that lw addressing works (with offset)


	lw $t6, 0xc($t0)		# verify that lw addressing works (with offset)
	# End Test
	
	# Exit Program
	li $v0, 10
	syscall
        halt
