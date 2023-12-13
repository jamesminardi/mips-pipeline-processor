.data
.text
.globl main

main:
#verify that signed subtraction of a negative number acts as addition
addi $t1, $zero, 0 #reset $t1
lui $t0, 0xFFFF
nop
nop
nop
lui $1,0
nop
nop
nop
ori $1,$1,65535
nop
nop
nop
add $8,$8,$1
#addi $t0, $t0, 0xFFFF
nop
nop
nop
sub $t1, $zero, $t0 #expected value in $t1 is 0x0001
nop
nop
nop
sub $t1, $t1, $t0 # $t1 = 0x00000002
nop
nop
nop
sub $t0, $t0, $t1 # $t0 = 0xFFFFFFFF - 0x0000002 = 0xFFFFFFFD
nop
nop
nop
sub $t1, $t1, $t0 # $t1 = 0x00000002 + 3 = 0x00000005
nop
nop
nop
sub $t0, $t0, $t1 # $t0 = 0xFFFFFFFD - 0x00000005 = 0xFFFFFFF8
nop
nop
nop
sub $t1, $t1, $t0 # $t0 = 0x00000005 + 8 = 0x0000000D
nop
nop
nop

li $v0, 10
syscall
halt
