	.data

Arr:	.word	1,3,2,5,4,0,7,6

	.text

	.globl main

main:
	li $t1, 8		# get size of array

loop_main:
	subi $a1, $t1, 1	# count for current pass
	ble $a1, $0, end	# check if complete
	la $a0, Arr		# get array address
	li $t2, 0		# clear swap flag
	jal loop		# single sort pass
	beq $t2, $0, end	# if no swaps then sort = done
	subi $t1, $t1, 1	# decrease remaining pass count
	j loop_main		# go back to start of loop

loop:
	lw $s1, 0($a0)		# loads first element in $s1
	lw $s2, 4($a0)		# loads second element in $s2
	bgt $s1, $s2, swap	# if s2 < s1 then swap

next:
	addiu $a0, $a0, 4	# next element
	subiu $a1, $a1, 1	# decrease number of loops
	bgt $a1, $0, loop	# checks for swap or goes to loop
	jr $ra			# returns

swap:
	sw $s1, 4($a0)		# puts value of [i+1] in s1
	sw $s2, 0($a0)		# puts value of [i] in s2
	li $t2, 1		# notes a swap
	j next			# jump to next

end:
	li $v0, 10
	syscall
	halt
