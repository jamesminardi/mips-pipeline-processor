.data
.text
.globl main

main :

addi $t1, $0, 5    #Adding 5 to the lower half
nop
nop
nop
lui $t1, 0x1001  # Loading value into upper half and it should clear the lower half of $t1
#addi $t2, $0, 0x11111111 # INtializing every bit in $t2
lui $1,4369
nop
nop
nop
ori $1,$1,4369
nop
nop
nop
add $10,$0,$1
nop
nop
nop
lui $t2, 0xffff  #Loading FFFF to the upper half and it should clear every other bit


#Exits the program
li $v0, 10
syscall
halt
