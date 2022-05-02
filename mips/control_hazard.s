

# Test Flushing of IF on control flow instruction
j test1
addi $t0, $0, 5 # Flush this to nop
test1:
addi $t1, $0, 1

# Test data flow hazard through a control flow hazard
addi $t2 $0, 2
j test2
addi $t0, $0, 999 # Flush this to nop
test2:
addi $t1, $2, 1 # Fwd from wb to id

# Test branch in combination with data flow hazard
addi $t0, $0, 1
addi $t1, $0, 1
beq $t0, $t1, test3
addi $t0, $0, 999 # Flush this
test3:
add $t2, $t1, $t0 # No fwd needed because beq stalls for the data hazards

# Branch & Jump combination
addi $t0, $0, 1
addi $t1, $0, 1
j test4
addi $t0, $0, 3 # Flush
test4:
beq $t0, $t1, test5 # Stall once for $t1 (Because it's in WB)
addi $t0, $0, 3 # Flush
test5:
add $t2, $t1, $t0 # No fwding needed because branch stalled $t1 and $t0 out of pipeline


# j, jal, jr test
	jal jal_mid
	addi $t6, $0, 1 # Initially flushed then returned to
	j jal_end
jal_mid: addi $t5, $0, 1 # Executed then flushed out later by jump
	jr $ra
jal_end: addi $t7, $0, 1 # Initially flushed then returned to



halt