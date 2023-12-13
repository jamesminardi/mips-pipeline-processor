vcom -reportprogress 300 -work work ~/cpre381/cpre381-toolflow/proj/src/MIPS_types.vhd

vcom -reportprogress 300 -work work ~/cpre381/cpre381-toolflow/proj/src/Multiplexers/mux2t1.vhd
vcom -reportprogress 300 -work work ~/cpre381/cpre381-toolflow/proj/src/Multiplexers/mux2t1_N.vhd

vcom -reportprogress 300 -work work ~/cpre381/cpre381-toolflow/proj/src/ALU/full_adder.vhd
vcom -reportprogress 300 -work work ~/cpre381/cpre381-toolflow/proj/src/ALU/full_adder_N.vhd
vcom -reportprogress 300 -work work ~/cpre381/cpre381-toolflow/proj/src/ALU/add_sub.vhd

vcom -reportprogress 300 -work work ~/cpre381/cpre381-toolflow/proj/src/ALU/barrel_shifter.vhd

vcom -reportprogress 300 -work work ~/cpre381/cpre381-toolflow/proj/src/ALU/ALU.vhd
vcom -reportprogress 300 -work work ~/cpre381/cpre381-toolflow/proj/test/ALU/tb_ALU.vhd

vsim work.tb_ALU -voptargs=+acc

add wave -position insertpoint  \
sim:/tb_alu/s_iA \
sim:/tb_alu/s_iB \
sim:/tb_alu/s_iShamt \
sim:/tb_alu/s_iALUOp \
sim:/tb_alu/s_oResult \
sim:/tb_alu/s_oCout \
sim:/tb_alu/s_oOverflow \
sim:/tb_alu/s_oZero

run 1400