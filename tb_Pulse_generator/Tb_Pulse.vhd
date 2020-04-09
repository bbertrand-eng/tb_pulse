
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
use ieee.std_logic_textio.all;
use std.textio.all;
use work.pulse_package.all;

ENTITY Tb_Pulse IS
END Tb_Pulse;

ARCHITECTURE behavior OF Tb_Pulse IS 

constant CLK_period : time := 200 ns;

signal CLK_5Mhz 		: std_logic;
--signal CLK_156k			: std_logic;
signal RESET 			: std_logic;
--signal Sig_in: signed(15 downto 0);
signal Pulse_Ram_Data_RD			: STD_LOGIC_VECTOR (15 downto 0);
--signal write_sig_1		: signed(19 downto 0);
--signal SendPulse 		: std_logic;
signal Pulse_Ram_Data_WR	: STD_LOGIC_vector (15 downto 0 );
signal Pulse_Ram_ADDRESS_WR	: unsigned (9 downto 0 );
signal Pulse_Ram_ADDRESS_RD	: unsigned (9 downto 0 );
signal WE_Pulse_Ram		: std_logic;
signal write_add_null	: std_logic;

signal write_Vp			: std_logic;

signal 	view_pixel			:	t_array_view_pixel;
signal	view_pixel_index	:	integer range 0 to C_pixel;
signal	Vtes_out			:	signed(15 downto 0);

signal 	Vp	:	t_array_Mem_Vp;

signal	Amplitude		: integer;

signal view_i			: integer;
signal view_c			: integer;

BEGIN

RESET <= '1', '0' after 100 ns;

CLK_process :process
begin
	CLK_5Mhz <= '0';
	wait for CLK_period/2;
	CLK_5Mhz <= '1';
	wait for CLK_period/2;
end process;



-- Component Instantiation
label_TES : entity work.TES 
	PORT MAP(
	
		-- global
		Reset				=> RESET,
		CLK_5Mhz			=> CLK_5Mhz,
		ENABLE_CLK_1X		=> '1',
		
		-- from gse Vp Vo 
		
		Vp => Vp, 
		write_Vp => write_Vp,
		
		-- from gse DualRam
		WE_Pulse_Ram		=> WE_Pulse_Ram,	--: std_logic;
		Pulse_Ram_ADDRESS_WR	=> Pulse_Ram_ADDRESS_WR,	--: unsigned (9 downto 0 );
		Pulse_Ram_ADDRESS_RD=> Pulse_Ram_ADDRESS_RD,	--: unsigned (9 downto 0 );
		Pulse_Ram_Data_WR		=> Pulse_Ram_Data_WR,	--: STD_LOGIC_vector (31 downto 0 );
--		Sig_in				=> to_signed(32767,20),
		Pulse_Ram_Data_RD	=> Pulse_Ram_Data_RD,	--: STD_LOGIC_VECTOR (31 downto 0);
		
		view_pixel	=>	view_pixel,
		view_pixel_index	=>	view_pixel_index,

		Vtes_out	=>	Vtes_out		
		
	);

	


stim_proc: process
begin
----------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------BEGIN INIT ALL Vp pixel don't' touch this area
----------------------------------------------------------------------------------------------------------------------------------------------
view_i	<= 0;
view_c	<= 0;
Amplitude <= 1900;	
write_Vp <= '1';

	for i in 0 to C_pixel-1 loop
	Vp(i) <= (std_logic_vector(to_unsigned(0,16)))&(std_logic_vector(to_unsigned(0,16)));
	
	end loop;

write_Vp <= '1';
wait for 100 us;
write_Vp <= '0';
	
--------------------------------END INIT ALL Vp pixel don't' touch
--------------------------------------------------------------------------------------------------------------------------------------

wait for 1 ms;

-----------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------enable pix one by one ----------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
--loop
	for i in 0 to C_pixel-1 loop
	Amplitude <= Amplitude+1900;	
		write_Vp <= '1';	
		Vp(i) <= (std_logic_vector(to_unsigned(33,16)))&(std_logic_vector(to_unsigned(Amplitude,16)));--pixel 31 energy ON
		wait for 400 ns;
		write_Vp <= '0';
		
		wait for 400 ns;
		
		write_Vp <= '1';		
		Vp(i) <= (std_logic_vector(to_unsigned(33,16)))&(std_logic_vector(to_unsigned(0,16)));--pixel 31 energy ON
		wait for 400 ns;
		write_Vp <= '0';

		wait for 10 ms;	
		
	end loop;
--end loop;	


----------------------------------------------------------------------------------------------------------------------------
-- -------------------------------------enable even pix same time-----------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------
for i in 0 to C_pixel-1 loop
	if (i mod 2) = 0 then
	Vp(i) <= (std_logic_vector(to_unsigned(33,16)))&(std_logic_vector(to_unsigned(65000,16)));--pixel 31 energy ON	
	end if;
end loop;

write_Vp <= '1';
wait for 400 ns;
write_Vp <= '0';

for i in 0 to C_pixel-1 loop
	if (i mod 2) = 0 then
	Vp(i) <= (std_logic_vector(to_unsigned(33,16)))&(std_logic_vector(to_unsigned(0,16)));--pixel 31 energy ON	
	end if;
end loop;

write_Vp <= '1';
wait for 400 ns;
write_Vp <= '0';

wait for 10 ms;

--------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------enable odd pix same time-----------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------

for i in 0 to C_pixel-1 loop
	if (i mod 2) = 1 then
	Vp(i) <= (std_logic_vector(to_unsigned(33,16)))&(std_logic_vector(to_unsigned(65000,16)));--pixel 31 energy ON	
	end if;
end loop;

write_Vp <= '1';
wait for 400 ns;
write_Vp <= '0';

for i in 0 to C_pixel-1 loop
	if (i mod 2) = 1 then
	Vp(i) <= (std_logic_vector(to_unsigned(33,16)))&(std_logic_vector(to_unsigned(0,16)));--pixel 31 energy ON	
	end if;
end loop;

write_Vp <= '1';
wait for 400 ns;
write_Vp <= '0';

wait for 50 ms;

-----------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------shift T/4 pix T/4----------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
for i in 0 to C_pixel-1 loop
	write_Vp <= '1';
	Vp(i) <= (std_logic_vector(to_unsigned(0,16)))&(std_logic_vector(to_unsigned(65000,16)));--pixel 31 energy ON
	wait for 400 ns;
	write_Vp <= '0';

	wait for 1.7 ms;
					
	write_Vp <= '1';
	Vp(i) <= (std_logic_vector(to_unsigned(0,16)))&(std_logic_vector(to_unsigned(0,16)));--pixel 31 energy ON
	wait for 400 ns;
	write_Vp <= '0';
end loop;

wait for 50 ms;

-- ----------------------------------------------------------------------------------------------------------------------------------
-- -- wait for 1 ms;
-----------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------compress and shift pix----------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------



for c in 0 to 500 loop
--if c=0 or c=2 or c=4 or c=6 or c=8 or c=10 or c=12 or c=14 or c=16 or c=18 or c=20 or c=22 or c=24 or c=26 or c=28 or c=30 or c=32  
if (c mod 2) = 0
then
view_c <= c;

	for i in 0 to C_pixel-1 loop
	view_i <= i;
			
				--if i=0 or i=2 or i=4 or i=6 or i=8 or i=10 or i=12 or i=14 or i=16 or i=18 or i=20 or i=22 or i=24 or i=25 or i=26 or i=28 or i=30 or i=32  
				if (i mod 2) = 0
				then
					write_Vp <= '1';
					Vp(i) <= (std_logic_vector(to_unsigned(0,16)))&(std_logic_vector(to_unsigned(65000,16)));--pixel 31 energy ON
					wait for 400 ns;
					write_Vp <= '0';

					wait for 400 ns;
					
					write_Vp <= '1';
					Vp(i) <= (std_logic_vector(to_unsigned(0,16)))&(std_logic_vector(to_unsigned(0,16)));--pixel 31 energy ON
					wait for 400 ns;
					write_Vp <= '0';
					
				else
				
					write_Vp <= '1';
					Vp(i) <= (std_logic_vector(to_unsigned(0,16)))&(std_logic_vector(to_unsigned(32767,16)));--pixel 31 energy ON
					wait for 400 ns;
					write_Vp <= '0';
	
					wait for 400 ns;
	
					write_Vp <= '1';		
					Vp(i) <= (std_logic_vector(to_unsigned(0,16)))&(std_logic_vector(to_unsigned(0,16)));--pixel 31 energy ON
					wait for 400 ns;
					write_Vp <= '0';
					
					wait for 400 ns;
					
				
				end if;
			wait for 10 us;
			
		wait for 220 us;		
	end loop;


else	
view_c <= c;
	for i in 0 to C_pixel-1 loop
	view_i <= i;	
			write_Vp <= '1';
				--if i=0 or i=2 or i=4 or i=6 or i=8 or i=10 or i=12 or i=14 or i=16 or i=18 or i=20 or i=22 or i=24 or i=25 or i=26 or i=28 or i=30 or i=32
				if (i mod 2) = 0		
				then
					write_Vp <= '1';
					Vp(i) <= (std_logic_vector(to_unsigned(33,16)))&(std_logic_vector(to_unsigned(32767,16)));--pixel 31 energy ON
					wait for 400 ns;
					write_Vp <= '0';					
					
					wait for 400 ns;
					
					write_Vp <= '1';
					Vp(i) <= (std_logic_vector(to_unsigned(33,16)))&(std_logic_vector(to_unsigned(0,16)));--pixel 31 energy ON
					wait for 400 ns;
					write_Vp <= '0';					
						
				else
					
					write_Vp <= '1';		
					Vp(i) <= (std_logic_vector(to_unsigned(33,16)))&(std_logic_vector(to_unsigned(65000,16)));--pixel 31 energy ON		
					wait for 400 ns;
					write_Vp <= '0';	
					
					wait for 400 ns;
					
					write_Vp <= '1';	
					Vp(i) <= (std_logic_vector(to_unsigned(33,16)))&(std_logic_vector(to_unsigned(0,16)));--pixel 31 energy ON
					wait for 400 ns;
					write_Vp <= '0';	

					wait for 400 ns;
					
				end if;
			--wait for 10 us;
			
		wait for 220 us;		
	end loop;
end if;
	
end loop;

wait for 60 ms;	

wait;
end process;




-- -------------------------------------------------------------------------------------------------------------------------------------
					-- ----------------------------------Manage files---------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------


-----------------------------------------
--- write process - 1
-----------------------------------------
write_proc1: process

file Sig_out_file	: text;
variable l : line;
variable Value : std_logic_vector(Pulse_Ram_Data_RD'length-1 downto 0);

begin
	file_open(Sig_out_file, "Output_signal.txt", WRITE_MODE);
	Pulse_Ram_ADDRESS_RD	<= (others=>'0');
	loop
  	wait until (CLK_5Mhz='1' and CLK_5Mhz'event); 
	Pulse_Ram_ADDRESS_RD <= Pulse_Ram_ADDRESS_RD +1;	
	Value:= std_logic_vector(Pulse_Ram_Data_RD);
   	hwrite(l, Value); 
	writeline(Sig_out_file, l);
    end loop;
end process;

----------------------------------------------------------------------------------------------
--
-- read file
--
----------------------------------------------------------------------------------------------

albel_read_file: process

file fake_pulse_CBE	: text;
variable l : line;
variable Value : std_logic_vector(31 downto 0);

begin
 
file_open(fake_pulse_CBE, "fake_pulse_CBE.txt", READ_MODE);
Pulse_Ram_ADDRESS_WR 	<= (others=>'0');
WE_Pulse_Ram			<= '0'; 
Pulse_Ram_Data_WR		<= (others=>'0');
write_add_null 			<= '0'; 
	wait until RESET = '0' and RESET'event;
	
		loop
    	wait until CLK_5Mhz='1' and CLK_5Mhz'event;
			if	write_add_null = '0' then
			write_add_null 			<= '1'; 
			WE_Pulse_Ram		<= '1';
			readline(fake_pulse_CBE, l);
			hread(l, Value);
			Pulse_Ram_Data_WR <= Value(31 downto 16);
			else		
				if not endfile(fake_pulse_CBE) then
					WE_Pulse_Ram		<= '1';
					readline(fake_pulse_CBE, l);
					hread(l, Value);
					Pulse_Ram_Data_WR <= Value(31 downto 16);
					
					Pulse_Ram_ADDRESS_WR <= Pulse_Ram_ADDRESS_WR +1;
				else
				WE_Pulse_Ram		<= '0';	
				end if;
			end if;
     	end loop;
end process;


END;
