

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
			
-- from gse Vp Vo 
		
			Vp		:	in	 t_array_Mem_Vp; 
			write_Vp: in  STD_LOGIC;
			
--CONTROL

			--Send_Pulse 			: in  STD_LOGIC;
			WE_Pulse_Ram 		: in std_logic;
			Pulse_Ram_ADDRESS_WR	: in unsigned (9 downto 0);
			Pulse_Ram_ADDRESS_RD: in unsigned (9 downto 0);
			Pulse_Ram_Data_WR		: in STD_LOGIC_VECTOR (15 downto 0);
--			Sig_in 				: in  signed (C_Size_DDS-1 downto 0);
        	Pulse_Ram_Data_RD 	: out STD_LOGIC_VECTOR (15 downto 0);
			
			view_pixel			:	out	t_array_view_pixel;
			view_pixel_index	:	out	integer range 0 to C_pixel;
			
			Vtes_out			:	out	signed(15 downto 0)
			
        );
end TES;

--! @brief-- BLock diagrams schematics -- 
--! @detail file:work.Pulse_Emulator.Behavioral.svg
architecture Behavioral of TES is

signal	CLK_73529Hz			: std_logic;
signal 	pixel				:	integer range 0 to C_pixel;
signal	pixel_delayed_1		:	integer range 0 to C_pixel;
signal	pixel_delayed_2		:	integer range 0 to C_pixel;
signal	pixel_delayed_3		:	integer range 0 to C_pixel;
signal	pixel_delayed_4		:	integer range 0 to C_pixel;

--signal	pixel_view			:	integer range 0 to C_pixel;

signal	counter_address		:	unsigned (9 downto 0);

-- constant C_MaxCount				:	positive := ((2**C_PluseLUT_Size_in)-1);

signal Pulse_Ram_ADDRESS_RD_internal : unsigned (9 downto 0);
signal Pulse_Ram_Data_RD_internal	: STD_LOGIC_VECTOR (15 downto 0);

type 	t_state is(idle,pulse);
signal 	state : t_state;

type 	t_array_start_pulse_pixel is array (C_pixel-1 downto 0) of std_logic;
signal	start_pulse_pixel	: t_array_start_pulse_pixel;
signal	detect_start_pulse_pixel	: t_array_start_pulse_pixel;
signal	start_pulse_pixel_shifted	: t_array_start_pulse_pixel;
signal	stop_pulse_pixel	: t_array_start_pulse_pixel;

signal	Mem_Vp	:	t_array_Mem_Vp;

signal	mem_counter_address	:	t_array_Mem_counter_address;

signal	unsigned_Pulse_Ram_Data_RD_internal :	unsigned(15 downto 0);
signal	unsigned_Mem_Vp						:	unsigned(15 downto 0);
signal	unsigned_multiply_to_pulse			:	unsigned(31 downto 0); 
signal	unsigned_L_multiply_to_pulse		:	unsigned(15 downto 0); 
signal	signed_L_multiply_to_pulse			:	signed(15 downto 0);
signal	Vtes								:	signed(15 downto 0);

constant Vo									: 	signed(15 downto 0)	:=	x"Ffff";	

signal	view_start_pulse_pixel				:	std_logic;

BEGIN

-------------------------------------------------------------------------------------
--	Master pixel increment
-------------------------------------------------------------------------------------


label_pixel : process(Reset, CLK_5Mhz)
begin
if Reset = '1' then
pixel			<= 0;
pixel_delayed_1	<= 0;
pixel_delayed_2	<= 0;
pixel_delayed_3	<= 0;
pixel_delayed_4	<= 0;
view_pixel_index <= 0;
CLK_73529Hz	<= '0';
else
    if CLK_5Mhz='1' and CLK_5Mhz'event then
	pixel <= pixel + 1;
	pixel_delayed_1 <= pixel;
	pixel_delayed_2 <= pixel_delayed_1; 
	pixel_delayed_3	<= pixel_delayed_2; 
	pixel_delayed_4	<= pixel_delayed_3;
	view_pixel_index	<=	pixel_delayed_4;
		if pixel = C_pixel-1 then
		pixel	<= 0;
		CLK_73529Hz <= not CLK_73529Hz;
		end if;
    end if;  -- clock
end if;  -- reset 
end process;



-------------------------------------------------------------------------------------
--	control and increment counter address pixel by start(pixel) read
-------------------------------------------------------------------------------------

label_mem_counter_address : process(Reset, CLK_5Mhz)
begin
if Reset = '1' then
mem_counter_address <= (others=>(others=>'0'));
else
    if CLK_5Mhz='1' and CLK_5Mhz'event then
		if	start_pulse_pixel(pixel) = '1' and stop_pulse_pixel(pixel) = '0' then
		mem_counter_address(pixel) <= mem_counter_address(pixel)+1;
		end if;
	end if;  -- clock
end if;  -- reset 
end process;

-------------------------------------------------------------------------------------
--	read counter(pixel) generate stop(pixel)  
-------------------------------------------------------------------------------------

label_generate_stop_pixel : process(Reset, CLK_5Mhz)
begin
if Reset = '1' then
stop_pulse_pixel	<= (others=>'0');
else
    if CLK_5Mhz='1' and CLK_5Mhz'event then
	stop_pulse_pixel(pixel) <= '0';
		if mem_counter_address(pixel) = 1023 then
		stop_pulse_pixel(pixel) <= '1';
		end if;
	end if;  -- clock
end if;  -- reset 
end process;


-------------------------------------------------------------------------------------
--	control Vp state and remote start pulse pixel
-------------------------------------------------------------------------------------

-- label_generate : for i in 33 downto 0 generate

-- detect_start_pulse_pixel(i) <= '1' when Mem_Vp(i)(15 downto 0) /= b"0000000000000000" else '0';	--option (2)
-- end generate label_generate; 

label_generate : for i in 33 downto 0 generate
	process(Reset, CLK_5Mhz)
	begin
	if Reset = '1' then
	detect_start_pulse_pixel(i) <= '0';
	else
		if CLK_5Mhz='1' and CLK_5Mhz'event then
			if	Mem_Vp(i)(15 downto 0) /= b"0000000000000000" then	
			detect_start_pulse_pixel(i) <= '1';
			else
			detect_start_pulse_pixel(i) <= '0';
			end if;
		end if;  -- clock
	end if;  -- reset 
	end process;
end generate label_generate; 



-------------------------------------------------------------------------------------
--	Vp
-------------------------------------------------------------------------------------

-- label_generate_vp : for i in 33 downto 0 generate	--	Write_Vp common all pixel
-- Mem_Vp(i)	<= Vp(i) when stop_pulse_pixel(i) = '0' and write_Vp='1' and start_pulse_pixel_shifted(i)='0' else 
-- (others=>'0') when stop_pulse_pixel(i) = '1';
-- end generate label_generate_vp; 

label_generate_vp : for i in 33 downto 0 generate
	process(Reset, CLK_5Mhz)
	begin
	if Reset = '1' then
	Mem_Vp(i) <= (others=>'0');
	else
		if CLK_5Mhz='1' and CLK_5Mhz'event then
			if	stop_pulse_pixel(i) = '0' and write_Vp='1' and start_pulse_pixel(i) = '0' and detect_start_pulse_pixel(i) = '0' and start_pulse_pixel_shifted(i)='0' then 
			Mem_Vp(i)	<= Vp(i);
			else
				if	stop_pulse_pixel(i) = '1' then
				Mem_Vp(i) <= (others=>'0');
				end if;
			end if;		
		end if;  -- clock
	end if;  -- reset 
	end process;
end generate label_generate_vp; 

-------------------------------------------------------------------------------------
--	start_pulse_pixel
-------------------------------------------------------------------------------------

label_start_pulse_pixel : process(Reset, CLK_5Mhz)
begin
if Reset = '1' then
start_pulse_pixel <= (others=>'0');
else
    if CLK_5Mhz='1' and CLK_5Mhz'event then
		if	pixel = 33 then
		start_pulse_pixel	<= detect_start_pulse_pixel;--option (2)
		end if;
    end if;  -- clock
end if;  -- reset 
end process;

-------------------------------------------------------------------------------------
--	
-------------------------------------------------------------------------------------

label_shift_start : process(Reset, CLK_5Mhz)
begin
if Reset = '1' then
start_pulse_pixel_shifted	<=	(others=>'0'); 
else
    if CLK_5Mhz='1' and CLK_5Mhz'event then
	start_pulse_pixel_shifted	<=	start_pulse_pixel;
	end if;  -- clock
end if;  -- reset 
end process;

-------------------------------------------------------------------------------------
--	read counter(pixel) to address dual RAM
-------------------------------------------------------------------------------------
label_mem_Cnt_Add_to_Add_RAM : entity work.mem_Cnt_Add_to_Add_RAM
	Port map( 
--RESET
		Reset		 		=>	Reset,
--CLOCKs
    	CLK_5Mhz			=>	CLK_5Mhz,
			--ENABLE_CLK_1X		: 	in  STD_LOGIC;
--CONTROL
		pixel				=>	pixel_delayed_2,
	
		mem_counter_address	=>	mem_counter_address,	
		Pulse_Ram_ADDRESS_RD_internal		=>	Pulse_Ram_ADDRESS_RD_internal	
			
	);


-------------------------------------------------------------------------------------
--	DUAL RAM
-------------------------------------------------------------------------------------

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

-------------------------------------------------------------------------------------
--	computing
-------------------------------------------------------------------------------------
--	multiply
unsigned_Pulse_Ram_Data_RD_internal <= unsigned(Pulse_Ram_Data_RD_internal);
unsigned_Mem_Vp	<=	unsigned(Mem_Vp(pixel_delayed_4)(15 downto 0));
unsigned_multiply_to_pulse <= unsigned_Pulse_Ram_Data_RD_internal*unsigned_Mem_Vp;--unsigned(15 downto 0);*unsigned(15 downto 0);
--unsigned_L_multiply_to_pulse 	<= unsigned_multiply_to_pulse(47 downto 32);
signed_L_multiply_to_pulse		<= signed(unsigned_multiply_to_pulse(31 downto 16));--unsigned(31 downto 0); 
Vtes	<=	Vo	-	signed_L_multiply_to_pulse;	--signed(15 downto 0)	:=	x"fff0" - signed(15 downto 0);	

--Vtes	<=	unsigned_L_multiply_to_pulse	

label_out_TES : process(Reset, CLK_5Mhz)
begin
if Reset = '1' then
Vtes_out	<= (others=>'0');
else
    if CLK_5Mhz='1' and CLK_5Mhz'event then
	Vtes_out <= Vtes;
	end if;  -- clock
end if;  -- reset 
end process;





-------------------------------------------------------------------------------------
--	demux
-------------------------------------------------------------------------------------

label_demux_pixel_fpa : entity work.demux_pixel_fpa
	Port map( 
--RESET
		Reset		 		=>	Reset,
--CLOCKs
    	CLK_5Mhz			=>	CLK_5Mhz,
			--ENABLE_CLK_1X		: 	in  STD_LOGIC;
--CONTROL
		pixel				=>	pixel_delayed_4,
	
			
		Pulse_Ram_Data_RD_internal		=>	Vtes,

		view_pixel	=>	view_pixel				
			
	);


-- label_generate : for pixel_view in 33 downto 0 generate
-- Pulse_Ram_ADDRESS_RD_internal <= mem_counter_address(pixel) when pixel = pixel_view; 
-- view_pixel(pixel) <= Pulse_Ram_Data_RD_internal when pixel = pixel_view;
-- end generate label_generate; 




-- view_start_pulse_pixel <= start_pulse_pixel(0)or start_pulse_pixel(1) or start_pulse_pixel(2) or start_pulse_pixel(3)or start_pulse_pixel(4) or 
-- start_pulse_pixel(5)or start_pulse_pixel(6) or start_pulse_pixel(7) or start_pulse_pixel(8)or start_pulse_pixel(9) or
-- start_pulse_pixel(10)or start_pulse_pixel(11) or start_pulse_pixel(12) or start_pulse_pixel(13)or start_pulse_pixel(14) or
-- start_pulse_pixel(15)or start_pulse_pixel(16) or start_pulse_pixel(17) or start_pulse_pixel(18)or start_pulse_pixel(19) or
-- start_pulse_pixel(20)or start_pulse_pixel(21) or start_pulse_pixel(22) or start_pulse_pixel(23)or start_pulse_pixel(24) or 
-- start_pulse_pixel(25)or start_pulse_pixel(26) or start_pulse_pixel(27) or start_pulse_pixel(28)or start_pulse_pixel(29) or
-- start_pulse_pixel(30)or start_pulse_pixel(31) or start_pulse_pixel(32) or start_pulse_pixel(33)or start_pulse_pixel(34);



end Behavioral;
