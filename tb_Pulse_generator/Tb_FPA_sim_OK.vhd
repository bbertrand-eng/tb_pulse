
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
use ieee.std_logic_textio.all;
--USE ieee.numeric_std.ALL;
use std.textio.all;
use work.pulse_package.all;

ENTITY Tb_FPA_sim_OK IS
END Tb_FPA_sim_OK;

ARCHITECTURE behavior OF Tb_FPA_sim_OK IS 

constant CLK_period : time := 200 ns;
constant CLK_period_10 : time := 10 ns;

signal CLK_5Mhz 		: std_logic;
signal CLK_100Mhz		: std_logic;

--signal CLK_156k			: std_logic;
signal RESET 			: std_logic;
signal RESET_file		: std_logic;
--signal Sig_in: signed(15 downto 0);
signal Pulse_Ram_Data_RD			: STD_LOGIC_VECTOR (15 downto 0);
--signal write_sig_1		: signed(19 downto 0);
--signal SendPulse 		: std_logic;
signal Pulse_Ram_Data_WR	: STD_LOGIC_vector (15 downto 0 );
signal Pulse_Ram_ADDRESS_WR	: STD_LOGIC_vector (9 downto 0 );
signal Pulse_Ram_ADDRESS_RD	: unsigned (9 downto 0 );
signal WE_Pulse_Ram		: std_logic;
signal write_add_null	: std_logic;

--signal write_Vp			: std_logic;

-- signal 	view_pixel			:	t_array_view_pixel;
-- signal	view_pixel_index	:	integer range 0 to C_pixel;
signal	Vtes_out			:	signed(15 downto 0);

--signal 	Vp	:	t_array_Mem_Vp;

--signal	Amplitude		: integer;

-- signal view_i			: integer;
-- signal view_c			: integer;

signal din_vp				: 	STD_LOGIC_VECTOR (31 downto 0);
signal wr_en_vp				:	std_logic;


signal feedback_sq1 : signed(15 downto 0);
signal error : signed(15 downto 0);






BEGIN

RESET <= '1', '0' after 100 ns;
RESET_file <= '1', '0' after 250 us;

CLK_process :process
begin
	CLK_5Mhz <= '0';
	wait for CLK_period/2;
	CLK_5Mhz <= '1';
	wait for CLK_period/2;
end process;

CLK_process_100 :process
begin
	CLK_100Mhz <= '0';
	wait for CLK_period_10/2;
	CLK_100Mhz <= '1';
	wait for CLK_period_10/2;
end process;


-- Component Instantiation
label_FPA_sim_ok : entity work.FPA_sim_OK
	port map(
		Reset                => Reset,
		CLK_5Mhz             => CLK_5Mhz,
		CLK_100Mhz           => CLK_100Mhz,
		din                  => din_vp,
		wr_en                => wr_en_vp,
		WE_Pulse_Ram         => WE_Pulse_Ram,
		Pulse_Ram_ADDRESS_WR => Pulse_Ram_ADDRESS_WR,
		Pulse_Ram_Data_WR    => Pulse_Ram_Data_WR,
		Vtes_out             => Vtes_out,
		feedback_sq1         => feedback_sq1,
		error                => error
	);




----------------------------------------------------------------------------------------------
--
-- read file
--
----------------------------------------------------------------------------------------------

label_read_file_pules: process

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

----------------------------------------------------------------------------------------------
--
-- read file
--
----------------------------------------------------------------------------------------------

label_read_file_vp	: process

file Vo_Vp	: text;
variable l : line;
variable Value : std_logic_vector(31 downto 0);

begin
 
file_open(Vo_Vp, "Vo_Vp.txt", READ_MODE);
din_vp 	<= (others=>'0'); 
wr_en_vp	<=	'0';
	wait until RESET_file = '0' and RESET_file'event;
	
		loop
    	wait until CLK_100Mhz='1' and CLK_100Mhz'event;
			if	write_add_null = '0' then
			write_add_null 			<= '1'; 
			wr_en_vp		<= '1';
			readline(Vo_Vp, l);
			hread(l, Value);
			din_vp <= Value(31 downto 0);
			else		
				if not endfile(Vo_Vp) then
					wr_en_vp		<= '1';
					readline(Vo_Vp, l);
					hread(l, Value);
					din_vp <= Value(31 downto 0);
				else
				wr_en_vp		<= '0';	
				end if;
			end if;
     	end loop;
end process;

END;