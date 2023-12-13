	.data

Arr:	.word	1,3,2,5,4,0,7,6

	.text

	.globl main

main:
	addi $t1, $t0, 8 # get size of array

loop_main:
	nop
	nop
	nop
	addi $a1, $t1, -1	# count for current pass

	nop
	nop
	nop

	# check if complete
	slt $1,$0,$5
	nop
	nop
	nop
	beq $1,$0,end

	nop
	nop
	nop
	lasw $a0, Arr		# get array address
	nop
	nop
	nop
	addi $t2, $0, 0 # clear swap flag

	jal loop		# single sort pass
	nop
	nop
	nop

	beq $t2, $0, end	# if no swaps then sort = done
	nop
	nop
	nop

	addi $t1, $t1, -1	# decrease remaining pass count

	j loop_main		# go back to start of loop
	nop
	nop
	nop

loop:
	nop ###
	nop
	nop
	lw $s1, 0($a0)		# loads first element in $s1
	lw $s2, 4($a0)		# loads second element in $s2

	nop
	nop
	nop
	slt $t7, $s1, $s2
	nop
	nop
	nop
	beq $t7, $0, swap	# if s2 < s1 then swap
	nop
	nop
	nop

next:
	addiu $a0, $a0, 4	# next element

	addiu $a1, $a1, -1	# decrease number of loops

	nop
	nop
	nop
	slt $1,$0,$5
	nop
	nop
	nop
	bne $1,$0,loop # checks for swap or goes to loop
	nop
	nop
	nop


	jr $ra			# returns
	nop
	nop
	nop

swap:
	sw $s1, 4($a0)		# puts value of [i+1] in s1
	sw $s2, 0($a0)		# puts value of [i] in s2
	addi $t2, $0, 1		# notes a swap
	
	j next			# jump to next
	nop
	nop
	nop

end:
	li $v0, 10
	syscall
	halt
