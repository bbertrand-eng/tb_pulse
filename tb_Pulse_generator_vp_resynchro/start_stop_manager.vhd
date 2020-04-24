
library ieee;

use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
--use ieee.std_logic_arith.all;
use ieee.numeric_std.all;
use work.pulse_package.all;

--use work.Spacewire_Pack.all;

entity start_stop_manager is
	port(
--RESET
			Reset		 		:	 in  STD_LOGIC;
--CLOCKs
    		CLK_5Mhz			: 	in  STD_LOGIC;
			--ENABLE_CLK_1X		: 	in  STD_LOGIC;
--CONTROL
			pixel				: 	in	integer;
-- --input

			Mem_Vp				:	in 	t_array_Mem_Vp;
			mem_counter_address	:	in	t_array_Mem_counter_address;

			detect_start_pulse_pixel	:	inout  t_array_start_pulse_pixel;
			detect_stop_pulse_pixel		:	inout t_array_start_pulse_pixel;
--output
			start_pulse_pixel	:	out t_array_start_pulse_pixel;
			stop_pulse_pixel	:	out t_array_start_pulse_pixel




			
	);
end entity;

architecture rtl of start_stop_manager is


begin


-------------------------------------------------------------------------------------
--	start_pulse_pixel and stop_pulse_pixel
-------------------------------------------------------------------------------------

-- label_start_pulse_pixel : process(Reset, CLK_5Mhz)
-- begin
-- if Reset = '1' then
-- start_pulse_pixel 	<= (others=>'0');
-- --stop_pulse_pixel 	<= (others=>'0');
-- else
    -- if CLK_5Mhz='1' and CLK_5Mhz'event then
		-- if	pixel = C_pixel-1 then
		-- start_pulse_pixel	<= detect_start_pulse_pixel;--option (2)
		-- --stop_pulse_pixel	<=	detect_stop_pulse_pixel;
		-- end if;
    -- end if;  -- clock
-- end if;  -- reset 
-- end process;

start_pulse_pixel	<= detect_start_pulse_pixel;


-- process(Reset, CLK_5Mhz)
-- begin
-- if Reset = '1' then
-- stop_pulse_pixel 	<= (others=>'0');
-- else
    -- if CLK_5Mhz='1' and CLK_5Mhz'event then
		-- if	detect_stop_pulse_pixel(pixel) = '1' then
		-- stop_pulse_pixel(pixel) <= '1';
		-- else
		-- stop_pulse_pixel(pixel) <= '0';
		-- end if;
    -- end if;  -- clock
-- end if;  -- reset 
-- end process;

stop_pulse_pixel <= detect_stop_pulse_pixel;


-------------------------------------------------------------------------------------
--	control Vp state and remote start pulse pixel
-------------------------------------------------------------------------------------

-- label_generate : for i in C_pixel-1 downto 0 generate

-- detect_start_pulse_pixel(i) <= '1' when Mem_Vp(i)(15 downto 0) /= b"0000000000000000" else '0';	--option (2)
-- end generate label_generate; 

label_generate : for i in C_pixel-1 downto 0 generate
	process(Reset, CLK_5Mhz)
	begin
	if Reset = '1' then
	detect_start_pulse_pixel(i) <= '0';
	else
		if CLK_5Mhz='1' and CLK_5Mhz'event then
			if	Mem_Vp(i)(15 downto 0) /= b"0000000000000000" then	
			detect_start_pulse_pixel(i) <= '1';
			else
			detect_start_pulse_pixel(i) <= '0';
			end if;
		end if;  -- clock
	end if;  -- reset 
	end process;
end generate label_generate; 


-------------------------------------------------------------------------------------
--	read counter(pixel) generate stop(pixel)  
-------------------------------------------------------------------------------------

label_generate_stop_pixel : process(Reset, CLK_5Mhz)
begin
if Reset = '1' then
detect_stop_pulse_pixel	<= (others=>'0');
else
    if CLK_5Mhz='1' and CLK_5Mhz'event then
	detect_stop_pulse_pixel(pixel) <= '0';
		if mem_counter_address(pixel) = C_depth_pulse_memory-1 then
		detect_stop_pulse_pixel(pixel) <= '1';
		end if;
	end if;  -- clock
end if;  -- reset 
end process;


end RTL;