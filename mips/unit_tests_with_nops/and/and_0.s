.data
.text
.globl main
main:
    # Start Test
    addi $1, $1, 0xFFFFFFFF
    addi $2, $2, 0xFFFFFFFF  
    and $3, $1, $2      # verify that anding 1 and 1 results in a 1 
    and $4, $1, $2      # verify that anding 1 and 1 results in a 1 
    and $5, $1, $2      # verify that anding 1 and 1 results in a 1 
    and $6, $1, $2      # verify that anding 1 and 1 results in a 1 
    and $7, $1, $2      # verify that anding 1 and 1 results in a 1 
    and $8, $1, $2      # verify that anding 1 and 1 results in a 1 
    and $9, $1, $2      # verify that anding 1 and 1 results in a 1 
    and $10, $1, $2      # verify that anding 1 and 1 results in a 1 
    and $11, $1, $2      # verify that anding 1 and 1 results in a 1 
    and $12, $1, $2      # verify that anding 1 and 1 results in a 1 
    and $13, $1, $2      # verify that anding 1 and 1 results in a 1 
    and $14, $1, $2      # verify that anding 1 and 1 results in a 1 
    and $15, $1, $2      # verify that anding 1 and 1 results in a 1 
    and $16, $1, $2      # verify that anding 1 and 1 results in a 1 
    and $17, $1, $2      # verify that anding 1 and 1 results in a 1 
    and $18, $1, $2      # verify that anding 1 and 1 results in a 1 
    and $19, $1, $2      # verify that anding 1 and 1 results in a 1 
    and $20, $1, $2      # verify that anding 1 and 1 results in a 1 
    and $21, $1, $2      # verify that anding 1 and 1 results in a 1 
    and $22, $1, $2      # verify that anding 1 and 1 results in a 1 
    and $23, $1, $2      # verify that anding 1 and 1 results in a 1 
    and $24, $1, $2      # verify that anding 1 and 1 results in a 1 
    and $25, $1, $2      # verify that anding 1 and 1 results in a 1 
    and $26, $1, $2      # verify that anding 1 and 1 results in a 1 
    and $27, $1, $2      # verify that anding 1 and 1 results in a 1 
    and $28, $1, $2      # verify that anding 1 and 1 results in a 1 
    and $29, $1, $2      # verify that anding 1 and 1 results in a 1 
    and $30, $1, $2      # verify that anding 1 and 1 results in a 1 
    # End Test

    # Exit program
    li $v0, 10
    syscall
    halt
