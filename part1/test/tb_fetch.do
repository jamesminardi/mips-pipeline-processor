vcom -reportprogress 300 -work work ~/cpre381/cpre381-toolflow/proj/src/MIPS_types.vhd

vcom -reportprogress 300 -work work ~/cpre381/cpre381-toolflow/proj/src/Multiplexers/mux2t1.vhd
vcom -reportprogress 300 -work work ~/cpre381/cpre381-toolflow/proj/src/Multiplexers/mux2t1_N.vhd



vcom -reportprogress 300 -work work ~/cpre381/cpre381-toolflow/proj/src/ALU/full_adder.vhd
vcom -reportprogress 300 -work work ~/cpre381/cpre381-toolflow/proj/src/ALU/full_adder_N.vhd
vcom -reportprogress 300 -work work ~/cpre381/cpre381-toolflow/proj/src/ALU/add_sub.vhd

vcom -reportprogress 300 -work work ~/cpre381/cpre381-toolflow/proj/src/ALU/barrel_shifter.vhd

vcom -reportprogress 300 -work work ~/cpre381/cpre381-toolflow/proj/src/fetch.vhd
vcom -reportprogress 300 -work work ~/cpre381/cpre381-toolflow/proj/test/tb_fetch.vhd

vsim work.tb_fetch -voptargs=+acc

add wave -position insertpoint  \
sim:/tb_fetch/s_iAddr \
sim:/tb_fetch/s_iJump \
sim:/tb_fetch/S_iJumpReg \
sim:/tb_fetch/s_iJumpRegData \
sim:/tb_fetch/s_iBranch \
sim:/tb_fetch/s_iZero \
sim:/tb_fetch/s_iBEQ \
sim:/tb_fetch/s_iBranchImm \
sim:/tb_fetch/s_iJumpImm \
sim:/tb_fetch/s_oAdder \
sim:/tb_fetch/s_oPCPlus4


run 800