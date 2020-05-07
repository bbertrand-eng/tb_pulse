
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
-- use IEEE.std_logic_arith.all;
-- use IEEE.std_logic_unsigned.all;
use ieee.std_logic_textio.all;
use std.textio.all;
--use work.pulse_package.all;

ENTITY Tb_Pulse_LUT_function IS
END Tb_Pulse_LUT_function;

ARCHITECTURE behavior OF Tb_Pulse_LUT_function IS

	constant CLK_period : time := 200 ns;

	signal CLK_5Mhz             : std_logic;
	--signal CLK_156k			: std_logic;
	signal RESET                : std_logic;
	signal RESET_read			: std_logic;
	--signal Sig_in: signed(15 downto 0);
	signal Pulse_Ram_Data_RD    : STD_LOGIC_VECTOR(15 downto 0);
	--signal write_sig_1		: signed(19 downto 0);
	--signal SendPulse 		: std_logic;
	signal Pulse_Ram_Data_WR    : STD_LOGIC_vector(15 downto 0);
	signal Pulse_Ram_ADDRESS_WR : unsigned(9 downto 0);
	signal Pulse_Ram_ADDRESS_RD : unsigned(9 downto 0);
	signal Pulse_Ram_ADDRESS_WR_std : STD_LOGIC_vector(9 downto 0);
	signal Pulse_Ram_ADDRESS_RD_std : STD_LOGIC_vector(9 downto 0);
	signal WE_Pulse_Ram         : std_logic;
	signal write_add_null       : std_logic;

	signal write_Vp : std_logic;

	-- signal view_pixel       : t_array_view_pixel;
	-- signal view_pixel_index : integer range 0 to C_pixel;
	-- signal Vtes_out         : signed(15 downto 0);

	-- signal Vp : t_array_Mem_Vp;
	-- signal Amplitude_vo : integer;

	-- signal Amplitude : integer;

	-- signal view_i       : integer;
	-- signal view_c       : integer;
	-- signal feedback_sq1 : signed(15 downto 0);
	-- signal error : signed(15 downto 0);

BEGIN

	RESET 		<= '1', '0' after 100 ns;
	RESET_read	<= '1', '0' after 10000 ns;

	CLK_process : process
	begin
		CLK_5Mhz <= '0';
		wait for CLK_period / 2;
		CLK_5Mhz <= '1';
		wait for CLK_period / 2;
	end process;

	-- Component Instantiation
	label_LUT_func : entity work.LUT_func
		PORT MAP(
			-- global

			Reset                	=> RESET,
			CLK_5Mhz             	=> CLK_5Mhz,
			-- from gse Vp Vo 

			WE_Pulse_Ram 			=>	WE_Pulse_Ram,
			Pulse_Ram_ADDRESS_WR	=>	Pulse_Ram_ADDRESS_WR_std,
			Pulse_Ram_ADDRESS_RD	=>	Pulse_Ram_ADDRESS_RD_std,
			Pulse_Ram_Data_WR		=>	Pulse_Ram_Data_WR,

			Pulse_Ram_Data_RD 		=>	Pulse_Ram_Data_RD
		);

Pulse_Ram_ADDRESS_RD_std <= std_logic_vector(Pulse_Ram_ADDRESS_RD);		
Pulse_Ram_ADDRESS_WR_std <= std_logic_vector(Pulse_Ram_ADDRESS_WR);
		
	stim_proc : process
	begin
	


		wait;
	end process;

	-- -------------------------------------------------------------------------------------------------------------------------------------
	-- ----------------------------------Manage files---------------------------------------------------------
	-------------------------------------------------------------------------------------------------------------------------------------

	-----------------------------------------
	--- write process - 1
	-----------------------------------------
	write_proc1 : process
		file Sig_out_file : text;
		variable l        : line;
		variable Value    : std_logic_vector(Pulse_Ram_Data_RD'length - 1 downto 0);

	begin
		file_open(Sig_out_file, "Output_signal.txt", WRITE_MODE);
		Pulse_Ram_ADDRESS_RD <= (others => '0');
		wait until RESET_read = '0' and RESET_read'event;
		loop
			wait until (CLK_5Mhz = '1' and CLK_5Mhz'event);
			Pulse_Ram_ADDRESS_RD <= Pulse_Ram_ADDRESS_RD + 1;
			Value                := std_logic_vector(Pulse_Ram_Data_RD);
			hwrite(l, Value);
			writeline(Sig_out_file, l);
		end loop;
	end process;

	----------------------------------------------------------------------------------------------
	--
	-- read file
	--
	----------------------------------------------------------------------------------------------

	albel_read_file : process
		file fake_pulse_CBE : text;
		variable l          : line;
		variable Value      : std_logic_vector(31 downto 0);

	begin
		file_open(fake_pulse_CBE, "fake_pulse_CBE.txt", READ_MODE);
		Pulse_Ram_ADDRESS_WR <= (others => '0');
		WE_Pulse_Ram         <= '0';
		Pulse_Ram_Data_WR    <= (others => '0');
		write_add_null       <= '0';
		wait until RESET = '0' and RESET'event;

		loop
			wait until CLK_5Mhz = '1' and CLK_5Mhz'event;
			if write_add_null = '0' then
				write_add_null    <= '1';
				WE_Pulse_Ram      <= '1';
				readline(fake_pulse_CBE, l);
				hread(l, Value);
				Pulse_Ram_Data_WR <= Value(31 downto 16);
			else
				if not endfile(fake_pulse_CBE) then
					WE_Pulse_Ram      <= '1';
					readline(fake_pulse_CBE, l);
					hread(l, Value);
					Pulse_Ram_Data_WR <= Value(31 downto 16);

					Pulse_Ram_ADDRESS_WR <= Pulse_Ram_ADDRESS_WR + 1;
				else
					WE_Pulse_Ram <= '0';
				end if;
			end if;
		end loop;
	end process;

END;
