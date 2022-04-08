.globl main

main:
	addi $t1, $0, 8
	addi $t2, $0, 16		

test1:
	addi $t3, $t1, 8
	beq $t3, $t2, test4

test2:
	bne $t3, $t1, test3
test3:
	jal test7
test4:	
	j test2
test5:
	jr $ra

test6:
	ori $t2, 27
test7:
	andi $t3, $t1, 24
	bne $t3, $t1, end
end:
	
	halt
