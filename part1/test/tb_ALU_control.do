vcom -reportprogress 300 -work work ~/cpre381/cpre381-toolflow/proj/src/MIPS_types.vhd
vcom -reportprogress 300 -work work ~/cpre381/cpre381-toolflow/proj/src/ALU_control.vhd
vcom -reportprogress 300 -work work ~/cpre381/cpre381-toolflow/proj/test/tb_ALU_control.vhd

vsim -voptargs=+acc work.tb_alu_control

add wave -position insertpoint  \
sim:/tb_alu_control/s_iALUOp \
sim:/tb_alu_control/s_iFunct \
sim:/tb_alu_control/s_oAction

run 1600
