# Combinational case test

addi $t0, $0, 255 # $t0 becomes 255
addi $t1, $t0, 255 # $t1 becomes 510
addi $t1, $t0, 255 # $t1 stays 510
add $t2, $0, $t1 # $t3 becomes 510
add $t2, $0, $t1 # $t3 stays 510

halt