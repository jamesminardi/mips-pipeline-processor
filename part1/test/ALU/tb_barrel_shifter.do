vcom -reportprogress 300 -work work ~/cpre381/cpre381-toolflow/proj/src/MIPS_types.vhd
vcom -reportprogress 300 -work work ~/cpre381/cpre381-toolflow/proj/src/Multiplexers/mux2t1.vhd
vcom -reportprogress 300 -work work ~/cpre381/cpre381-toolflow/proj/src/Multiplexers/mux2t1_N.vhd

vcom -reportprogress 300 -work work ~/cpre381/cpre381-toolflow/proj/src/ALU/barrel_shifter.vhd
vcom -reportprogress 300 -work work ~/cpre381/cpre381-toolflow/proj/test/ALU/tb_barrel_shifter.vhd

vsim work.tb_barrel_shifter -voptargs=+acc

add wave -position insertpoint  \
sim:/tb_barrel_shifter/s_iA \
sim:/tb_barrel_shifter/s_iLeft \
sim:/tb_barrel_shifter/s_iArithmetic \
sim:/tb_barrel_shifter/s_iShamt \
sim:/tb_barrel_shifter/s_oResult

run 1800
