vcom pulse_package.vhd
vcom demux_pixel_fpa.vhd
vcom Pulse_LUT_function.vhd
vcom TES.vhd
vcom Tb_Pulse.vhd
vsim work.Tb_Pulse -t 1ns
add wave /tb_pulse/*
run 50 ns