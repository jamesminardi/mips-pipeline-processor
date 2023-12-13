
addi $t1 , $t1 , 1 # this test shows that the shift is performed exactly as I want, and it fills the gaps with 0
	nop
	nop
	nop
sll $t1 , $t1 , 31
	nop
	nop
	nop
halt
nop
nop
nop
