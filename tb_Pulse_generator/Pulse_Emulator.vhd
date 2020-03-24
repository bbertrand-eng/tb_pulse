----------------------------------------------------------------------------------
-- Company       : CNRS - INSU - IRAP
-- Engineer      : Antoine CLENET/ Christophe OZIOL 
-- Create Date   : 12:14:36 05/26/2015 
-- Design Name   : DRE XIFU FPGA_BOARD
-- Module Name   : Pulse_Emulator - Behavioral 
-- Project Name  : Athena XIfu DRE
-- Target Devices: Virtex 6 LX 240
-- Tool versions : ISE-14.7
-- Description   : Pulse emulator for pixel
--
-- Dependencies: Athena package
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
---------------------------------------oOOOo(o_o)oOOOo-----------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.ALL;
--use work.athena_package.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Pulse_Emulator is
    Port (
--RESET
			Reset		 		: in  STD_LOGIC;
--CLOCKs
    		CLK_156k					: in  STD_LOGIC;
			ENABLE_CLK_1X			: in  STD_LOGIC;
--CONTROL

			--Send_Pulse 			: in  STD_LOGIC;
			WE_Pulse_Ram 		: in std_logic;
			Pulse_Ram_ADDRESS	: in unsigned (9 downto 0);
			Pulse_Ram_ADDRESS_RD: in unsigned (9 downto 0);
			Pulse_Ram_Data		: in STD_LOGIC_VECTOR (31 downto 0);
--			Sig_in 				: in  signed (C_Size_DDS-1 downto 0);
        	Pulse_Ram_Data_RD 	: out STD_LOGIC_VECTOR (31 downto 0)
        );
end Pulse_Emulator;

--! @brief-- BLock diagrams schematics -- 
--! @detail file:work.Pulse_Emulator.Behavioral.svg
architecture Behavioral of Pulse_Emulator is

constant C_PluseLUT_Size_in 	: integer := 18;
constant C_PluseLUT_Size_out 	: integer := 16;
constant C_MaxCount			: positive := ((2**C_PluseLUT_Size_in)-1);


type 	t_state is(idle,pulse);
signal 	state : t_state;

signal 	counter				: unsigned(C_PluseLUT_Size_in-1 downto 0);

-- signal 	one_pulse 			: STD_LOGIC;
-- signal 	one_pulsed 			: STD_LOGIC;


BEGIN

label_LUT_func: entity work.LUT_func 
	-- Generic map(
		-- C_Size_in	=> C_PluseLUT_Size_in,	
		-- C_Size_out	=> C_PluseLUT_Size_out	
		-- )
	Port map( 
		RESET				=> Reset,
		CLK_156k			=> CLK_156k,
		ENABLE_CLK_1X		=> ENABLE_CLK_1X,
		WE_Pulse_Ram 		=> WE_Pulse_Ram ,
		Pulse_Ram_ADDRESS	=> Pulse_Ram_ADDRESS,
		Pulse_Ram_ADDRESS_RD=> Pulse_Ram_ADDRESS_RD,	
		Pulse_Ram_Data		=> Pulse_Ram_Data,
		--Func_in				=> counter,
		Func_out			=> Pulse_Ram_Data_RD
);


-- P_ONE_pulse: process(CLK_156k)
	-- begin
		-- if (rising_edge(CLK_156k)) then
			-- if (Reset = '1') then
				-- one_pulse <= '0';
		 		-- one_pulsed <= '0';
			-- elsif (ENABLE_CLK_1X = '1') then
				-- if (Send_Pulse ='1' and	one_pulsed = '0') then
					-- one_pulse 	<='1';
					-- one_pulsed 	<='1';
				-- else 
					-- if (one_pulse ='1' and one_pulsed = '1') then
						-- one_pulse	<= '0';
						-- one_pulsed 	<= '1';
					-- else 
						-- if (Send_Pulse ='0' ) then
						-- one_pulse	<= '0';
						-- one_pulsed 	<= '0';
						-- end if;
					-- end if;
				-- end if;
			-- end if;
		-- end if;
-- end process; 
-- P_sig_gene: process(CLK_4X)
-- begin
	-- if rising_edge(CLK_4X) then
		-- if (Reset = '1') then
			-- pulse_amp_buf		<= (others=>'0');
			-- pulse_amp_offset	<= (others=>'0');
			-- Bias_Pulse_buf		<= (others=>'0');
			-- Pulse_Ram_Data_RD 			<= (others=>'0');
			-- state				<= idle;
			-- Pulse_amplitude_reg <= (others=>'0');
			-- counter 			<= (others=>'0');
			-- counter_prev 		<= (others=>'0');
		-- elsif (ENABLE_CLK_1X ='1') then
			-- Pulse_amplitude_reg <= Pulse_amplitude;
			-- pulse_amp_buf		<= LUT_out*Pulse_amplitude_reg;
			-- pulse_amp_offset	<= to_unsigned((2**(LUT_out'length))-1,LUT_out'length) - pulse_amp;
			-- Bias_Pulse_buf		<= signed('0' & pulse_amp_offset) * Sig_in;
			-- Pulse_Ram_Data_RD	<= Bias_Pulse;
			-- Case state is
			-- when idle	=>
				-- if one_pulse = '1' then
					-- counter 		<= (others=>'0');
					-- counter_prev 	<= (others=>'0');
					-- state			<= pulse;
				-- else 
					-- state		<= idle;
				-- end if;
			-- when pulse	=>
				-- if (counter < C_MaxCount) and (counter >= counter_prev) then
					-- counter_prev	<= counter;
					-- counter			<= resize(counter+Pulse_timescale,counter'length);
					-- state			<= pulse;
				-- else
					-- state			<= idle;
				-- end if;		
			-- end case;
		-- end if;
	-- end if;
-- end process;

-- pulse_amp			<= pulse_amp_buf(pulse_amp_buf'length-1 downto pulse_amp_buf'length-LUT_out'length);
-- Bias_Pulse			<= Bias_Pulse_buf(Bias_Pulse_buf'length-1 -1 downto Bias_Pulse_buf'length-1 - Pulse_Ram_Data_RD'length);


end Behavioral;
