# Individual instruction tests



# values used for beq and bne
addi $t0, $0, 1
addi $t1, $0, 2
addi $t2, $0, 1



# beq
	beq $t0, $t2, beq_end
	addi $t3, $0, 0
beq_end:	addi $t3, $0, 1



# bne
	bne $t0, $t1, bne_end
	addi $t4, $0, 0
bne_end:	addi $t4, $0, 1



# j, jal, jr
	jal jal_mid
	addi $t6, $0, 1
	j jal_end
jal_mid: addi $t5, $0, 1
	jr $ra
jal_end: addi $t7, $0, 1



halt