# Combinational case test
	beq $t0, $t2, beq_end
	ori $t3, $0, 1
beq_end:	bne $t0, $t1, bne_end
	ori $t3, $0, 2
bne_end:	jal jal_mid
	ori $t3, $0, 3
	j jal_end
jal_mid: ori $t3, $0, 4
	jr $ra
jal_end: ori $t3, $0, 5

halt