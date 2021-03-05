library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.pulse_package.all;

entity FPA_sim is
	port(
		Reset                : in    std_logic;
		CLK_5Mhz             : in    std_logic;
		
		Vo					: in    t_array_Mem_Vo;	
		write_Vp             : in    std_logic;
		Vp                   : in    t_array_Mem_Vp;
		V_squid_offset		: in    t_array_Mem_Squid_offset;	
		
		-- from gse DualRam
		WE_Pulse_Ram         : in    std_logic;
		Pulse_Ram_ADDRESS_WR : in STD_LOGIC_VECTOR (9 downto 0);
		Pulse_Ram_Data_WR    : in    STD_LOGIC_VECTOR(15 downto 0);
		
		view_pixel           : out   t_array_view_pixel;
		view_pixel_index     : inout   integer range 0 to C_pixel;
		--	DualRam RD
		Pulse_Ram_ADDRESS_RD : out   STD_LOGIC_VECTOR(9 downto 0); --debug stay open
		Pulse_Ram_Data_RD    : out   STD_LOGIC_VECTOR(15 downto 0); --debug stay open
		--	DualRam WR	
		squid_Ram_ADDRESS_WR: in  STD_LOGIC_vector (11 downto 0);
		squid_Ram_Data_WR	: in  STD_LOGIC_VECTOR (15 downto 0);
		WE_squid_Ram		: in    std_logic;
		--	FMC150
		Vtes_out             : inout signed(15 downto 0);
		feedback_sq1         : in    signed(13 downto 0);
		error                : out   signed(15 downto 0)
	);
end entity FPA_sim;

architecture RTL of FPA_sim is

signal out_perfect_squid_wide_positif	:	signed(17 downto 0);
signal squid_Ram_ADDRESS_RD				:	unsigned (11 downto 0);
signal squid_Ram_Data_RD 				:	STD_LOGIC_VECTOR(15 downto 0);
signal squid_Ram_Data_RD_wide 			:	signed(16 downto 0);
signal out_squid_adder					:	signed(16 downto 0);
signal out_squid_adder_centered			:	signed(16 downto 0);


begin

	label_TES : entity work.TES
		PORT MAP(
			-- global
			Reset                => Reset,
			CLK_5Mhz             => CLK_5Mhz,
			ENABLE_CLK_1X        => '1',
			-- from gse Vp Vo 
			Vo					=>	Vo,
			Vp                   => Vp,
			write_Vp             => write_Vp,
			-- from gse DualRam
			WE_Pulse_Ram         => WE_Pulse_Ram, --: std_logic;
			Pulse_Ram_ADDRESS_WR => Pulse_Ram_ADDRESS_WR, --: unsigned (9 downto 0 );
			Pulse_Ram_ADDRESS_RD => Pulse_Ram_ADDRESS_RD, --: unsigned (9 downto 0 );
			Pulse_Ram_Data_WR    => Pulse_Ram_Data_WR, --: STD_LOGIC_vector (31 downto 0 );
			--		Sig_in				=> to_signed(32767,20),
			Pulse_Ram_Data_RD    => Pulse_Ram_Data_RD, --: STD_LOGIC_VECTOR (31 downto 0);

			view_pixel           => view_pixel,
			view_pixel_index     => view_pixel_index,
			Vtes_out             => Vtes_out
		);

		
	label_SQUID	 : entity work.SQUID
				PORT MAP(
				Reset                => Reset,
				CLK_5Mhz             => CLK_5Mhz,
				
				feedback_sq1		=>	feedback_sq1,
				Vtes_out			=>	Vtes_out,
				
				out_perfect_squid_wide_positif	=>	out_perfect_squid_wide_positif
				
				
				);
		
	label_SQUID_table	:	entity work.SQUID_table
				PORT MAP(
		--RESET
				RESET				=>	Reset,
		--CLOCK
				CLK_5Mhz			=>	CLK_5Mhz,
				--ENABLE_CLK_1X		: in  std_logic;
				WE_squid_Ram 		=>	WE_squid_Ram, --: std_logic;
				squid_Ram_ADDRESS_WR=>	squid_Ram_ADDRESS_WR,	
				squid_Ram_ADDRESS_RD=>	squid_Ram_ADDRESS_RD,
				squid_Ram_Data_WR	=>	squid_Ram_Data_WR,

				squid_Ram_Data_RD 	=>	squid_Ram_Data_RD				
				
				);

squid_Ram_Data_RD_wide	<= signed('0'&squid_Ram_Data_RD);				
squid_Ram_ADDRESS_RD	<= unsigned(out_perfect_squid_wide_positif(11 downto 0));

-------------------------------------------------------------------------------------
--	squid_offset_adder
-------------------------------------------------------------------------------------


label_squid_offset_adder : process(Reset, CLK_5Mhz)
begin
if Reset = '1' then
out_squid_adder <=	(others=>'0');
else
    if CLK_5Mhz='1' and CLK_5Mhz'event then
	
	out_squid_adder <= squid_Ram_Data_RD_wide + V_squid_offset(view_pixel_index);
	
	end if;  -- clock
end if;  -- reset 
end process;

-------------------------------------------------------------------------------------
-- center around 0
-------------------------------------------------------------------------------------

out_squid_adder_centered <= out_squid_adder-(2**16);				


end architecture RTL;