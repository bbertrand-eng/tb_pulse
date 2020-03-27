
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
			mem_counter_address	:	in	t_array_Mem_counter_address;

			
			Pulse_Ram_Data_RD_internal		:	in	STD_LOGIC_VECTOR (31 downto 0);	
			Pulse_Ram_ADDRESS_RD_internal	:	out	unsigned (9 downto 0)	

		
	);
end entity;

architecture rtl of demux_pixel_fpa is

type	t_array_view_pixel	is array (C_pixel-1 downto 0) of STD_LOGIC_VECTOR (31 downto 0);
signal	view_pixel			:	t_array_view_pixel;

begin

label_view_pixel : process(Reset, CLK_5Mhz)
begin
if Reset = '1' then
view_pixel <=  (others=>(others=>'0'));
Pulse_Ram_ADDRESS_RD_internal <= (others=>'0'); 
else
    if CLK_5Mhz='1' and CLK_5Mhz'event then
		if pixel = 0 then
		Pulse_Ram_ADDRESS_RD_internal <= mem_counter_address(0);
		view_pixel(32) <= Pulse_Ram_Data_RD_internal;
		
		elsif pixel = 1 then
		Pulse_Ram_ADDRESS_RD_internal <= mem_counter_address(1);
		view_pixel(33) <= Pulse_Ram_Data_RD_internal;
		
		elsif pixel = 2 then
		Pulse_Ram_ADDRESS_RD_internal <= mem_counter_address(2);
		view_pixel(0) <= Pulse_Ram_Data_RD_internal;
	
	
		elsif pixel = 3 then
--		elsif pixel = i then
		Pulse_Ram_ADDRESS_RD_internal <= mem_counter_address(3);
--		Pulse_Ram_ADDRESS_RD_internal <= mem_counter_address(i);
		view_pixel(1) <= Pulse_Ram_Data_RD_internal;
--		view_pixel(i-2) <= Pulse_Ram_Data_RD_internal;	-- Deux clk entre ecriture et lecture dans la DualRAM
	
	
		elsif pixel = 4 then
		Pulse_Ram_ADDRESS_RD_internal <= mem_counter_address(4);
		view_pixel(2) <= Pulse_Ram_Data_RD_internal;
		
		elsif pixel = 5 then
		Pulse_Ram_ADDRESS_RD_internal <= mem_counter_address(5);
		view_pixel(3) <= Pulse_Ram_Data_RD_internal;
		
		elsif pixel = 6 then
		Pulse_Ram_ADDRESS_RD_internal <= mem_counter_address(6);
		view_pixel(4) <= Pulse_Ram_Data_RD_internal;	
		
		elsif pixel = 7 then
		Pulse_Ram_ADDRESS_RD_internal <= mem_counter_address(7);
		view_pixel(5) <= Pulse_Ram_Data_RD_internal;
		
		elsif pixel = 8 then
		Pulse_Ram_ADDRESS_RD_internal <= mem_counter_address(8);
		view_pixel(6) <= Pulse_Ram_Data_RD_internal;	

		elsif pixel = 9 then
		Pulse_Ram_ADDRESS_RD_internal <= mem_counter_address(9);
		view_pixel(7) <= Pulse_Ram_Data_RD_internal;
		
		elsif pixel = 10 then
		Pulse_Ram_ADDRESS_RD_internal <= mem_counter_address(10);
		view_pixel(8) <= Pulse_Ram_Data_RD_internal;
		
		elsif pixel = 11 then
		Pulse_Ram_ADDRESS_RD_internal <= mem_counter_address(11);
		view_pixel(9) <= Pulse_Ram_Data_RD_internal;
		
		elsif pixel = 12 then
		Pulse_Ram_ADDRESS_RD_internal <= mem_counter_address(12);
		view_pixel(10) <= Pulse_Ram_Data_RD_internal;
		
		elsif pixel = 13 then
		Pulse_Ram_ADDRESS_RD_internal <= mem_counter_address(13);
		view_pixel(11) <= Pulse_Ram_Data_RD_internal;
		
		elsif pixel = 14 then
		Pulse_Ram_ADDRESS_RD_internal <= mem_counter_address(14);
		view_pixel(12) <= Pulse_Ram_Data_RD_internal;
		
		elsif pixel = 15 then
		Pulse_Ram_ADDRESS_RD_internal <= mem_counter_address(15);
		view_pixel(13) <= Pulse_Ram_Data_RD_internal;
		
		elsif pixel = 16 then
		Pulse_Ram_ADDRESS_RD_internal <= mem_counter_address(16);
		view_pixel(14) <= Pulse_Ram_Data_RD_internal;	
		
		elsif pixel = 17 then
		Pulse_Ram_ADDRESS_RD_internal <= mem_counter_address(17);
		view_pixel(15) <= Pulse_Ram_Data_RD_internal;
		
		elsif pixel = 18 then
		Pulse_Ram_ADDRESS_RD_internal <= mem_counter_address(18);
		view_pixel(16) <= Pulse_Ram_Data_RD_internal;	

		elsif pixel = 19 then
		Pulse_Ram_ADDRESS_RD_internal <= mem_counter_address(19);
		view_pixel(17) <= Pulse_Ram_Data_RD_internal;

		elsif pixel = 20 then
		Pulse_Ram_ADDRESS_RD_internal <= mem_counter_address(20);
		view_pixel(18) <= Pulse_Ram_Data_RD_internal;
		
		elsif pixel = 21 then
		Pulse_Ram_ADDRESS_RD_internal <= mem_counter_address(21);
		view_pixel(19) <= Pulse_Ram_Data_RD_internal;
		
		elsif pixel = 22 then
		Pulse_Ram_ADDRESS_RD_internal <= mem_counter_address(22);
		view_pixel(20) <= Pulse_Ram_Data_RD_internal;
		
		elsif pixel = 23 then
		Pulse_Ram_ADDRESS_RD_internal <= mem_counter_address(23);
		view_pixel(21) <= Pulse_Ram_Data_RD_internal;
		
		elsif pixel = 24 then
		Pulse_Ram_ADDRESS_RD_internal <= mem_counter_address(24);
		view_pixel(22) <= Pulse_Ram_Data_RD_internal;
		
		elsif pixel = 25 then
		Pulse_Ram_ADDRESS_RD_internal <= mem_counter_address(25);
		view_pixel(23) <= Pulse_Ram_Data_RD_internal;
		
		elsif pixel = 26 then
		Pulse_Ram_ADDRESS_RD_internal <= mem_counter_address(26);
		view_pixel(24) <= Pulse_Ram_Data_RD_internal;	
		
		elsif pixel = 27 then
		Pulse_Ram_ADDRESS_RD_internal <= mem_counter_address(27);
		view_pixel(25) <= Pulse_Ram_Data_RD_internal;
		
		elsif pixel = 28 then
		Pulse_Ram_ADDRESS_RD_internal <= mem_counter_address(28);
		view_pixel(26) <= Pulse_Ram_Data_RD_internal;	

		elsif pixel = 29 then
		Pulse_Ram_ADDRESS_RD_internal <= mem_counter_address(29);
		view_pixel(27) <= Pulse_Ram_Data_RD_internal;

		elsif pixel = 30 then
		Pulse_Ram_ADDRESS_RD_internal <= mem_counter_address(30);
		view_pixel(28) <= Pulse_Ram_Data_RD_internal;
		
		elsif pixel = 31 then
		Pulse_Ram_ADDRESS_RD_internal <= mem_counter_address(31);
		view_pixel(29) <= Pulse_Ram_Data_RD_internal;
		
		elsif pixel = 32 then
		Pulse_Ram_ADDRESS_RD_internal <= mem_counter_address(32);
		view_pixel(30) <= Pulse_Ram_Data_RD_internal;
		
		elsif pixel = 33 then
		Pulse_Ram_ADDRESS_RD_internal <= mem_counter_address(33);
		view_pixel(31) <= Pulse_Ram_Data_RD_internal;
			
		
		end if;
    end if;  -- clock
end if;  -- reset 
end process;


end RTL;