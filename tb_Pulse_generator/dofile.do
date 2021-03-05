vcom pulse_package.vhd
vcom demux_pixel_fpa.vhd
vcom mem_Cnt_Add_to_Add_RAM.vhd
vcom Pulse_LUT_function.vhd
vcom start_stop_manager.vhd
vcom TES.vhd
vcom SQUID.vhd
vcom SQUID_table.vhd	
vcom FPA_sim.vhd
vcom Tb_FPA_sim.vhd
#vsim work.Tb_FPA_sim -t 1ns
vsim -voptargs="+acc" work.tb_fpa_sim -t 1ns
add wave /Tb_FPA_sim/*
run 50 ns