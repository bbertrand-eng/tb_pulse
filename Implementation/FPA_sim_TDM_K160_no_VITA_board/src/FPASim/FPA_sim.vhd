library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.pulse_package.all;

entity FPA_sim is
	port(
		Reset                : in    std_logic;
		CLK_5Mhz             : in    std_logic;
		slow_clk			: in    std_logic;
		
		Vo					: in    t_array_Mem_Vo;	
		write_Vp             : in    std_logic;
		Vp                   : in    t_array_Mem_Vp;
		WE_Pulse_Ram         : in    std_logic;
		Pulse_Ram_ADDRESS_WR : in 	unsigned (9 downto 0);
		Pulse_Ram_Data_WR    : in    STD_LOGIC_VECTOR(15 downto 0);
		view_pixel           : out   t_array_view_pixel;
		view_pixel_index     : out   integer range 0 to C_pixel;
		Pulse_Ram_ADDRESS_RD : out   unsigned(9 downto 0); --debug stay open
		Pulse_Ram_Data_RD    : out   STD_LOGIC_VECTOR(15 downto 0); --debug stay open

		Vtes_out             : inout signed(15 downto 0);
		feedback_sq1         : in    signed(15 downto 0);
		error                : out   signed(15 downto 0)
	);
end entity FPA_sim;

architecture RTL of FPA_sim is

begin

	label_TES : entity work.TES
		PORT MAP(
			-- global
			Reset                => Reset,
			CLK_5Mhz             => CLK_5Mhz,
			slow_clk			=> slow_clk,
			
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

error	<=	Vtes_out - feedback_sq1;

end architecture RTL;