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
use work.pulse_package.all;
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
    		CLK_5Mhz			: in  STD_LOGIC;
			ENABLE_CLK_1X		: in  STD_LOGIC;
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

signal	CLK_73529Hz			: std_logic;
signal 	pixel				:	integer range 0 to C_pixel;

type 	t_array_Mem_counter_address is array (C_pixel-1 downto 0) of unsigned (9 downto 0);
signal	mem_counter_address	:	t_array_Mem_counter_address;

signal	counter_address		:	unsigned (9 downto 0);

signal	view_pixel			:	STD_LOGIC_VECTOR (31 downto 0);
	
-- constant C_MaxCount				:	positive := ((2**C_PluseLUT_Size_in)-1);

signal Pulse_Ram_ADDRESS_RD_internal : unsigned (9 downto 0);
signal Pulse_Ram_Data_RD_internal	: STD_LOGIC_VECTOR (31 downto 0);

type 	t_state is(idle,pulse);
signal 	state : t_state;

BEGIN

label_pixel : process(Reset, CLK_5Mhz)
begin
if Reset = '1' then
pixel	<= 0;
CLK_73529Hz	<= '0';

else
    if CLK_5Mhz='1' and CLK_5Mhz'event then
	pixel <= pixel + 1;
		if pixel = C_pixel-1 then
		pixel	<= 0;
		CLK_73529Hz <= not CLK_73529Hz;
		end if;
    end if;  -- clock
end if;  -- reset 
end process;

-- label_counter_address : process(Reset, CLK_5Mhz)
-- begin
-- if Reset = '1' then
-- counter_address <= (others => '0');
-- else
    -- if CLK_5Mhz='1' and CLK_5Mhz'event then
	-- counter_address <= counter_address + 1; 
		-- if counter_address = C_depth_pulse_memory-1 then
		-- counter_address <= (others => '0');
		-- end if;
    -- end if;  -- clock
-- end if;  -- reset 
-- end process;

label_mem_counter_address : process(Reset, CLK_5Mhz)
begin
if Reset = '1' then
mem_counter_address <= (others=>(others=>'0'));

else
    if CLK_5Mhz='1' and CLK_5Mhz'event then
	mem_counter_address(pixel) <= mem_counter_address(pixel)+1;
    end if;  -- clock
end if;  -- reset 
end process;


label_LUT_func: entity work.LUT_func 
	-- Generic map(
		-- C_Size_in	=> C_PluseLUT_Size_in,	
		-- C_Size_out	=> C_PluseLUT_Size_out	
		-- )
	Port map( 
		RESET				=> Reset,
		CLK_5Mhz			=> CLK_5Mhz,
		ENABLE_CLK_1X		=> ENABLE_CLK_1X,
		WE_Pulse_Ram 		=> WE_Pulse_Ram ,
		Pulse_Ram_ADDRESS	=> Pulse_Ram_ADDRESS,
		Pulse_Ram_ADDRESS_RD=> Pulse_Ram_ADDRESS_RD_internal,	
		Pulse_Ram_Data		=> Pulse_Ram_Data,
		--Func_in				=> counter,
		Func_out			=> Pulse_Ram_Data_RD_internal
);




label_view_pixel : process(Reset, CLK_5Mhz)
begin
if Reset = '1' then
view_pixel <= (others=>'0');
Pulse_Ram_ADDRESS_RD_internal <= (others=>'0');
else
    if CLK_5Mhz='1' and CLK_5Mhz'event then
		if pixel = 0 then
		Pulse_Ram_ADDRESS_RD_internal <= mem_counter_address(0);
		view_pixel <= Pulse_Ram_Data_RD_internal;
		end if;
    end if;  -- clock
end if;  -- reset 
end process;

end Behavioral;
