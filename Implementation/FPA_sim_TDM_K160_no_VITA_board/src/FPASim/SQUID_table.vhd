
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.math_real.all;
use work.pulse_package.all;


entity SQUID_table is

    Port ( 
--RESET
		RESET				: in  std_logic;
--CLOCK
		CLK_5Mhz				: in  std_logic;
		--ENABLE_CLK_1X		: in  std_logic;
		WE_squid_Ram 		: in  std_logic;
		squid_Ram_ADDRESS_WR: in  unsigned (11 downto 0);
		squid_Ram_ADDRESS_RD: in  unsigned (11 downto 0);
		squid_Ram_Data_WR	: in  STD_LOGIC_VECTOR (15 downto 0);

		squid_Ram_Data_RD 	: out STD_LOGIC_VECTOR(15 downto 0)
		);
end SQUID_table;

--! @brief-- BLock diagrams schematics -- 
--! @detail file:work.SQUID_table.Behavioral.svg
architecture Behavioral of SQUID_table is


signal  squid_Ram : t_squid_Ram	:=	(others=>(others=>'0'));

begin
P_Write_squid_Ram: process (CLK_5Mhz)
begin
	if rising_edge(CLK_5Mhz) then
		if (WE_squid_Ram ='1') then
			squid_Ram(to_integer(unsigned(squid_Ram_ADDRESS_WR)))	<= squid_Ram_Data_WR;
		end if;
	end if;
end process;

P_readout: process (RESET,CLK_5Mhz)
begin
if RESET = '1' then
squid_Ram_Data_RD	<= (others=>'0');
else
	if rising_edge(CLK_5Mhz) then
	squid_Ram_Data_RD	<= squid_Ram(to_integer(squid_Ram_ADDRESS_RD));	
	end if;
end if;	
end process;

end Behavioral;