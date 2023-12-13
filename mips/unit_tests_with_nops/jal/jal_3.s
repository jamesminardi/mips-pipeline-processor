.data
.text
.globl main
main:
    # Start Test
    A:
    jal B
	nop
	nop
	nop
    B: 
    addi $t1, $t1, 1
    jal C
	nop
	nop
	nop
    C:
    addi $t1, $t1, 1
    jal D
	nop
	nop
	nop
    D: 
    addi $t1, $t1, 1
    jal Exit
	nop
	nop
	nop
    Exit: 
    # End Test

    # Exit program
    li $v0, 10
    syscall
    halt
