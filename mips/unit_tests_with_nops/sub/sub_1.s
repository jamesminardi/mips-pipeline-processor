.data
.text
.globl main
main:

    # Start Test
    
    addi $1, $0, 31    #adding 31 into register 1
	nop
	nop
	nop
    addi $2, $0, 1     #adding 1 into register 2
	nop
	nop
	nop
    sub $1, $1, $2     # verify that one can clear registers and 31-1 works in the ALU
	nop
	nop
	nop
    sub $1, $1, $2     # verify that one can clear registers and 31-1 works in the ALU
    nop
	nop
	nop
	sub $1, $1, $2     # verify that one can clear registers and 31-1 works in the ALU
    
	nop
	nop
	nop
	sub $1, $1, $2     # verify that one can clear registers and 31-1 works in the ALU
    nop
	nop
	nop
	sub $1, $1, $2     # verify that one can clear registers and 31-1 works in the ALU
	nop
	nop
	nop
    sub $1, $1, $2     # verify that one can clear registers and 31-1 works in the ALU
	nop
	nop
	nop
    sub $1, $1, $2     # verify that one can clear registers and 31-1 works in the ALU
	nop
	nop
	nop
    sub $1, $1, $2     # verify that one can clear registers and 31-1 works in the ALU
	nop
	nop
	nop
    sub $1, $1, $2     # verify that one can clear registers and 31-1 works in the ALU
	nop
	nop
	nop
    sub $1, $1, $2     # verify that one can clear registers and 31-1 works in the ALU
	nop
	nop
	nop
    sub $1, $1, $2     # verify that one can clear registers and 31-1 works in the ALU
	nop
	nop
	nop
    sub $1, $1, $2     # verify that one can clear registers and 31-1 works in the ALU
	nop
	nop
	nop
    sub $1, $1, $2     # verify that one can clear registers and 31-1 works in the ALU
	nop
	nop
	nop
    sub $1, $1, $2     # verify that one can clear registers and 31-1 works in the ALU
	nop
	nop
	nop
    sub $1, $1, $2     # verify that one can clear registers and 31-1 works in the ALU
	nop
	nop
	nop
    sub $1, $1, $2     # verify that one can clear registers and 31-1 works in the ALU
	nop
	nop
	nop
    sub $1, $1, $2     # verify that one can clear registers and 31-1 works in the ALU
	nop
	nop
	nop
    sub $1, $1, $2     # verify that one can clear registers and 31-1 works in the ALU
	nop
	nop
	nop
    sub $1, $1, $2     # verify that one can clear registers and 31-1 works in the ALU
	nop
	nop
	nop
    sub $1, $1, $2     # verify that one can clear registers and 31-1 works in the ALU
	nop
	nop
	nop
    sub $1, $1, $2     # verify that one can clear registers and 31-1 works in the ALU
	nop
	nop
	nop
    sub $1, $1, $2     # verify that one can clear registers and 31-1 works in the ALU
	nop
	nop
	nop
    sub $1, $1, $2     # verify that one can clear registers and 31-1 works in the ALU
	nop
	nop
	nop
    sub $1, $1, $2     # verify that one can clear registers and 31-1 works in the ALU
	nop
	nop
	nop
    sub $1, $1, $2     # verify that one can clear registers and 31-1 works in the ALU
	nop
	nop
	nop
    sub $1, $1, $2     # verify that one can clear registers and 31-1 works in the ALU
	nop
	nop
	nop
    sub $1, $1, $2     # verify that one can clear registers and 31-1 works in the ALU
	nop
	nop
	nop
    sub $1, $1, $2     # verify that one can clear registers and 31-1 works in the ALU
	nop
	nop
	nop
    sub $1, $1, $2     # verify that one can clear registers and 31-1 works in the ALU
	nop
	nop
	nop
    sub $1, $1, $2     # verify that one can clear registers and 31-1 works in the ALU
	nop
	nop
	nop
    sub $1, $1, $2     # verify that one can clear registers and 31-1 works in the ALU
	nop
	nop
	nop
     
    # Exit program
    li $v0, 10
    syscall
    halt
