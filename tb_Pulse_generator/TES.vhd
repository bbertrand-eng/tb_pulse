

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

entity TES is
    Port (
--RESET
			Reset		 		: in  STD_LOGIC;
--CLOCKs
    		CLK_5Mhz			: in  STD_LOGIC;
			ENABLE_CLK_1X		: in  STD_LOGIC;
--CONTROL

			--Send_Pulse 			: in  STD_LOGIC;
			WE_Pulse_Ram 		: in std_logic;
			Pulse_Ram_ADDRESS_WR	: in unsigned (9 downto 0);
			Pulse_Ram_ADDRESS_RD: in unsigned (9 downto 0);
			Pulse_Ram_Data_WR		: in STD_LOGIC_VECTOR (31 downto 0);
--			Sig_in 				: in  signed (C_Size_DDS-1 downto 0);
        	Pulse_Ram_Data_RD 	: out STD_LOGIC_VECTOR (31 downto 0)
        );
end TES;

--! @brief-- BLock diagrams schematics -- 
--! @detail file:work.Pulse_Emulator.Behavioral.svg
architecture Behavioral of TES is

signal	CLK_73529Hz			: std_logic;
signal 	pixel				:	integer range 0 to C_pixel;
--signal	pixel_view			:	integer range 0 to C_pixel;



signal	counter_address		:	unsigned (9 downto 0);


	
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

	Port map( 
		RESET				=> Reset,
		CLK_5Mhz			=> CLK_5Mhz,
		ENABLE_CLK_1X		=> ENABLE_CLK_1X,
		WE_Pulse_Ram 		=> WE_Pulse_Ram ,
		Pulse_Ram_ADDRESS_WR=> Pulse_Ram_ADDRESS_WR,
		Pulse_Ram_ADDRESS_RD=> Pulse_Ram_ADDRESS_RD_internal,	
		Pulse_Ram_Data_WR	=> Pulse_Ram_Data_WR,
		--Func_in				=> counter,
		Pulse_Ram_Data_RD	=> Pulse_Ram_Data_RD_internal
);

label_demux_pixel_fpa : entity work.demux_pixel_fpa
	Port map( 
--RESET
		Reset		 		=>	Reset,
--CLOCKs
    	CLK_5Mhz			=>	CLK_5Mhz,
			--ENABLE_CLK_1X		: 	in  STD_LOGIC;
--CONTROL
		pixel				=>	pixel,
		mem_counter_address	=>	mem_counter_address,	
			
		Pulse_Ram_Data_RD_internal		=>	Pulse_Ram_Data_RD_internal,	
		Pulse_Ram_ADDRESS_RD_internal	=>	Pulse_Ram_ADDRESS_RD_internal	
	);


-- label_generate : for pixel_view in 33 downto 0 generate
-- Pulse_Ram_ADDRESS_RD_internal <= mem_counter_address(pixel) when pixel = pixel_view; 
-- view_pixel(pixel) <= Pulse_Ram_Data_RD_internal when pixel = pixel_view;
-- end generate label_generate; 






end Behavioral;
