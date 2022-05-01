# Individual case tests

# ID/EX.RegisterRd = IF/ID.RegisterRs
addi $t0, $0, 255 # $t0 becomes 255
addi $t1, $t0, 255 # $t1 becomes 510

# ID/EX.RegisterRd = IF/ID.RegisterRt
addi $t2, $0, 255 # $t2 becomes 255
add $t3, $0, $t2 # $t3 becomes 255

# EX/MEM.RegisterRd = IF/ID.RegisterRs
addi $t4, $0, 255 # $t4 becomes 255
addi $t5, $0, 127 # $t5 becomes 127
addi $t5, $t4, 255 # $t5 becomes 382

# EX/MEM.RegisterRd = IF/ID.RegisterRt
addi $t6, $0, 255 # $t6 becomes 255
addi $t7, $0, 127 # $t7 becomes 127
add $t7, $0, $t6 # $t7 becomes 382

# Load hazard
lui $1, 4097
ori $16, $1, 0
lui $1, 4097
ori $21, $1, 76
lw $21, 0($21)
addiu $2, $0, 10


## Data dependency for i-type to i-type instructions
lui $1, 0x00007fff
ori $1, $1, 0x0000effc
## Data dependency for i-type to r-type instructions
add $29, $0, $1
add $5, $1, $0
## Data dependency for r-type and i-type to r-type instructions
sub $3, $1, $29
sub $3, $5, $29 
## Data dependency for r-type and r-type to r-type instructions
add $6, $5, $3 
## Data dependency for r-type and r-type to r-type instructions
## load instruction
la $13, String2
## load String1 inside 12
lui $1, 0x00001001
ori $12, $1, 0x00000000
## Data dependency for i-type to i-type instructions
lw $7, 0($12)
## Data dependency for i-type and i-type to r-type instructions
add $8, $1, $12
## Data dependency for r-type and i-type to r-type instructions
sub $8, $7, $8
## Data dependency for sw after lw instructions
lw $10, 4($12)
sw $1, 8($12)

halt