
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
use ieee.std_logic_textio.all;
use std.textio.all;

ENTITY Tb_Pulse IS
END Tb_Pulse;

ARCHITECTURE behavior OF Tb_Pulse IS 

constant CLK_period : time := 50 ns;

signal CLK 				: std_logic;
signal RESET 			: std_logic;
--signal Sig_in: signed(15 downto 0);
signal Sig_out			: STD_LOGIC_VECTOR (31 downto 0);
signal write_sig_1		: signed(19 downto 0);
signal SendPulse 		: std_logic;
signal Pulse_Ram_Data	: STD_LOGIC_vector (31 downto 0 );
signal Pulse_Ram_ADDRESS	: unsigned (9 downto 0 );
signal Pulse_Ram_ADDRESS_RD	: unsigned (9 downto 0 );
signal WE_Pulse_Ram		: std_logic;

BEGIN

RESET <= '1', '0' after 100 ns;

-- Component Instantiation
uut: entity work.Pulse_Emulator 
	PORT MAP(
		Reset				=> RESET,
		CLK_4X				=> CLK,
		ENABLE_CLK_1X		=> '1',
		Pulse_timescale	=> to_unsigned(1,4),
		Pulse_amplitude	=> to_unsigned(128,8),
		Send_Pulse			=> SendPulse,
		WE_Pulse_Ram		=> WE_Pulse_Ram,
		Pulse_Ram_ADDRESS	=> Pulse_Ram_ADDRESS,
		Pulse_Ram_ADDRESS_RD=> Pulse_Ram_ADDRESS_RD,
		Pulse_Ram_Data		=> Pulse_Ram_Data,
		Sig_in				=> to_signed(32767,20),
		Sig_out				=> Sig_out
	);


CLK_process :process
begin
	CLK <= '0';
	wait for CLK_period/2;
	CLK <= '1';
	wait for CLK_period/2;
end process;


stim_proc: process
begin		

	SendPulse	<= '0';
	wait for CLK_period*10;

	
	wait for CLK_period*2*10000;		-- = 1 ms
	SendPulse	<= '1';
	wait for CLK_period*1000;
	SendPulse	<= '1';

	wait for CLK_period*2*150000;		-- = 15 ms
	SendPulse	<= '1';
	wait for CLK_period*100000;
	SendPulse	<= '0';
	
	wait;
end process;


--write_sig_1		<= Sig_out;


-----------------------------------------
--- write process - 1
-----------------------------------------
write_proc1: process

file Sig_out_file	: text;
variable l : line;
variable Value : std_logic_vector(Sig_out'length-1 downto 0);

begin
	file_open(Sig_out_file, "Output_signal.txt", WRITE_MODE);
	Pulse_Ram_ADDRESS_RD	<= (others=>'0');
	loop
  	wait until (CLK='1' and CLK'event); 
	Pulse_Ram_ADDRESS_RD <= Pulse_Ram_ADDRESS_RD +1;	
	Value:= std_logic_vector(Sig_out);
   	write(l, Value); 
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
 
	wait until RESET = '0' and RESET'event;
  	file_open(fake_pulse_CBE, "fake_pulse_CBE.txt", READ_MODE);
	Pulse_Ram_ADDRESS 	<= (others=>'0');
	
	WE_Pulse_Ram		<= '0';
		loop
    	wait until Clk='1' and Clk'event;
    	if not endfile(fake_pulse_CBE) 
		then
		WE_Pulse_Ram		<= '1';
        	readline(fake_pulse_CBE, l);
        	hread(l, Value);
         	Pulse_Ram_Data <= Value;
			
			Pulse_Ram_ADDRESS <= Pulse_Ram_ADDRESS +1;
		else
		WE_Pulse_Ram		<= '0';	
		end if;
     	end loop;
end process;


END;
