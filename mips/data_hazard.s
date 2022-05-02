
addi $t0, $0, 5
lui $t5, 0x1000
sw $t0, 0($t5) # Fwd $t1 and $t0

# Test1: Load-use
lw $2, 0($t5)
addi $3, $t2, 1 # (Stall b/c of load-use)
addi $4, $t2, 2 # Fwd $1
addi $5, $2, 3 # Okay because of stall


# Test2: Regfile bypass
addi $t1, $0, 5
addi $t2, $t1, 1 # (fwd)
addi $t3, $t1, 1 # (fwd)
and $t1, $t1, $t2 # (rf bypass)

# Test3: Fwd mem -> ex
addi $t0, $0, 10
addi $t1, $t0, 20 # (fwd mem to ex stage)

# Test4: Fwd wb to ex 
addi $t0, $0, 10
nop
addi $t1, $t0, 20 # (fwd wb to ex stage)

# Test5: Fwd wb to mem to ex
addi $t0, $0, 10
addi $t1, $t0, 20 # (fwd from mem to ex)
addi $t2, $t1, 30 # (fwd from mem to ex)

# Test6: STall branch/Jr b/c of data hazard
addi $t0, $0, 1
addi $t1, $0, 1
beq $t0, $t1, branch # Stall dependencies out of pipeline because pc fetch is in ID and it isn't Fwded
addi $t1, $0, 3 # Flushed
branch:
halt

