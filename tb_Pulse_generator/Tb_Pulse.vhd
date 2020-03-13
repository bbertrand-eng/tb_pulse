
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
use ieee.std_logic_textio.all;
use std.textio.all;

ENTITY testbench IS
END testbench;

ARCHITECTURE behavior OF testbench IS 

constant CLK_period : time := 50 ns;

signal CLK : std_logic;
signal RESET : std_logic;
--signal Sig_in: signed(15 downto 0);
signal Sig_out: signed(19 downto 0);
signal write_sig_1 : signed(19 downto 0);
signal SendPulse : std_logic;


BEGIN

-- Component Instantiation
uut: entity work.Pulse_Emulator 
	PORT MAP(
		Reset				=> RESET,
		CLK_4X				=> CLK,
		ENABLE_CLK_1X		=> '1',
		Pulse_timescale	=> to_unsigned(1,4),
		Pulse_amplitude	=> to_unsigned(128,8),
		Send_Pulse			=> SendPulse,
		WE_Pulse_Ram		=> '0',
		Pulse_Ram_ADDRESS	=> (others => '0'),
		Pulse_Ram_Data		=> (others => '0'),
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
	RESET	<= '1';
	SendPulse	<= '0';
	wait for CLK_period*10;
	RESET	<= '0';
	
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


write_sig_1		<= Sig_out;


-----------------------------------------
--- write process - 1
-----------------------------------------
write_proc1: process

file Sig_out_file	: text;
variable l : line;
variable Value : std_logic_vector(write_sig_1'length-1 downto 0);

begin
	file_open(Sig_out_file, "Output_signal.txt", WRITE_MODE);
	loop
  	wait until (CLK='1' and CLK'event);  			  
  	   Value:= std_logic_vector(write_sig_1);
   	write(l, Value); 
      writeline(Sig_out_file, l);
    end loop;
end process;


END;
