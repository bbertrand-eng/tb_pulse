library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.pulse_package.all;

entity FPA_sim_OK is
	port(
		Reset                : in    std_logic;
		CLK_5Mhz             : in    std_logic;
		CLK_100Mhz           : in    std_logic;
		--	Vp fifo pipe in
		din                  : IN    STD_LOGIC_VECTOR(31 DOWNTO 0);
		wr_en                : IN    STD_LOGIC;
		--	tempo
		WE_Pulse_Ram         : in    std_logic;
		Pulse_Ram_ADDRESS_WR : in    unsigned(9 downto 0);
		Pulse_Ram_Data_WR    : in    STD_LOGIC_VECTOR(15 downto 0);
		Vtes_out             : inout signed(15 downto 0);
		feedback_sq1         : in    signed(15 downto 0);
		error                : out   signed(15 downto 0)
	);
end entity FPA_sim_OK;

architecture RTL of FPA_sim_OK is

	signal dout  : STD_LOGIC_VECTOR(31 DOWNTO 0);
	signal full  : STD_LOGIC;
	signal empty : STD_LOGIC;
	signal valid : STD_LOGIC;

	signal rd_en : STD_LOGIC;

	type FSM_State is (read_fifo_add, valid_fifo_add, read_fifo_Vo, valid_fifo_Vo,
	                   read_fifo_Vp, valid_fifo_Vp, read_fifo_frequence, valid_fifo_frequence,
	                   format_tab, write_register
	                  );
	signal current_state        : FSM_State;
	--signal WE_Pulse_Ram : std_logic;
	--signal Pulse_Ram_ADDRESS_WR : unsigned (9 downto 0);
	signal Pulse_Ram_ADDRESS_RD : unsigned(9 downto 0);
	--signal Pulse_Ram_Data_WR : STD_LOGIC_VECTOR (15 downto 0);
	signal Pulse_Ram_Data_RD    : STD_LOGIC_VECTOR(15 downto 0);
	signal view_pixel           : t_array_view_pixel;

	signal view_pixel_index : integer range 0 to C_pixel;

	signal write_Vp         : STD_LOGIC;
	signal address          : STD_LOGIC_VECTOR(31 DOWNTO 0);
	signal Vo               : STD_LOGIC_VECTOR(31 DOWNTO 0);
	signal frequence        : STD_LOGIC_VECTOR(31 DOWNTO 0);
	signal Vp_fifo          : STD_LOGIC_VECTOR(31 DOWNTO 0);
	signal unsigned_address : unsigned(5 downto 0);
	signal int_address      : integer range 0 to C_pixel - 1;

begin

	label_fifo_r32_1024_w32_1024 : entity work.fifo_r32_1024_w32_1024
		port map(
			rst    => Reset,
			wr_clk => CLK_100Mhz,
			rd_clk => CLK_5Mhz,
			din    => din,
			wr_en  => wr_en,
			rd_en  => rd_en,
			dout   => dout,
			full   => full,
			empty  => empty,
			valid  => valid
		);

	label_case : process(CLK_5Mhz, Reset) is
	begin
		if Reset = '1' then
			rd_en         <= '0';
			Current_state <= read_fifo_add;
			write_Vp      <= '0';
			Vp            <= (others => (others => '0'));
		elsif rising_edge(CLK_5Mhz) then
			
			write_Vp <= '0';
			
			case Current_state is

				when read_fifo_add =>
					if empty = '0' then
						rd_en         <= '1';
						Current_state <= valid_fifo_add;
					end if;

				when valid_fifo_add =>
					rd_en <= '0';
					if valid = '1' then
						address       <= dout;
						Current_state <= read_fifo_Vo;
					end if;

				when read_fifo_Vo =>

					--unsigned_address <= unsigned(address(5 downto 0));
					rd_en         <= '1';
					Current_state <= valid_fifo_Vo;

				when valid_fifo_Vo =>

					--int_address <= To_integer(unsigned_address);
					rd_en <= '0';
					if valid = '1' then
						Vo            <= dout;
						Current_state <= read_fifo_Vp;
					end if;

				when read_fifo_Vp =>

					rd_en         <= '1';
					Current_state <= valid_fifo_Vp;

				when valid_fifo_Vp =>

					rd_en <= '0';
					if valid = '1' then
						Vp_fifo       <= dout;
						Current_state <= read_fifo_frequence;
					end if;

				when read_fifo_frequence =>

					rd_en         <= '1';
					Current_state <= valid_fifo_frequence;

				when valid_fifo_frequence =>

					rd_en <= '0';
					if valid = '1' then
						frequence     <= dout;
						Current_state <= format_tab;
					end if;

				when format_tab =>

					Vp(To_integer(unsigned(address(5 downto 0)))) <= Vp_fifo;
					Current_state <= read_fifo_add;
					
						if empty = '1' then
						Current_state <= write_register;
						end if;

				when write_register =>
					
					write_Vp      <= '1';
					Current_state <= read_fifo_add;

				when others =>

			end case;

		end if;
	end process label_case;

	label_FPA_sim : entity work.FPA_sim
		port map(
			Reset                => Reset,
			CLK_5Mhz             => CLK_5Mhz,
			write_Vp             => write_Vp,
			Vp                   => Vp,
			WE_Pulse_Ram         => WE_Pulse_Ram,
			Pulse_Ram_ADDRESS_WR => Pulse_Ram_ADDRESS_WR,
			Pulse_Ram_Data_WR    => Pulse_Ram_Data_WR,
			view_pixel           => view_pixel,
			view_pixel_index     => view_pixel_index,
			--			Pulse_Ram_ADDRESS_RD => Pulse_Ram_ADDRESS_RD,
			--			Pulse_Ram_Data_RD    => Pulse_Ram_Data_RD,
			Vtes_out             => Vtes_out,
			feedback_sq1         => feedback_sq1,
			error                => error
		);

end architecture RTL;
