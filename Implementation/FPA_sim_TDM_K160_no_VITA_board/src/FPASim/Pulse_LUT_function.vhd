
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.math_real.all;
use work.pulse_package.all;


entity LUT_func is

    Port ( 
--RESET
		RESET				: in  std_logic;
--CLOCK
		CLK_5Mhz				: in  std_logic;
		ENABLE_CLK_1X		: in  std_logic;
		WE_Pulse_Ram 		: in  std_logic;
		Pulse_Ram_ADDRESS_WR: in  unsigned (9 downto 0);
		Pulse_Ram_ADDRESS_RD: in  unsigned (9 downto 0);
		Pulse_Ram_Data_WR	: in  STD_LOGIC_VECTOR (15 downto 0);

		Pulse_Ram_Data_RD 	: out STD_LOGIC_VECTOR(15 downto 0)
		);
end LUT_func;

--! @brief-- BLock diagrams schematics -- 
--! @detail file:work.LUT_func.Behavioral.svg
architecture Behavioral of LUT_func is


signal  Pulse_Ram : t_Pulse_Ram	:=	(others=>(others=>'0'));

begin
P_Write_Pulse_Ram: process (CLK_5Mhz)
begin
	if rising_edge(CLK_5Mhz) then
		if (WE_Pulse_Ram ='1') then
			Pulse_Ram(to_integer(Pulse_Ram_ADDRESS_WR))	<= Pulse_Ram_Data_WR;
		end if;
	end if;
end process;

P_readout: process (RESET,CLK_5Mhz)
begin
if RESET = '1' then
Pulse_Ram_Data_RD	<= (others=>'0');
else
	if rising_edge(CLK_5Mhz) then
	Pulse_Ram_Data_RD	<= Pulse_Ram(to_integer(Pulse_Ram_ADDRESS_RD));	
	end if;
end if;	
end process;

end Behavioral;