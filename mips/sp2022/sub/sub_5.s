.data
.text
.globl main

main:
#test that subtraction works in cases where rs > rt

li $t1, 0xFFFFFFFF
nop
nop
nop
li $t2, 0x00000001
nop
nop
nop
sub $t1, $t1, $t2 # $2 = 0xFFFFFFFE
nop
nop
nop
sub $t1, $t1, $zero
nop
nop
nop
lui $1,3840
nop
nop
nop
ori $10,$1,0
nop
nop
nop
sub $t1, $t1, $t2 # $2 = 0xF0FFFFFE
nop
nop
nop
li $t2, 0x0000F000
nop
nop
nop
sub $t1, $t1, $t2 # $2 = 0xF0FF0FFE 
nop
nop
nop

li $v0, 10
syscall
halt
