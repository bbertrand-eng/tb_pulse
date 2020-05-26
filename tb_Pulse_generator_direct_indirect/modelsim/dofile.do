vcom ../src/pulse_package.vhd
vcom ../src/demux_pixel_fpa.vhd
vcom ../src/mem_Cnt_Add_to_Add_RAM.vhd
vcom ../src/Pulse_LUT_function.vhd
vcom ../src/start_stop_manager.vhd
vcom ../src/start_stop_manager_direct.vhd
vcom ../src/TES.vhd
vcom ../src/FPA_sim.vhd
vcom ../src/Tb_FPA_sim.vhd
vsim work.Tb_FPA_sim -t 1ns
add wave /Tb_FPA_sim/*
run 50 ns