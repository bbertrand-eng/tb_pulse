
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
use ieee.std_logic_textio.all;
use std.textio.all;

ENTITY Tb_Pulse IS
END Tb_Pulse;

ARCHITECTURE behavior OF Tb_Pulse IS 

constant CLK_period : time := 200 ns;

signal CLK_5Mhz 		: std_logic;
--signal CLK_156k			: std_logic;
signal RESET 			: std_logic;
--signal Sig_in: signed(15 downto 0);
signal Pulse_Ram_Data_RD			: STD_LOGIC_VECTOR (31 downto 0);
--signal write_sig_1		: signed(19 downto 0);
--signal SendPulse 		: std_logic;
signal Pulse_Ram_Data_WR	: STD_LOGIC_vector (31 downto 0 );
signal Pulse_Ram_ADDRESS_WR	: unsigned (9 downto 0 );
signal Pulse_Ram_ADDRESS_RD	: unsigned (9 downto 0 );
signal WE_Pulse_Ram		: std_logic;

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
label_Pulse_Emulator : entity work.Pulse_Emulator 
	PORT MAP(
		Reset				=> RESET,
		CLK_5Mhz			=> CLK_5Mhz,
		ENABLE_CLK_1X		=> '1',

		--Send_Pulse			=> SendPulse,
		WE_Pulse_Ram		=> WE_Pulse_Ram,	--: std_logic;
		Pulse_Ram_ADDRESS_WR	=> Pulse_Ram_ADDRESS_WR,	--: unsigned (9 downto 0 );
		Pulse_Ram_ADDRESS_RD=> Pulse_Ram_ADDRESS_RD,	--: unsigned (9 downto 0 );
		Pulse_Ram_Data_WR		=> Pulse_Ram_Data_WR,	--: STD_LOGIC_vector (31 downto 0 );
--		Sig_in				=> to_signed(32767,20),
		Pulse_Ram_Data_RD	=> Pulse_Ram_Data_RD	--: STD_LOGIC_VECTOR (31 downto 0);
	);




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
variable Value : std_logic_vector(31 downto 0);

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
