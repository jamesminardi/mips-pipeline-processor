.data
.text
.globl main

# Test common case of shift left logical by ensuring zeros are inserted from the right

main:
    # Start Test
	lui $1,-32768
		nop
	nop
	nop
	ori $1,$1,0
		nop
	nop
	nop
	add $2,$0,$1
	nop
	nop
	nop
    sll $1, $2, 1      # verify that sll inserts zeros from the right

    addi $2, $0, 0xFFFFFFFE
	nop
	nop
	nop
    sll $1, $2, 31      # verify that sll inserts zeros from the right
    # End Test

    # Exit program
    li $v0, 10
    syscall
    halt
