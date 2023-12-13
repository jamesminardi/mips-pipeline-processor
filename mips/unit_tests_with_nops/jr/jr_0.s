.data
.text
.globl main
main:
addi $s0, $0, 0

#start
jal target
nop
nop
nop
                   #can program step through multilple jal jr calls
jal target2
nop
nop
nop

jal target3
nop
nop
nop

j end
nop
nop
nop



target:

addi $s0 $s0, 1 #first jal

jr $ra

target2:
nop # needed because of jr just above
nop
nop
addi $s0 $s0, 1#second jal

jr $ra

target3:#third jal
nop # needed because of jr just above
nop
nop
addi $s0 $s0, 1

# jr $ra

end:



    # Exit program
    li $v0, 10
    syscall
    halt
