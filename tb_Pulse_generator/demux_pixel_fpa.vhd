
library ieee;

use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
--use ieee.std_logic_arith.all;
use ieee.numeric_std.all;
use work.pulse_package.all;

--use work.Spacewire_Pack.all;

entity demux_pixel_fpa is
	port(
--RESET
			Reset		 		:	 in  STD_LOGIC;
--CLOCKs
    		CLK_5Mhz			: 	in  STD_LOGIC;
			--ENABLE_CLK_1X		: 	in  STD_LOGIC;
--CONTROL
			pixel				: 	in	integer;
						
			Pulse_Ram_Data_RD_internal		:	in	signed(15 downto 0);

			view_pixel			:	out	t_array_view_pixel
			
	);
end entity;

architecture rtl of demux_pixel_fpa is


begin

label_view_pixel : process(Reset, CLK_5Mhz)
begin
if Reset = '1' then
view_pixel <=  (others=>(others=>'0'));
 
else
    if CLK_5Mhz='1' and CLK_5Mhz'event then
		if pixel = 0 then
	
		view_pixel(0) <= Pulse_Ram_Data_RD_internal;
		
		elsif pixel = 1 then
		
		view_pixel(1) <= Pulse_Ram_Data_RD_internal;
		
		elsif pixel = 2 then
		
		view_pixel(2) <= Pulse_Ram_Data_RD_internal;
	
	
		elsif pixel = 3 then

		view_pixel(3) <= Pulse_Ram_Data_RD_internal;

	
	
		elsif pixel = 4 then
		
		view_pixel(4) <= Pulse_Ram_Data_RD_internal;
		
		elsif pixel = 5 then
		
		view_pixel(5) <= Pulse_Ram_Data_RD_internal;
		
		elsif pixel = 6 then
	
		view_pixel(6) <= Pulse_Ram_Data_RD_internal;	
		
		elsif pixel = 7 then
		
		view_pixel(7) <= Pulse_Ram_Data_RD_internal;
		
		elsif pixel = 8 then
		
		view_pixel(8) <= Pulse_Ram_Data_RD_internal;	

		elsif pixel = 9 then
		
		view_pixel(9) <= Pulse_Ram_Data_RD_internal;
		
		elsif pixel = 10 then
	
		view_pixel(10) <= Pulse_Ram_Data_RD_internal;
		
		elsif pixel = 11 then
		
		view_pixel(11) <= Pulse_Ram_Data_RD_internal;
		
		elsif pixel = 12 then
		
		view_pixel(12) <= Pulse_Ram_Data_RD_internal;
		
		elsif pixel = 13 then
		
		view_pixel(13) <= Pulse_Ram_Data_RD_internal;
		
		elsif pixel = 14 then
		
		view_pixel(14) <= Pulse_Ram_Data_RD_internal;
		
		elsif pixel = 15 then
		
		view_pixel(15) <= Pulse_Ram_Data_RD_internal;
		
		elsif pixel = 16 then
		
		view_pixel(16) <= Pulse_Ram_Data_RD_internal;	
		
		elsif pixel = 17 then
	
		view_pixel(17) <= Pulse_Ram_Data_RD_internal;
		
		elsif pixel = 18 then

		view_pixel(18) <= Pulse_Ram_Data_RD_internal;	

		elsif pixel = 19 then

		view_pixel(19) <= Pulse_Ram_Data_RD_internal;

		elsif pixel = 20 then
		
		view_pixel(20) <= Pulse_Ram_Data_RD_internal;
		
		elsif pixel = 21 then
		
		view_pixel(21) <= Pulse_Ram_Data_RD_internal;
		
		elsif pixel = 22 then
		
		view_pixel(22) <= Pulse_Ram_Data_RD_internal;
		
		elsif pixel = 23 then

		view_pixel(23) <= Pulse_Ram_Data_RD_internal;
		
		elsif pixel = 24 then
		
		view_pixel(24) <= Pulse_Ram_Data_RD_internal;
		
		elsif pixel = 25 then
		
		view_pixel(25) <= Pulse_Ram_Data_RD_internal;
		
		elsif pixel = 26 then
		
		view_pixel(26) <= Pulse_Ram_Data_RD_internal;	
		
		elsif pixel = 27 then
		
		view_pixel(27) <= Pulse_Ram_Data_RD_internal;
		
		elsif pixel = 28 then
	
		view_pixel(28) <= Pulse_Ram_Data_RD_internal;	

		elsif pixel = 29 then
	
		view_pixel(29) <= Pulse_Ram_Data_RD_internal;

		elsif pixel = 30 then
	
		view_pixel(30) <= Pulse_Ram_Data_RD_internal;
		
		elsif pixel = 31 then
		
		view_pixel(31) <= Pulse_Ram_Data_RD_internal;
		
		elsif pixel = 32 then
	
		view_pixel(32) <= Pulse_Ram_Data_RD_internal;
		
		elsif pixel = 33 then

		view_pixel(33) <= Pulse_Ram_Data_RD_internal;
			
		
		end if;
    end if;  -- clock
end if;  -- reset 
end process;


end RTL;