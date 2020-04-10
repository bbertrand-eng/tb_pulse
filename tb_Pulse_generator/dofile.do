vcom pulse_package.vhd
vcom demux_pixel_fpa.vhd
vcom mem_Cnt_Add_to_Add_RAM.vhd
vcom Pulse_LUT_function.vhd
vcom start_stop_manager.vhd
vcom TES.vhd
vcom Tb_Pulse.vhd
vsim work.Tb_Pulse -t 1ns
add wave /tb_pulse/*
run 50 ns