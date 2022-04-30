.data
.text
.globl main
main:


jal target
nop
nop
nop
j end       #can proram jump through multiple different nested jal jr statents
nop
nop
nop

target:
nop
nop
nop
jal target2
nop
nop
nop

addi $sp, $ra, -8  #jumpst to correct sopt
nop
nop
nop
jr $sp
nop
nop
nop


target2:
nop
nop
nop
jr $ra #returns to previous are inside the inside of the initial jal statement
nop
nop
nop

 
 end:
 
 
    # Exit program
    li $v0, 10
    syscall
    halt
