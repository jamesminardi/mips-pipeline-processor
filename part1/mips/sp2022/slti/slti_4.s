.data
.text
.globl main
main:
    # Start Test
    addi $t0, $t0, 2
    slti $t0, $t0, 1 
    # End Test

    # Exit program
    li $v0, 10
    syscall
    halt
