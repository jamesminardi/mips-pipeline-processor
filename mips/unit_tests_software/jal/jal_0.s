# testing common case for jumping to another section of code
	.data 
 
	.text 
	.globl main
main:
	jal test #16 (x10)
	nop
	nop
	nop
 	
test: 
	addi $t1, $zero, 1
	

halt
