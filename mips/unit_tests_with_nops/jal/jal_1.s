# Testing common case of jumping both forward and backward	
	.data 
 
	.text
	.globl main
main:
	jal test2			# Forward jump
	nop
	nop
	nop
	halt
 	
test1: 
	halt
	
test2:
	nop
	nop
	nop
	jal test1			# Backwards jump
	nop
	nop
	nop
	addi $t0, $zero, 20	# In case of fail $t0 = 20
	
	
	
        halt
