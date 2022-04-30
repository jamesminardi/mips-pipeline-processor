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
    bne $t1, 2, A
    Exit: 
    # End Test

    # Exit program
    li $v0, 10
    syscall
    halt
