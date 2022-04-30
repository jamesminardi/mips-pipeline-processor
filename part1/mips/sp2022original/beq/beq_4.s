.data
.text
.globl main
main:
	# test begin
	# this test will ensure that beq is capable of branching when equal
	
	# set up register values
	# each one of these will test a specific bit in the 32 bit word
	addi	$1,$0,1
	sll	$2,$1,1
	sll	$3,$2,1
	sll	$4,$3,1
	sll	$5,$4,1
	sll	$6,$5,1
	sll	$7,$6,1
	sll	$8,$7,1
	sll	$9,$8,1
	sll	$10,$9,1
	sll	$11,$10,1
	sll	$12,$11,1
	sll	$13,$12,1
	sll	$14,$13,1
	sll	$15,$14,1
	sll	$16,$15,1
	sll	$17,$16,1
	sll	$18,$17,1
	sll	$19,$18,1
	sll	$20,$19,1
	sll	$21,$20,1
	sll	$22,$21,1
	sll	$23,$22,1
	sll	$24,$23,1
	sll	$25,$24,1
	sll	$26,$25,1
	sll	$27,$26,1
	sll	$28,$27,1
	sll	$29,$28,1
	sll	$30,$29,1
	sll	$31,$30,1
	
	# now test all of the registers in the beq instruction
	# this test will test every bit inside of the comparison logic, and ensure that every register can be compared
	
	# this test exists to ensure that the comparison logic is capible of correctly identifying that two values are
	# equal for all registers. every comparison in this test should compare to be true, with a combination of registers
	# and values. This test will also ensure that beq can correctly jump forward the correct amount of spaces.
	
	beq	$0,$0 next
	li	$v0,10
	syscall
next:
	beq	$1,$1,next1
	li	$v0,10
	syscall
next1:
	beq	$2,$2,next2
	li	$v0,10
	syscall
next2:
	beq	$3,$3,next3
	li	$v0,10
	syscall
next3:
	beq	$4,$4,next4
	li	$v0,10
	syscall
next4:
	beq	$5,$5,next5
	li	$v0,10
	syscall
next5:
	beq	$6,$6,next6
	li	$v0,10
	syscall
next6:
	beq	$7,$7,next7
	li	$v0,10
	syscall
next7:
	beq	$8,$8,next8
	li	$v0,10
	syscall
next8:
	beq	$9,$9,next9
	li	$v0,10
	syscall
next9:
	beq	$10,$10,next10
	li	$v0,10
	syscall
next10:
	beq	$11,$11,next11
	li	$v0,10
	syscall
next11:
	beq	$12,$12,next12
	li	$v0,10
	syscall
next12:
	beq	$13,$13,next13
	li	$v0,10
	syscall
next13:
	beq	$14,$14,next14
	li	$v0,10
	syscall
next14:
	beq	$15,$15,next15
	li	$v0,10
	syscall
next15:
	beq	$16,$16,next16
	li	$v0,10
	syscall
next16:
	beq	$17,$17,next17
	li	$v0,10
	syscall
next17:
	beq	$18,$18,next18
	li	$v0,10
	syscall
next18:
	beq	$19,$19,next19
	li	$v0,10
	syscall
next19:
	beq	$20,$20,next20
	li	$v0,10
	syscall
next20:
	beq	$21,$21,next21
	li	$v0,10
	syscall
next21:
	beq	$22,$22,next22
	li	$v0,10
	syscall
next22:
	beq	$23,$23,next23
	li	$v0,10
	syscall
next23:
	beq	$24,$24,next24
	li	$v0,10
	syscall
next24:
	beq	$25,$25,next25
	li	$v0,10
	syscall
next25:
	beq	$26,$26,next26
	li	$v0,10
	syscall
next26:
	beq	$27,$27,next27
	li	$v0,10
	syscall
next27:
	beq	$28,$28,next28
	li	$v0,10
	syscall
next28:
	beq	$29,$29,next29
	li	$v0,10
	syscall
next29:
	beq	$30,$30,next30
	li	$v0,10
	syscall
next30:
	beq	$31,$31,pass
	li	$v0,10
	syscall
	
pass:
        halt
	# reaching this point indicates that the test nominally succeeded 
	
	# test end
	# exit the program

	

