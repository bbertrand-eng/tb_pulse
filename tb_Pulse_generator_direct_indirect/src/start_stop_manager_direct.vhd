
library ieee;

use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
--use ieee.std_logic_arith.all;
use ieee.numeric_std.all;
use work.pulse_package.all;

--use work.Spacewire_Pack.all;

entity start_stop_manager_direct is
	port(
--RESET
			Reset		 		:	 in  STD_LOGIC;
--CLOCKs
    		CLK_5Mhz			: 	in  STD_LOGIC;
			--ENABLE_CLK_1X		: 	in  STD_LOGIC;
--CONTROL
			pixel				: 	in	integer;
			pixel_delayed_3		: 	in	integer;
-- --input

			Mem_Vp				:	in 	t_array_Mem_Vp;
			mem_counter_address	:	in	t_array_Mem_counter_address;

			detect_start_pulse_pixel	:	inout  t_array_start_pulse_pixel;
			detect_stop_pulse_pixel		:	inout t_array_start_pulse_pixel;
--output
			start_pulse_pixel		:	inout t_array_start_pulse_pixel;
			start_pulse_pixel_shift	:	inout t_array_start_pulse_pixel;
			
			stop_pulse_pixel	:	out t_array_start_pulse_pixel




			
	);
end entity;

architecture rtl of start_stop_manager_direct is


begin


-------------------------------------------------------------------------------------
--	start_pulse_pixel 
-------------------------------------------------------------------------------------

--label_generate_start_pulse_pixel : for i in C_pixel-1 downto 0 generate
label_start_pulse_pixel : process(Reset, CLK_5Mhz)
begin
if Reset = '1' then
start_pulse_pixel 	<= (others=>'0');
else
    if CLK_5Mhz='1' and CLK_5Mhz'event then
		if	pixel = 33 then
		start_pulse_pixel(0)	<= detect_start_pulse_pixel(0);--option (2)
		elsif pixel = 0 then 
		start_pulse_pixel(1)	<= detect_start_pulse_pixel(1);
		elsif pixel = 1 then 
		start_pulse_pixel(2)	<= detect_start_pulse_pixel(2);
		elsif pixel = 2 then 
		start_pulse_pixel(3)	<= detect_start_pulse_pixel(3);
		elsif pixel = 3 then 
		start_pulse_pixel(4)	<= detect_start_pulse_pixel(4);
		elsif pixel = 4 then 
		start_pulse_pixel(5)	<= detect_start_pulse_pixel(5);
		elsif pixel = 5 then 
		start_pulse_pixel(6)	<= detect_start_pulse_pixel(6);
		elsif pixel = 6 then 
		start_pulse_pixel(7)	<= detect_start_pulse_pixel(7);
		elsif pixel = 7 then 
		start_pulse_pixel(8)	<= detect_start_pulse_pixel(8);
		elsif pixel = 8 then 
		start_pulse_pixel(9)	<= detect_start_pulse_pixel(9);
		
		elsif pixel = 9 then
		start_pulse_pixel(10)	<= detect_start_pulse_pixel(10);--option (2)
		elsif pixel = 10 then 
		start_pulse_pixel(11)	<= detect_start_pulse_pixel(11);
		elsif pixel = 11 then 
		start_pulse_pixel(12)	<= detect_start_pulse_pixel(12);
		elsif pixel = 12 then 
		start_pulse_pixel(13)	<= detect_start_pulse_pixel(13);
		elsif pixel = 13 then 
		start_pulse_pixel(14)	<= detect_start_pulse_pixel(14);
		elsif pixel = 14 then 
		start_pulse_pixel(15)	<= detect_start_pulse_pixel(15);
		elsif pixel = 15 then 
		start_pulse_pixel(16)	<= detect_start_pulse_pixel(16);
		elsif pixel = 16 then 
		start_pulse_pixel(17)	<= detect_start_pulse_pixel(17);
		elsif pixel = 17 then 
		start_pulse_pixel(18)	<= detect_start_pulse_pixel(18);
		elsif pixel = 18 then 
		start_pulse_pixel(19)	<= detect_start_pulse_pixel(19);

		elsif pixel = 19 then
		start_pulse_pixel(20)	<= detect_start_pulse_pixel(20);--option (2)
		elsif pixel = 20 then 
		start_pulse_pixel(21)	<= detect_start_pulse_pixel(21);
		elsif pixel = 21 then 
		start_pulse_pixel(22)	<= detect_start_pulse_pixel(22);
		elsif pixel = 22 then 
		start_pulse_pixel(23)	<= detect_start_pulse_pixel(23);
		elsif pixel = 23 then 
		start_pulse_pixel(24)	<= detect_start_pulse_pixel(24);
		elsif pixel = 24 then 
		start_pulse_pixel(25)	<= detect_start_pulse_pixel(25);
		elsif pixel = 25 then 
		start_pulse_pixel(26)	<= detect_start_pulse_pixel(26);
		elsif pixel = 26 then 
		start_pulse_pixel(27)	<= detect_start_pulse_pixel(27);
		elsif pixel = 27 then 
		start_pulse_pixel(28)	<= detect_start_pulse_pixel(28);
		elsif pixel = 28 then 
		start_pulse_pixel(29)	<= detect_start_pulse_pixel(29);		
	
		elsif pixel = 29 then
		start_pulse_pixel(30)	<= detect_start_pulse_pixel(30);--option (2)
		elsif pixel = 30 then 
		start_pulse_pixel(31)	<= detect_start_pulse_pixel(31);
		elsif pixel = 31 then 
		start_pulse_pixel(32)	<= detect_start_pulse_pixel(32);
		elsif pixel = 32 then 
		start_pulse_pixel(33)	<= detect_start_pulse_pixel(33);	
		
		end if;
    end if;  -- clock
end if;  -- reset 
end process;
--end generate label_generate_start_pulse_pixel; 


-- label_generate_start_pulse_pixel : for i in C_pixel-1 downto 0 generate
-- start_pulse_pixel(i) <= detect_start_pulse_pixel(i) when pixel = i else start_pulse_pixel(i);
-- end generate label_generate_start_pulse_pixel; 

-------------------------------------------------------------------------------------
--	start_pulse_pixel_shift 
-------------------------------------------------------------------------------------

process(Reset, CLK_5Mhz)
begin
if Reset = '1' then
start_pulse_pixel_shift 	<= (others=>'0');
else
    if CLK_5Mhz='1' and CLK_5Mhz'event then
		if	pixel_delayed_3 = 33 then
		start_pulse_pixel_shift(0)	<= start_pulse_pixel(0);--option (2)
		elsif pixel_delayed_3 = 0 then 
		start_pulse_pixel_shift(1)	<= start_pulse_pixel(1);
		elsif pixel_delayed_3 = 1 then 
		start_pulse_pixel_shift(2)	<= start_pulse_pixel(2);
		elsif pixel_delayed_3 = 2 then 
		start_pulse_pixel_shift(3)	<= start_pulse_pixel(3);
		elsif pixel_delayed_3 = 3 then 
		start_pulse_pixel_shift(4)	<= start_pulse_pixel(4);
		elsif pixel_delayed_3 = 4 then 
		start_pulse_pixel_shift(5)	<= start_pulse_pixel(5);
		elsif pixel_delayed_3 = 5 then 
		start_pulse_pixel_shift(6)	<= start_pulse_pixel(6);
		elsif pixel_delayed_3 = 6 then 
		start_pulse_pixel_shift(7)	<= start_pulse_pixel(7);
		elsif pixel_delayed_3 = 7 then 
		start_pulse_pixel_shift(8)	<= start_pulse_pixel(8);
		elsif pixel_delayed_3 = 8 then 
		start_pulse_pixel_shift(9)	<= start_pulse_pixel(9);
		
		elsif pixel_delayed_3 = 9 then
		start_pulse_pixel_shift(10)	<= start_pulse_pixel(10);--option (2)
		elsif pixel_delayed_3 = 10 then 
		start_pulse_pixel_shift(11)	<= start_pulse_pixel(11);
		elsif pixel_delayed_3 = 11 then 
		start_pulse_pixel_shift(12)	<= start_pulse_pixel(12);
		elsif pixel_delayed_3 = 12 then 
		start_pulse_pixel_shift(13)	<= start_pulse_pixel(13);
		elsif pixel_delayed_3 = 13 then 
		start_pulse_pixel_shift(14)	<= start_pulse_pixel(14);
		elsif pixel_delayed_3 = 14 then 
		start_pulse_pixel_shift(15)	<= start_pulse_pixel(15);
		elsif pixel_delayed_3 = 15 then 
		start_pulse_pixel_shift(16)	<= start_pulse_pixel(16);
		elsif pixel_delayed_3 = 16 then 
		start_pulse_pixel_shift(17)	<= start_pulse_pixel(17);
		elsif pixel_delayed_3 = 17 then 
		start_pulse_pixel_shift(18)	<= start_pulse_pixel(18);
		elsif pixel_delayed_3 = 18 then 
		start_pulse_pixel_shift(19)	<= start_pulse_pixel(19);

		elsif pixel_delayed_3 = 19 then
		start_pulse_pixel_shift(20)	<= start_pulse_pixel(20);--option (2)
		elsif pixel_delayed_3 = 20 then 
		start_pulse_pixel_shift(21)	<= start_pulse_pixel(21);
		elsif pixel_delayed_3 = 21 then 
		start_pulse_pixel_shift(22)	<= start_pulse_pixel(22);
		elsif pixel_delayed_3 = 22 then 
		start_pulse_pixel_shift(23)	<= start_pulse_pixel(23);
		elsif pixel_delayed_3 = 23 then 
		start_pulse_pixel_shift(24)	<= start_pulse_pixel(24);
		elsif pixel_delayed_3 = 24 then 
		start_pulse_pixel_shift(25)	<= start_pulse_pixel(25);
		elsif pixel_delayed_3 = 25 then 
		start_pulse_pixel_shift(26)	<= start_pulse_pixel(26);
		elsif pixel_delayed_3 = 26 then 
		start_pulse_pixel_shift(27)	<= start_pulse_pixel(27);
		elsif pixel_delayed_3 = 27 then 
		start_pulse_pixel_shift(28)	<= start_pulse_pixel(28);
		elsif pixel_delayed_3 = 28 then 
		start_pulse_pixel_shift(29)	<= start_pulse_pixel(29);		
	
		elsif pixel_delayed_3 = 29 then
		start_pulse_pixel_shift(30)	<= start_pulse_pixel(30);--option (2)
		elsif pixel_delayed_3 = 30 then 
		start_pulse_pixel_shift(31)	<= start_pulse_pixel(31);
		elsif pixel_delayed_3 = 31 then 
		start_pulse_pixel_shift(32)	<= start_pulse_pixel(32);
		elsif pixel_delayed_3 = 32 then 
		start_pulse_pixel_shift(33)	<= start_pulse_pixel(33);	
		
		end if;
    end if;  -- clock
end if;  -- reset 
end process;



-- label_start_pulse_pixel_shift : for i in C_pixel-1 downto 0 generate
-- start_pulse_pixel_shift(i)	<= start_pulse_pixel(i) when pixel_delayed_3 = i else start_pulse_pixel_shift(i);
-- end generate label_start_pulse_pixel_shift; 

process(Reset, CLK_5Mhz)
begin
if Reset = '1' then
stop_pulse_pixel 	<= (others=>'0');
else
    if CLK_5Mhz='1' and CLK_5Mhz'event then
		if	detect_stop_pulse_pixel(pixel) = '1' then
		stop_pulse_pixel(pixel) <= '1';
		else
		stop_pulse_pixel(pixel) <= '0';
		end if;
    end if;  -- clock
end if;  -- reset 
end process;


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