
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
signal write_Vp			: std_logic;

signal view_pixel			:	t_array_view_pixel;

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
		
		view_pixel	=>	view_pixel
		
	);

	


stim_proc: process
begin
--------------------------------BEGIN INIT ALL Vp pixel don't' touch
write_Vp <= '1';
--Vp(pixel number) <= (std_logic_vector(to_unsigned(pixel number,16)))&(std_logic_vector(to_unsigned(energy,16)))	
Vp(0) <= (std_logic_vector(to_unsigned(0,16)))&(std_logic_vector(to_unsigned(0,16)));
--(std_logic_vector(to_unsigned(0;16)))&(std_logic_vector(to_unsigned(65000,16))) after 3ms ;
Vp(1) <= (std_logic_vector(to_unsigned(1,16)))&(std_logic_vector(to_unsigned(0,16)));
--(std_logic_vector(to_unsigned(1,16)))&(std_logic_vector(to_unsigned(65000,16))) after 4ms ;	
Vp(2) <= (std_logic_vector(to_unsigned(2,16)))&(std_logic_vector(to_unsigned(0,16)));
--(std_logic_vector(to_unsigned(2,16)))&(std_logic_vector(to_unsigned(65000,16))) after 5ms ;	
Vp(3) <= (std_logic_vector(to_unsigned(3,16)))&(std_logic_vector(to_unsigned(0,16)));
--(std_logic_vector(to_unsigned(3,16)))&(std_logic_vector(to_unsigned(65000,16))) after 6ms ;	
Vp(4) <= (std_logic_vector(to_unsigned(4,16)))&(std_logic_vector(to_unsigned(0,16)));
--(std_logic_vector(to_unsigned(4,16)))&(std_logic_vector(to_unsigned(65000,16))) after 7ms ;	
Vp(5) <= (std_logic_vector(to_unsigned(5,16)))&(std_logic_vector(to_unsigned(0,16)));
--(std_logic_vector(to_unsigned(4,16)))&(std_logic_vector(to_unsigned(65000,16))) after 8ms; 
Vp(6) <= (std_logic_vector(to_unsigned(6,16)))&(std_logic_vector(to_unsigned(0,16)));
--(std_logic_vector(to_unsigned(4,16)))&(std_logic_vector(to_unsigned(65000,16))) after 9ms; 
Vp(7) <= (std_logic_vector(to_unsigned(7,16)))&(std_logic_vector(to_unsigned(0,16)));
--(std_logic_vector(to_unsigned(4,16)))&(std_logic_vector(to_unsigned(65000,16))) after 10ms; 
Vp(8) <= (std_logic_vector(to_unsigned(8,16)))&(std_logic_vector(to_unsigned(0,16)));
--(std_logic_vector(to_unsigned(4,16)))&(std_logic_vector(to_unsigned(65000,16))) after 11ms; 
Vp(9) <= (std_logic_vector(to_unsigned(9,16)))&(std_logic_vector(to_unsigned(0,16)));
--(std_logic_vector(to_unsigned(4,16)))&(std_logic_vector(to_unsigned(65000,16))) after 12ms; 
Vp(10) <= (std_logic_vector(to_unsigned(10,16)))&(std_logic_vector(to_unsigned(0,16)));
--(std_logic_vector(to_unsigned(4,16)))&(std_logic_vector(to_unsigned(65000,16))) after 13ms;
Vp(11) <= (std_logic_vector(to_unsigned(11,16)))&(std_logic_vector(to_unsigned(0,16)));
--(std_logic_vector(to_unsigned(4,16)))&(std_logic_vector(to_unsigned(65000,16))) after 14ms;
Vp(12) <= (std_logic_vector(to_unsigned(12,16)))&(std_logic_vector(to_unsigned(0,16)));
--(std_logic_vector(to_unsigned(4,16)))&(std_logic_vector(to_unsigned(65000,16))) after 15ms;
Vp(13) <= (std_logic_vector(to_unsigned(13,16)))&(std_logic_vector(to_unsigned(0,16)));
--(std_logic_vector(to_unsigned(4,16)))&(std_logic_vector(to_unsigned(65000,16))) after 16ms;
Vp(14) <= (std_logic_vector(to_unsigned(14,16)))&(std_logic_vector(to_unsigned(0,16)));
--(std_logic_vector(to_unsigned(4,16)))&(std_logic_vector(to_unsigned(65000,16))) after 17ms;
Vp(15) <= (std_logic_vector(to_unsigned(15,16)))&(std_logic_vector(to_unsigned(0,16)));
--(std_logic_vector(to_unsigned(4,16)))&(std_logic_vector(to_unsigned(65000,16))) after 18ms;
Vp(16) <= (std_logic_vector(to_unsigned(16,16)))&(std_logic_vector(to_unsigned(0,16)));
--(std_logic_vector(to_unsigned(4,16)))&(std_logic_vector(to_unsigned(65000,16))) after 19ms;
Vp(17) <= (std_logic_vector(to_unsigned(17,16)))&(std_logic_vector(to_unsigned(0,16)));
--(std_logic_vector(to_unsigned(4,16)))&(std_logic_vector(to_unsigned(65000,16))) after 20ms;
Vp(18) <= (std_logic_vector(to_unsigned(18,16)))&(std_logic_vector(to_unsigned(0,16)));
--(std_logic_vector(to_unsigned(4,16)))&(std_logic_vector(to_unsigned(65000,16))) after 21ms;
Vp(19) <= (std_logic_vector(to_unsigned(19,16)))&(std_logic_vector(to_unsigned(0,16)));
--(std_logic_vector(to_unsigned(4,16)))&(std_logic_vector(to_unsigned(65000,16))) after 22ms;
Vp(20) <= (std_logic_vector(to_unsigned(20,16)))&(std_logic_vector(to_unsigned(0,16)));
--(std_logic_vector(to_unsigned(4,16)))&(std_logic_vector(to_unsigned(65000,16))) after 23ms;
Vp(21) <= (std_logic_vector(to_unsigned(21,16)))&(std_logic_vector(to_unsigned(0,16)));
--(std_logic_vector(to_unsigned(4,16)))&(std_logic_vector(to_unsigned(65000,16))) after 24ms;
Vp(22) <= (std_logic_vector(to_unsigned(22,16)))&(std_logic_vector(to_unsigned(0,16)));
--(std_logic_vector(to_unsigned(4,16)))&(std_logic_vector(to_unsigned(65000,16))) after 25ms;
Vp(23) <= (std_logic_vector(to_unsigned(23,16)))&(std_logic_vector(to_unsigned(0,16)));
--(std_logic_vector(to_unsigned(4,16)))&(std_logic_vector(to_unsigned(65000,16))) after 26ms;
Vp(24) <= (std_logic_vector(to_unsigned(24,16)))&(std_logic_vector(to_unsigned(0,16)));
--(std_logic_vector(to_unsigned(4,16)))&(std_logic_vector(to_unsigned(65000,16))) after 27ms;
Vp(25) <= (std_logic_vector(to_unsigned(25,16)))&(std_logic_vector(to_unsigned(0,16)));
--(std_logic_vector(to_unsigned(4,16)))&(std_logic_vector(to_unsigned(65000,16))) after 28ms;
Vp(26) <= (std_logic_vector(to_unsigned(26,16)))&(std_logic_vector(to_unsigned(0,16)));
--(std_logic_vector(to_unsigned(4,16)))&(std_logic_vector(to_unsigned(65000,16))) after 29ms;
Vp(27) <= (std_logic_vector(to_unsigned(27,16)))&(std_logic_vector(to_unsigned(0,16)));
--(std_logic_vector(to_unsigned(4,16)))&(std_logic_vector(to_unsigned(65000,16))) after 30ms;
Vp(28) <= (std_logic_vector(to_unsigned(28,16)))&(std_logic_vector(to_unsigned(0,16)));
--(std_logic_vector(to_unsigned(4,16)))&(std_logic_vector(to_unsigned(65000,16))) after 31ms;
Vp(29) <= (std_logic_vector(to_unsigned(29,16)))&(std_logic_vector(to_unsigned(0,16)));
--(std_logic_vector(to_unsigned(4,16)))&(std_logic_vector(to_unsigned(65000,16))) after 32ms;
Vp(30) <= (std_logic_vector(to_unsigned(30,16)))&(std_logic_vector(to_unsigned(0,16)));
--(std_logic_vector(to_unsigned(4,16)))&(std_logic_vector(to_unsigned(65000,16))) after 33ms;
Vp(31) <= (std_logic_vector(to_unsigned(31,16)))&(std_logic_vector(to_unsigned(0,16)));
--(std_logic_vector(to_unsigned(4,16)))&(std_logic_vector(to_unsigned(65000,16))) after 34ms;
Vp(32) <= (std_logic_vector(to_unsigned(32,16)))&(std_logic_vector(to_unsigned(0,16)));
--(std_logic_vector(to_unsigned(32,16)))&(std_logic_vector(to_unsigned(0,16))) after 10us;
Vp(33) <= (std_logic_vector(to_unsigned(33,16)))&(std_logic_vector(to_unsigned(0,16)));
wait for 100 us;
write_Vp <= '0';
--------------------------------END INIT ALL Vp pixel don't' touch

wait for 1 ms;

write_Vp <= '1';
Vp(33) <= (std_logic_vector(to_unsigned(33,16)))&(std_logic_vector(to_unsigned(65000,16)));--pixel 33 energy ON
Vp(32) <= (std_logic_vector(to_unsigned(1,16)))&(std_logic_vector(to_unsigned(65000,16)));--pixel 1 energy ON
wait for 100 us;
write_Vp <= '0';
wait for 100 us;
Vp(33) <= (std_logic_vector(to_unsigned(33,16)))&(std_logic_vector(to_unsigned(0,16)));--pixel 33 energy OFF
Vp(32) <= (std_logic_vector(to_unsigned(1,16)))&(std_logic_vector(to_unsigned(0,16)));--pixel 1 energy OFF

wait for 7 ms;

write_Vp <= '1';
Vp(33) <= (std_logic_vector(to_unsigned(33,16)))&(std_logic_vector(to_unsigned(65000,16)));--pixel 33 energy ON
wait for 100 us;
write_Vp <= '0';
wait for 100 us;
Vp(33) <= (std_logic_vector(to_unsigned(33,16)))&(std_logic_vector(to_unsigned(0,16)));--pixel 33 energy OFF

wait for 7 ms;

write_Vp <= '1';
Vp(32) <= (std_logic_vector(to_unsigned(33,16)))&(std_logic_vector(to_unsigned(65000,16)));--pixel 32 energy ON
wait for 100 us;
write_Vp <= '0';
wait for 100 us;
Vp(32) <= (std_logic_vector(to_unsigned(33,16)))&(std_logic_vector(to_unsigned(0,16)));--pixel 32 energy OFF

wait for 7 ms;
-------------------------------------copy-------------------------------------------
write_Vp <= '1';
Vp(31) <= (std_logic_vector(to_unsigned(33,16)))&(std_logic_vector(to_unsigned(65000,16)));--pixel 31 energy ON
wait for 100 us;
write_Vp <= '0';
wait for 100 us;
Vp(31) <= (std_logic_vector(to_unsigned(33,16)))&(std_logic_vector(to_unsigned(0,16)));--pixel 31 energy OFF

wait for 7 ms;
----------------------------------end copy another pulse---------------------------------------------------------

write_Vp <= '1';
Vp(30) <= (std_logic_vector(to_unsigned(33,16)))&(std_logic_vector(to_unsigned(65000,16)));--pixel 31 energy ON
wait for 100 us;
write_Vp <= '0';
wait for 100 us;
Vp(30) <= (std_logic_vector(to_unsigned(33,16)))&(std_logic_vector(to_unsigned(0,16)));--pixel 31 energy OFF

wait for 7 ms;

write_Vp <= '1';
Vp(29) <= (std_logic_vector(to_unsigned(33,16)))&(std_logic_vector(to_unsigned(65000,16)));--pixel 30 energy ON
wait for 100 us;
write_Vp <= '0';
wait for 100 us;
Vp(29) <= (std_logic_vector(to_unsigned(33,16)))&(std_logic_vector(to_unsigned(0,16)));--pixel 30 energy OFF

wait for 7 ms;

-------------------------------------copy-------------------------------------------
write_Vp <= '1';
Vp(28) <= (std_logic_vector(to_unsigned(33,16)))&(std_logic_vector(to_unsigned(65000,16)));--pixel 31 energy ON
wait for 100 us;
write_Vp <= '0';
wait for 100 us;
Vp(28) <= (std_logic_vector(to_unsigned(33,16)))&(std_logic_vector(to_unsigned(0,16)));--pixel 31 energy OFF

wait for 7 ms;
----------------------------------end copy another pulse---------------------------------------------------------

-------------------------------------copy-------------------------------------------
write_Vp <= '1';
Vp(27) <= (std_logic_vector(to_unsigned(33,16)))&(std_logic_vector(to_unsigned(65000,16)));--pixel 31 energy ON
wait for 100 us;
write_Vp <= '0';
wait for 100 us;
Vp(27) <= (std_logic_vector(to_unsigned(33,16)))&(std_logic_vector(to_unsigned(0,16)));--pixel 31 energy OFF

wait for 7 ms;
----------------------------------end copy another pulse---------------------------------------------------------

-------------------------------------copy-------------------------------------------
write_Vp <= '1';
Vp(26) <= (std_logic_vector(to_unsigned(33,16)))&(std_logic_vector(to_unsigned(65000,16)));--pixel 31 energy ON
wait for 100 us;
write_Vp <= '0';
wait for 100 us;
Vp(26) <= (std_logic_vector(to_unsigned(33,16)))&(std_logic_vector(to_unsigned(0,16)));--pixel 31 energy OFF

wait for 7 ms;
----------------------------------end copy another pulse---------------------------------------------------------

wait for 30 ms;

write_Vp <= '1';
Vp(25) <= (std_logic_vector(to_unsigned(33,16)))&(std_logic_vector(to_unsigned(65000,16)));--pixel 30 energy ON
wait for 100 us;
write_Vp <= '0';
wait for 100 us;
Vp(25) <= (std_logic_vector(to_unsigned(33,16)))&(std_logic_vector(to_unsigned(0,16)));--pixel 30 energy OFF

wait for 7 ms;

-------------------------------------copy-------------------------------------------
write_Vp <= '1';
Vp(24) <= (std_logic_vector(to_unsigned(33,16)))&(std_logic_vector(to_unsigned(65000,16)));--pixel 31 energy ON
wait for 100 us;
write_Vp <= '0';
wait for 100 us;
Vp(24) <= (std_logic_vector(to_unsigned(33,16)))&(std_logic_vector(to_unsigned(0,16)));--pixel 31 energy OFF

wait for 7 ms;
----------------------------------end copy another pulse---------------------------------------------------------

-------------------------------------copy-------------------------------------------
-- write_Vp <= '1';
-- Vp(0) <= (std_logic_vector(to_unsigned(33,16)))&(std_logic_vector(to_unsigned(65000,16)));--pixel 31 energy ON
-- Vp(2) <= (std_logic_vector(to_unsigned(33,16)))&(std_logic_vector(to_unsigned(65000,16)));--pixel 31 energy ON
-- Vp(4) <= (std_logic_vector(to_unsigned(33,16)))&(std_logic_vector(to_unsigned(65000,16)));--pixel 31 energy ON
-- Vp(6) <= (std_logic_vector(to_unsigned(33,16)))&(std_logic_vector(to_unsigned(65000,16)));--pixel 31 energy ON
-- Vp(8) <= (std_logic_vector(to_unsigned(33,16)))&(std_logic_vector(to_unsigned(65000,16)));--pixel 31 energy ON
-- Vp(10) <= (std_logic_vector(to_unsigned(33,16)))&(std_logic_vector(to_unsigned(65000,16)));--pixel 31 energy ON
-- Vp(12) <= (std_logic_vector(to_unsigned(33,16)))&(std_logic_vector(to_unsigned(65000,16)));--pixel 31 energy ON
-- Vp(14) <= (std_logic_vector(to_unsigned(33,16)))&(std_logic_vector(to_unsigned(65000,16)));--pixel 31 energy ON
-- Vp(16) <= (std_logic_vector(to_unsigned(33,16)))&(std_logic_vector(to_unsigned(65000,16)));--pixel 31 energy ON
-- Vp(18) <= (std_logic_vector(to_unsigned(33,16)))&(std_logic_vector(to_unsigned(65000,16)));--pixel 31 energy ON
-- Vp(20) <= (std_logic_vector(to_unsigned(33,16)))&(std_logic_vector(to_unsigned(65000,16)));--pixel 31 energy ON
-- Vp(22) <= (std_logic_vector(to_unsigned(33,16)))&(std_logic_vector(to_unsigned(65000,16)));--pixel 31 energy ON
-- Vp(24) <= (std_logic_vector(to_unsigned(33,16)))&(std_logic_vector(to_unsigned(65000,16)));--pixel 31 energy ON
-- Vp(26) <= (std_logic_vector(to_unsigned(33,16)))&(std_logic_vector(to_unsigned(65000,16)));--pixel 31 energy ON
-- Vp(28) <= (std_logic_vector(to_unsigned(33,16)))&(std_logic_vector(to_unsigned(65000,16)));--pixel 31 energy ON
-- Vp(30) <= (std_logic_vector(to_unsigned(33,16)))&(std_logic_vector(to_unsigned(65000,16)));--pixel 31 energy ON

-- wait for 400 us;
-- write_Vp <= '0';
-- wait for 400 us;
-- Vp(0) <= (std_logic_vector(to_unsigned(33,16)))&(std_logic_vector(to_unsigned(0,16)));--pixel 31 energy OFF
-- Vp(2) <= (std_logic_vector(to_unsigned(33,16)))&(std_logic_vector(to_unsigned(0,16)));--pixel 31 energy OFF
-- Vp(4) <= (std_logic_vector(to_unsigned(33,16)))&(std_logic_vector(to_unsigned(0,16)));--pixel 31 energy ON
-- Vp(6) <= (std_logic_vector(to_unsigned(33,16)))&(std_logic_vector(to_unsigned(0,16)));--pixel 31 energy ON
-- Vp(8) <= (std_logic_vector(to_unsigned(33,16)))&(std_logic_vector(to_unsigned(0,16)));--pixel 31 energy ON
-- Vp(10) <= (std_logic_vector(to_unsigned(33,16)))&(std_logic_vector(to_unsigned(0,16)));--pixel 31 energy ON
-- Vp(12) <= (std_logic_vector(to_unsigned(33,16)))&(std_logic_vector(to_unsigned(0,16)));--pixel 31 energy ON
-- Vp(14) <= (std_logic_vector(to_unsigned(33,16)))&(std_logic_vector(to_unsigned(0,16)));--pixel 31 energy ON
-- Vp(16) <= (std_logic_vector(to_unsigned(33,16)))&(std_logic_vector(to_unsigned(0,16)));--pixel 31 energy ON
-- Vp(18) <= (std_logic_vector(to_unsigned(33,16)))&(std_logic_vector(to_unsigned(0,16)));--pixel 31 energy ON
-- Vp(20) <= (std_logic_vector(to_unsigned(33,16)))&(std_logic_vector(to_unsigned(0,16)));--pixel 31 energy ON
-- Vp(22) <= (std_logic_vector(to_unsigned(33,16)))&(std_logic_vector(to_unsigned(0,16)));--pixel 31 energy ON
-- Vp(24) <= (std_logic_vector(to_unsigned(33,16)))&(std_logic_vector(to_unsigned(0,16)));--pixel 31 energy ON
-- Vp(26) <= (std_logic_vector(to_unsigned(33,16)))&(std_logic_vector(to_unsigned(0,16)));--pixel 31 energy ON
-- Vp(28) <= (std_logic_vector(to_unsigned(33,16)))&(std_logic_vector(to_unsigned(0,16)));--pixel 31 energy ON
-- Vp(30) <= (std_logic_vector(to_unsigned(33,16)))&(std_logic_vector(to_unsigned(0,16)));--pixel 31 energy ON

wait for 7 ms;



----------------------------------end copy another pulse---------------------------------------------------------



-- -------------------------------------copy-------------------------------------------
write_Vp <= '1';
Vp(1) <= (std_logic_vector(to_unsigned(33,16)))&(std_logic_vector(to_unsigned(65000,16)));--pixel 31 energy ON
wait for 100 us;
write_Vp <= '0';
wait for 100 us;
Vp(1) <= (std_logic_vector(to_unsigned(33,16)))&(std_logic_vector(to_unsigned(0,16)));--pixel 31 energy OFF

wait for 7 ms;
----------------------------------end copy another pulse---------------------------------------------------------

-------------------------------------copy-------------------------------------------
write_Vp <= '1';
Vp(2) <= (std_logic_vector(to_unsigned(33,16)))&(std_logic_vector(to_unsigned(65000,16)));--pixel 31 energy ON
wait for 100 us;
write_Vp <= '0';
wait for 100 us;
Vp(2) <= (std_logic_vector(to_unsigned(33,16)))&(std_logic_vector(to_unsigned(0,16)));--pixel 31 energy OFF

wait for 7 ms;
----------------------------------end copy another pulse---------------------------------------------------------

-------------------------------------copy-------------------------------------------
write_Vp <= '1';
Vp(1) <= (std_logic_vector(to_unsigned(33,16)))&(std_logic_vector(to_unsigned(65000,16)));--pixel 31 energy ON
wait for 100 us;
write_Vp <= '0';
wait for 100 us;
Vp(1) <= (std_logic_vector(to_unsigned(33,16)))&(std_logic_vector(to_unsigned(0,16)));--pixel 31 energy OFF

wait for 7 ms;
----------------------------------end copy another pulse---------------------------------------------------------

-------------------------------------copy-------------------------------------------
write_Vp <= '1';
Vp(2) <= (std_logic_vector(to_unsigned(33,16)))&(std_logic_vector(to_unsigned(65000,16)));--pixel 31 energy ON
wait for 100 us;
write_Vp <= '0';
wait for 100 us;
Vp(2) <= (std_logic_vector(to_unsigned(33,16)))&(std_logic_vector(to_unsigned(0,16)));--pixel 31 energy OFF

wait for 7 ms;
----------------------------------end copy another pulse---------------------------------------------------------

-------------------------------------copy-------------------------------------------
write_Vp <= '1';
Vp(3) <= (std_logic_vector(to_unsigned(33,16)))&(std_logic_vector(to_unsigned(65000,16)));--pixel 31 energy ON
wait for 100 us;
write_Vp <= '0';
wait for 100 us;
Vp(3) <= (std_logic_vector(to_unsigned(33,16)))&(std_logic_vector(to_unsigned(0,16)));--pixel 31 energy OFF

wait for 7 ms;
----------------------------------end copy another pulse---------------------------------------------------------

-------------------------------------copy-------------------------------------------
write_Vp <= '1';
Vp(4) <= (std_logic_vector(to_unsigned(33,16)))&(std_logic_vector(to_unsigned(65000,16)));--pixel 31 energy ON
wait for 100 us;
write_Vp <= '0';
wait for 100 us;
Vp(4) <= (std_logic_vector(to_unsigned(33,16)))&(std_logic_vector(to_unsigned(0,16)));--pixel 31 energy OFF

wait for 7 ms;
----------------------------------end copy another pulse---------------------------------------------------------


-------------------------------------copy-------------------------------------------
write_Vp <= '1';
Vp(3) <= (std_logic_vector(to_unsigned(33,16)))&(std_logic_vector(to_unsigned(65000,16)));--pixel 31 energy ON
wait for 100 us;
write_Vp <= '0';
wait for 100 us;
Vp(3) <= (std_logic_vector(to_unsigned(33,16)))&(std_logic_vector(to_unsigned(0,16)));--pixel 31 energy OFF

wait for 7 ms;
----------------------------------end copy another pulse---------------------------------------------------------

-------------------------------------copy-------------------------------------------
write_Vp <= '1';
Vp(4) <= (std_logic_vector(to_unsigned(33,16)))&(std_logic_vector(to_unsigned(65000,16)));--pixel 31 energy ON
wait for 100 us;
write_Vp <= '0';
wait for 100 us;
Vp(4) <= (std_logic_vector(to_unsigned(33,16)))&(std_logic_vector(to_unsigned(0,16)));--pixel 31 energy OFF

wait for 7 ms;
----------------------------------end copy another pulse---------------------------------------------------------

-------------------------------------copy-------------------------------------------
write_Vp <= '1';
Vp(5) <= (std_logic_vector(to_unsigned(33,16)))&(std_logic_vector(to_unsigned(65000,16)));--pixel 31 energy ON
wait for 100 us;
write_Vp <= '0';
wait for 100 us;
Vp(5) <= (std_logic_vector(to_unsigned(33,16)))&(std_logic_vector(to_unsigned(0,16)));--pixel 31 energy OFF

wait for 7 ms;
----------------------------------end copy another pulse---------------------------------------------------------

-------------------------------------copy-------------------------------------------
write_Vp <= '1';
Vp(6) <= (std_logic_vector(to_unsigned(33,16)))&(std_logic_vector(to_unsigned(65000,16)));--pixel 31 energy ON
wait for 100 us;
write_Vp <= '0';
wait for 100 us;
Vp(6) <= (std_logic_vector(to_unsigned(33,16)))&(std_logic_vector(to_unsigned(0,16)));--pixel 31 energy OFF

wait for 7 ms;
----------------------------------end copy another pulse---------------------------------------------------------

-------------------------------------copy-------------------------------------------
write_Vp <= '1';
Vp(7) <= (std_logic_vector(to_unsigned(33,16)))&(std_logic_vector(to_unsigned(65000,16)));--pixel 31 energy ON
wait for 100 us;
write_Vp <= '0';
wait for 100 us;
Vp(7) <= (std_logic_vector(to_unsigned(33,16)))&(std_logic_vector(to_unsigned(0,16)));--pixel 31 energy OFF

wait for 7 ms;
----------------------------------end copy another pulse---------------------------------------------------------


-------------------------------------copy-------------------------------------------
write_Vp <= '1';
Vp(9) <= (std_logic_vector(to_unsigned(33,16)))&(std_logic_vector(to_unsigned(65000,16)));--pixel 31 energy ON
wait for 100 us;
write_Vp <= '0';
wait for 100 us;
Vp(9) <= (std_logic_vector(to_unsigned(33,16)))&(std_logic_vector(to_unsigned(0,16)));--pixel 31 energy OFF

wait for 7 ms;
----------------------------------end copy another pulse---------------------------------------------------------

-------------------------------------copy-------------------------------------------
write_Vp <= '1';
Vp(10) <= (std_logic_vector(to_unsigned(33,16)))&(std_logic_vector(to_unsigned(65000,16)));--pixel 31 energy ON
wait for 100 us;
write_Vp <= '0';
wait for 100 us;
Vp(10) <= (std_logic_vector(to_unsigned(33,16)))&(std_logic_vector(to_unsigned(0,16)));--pixel 31 energy OFF

wait for 7 ms;
----------------------------------end copy another pulse---------------------------------------------------------

-------------------------------------copy-------------------------------------------
write_Vp <= '1';
Vp(11) <= (std_logic_vector(to_unsigned(33,16)))&(std_logic_vector(to_unsigned(65000,16)));--pixel 31 energy ON
wait for 100 us;
write_Vp <= '0';
wait for 100 us;
Vp(11) <= (std_logic_vector(to_unsigned(33,16)))&(std_logic_vector(to_unsigned(0,16)));--pixel 31 energy OFF

wait for 7 ms;
----------------------------------end copy another pulse---------------------------------------------------------

-------------------------------------copy-------------------------------------------
write_Vp <= '1';
Vp(12) <= (std_logic_vector(to_unsigned(33,16)))&(std_logic_vector(to_unsigned(65000,16)));--pixel 31 energy ON
wait for 100 us;
write_Vp <= '0';
wait for 100 us;
Vp(12) <= (std_logic_vector(to_unsigned(33,16)))&(std_logic_vector(to_unsigned(0,16)));--pixel 31 energy OFF

wait for 7 ms;
----------------------------------end copy another pulse---------------------------------------------------------

-------------------------------------copy-------------------------------------------
write_Vp <= '1';
Vp(13) <= (std_logic_vector(to_unsigned(33,16)))&(std_logic_vector(to_unsigned(65000,16)));--pixel 31 energy ON
wait for 100 us;
write_Vp <= '0';
wait for 100 us;
Vp(13) <= (std_logic_vector(to_unsigned(33,16)))&(std_logic_vector(to_unsigned(0,16)));--pixel 31 energy OFF

wait for 7 ms;
----------------------------------end copy another pulse---------------------------------------------------------

-------------------------------------copy-------------------------------------------
write_Vp <= '1';
Vp(14) <= (std_logic_vector(to_unsigned(33,16)))&(std_logic_vector(to_unsigned(65000,16)));--pixel 31 energy ON
wait for 100 us;
write_Vp <= '0';
wait for 100 us;
Vp(14) <= (std_logic_vector(to_unsigned(33,16)))&(std_logic_vector(to_unsigned(0,16)));--pixel 31 energy OFF

wait for 7 ms;
----------------------------------end copy another pulse---------------------------------------------------------

-------------------------------------copy-------------------------------------------
write_Vp <= '1';
Vp(15) <= (std_logic_vector(to_unsigned(33,16)))&(std_logic_vector(to_unsigned(65000,16)));--pixel 31 energy ON
wait for 100 us;
write_Vp <= '0';
wait for 100 us;
Vp(15) <= (std_logic_vector(to_unsigned(33,16)))&(std_logic_vector(to_unsigned(0,16)));--pixel 31 energy OFF

wait for 7 ms;
----------------------------------end copy another pulse---------------------------------------------------------

-------------------------------------copy-------------------------------------------
write_Vp <= '1';
Vp(16) <= (std_logic_vector(to_unsigned(33,16)))&(std_logic_vector(to_unsigned(65000,16)));--pixel 31 energy ON
wait for 100 us;
write_Vp <= '0';
wait for 100 us;
Vp(16) <= (std_logic_vector(to_unsigned(33,16)))&(std_logic_vector(to_unsigned(0,16)));--pixel 31 energy OFF

wait for 7 ms;
----------------------------------end copy another pulse---------------------------------------------------------

-------------------------------------copy-------------------------------------------
write_Vp <= '1';
Vp(17) <= (std_logic_vector(to_unsigned(33,16)))&(std_logic_vector(to_unsigned(65000,16)));--pixel 31 energy ON
wait for 100 us;
write_Vp <= '0';
wait for 100 us;
Vp(17) <= (std_logic_vector(to_unsigned(33,16)))&(std_logic_vector(to_unsigned(0,16)));--pixel 31 energy OFF

wait for 7 ms;
----------------------------------end copy another pulse---------------------------------------------------------


-------------------------------------copy-------------------------------------------
write_Vp <= '1';
Vp(18) <= (std_logic_vector(to_unsigned(33,16)))&(std_logic_vector(to_unsigned(65000,16)));--pixel 31 energy ON
wait for 100 us;
write_Vp <= '0';
wait for 100 us;
Vp(18) <= (std_logic_vector(to_unsigned(33,16)))&(std_logic_vector(to_unsigned(0,16)));--pixel 31 energy OFF

wait for 7 ms;
----------------------------------end copy another pulse---------------------------------------------------------

-------------------------------------copy-------------------------------------------
write_Vp <= '1';
Vp(19) <= (std_logic_vector(to_unsigned(33,16)))&(std_logic_vector(to_unsigned(65000,16)));--pixel 31 energy ON
wait for 100 us;
write_Vp <= '0';
wait for 100 us;
Vp(19) <= (std_logic_vector(to_unsigned(33,16)))&(std_logic_vector(to_unsigned(0,16)));--pixel 31 energy OFF

wait for 7 ms;
----------------------------------end copy another pulse---------------------------------------------------------


-------------------------------------copy-------------------------------------------
write_Vp <= '1';
Vp(20) <= (std_logic_vector(to_unsigned(33,16)))&(std_logic_vector(to_unsigned(65000,16)));--pixel 31 energy ON
wait for 100 us;
write_Vp <= '0';
wait for 100 us;
Vp(20) <= (std_logic_vector(to_unsigned(33,16)))&(std_logic_vector(to_unsigned(0,16)));--pixel 31 energy OFF

wait for 7 ms;
----------------------------------end copy another pulse---------------------------------------------------------

-------------------------------------copy-------------------------------------------
write_Vp <= '1';
Vp(21) <= (std_logic_vector(to_unsigned(33,16)))&(std_logic_vector(to_unsigned(65000,16)));--pixel 31 energy ON
wait for 100 us;
write_Vp <= '0';
wait for 100 us;
Vp(21) <= (std_logic_vector(to_unsigned(33,16)))&(std_logic_vector(to_unsigned(0,16)));--pixel 31 energy OFF

wait for 7 ms;
----------------------------------end copy another pulse---------------------------------------------------------

-------------------------------------copy-------------------------------------------
write_Vp <= '1';
Vp(22) <= (std_logic_vector(to_unsigned(33,16)))&(std_logic_vector(to_unsigned(65000,16)));--pixel 31 energy ON
wait for 100 us;
write_Vp <= '0';
wait for 100 us;
Vp(22) <= (std_logic_vector(to_unsigned(33,16)))&(std_logic_vector(to_unsigned(0,16)));--pixel 31 energy OFF

wait for 7 ms;
----------------------------------end copy another pulse---------------------------------------------------------

-------------------------------------copy-------------------------------------------
write_Vp <= '1';
Vp(23) <= (std_logic_vector(to_unsigned(33,16)))&(std_logic_vector(to_unsigned(65000,16)));--pixel 31 energy ON
wait for 100 us;
write_Vp <= '0';
wait for 100 us;
Vp(23) <= (std_logic_vector(to_unsigned(33,16)))&(std_logic_vector(to_unsigned(0,16)));--pixel 31 energy OFF

wait for 7 ms;
----------------------------------end copy another pulse---------------------------------------------------------


wait;
end process;

-- label_CLK_156k :process
-- begin
	-- CLK_156k <= '0';
	-- wait for CLK_period*1282/2;
	-- CLK_156k <= '1';
	-- wait for CLK_period*1282/2;
-- end process;

-- stim_proc: process
-- begin		

	-- SendPulse	<= '0';
	-- wait for CLK_period*10;

	
	-- wait for CLK_period*2*10000;		-- = 1 ms
	-- SendPulse	<= '1';
	-- wait for CLK_period*1000;
	-- SendPulse	<= '1';

	-- wait for CLK_period*2*150000;		-- = 15 ms
	-- SendPulse	<= '1';
	-- wait for CLK_period*100000;
	-- SendPulse	<= '0';
	
	-- wait;
-- end process;


--write_sig_1		<= Pulse_Ram_Data_RD;


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
variable Value : std_logic_vector(15 downto 0);

begin
 
	wait until RESET = '0' and RESET'event;
  	file_open(fake_pulse_CBE, "fake_pulse_CBE.txt", READ_MODE);
	Pulse_Ram_ADDRESS_WR 	<= (others=>'0');
	
	WE_Pulse_Ram		<= '0';
		loop
    	wait until CLK_5Mhz='1' and CLK_5Mhz'event;
    	if not endfile(fake_pulse_CBE) 
		then
		WE_Pulse_Ram		<= '1';
        	readline(fake_pulse_CBE, l);
        	hread(l, Value);
         	Pulse_Ram_Data_WR <= Value;
			
			Pulse_Ram_ADDRESS_WR <= Pulse_Ram_ADDRESS_WR +1;
		else
		WE_Pulse_Ram		<= '0';	
		end if;
     	end loop;
end process;


END;
