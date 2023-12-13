vcom -reportprogress 300 -work work ~/cpre381/cpre381-toolflow/proj/src/MIPS_types.vhd
vcom -reportprogress 300 -work work ~/cpre381/cpre381-toolflow/proj/src/control.vhd
vcom -reportprogress 300 -work work ~/cpre381/cpre381-toolflow/proj/test/tb_control.vhd


vsim work.tb_control -voptargs=+acc


add wave -position insertpoint  \
sim:/tb_control/s_iOpcode \
sim:/tb_control/s_iFunct \
sim:/tb_control/s_oRegDst \
sim:/tb_control/s_oALUSrc \
sim:/tb_control/s_oMemtoReg \
sim:/tb_control/s_oRegWrite \
sim:/tb_control/s_oMemRead \
sim:/tb_control/s_oMemWrite \
sim:/tb_control/s_oJump \
sim:/tb_control/s_oJumpReg \
sim:/tb_control/s_oBranch \
sim:/tb_control/s_oBranchEq \
sim:/tb_control/s_oALUOp \
sim:/tb_control/s_oHalt \
sim:/tb_control/s_oSignExt

run 1200
