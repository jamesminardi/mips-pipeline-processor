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
    add $a0, $zero, $ra
    li $v0, 1
    syscall
    jal C
	nop
	nop
	nop
    C:
    add $a0, $zero, $ra
    li $v0, 1
    syscall
    jal D
	nop
	nop
	nop
    D: 
    add $a0, $zero, $ra
    li $v0, 1
    syscall
    Exit: 
    # End Test

    # Exit program
    li $v0, 10
    syscall
    halt
