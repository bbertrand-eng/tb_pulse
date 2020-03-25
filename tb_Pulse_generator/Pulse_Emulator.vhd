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
--signal	pixel_view			:	integer range 0 to C_pixel;

type 	t_array_Mem_counter_address is array (C_pixel-1 downto 0) of unsigned (9 downto 0);
signal	mem_counter_address	:	t_array_Mem_counter_address;

signal	counter_address		:	unsigned (9 downto 0);

type	t_array_view_pixel	is array (C_pixel-1 downto 0) of STD_LOGIC_VECTOR (31 downto 0);
signal	view_pixel			:	t_array_view_pixel;
	
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



-- label_generate : for pixel_view in 33 downto 0 generate
-- Pulse_Ram_ADDRESS_RD_internal <= mem_counter_address(pixel) when pixel = pixel_view; 
-- view_pixel(pixel) <= Pulse_Ram_Data_RD_internal when pixel = pixel_view;
-- end generate label_generate; 

label_view_pixel : process(Reset, CLK_5Mhz)
begin
if Reset = '1' then
view_pixel <=  (others=>(others=>'0'));
Pulse_Ram_ADDRESS_RD_internal <= (others=>'0'); 
else
    if CLK_5Mhz='1' and CLK_5Mhz'event then
		if pixel = 0 then
		Pulse_Ram_ADDRESS_RD_internal <= mem_counter_address(0);
		view_pixel(0) <= Pulse_Ram_Data_RD_internal;
		
		elsif pixel = 1 then
		Pulse_Ram_ADDRESS_RD_internal <= mem_counter_address(1);
		view_pixel(1) <= Pulse_Ram_Data_RD_internal;
		
		elsif pixel = 2 then
		Pulse_Ram_ADDRESS_RD_internal <= mem_counter_address(2);
		view_pixel(2) <= Pulse_Ram_Data_RD_internal;
		
		elsif pixel = 3 then
		Pulse_Ram_ADDRESS_RD_internal <= mem_counter_address(3);
		view_pixel(3) <= Pulse_Ram_Data_RD_internal;
		
		elsif pixel = 4 then
		Pulse_Ram_ADDRESS_RD_internal <= mem_counter_address(4);
		view_pixel(4) <= Pulse_Ram_Data_RD_internal;
		
		elsif pixel = 5 then
		Pulse_Ram_ADDRESS_RD_internal <= mem_counter_address(5);
		view_pixel(5) <= Pulse_Ram_Data_RD_internal;
		
		elsif pixel = 6 then
		Pulse_Ram_ADDRESS_RD_internal <= mem_counter_address(6);
		view_pixel(6) <= Pulse_Ram_Data_RD_internal;	
		
		elsif pixel = 7 then
		Pulse_Ram_ADDRESS_RD_internal <= mem_counter_address(7);
		view_pixel(7) <= Pulse_Ram_Data_RD_internal;
		
		elsif pixel = 8 then
		Pulse_Ram_ADDRESS_RD_internal <= mem_counter_address(8);
		view_pixel(8) <= Pulse_Ram_Data_RD_internal;	

		elsif pixel = 9 then
		Pulse_Ram_ADDRESS_RD_internal <= mem_counter_address(9);
		view_pixel(9) <= Pulse_Ram_Data_RD_internal;
		
		elsif pixel = 10 then
		Pulse_Ram_ADDRESS_RD_internal <= mem_counter_address(10);
		view_pixel(10) <= Pulse_Ram_Data_RD_internal;
		
		elsif pixel = 11 then
		Pulse_Ram_ADDRESS_RD_internal <= mem_counter_address(11);
		view_pixel(11) <= Pulse_Ram_Data_RD_internal;
		
		elsif pixel = 12 then
		Pulse_Ram_ADDRESS_RD_internal <= mem_counter_address(12);
		view_pixel(12) <= Pulse_Ram_Data_RD_internal;
		
		elsif pixel = 13 then
		Pulse_Ram_ADDRESS_RD_internal <= mem_counter_address(13);
		view_pixel(13) <= Pulse_Ram_Data_RD_internal;
		
		elsif pixel = 14 then
		Pulse_Ram_ADDRESS_RD_internal <= mem_counter_address(14);
		view_pixel(14) <= Pulse_Ram_Data_RD_internal;
		
		elsif pixel = 15 then
		Pulse_Ram_ADDRESS_RD_internal <= mem_counter_address(15);
		view_pixel(15) <= Pulse_Ram_Data_RD_internal;
		
		elsif pixel = 16 then
		Pulse_Ram_ADDRESS_RD_internal <= mem_counter_address(16);
		view_pixel(16) <= Pulse_Ram_Data_RD_internal;	
		
		elsif pixel = 17 then
		Pulse_Ram_ADDRESS_RD_internal <= mem_counter_address(17);
		view_pixel(17) <= Pulse_Ram_Data_RD_internal;
		
		elsif pixel = 18 then
		Pulse_Ram_ADDRESS_RD_internal <= mem_counter_address(18);
		view_pixel(18) <= Pulse_Ram_Data_RD_internal;	

		elsif pixel = 19 then
		Pulse_Ram_ADDRESS_RD_internal <= mem_counter_address(19);
		view_pixel(19) <= Pulse_Ram_Data_RD_internal;

		elsif pixel = 20 then
		Pulse_Ram_ADDRESS_RD_internal <= mem_counter_address(20);
		view_pixel(20) <= Pulse_Ram_Data_RD_internal;
		
		elsif pixel = 21 then
		Pulse_Ram_ADDRESS_RD_internal <= mem_counter_address(21);
		view_pixel(21) <= Pulse_Ram_Data_RD_internal;
		
		elsif pixel = 22 then
		Pulse_Ram_ADDRESS_RD_internal <= mem_counter_address(22);
		view_pixel(22) <= Pulse_Ram_Data_RD_internal;
		
		elsif pixel = 23 then
		Pulse_Ram_ADDRESS_RD_internal <= mem_counter_address(23);
		view_pixel(23) <= Pulse_Ram_Data_RD_internal;
		
		elsif pixel = 24 then
		Pulse_Ram_ADDRESS_RD_internal <= mem_counter_address(24);
		view_pixel(24) <= Pulse_Ram_Data_RD_internal;
		
		elsif pixel = 25 then
		Pulse_Ram_ADDRESS_RD_internal <= mem_counter_address(25);
		view_pixel(25) <= Pulse_Ram_Data_RD_internal;
		
		elsif pixel = 26 then
		Pulse_Ram_ADDRESS_RD_internal <= mem_counter_address(26);
		view_pixel(26) <= Pulse_Ram_Data_RD_internal;	
		
		elsif pixel = 27 then
		Pulse_Ram_ADDRESS_RD_internal <= mem_counter_address(27);
		view_pixel(27) <= Pulse_Ram_Data_RD_internal;
		
		elsif pixel = 28 then
		Pulse_Ram_ADDRESS_RD_internal <= mem_counter_address(28);
		view_pixel(28) <= Pulse_Ram_Data_RD_internal;	

		elsif pixel = 29 then
		Pulse_Ram_ADDRESS_RD_internal <= mem_counter_address(29);
		view_pixel(29) <= Pulse_Ram_Data_RD_internal;

		elsif pixel = 30 then
		Pulse_Ram_ADDRESS_RD_internal <= mem_counter_address(30);
		view_pixel(30) <= Pulse_Ram_Data_RD_internal;
		
		elsif pixel = 31 then
		Pulse_Ram_ADDRESS_RD_internal <= mem_counter_address(31);
		view_pixel(31) <= Pulse_Ram_Data_RD_internal;
		
		elsif pixel = 32 then
		Pulse_Ram_ADDRESS_RD_internal <= mem_counter_address(32);
		view_pixel(32) <= Pulse_Ram_Data_RD_internal;
		
		elsif pixel = 33 then
		Pulse_Ram_ADDRESS_RD_internal <= mem_counter_address(33);
		view_pixel(33) <= Pulse_Ram_Data_RD_internal;
			
		
		end if;
    end if;  -- clock
end if;  -- reset 
end process;




end Behavioral;
