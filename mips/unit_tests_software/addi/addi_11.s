##Test overflow, should end with 0x0000000
#addi $s0, $s0, 0x7fffffff ##set max val

lui $1,32767
ori $1,$1,65535
add $16,$16,$1

addi $16,$16,1

lui $1,0x7777
ori $1,$1,0xEEEE
add $16,$16,$1


lui $1,0x3333 # 0x70000000
ori $1,$1,0x1111
add $16,$16,$1


addi $16,$16,1

addi $15,$15,1
nop
nop
addi $15,$15,9




halt
