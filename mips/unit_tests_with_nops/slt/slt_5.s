.data
.text
.globl main
main:
    # Start Test
    addi $12, $12, 100	#prep
    addi $12, $12, 100	#prep
    slt $t9, $12, $13   # test the basic functionality of slt on equality
    # End Test

    # Exit program
    li $v0, 10
    syscall
    halt
