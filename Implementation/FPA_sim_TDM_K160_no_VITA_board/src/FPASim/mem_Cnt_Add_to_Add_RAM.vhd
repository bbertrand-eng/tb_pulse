
library ieee;

use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
--use ieee.std_logic_arith.all;
use ieee.numeric_std.all;
use work.pulse_package.all;

--use work.Spacewire_Pack.all;

entity mem_Cnt_Add_to_Add_RAM is
	port(
--RESET
			Reset		 		:	 in  STD_LOGIC;
--CLOCKs
			CLK_4X				: in    std_logic;--	20 MHz
			ENABLE_CLK_1X		: in    std_logic;
			--ENABLE_CLK_1X		: 	in  STD_LOGIC;
--CONTROL
			pixel				: 	in	integer;
			
			mem_counter_address	:	in	t_array_Mem_counter_address;
			Pulse_Ram_ADDRESS_RD_internal	:	out	unsigned (9 downto 0)	

		
	);
end entity;

architecture rtl of mem_Cnt_Add_to_Add_RAM is

type	t_array_view_pixel	is array (C_pixel-1 downto 0) of STD_LOGIC_VECTOR (31 downto 0);
signal	view_pixel			:	t_array_view_pixel;

begin

label_view_pixel : process(Reset, CLK_4X)
begin
if Reset = '1' then

Pulse_Ram_ADDRESS_RD_internal <= (others=>'0'); 
else
	if rising_edge(CLK_4X) then
		if (ENABLE_CLK_1X ='1') then
			if pixel = 0 then
			Pulse_Ram_ADDRESS_RD_internal <= mem_counter_address(0);

			
			elsif pixel = 1 then
			Pulse_Ram_ADDRESS_RD_internal <= mem_counter_address(1);

			
			elsif pixel = 2 then
			Pulse_Ram_ADDRESS_RD_internal <= mem_counter_address(2);

		
		
			elsif pixel = 3 then
	--		elsif pixel = i then
			Pulse_Ram_ADDRESS_RD_internal <= mem_counter_address(3);
	--		Pulse_Ram_ADDRESS_RD_internal <= mem_counter_address(i);


		
		
			elsif pixel = 4 then
			Pulse_Ram_ADDRESS_RD_internal <= mem_counter_address(4);
			
			
			
			elsif pixel = 5 then
			Pulse_Ram_ADDRESS_RD_internal <= mem_counter_address(5);
			
			
			elsif pixel = 6 then
			Pulse_Ram_ADDRESS_RD_internal <= mem_counter_address(6);
		
			
			elsif pixel = 7 then
			Pulse_Ram_ADDRESS_RD_internal <= mem_counter_address(7);

			
			elsif pixel = 8 then
			Pulse_Ram_ADDRESS_RD_internal <= mem_counter_address(8);
		

			elsif pixel = 9 then
			Pulse_Ram_ADDRESS_RD_internal <= mem_counter_address(9);

			
			elsif pixel = 10 then
			Pulse_Ram_ADDRESS_RD_internal <= mem_counter_address(10);
		
			
			elsif pixel = 11 then
			Pulse_Ram_ADDRESS_RD_internal <= mem_counter_address(11);
			
			
			elsif pixel = 12 then
			Pulse_Ram_ADDRESS_RD_internal <= mem_counter_address(12);

			
			elsif pixel = 13 then
			Pulse_Ram_ADDRESS_RD_internal <= mem_counter_address(13);
		
			
			elsif pixel = 14 then
			Pulse_Ram_ADDRESS_RD_internal <= mem_counter_address(14);
		
			
			elsif pixel = 15 then
			Pulse_Ram_ADDRESS_RD_internal <= mem_counter_address(15);
			
			
			elsif pixel = 16 then
			Pulse_Ram_ADDRESS_RD_internal <= mem_counter_address(16);
				
			
			elsif pixel = 17 then
			Pulse_Ram_ADDRESS_RD_internal <= mem_counter_address(17);
			
			
			elsif pixel = 18 then
			Pulse_Ram_ADDRESS_RD_internal <= mem_counter_address(18);
				

			elsif pixel = 19 then
			Pulse_Ram_ADDRESS_RD_internal <= mem_counter_address(19);
			

			elsif pixel = 20 then
			Pulse_Ram_ADDRESS_RD_internal <= mem_counter_address(20);
		
			
			elsif pixel = 21 then
			Pulse_Ram_ADDRESS_RD_internal <= mem_counter_address(21);
				
			elsif pixel = 22 then
			Pulse_Ram_ADDRESS_RD_internal <= mem_counter_address(22);
					
			elsif pixel = 23 then
			Pulse_Ram_ADDRESS_RD_internal <= mem_counter_address(23);
			
			
			elsif pixel = 24 then
			Pulse_Ram_ADDRESS_RD_internal <= mem_counter_address(24);
			
			
			
			elsif pixel = 25 then
			Pulse_Ram_ADDRESS_RD_internal <= mem_counter_address(25);

			
			
			elsif pixel = 26 then
			Pulse_Ram_ADDRESS_RD_internal <= mem_counter_address(26);
			
			
			elsif pixel = 27 then
			Pulse_Ram_ADDRESS_RD_internal <= mem_counter_address(27);

			
			elsif pixel = 28 then
			Pulse_Ram_ADDRESS_RD_internal <= mem_counter_address(28);
		

			elsif pixel = 29 then
			Pulse_Ram_ADDRESS_RD_internal <= mem_counter_address(29);


			elsif pixel = 30 then
			Pulse_Ram_ADDRESS_RD_internal <= mem_counter_address(30);
			
			
			elsif pixel = 31 then
			Pulse_Ram_ADDRESS_RD_internal <= mem_counter_address(31);
			
			
			elsif pixel = 32 then
			Pulse_Ram_ADDRESS_RD_internal <= mem_counter_address(32);
			
			
			elsif pixel = 33 then
			Pulse_Ram_ADDRESS_RD_internal <= mem_counter_address(33);
		
				
			
			end if;
		end if;
    end if;  -- clock
end if;  -- reset 
end process;


end RTL;