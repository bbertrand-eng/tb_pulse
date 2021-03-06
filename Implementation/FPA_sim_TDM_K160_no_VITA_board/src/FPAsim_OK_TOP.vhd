----------------------------------------------------------------------------------
-- Company  : IRAP CNRS 
-- Engineer : Bernard Bertrand
-- 
-- Create Date:    09:16:51 05/22/2015 
-- Design Name:    Ramtester
-- Module Name:    Ramtest - RTL 
-- Project Name:	 ATHENA XIFU
-- Target Devices: xc7k160t
-- Tool versions:  ISE 14.7
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
---------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.FRONTPANEL.all;

--use work.FPAsim_OK_TOP_pack.all;
--use work.athena_package.all;
use work.pulse_package.all;



library STD;
use std.textio.all;


entity FPAsim_OK_TOP is
		port(
		
		
		--reset		: in	STD_LOGIC;	--	only simulation
				
		sys_clkp	: in	STD_LOGIC;								-- input	  wire         sys_clkp,
		sys_clkn	: in 	STD_LOGIC;								-- input  wire         sys_clkn,
		
		okUH      : in     STD_LOGIC_VECTOR(4 downto 0);
		okHU      : out    STD_LOGIC_VECTOR(2 downto 0);
		okUHU     : inout  STD_LOGIC_VECTOR(31 downto 0);
		okAA      : inout  STD_LOGIC;
		
		led       : out    STD_LOGIC_VECTOR(3 downto 0)
       			
		);
end FPAsim_OK_TOP;

architecture RTL of FPAsim_OK_TOP is

signal reset			: std_logic;

-- signal CONTROL0 		: std_logic_vector(35 downto 0);
-- signal CONTROL1 		: std_logic_vector(35 downto 0);
-- signal CONTROL2 		: std_logic_vector(35 downto 0);
-- signal CONTROL3			: std_logic_vector(35 downto 0);
-- signal CONTROL4			: std_logic_vector(35 downto 0);
-- signal CONTROL5			: std_logic_vector(35 downto 0);
-- signal SYNC_OUT		: std_logic_vector(31 downto 0);
-- signal SYNC_OUT_2	: std_logic_vector(31 downto 0);
-- signal TRIG0			: std_logic_vector(32 downto 0);
-- signal TRIG1			: std_logic_vector(31 downto 0);
-- signal TRIG2			: std_logic_vector(31 downto 0);
-- signal TRIG3			: std_logic_vector(31 downto 0);

signal CLK_5Mhz			: std_logic;
signal clk_61_44MHz		: std_logic;
signal CLK_OUT2			: std_logic;	
signal GLOBAL_CLK		: std_logic;
-- signal CLUSTER_CLK		: t_CLUSTER_CLK;
-- signal Sequencer		: unsigned(1 downto 0);			

-- signal	START_STOP		: std_logic;

--signal count_slow_clk			: integer range 0 to 3;


--	okHost
signal okClk			: STD_LOGIC;
signal okHE				: STD_LOGIC_VECTOR(112 downto 0);
signal okEH				: STD_LOGIC_VECTOR(64 downto 0);

--	okWireOR
signal okEHx			: std_logic_vector(65*9-1 downto 0); 

--	okPipeIn_fifo
signal	ep_dataout		: STD_LOGIC_VECTOR(31 downto 0);
signal 	ep_write		: STD_LOGIC;

--	okPipeIn_fifo
signal	ep_dataout_Vp	: STD_LOGIC_VECTOR(31 downto 0);
signal 	ep_write_Vp		: STD_LOGIC;

--	okPipeIn_fifo
signal	ep_dataout_squid	: STD_LOGIC_VECTOR(31 downto 0);
signal 	ep_write_squid		: STD_LOGIC;

--	okPipeIn_fifo
signal	ep_dataout_no_linearity		: STD_LOGIC_VECTOR(31 downto 0);
signal 	ep_write_no_linearity		: STD_LOGIC;


signal 	rd_en	: STD_LOGIC;
signal 	dout	: STD_LOGIC_VECTOR(31 downto 0);
signal 	valid	: STD_LOGIC;
signal 	empty	: STD_LOGIC;
signal 	full	: STD_LOGIC;

	type FSM_State_vp is (read_fifo_add, valid_fifo_add, write_ram, increase_add_wr
	                  );
	signal current_state_vp        : FSM_State_vp;
	
	type FSM_State_squid is (read_fifo_add, valid_fifo_add, write_ram, increase_add_wr
	                  );	
	signal Current_state_squid		: FSM_State_squid;	
	



signal 	rd_en_Vp	: STD_LOGIC;
signal 	dout_vp		: STD_LOGIC_VECTOR(31 downto 0);
signal	dout_Vp_valid: STD_LOGIC_VECTOR(31 downto 0);
signal 	valid_vp	: STD_LOGIC;
signal 	empty_vp	: STD_LOGIC;
signal 	full_vp		: STD_LOGIC;

signal 	rd_en_squid			: STD_LOGIC;
signal 	dout_squid_valid	: STD_LOGIC_VECTOR(31 downto 0);
signal	dout_squid			: STD_LOGIC_VECTOR(31 downto 0);
signal 	valid_squid			: STD_LOGIC;
signal 	empty_squid			: STD_LOGIC;
signal 	full_squid			: STD_LOGIC;
signal	no_linarity_enable	: STD_LOGIC;




	type FSM_State is (read_fifo, valid_fifo, config_Vo, config_Vp, config_fequency, config_squid_offset

	                  );
	signal current_state        : FSM_State;

signal squid_Ram_ADDRESS_WR	:	unsigned (11 downto 0);
signal squid_Ram_Data_WR	: 	STD_LOGIC_VECTOR (15 downto 0);
signal WE_squid_Ram			: 	std_logic;	
signal V_squid_offset		:	t_array_Mem_Squid_offset;		
	
	
--signal	write_Vp        		: STD_LOGIC;	
signal	write_Vp_wire			: STD_LOGIC;	
signal	write_Vp_detect			: STD_LOGIC;
signal	write_Vp_detect_old		: STD_LOGIC;
signal 	Vo	:	t_array_Mem_Vo;
signal 	Vp	:	t_array_Mem_Vp;	

signal address          : STD_LOGIC_VECTOR(31 DOWNTO 0);
signal Vo_fifo          : STD_LOGIC_VECTOR(31 DOWNTO 0);
signal frequence        : STD_LOGIC_VECTOR(31 DOWNTO 0);
signal Vp_fifo          : STD_LOGIC_VECTOR(31 DOWNTO 0);
signal unsigned_address : unsigned(5 downto 0);
signal int_address      : integer range 0 to C_pixel - 1;



signal	WE_Pulse_Ram         :	std_logic;
signal	Pulse_Ram_ADDRESS_WR :	unsigned(9 downto 0);
signal	Pulse_Ram_Data_WR    :	STD_LOGIC_VECTOR(15 downto 0);

signal view_pixel           : t_array_view_pixel;
signal view_pixel_index : integer range 0 to C_pixel;


signal Vtes_out             :	signed(15 downto 0);
signal feedback_sq1         :	signed(13 downto 0);
signal error                :	signed(15 downto 0);

signal ep00wire			: STD_LOGIC_VECTOR(31 downto 0);

--	led	
	
signal count					: integer range 0 to 10000002;			
signal led_temp					: STD_LOGIC_VECTOR(3 downto 0);

-- slow clk

-- signal count_slow_clk			: integer range 0 to 401;
-- signal slow_clk	 				: STD_LOGIC;

signal CONTROL0 		: std_logic_vector(35 downto 0);
signal DATA_0	  		: std_logic_vector(138 downto 0);

signal CONTROL1 		: std_logic_vector(35 downto 0);
signal DATA_1	  		: std_logic_vector(54 downto 0);


--signal CLUSTER_CLK		: t_CLUSTER_CLK;
signal Sequencer		: unsigned(1 downto 0);			

signal SYNC_OUT			:	std_logic_vector(31 downto 0);

signal pixel			:	integer range 0 to 255;

signal Pulse_Ram_Data_RD		:	STD_LOGIC_VECTOR(15 downto 0); --debug stay open		
signal out_squid_adder_centered	:	signed(16 downto 0);

begin


----------------------------------------------------
--	xilinx clock manager
----------------------------------------------------

MaterCLK : entity work.CLK_MNGR_FPA PORT MAP(
  CLK_IN1_P			=> sys_clkp,
  CLK_IN1_N			=> sys_clkn,
  CLK_OUT1			=> GLOBAL_CLK,
  CLK_OUT2			=> clk_61_44MHz,
  CLK_OUT3			=> CLK_5Mhz,
  RESET				=> reset,
  LOCKED			=> open	
); 

-- ----------------------------------------------------
-- --	clock manager CNES compliance
-- ----------------------------------------------------

-- label_CMM : entity work.CMM 
-- PORT MAP(
		-- GLOBAL_CLK 				=>	CLK_20Mhz,		--	20 MHz
        -- RESET 					=>	reset,			--	reset from wire GSE
		
		-- CLUSTER_CLK				=>	CLUSTER_CLK,
		-- Sequencer				=>	Sequencer	
-- );

-- ----------------------------------------------------
-- --	slow clk
-- ----------------------------------------------------

-- process(reset, CLUSTER_CLK.CLK_4X)	
-- begin
-- if reset = '1' then
-- slow_clk 		<= '0';
-- count_slow_clk	<= 0;
-- else 
	-- if (rising_edge(CLUSTER_CLK.CLK_4X)) then	--	20 MHz
	-- count_slow_clk <= count_slow_clk + 1;
		-- if count_slow_clk >= 3 then
		-- slow_clk <= not slow_clk;	
		-- count_slow_clk	<= 0;
		-- end if;
	-- end if;	
-- end if;
-- end process; 	

----------------------------------------------------
--	LED
----------------------------------------------------   
 
led(3 downto 0) <= led_temp;

--led(3) <= clk;
--clk <= sys_clk;
process (GLOBAL_CLK, reset) begin
if reset = '1' then
count <= 0;
led_temp <= (others => '1');
else
	if rising_edge(GLOBAL_CLK) then 
	count <= count + 1;
		if count >= 10000000 then
		led_temp(0) <= not led_temp(0);
		led_temp(1) <= not led_temp(1);
		led_temp(2) <= not led_temp(2);
		led_temp(3) <= not led_temp(3);
		count <= 0;
		end if;
	end if;
end if;
end process;
 
----------------------------------------------------
--	RESET
----------------------------------------------------  
 
reset <= ep00wire(1) or SYNC_OUT(0);    --or SYNC_OUT_fast(0);  
	
-- ----------------------------------------------------
-- --	uncomment for simulation
-- ----------------------------------------------------
-- --pragma synthesis_off 
-- SYNC_OUT(31) <=  '0';
-- SYNC_OUT(1) <=  '1';
-- SYNC_OUT(0) <=  '0';
-- --pragma synthesis_on

-- ----------------------------------------------------------- 	 
	 
----------------------------------------------------
--	ok wire host
----------------------------------------------------

label_okHost : okHost	
port map(

	okUH	=>	okUH,
	okHU	=>	okHU,
	okUHU	=>	okUHU,
	okAA	=>	okAA,	--//temp removed for SIMULATION replace Core
	okClk	=>	okClk,	--out
	okHE	=>	okHE, 
	okEH	=>	okEH

); 
 
 
----------------------------------------------------
--	ok wire OR
----------------------------------------------------

label_okWireOR : okWireOR     generic map ( N => 9 ) 
port map (
	okEH	=>	okEH, 
	okEHx	=>	okEHx
);

----------------------------------------------------
--	ok wire in
----------------------------------------------------

label_okWireIn : okWireIn    
port map (
	okHE		=>	okHE,                                     
	ep_addr		=>	x"00", 
	ep_dataout	=>	ep00wire
);
	
----------------------------------------------------
--	manage write all register
----------------------------------------------------

	label_write_all : process(CLK_5Mhz, Reset) is
	begin
		if Reset = '1' then
		
		write_Vp_wire		<= '0';
		write_Vp_detect	<=	'0';
		write_Vp_detect_old	<=	'0';
		
		elsif rising_edge(CLK_5Mhz) then
		
		
		write_Vp_detect <=	ep00wire(2);
		write_Vp_detect_old <= write_Vp_detect; 
		
			if write_Vp_detect_old = '0' and write_Vp_detect = '1' then
			write_Vp_wire		<= '1';
			else
			write_Vp_wire		<= '0';
			end if;
		
		end if;
	end process label_write_all;
		
----------------------------------------------------
--	ok pipe in configure
----------------------------------------------------
	
label_okPipeIn_conf : okPipeIn --okBTPipeIn  
port map (
	okHE	=>	okHE, 
	okEH	=>	okEHx( 1*65-1 downto 0*65 ),  
	ep_addr	=>	x"80", 
    ep_write=>	ep_write, 
	ep_dataout		=>	ep_dataout
	);	

----------------------------------------------------
--	fifo pipe in configure
----------------------------------------------------	
	
okPipeIn_FIFO_conf	:	entity work.fifo_w32_1024_r32_1024 
port map (
	rst		=>	reset,
	wr_clk	=>	okClk,
	rd_clk	=>	CLK_5Mhz,	--	normal clock 20MHz 
	din		=>	ep_dataout, --// Bus [31 : 0] 
	wr_en	=>	ep_write,
	rd_en	=>	rd_en,
	dout	=>	dout, --// Bus [31 : 0] 
	full	=>	full,
	empty	=>	empty,
	valid	=>	valid

	); 	

----------------------------------------------------
--	FSM configure Vp and V0 and squid offset
----------------------------------------------------		
	
	label_case_configure : process(CLK_5Mhz, Reset) is
	begin
		if Reset = '1' then
			rd_en         <= '0';
			Current_state <= read_fifo;
			--write_Vp      <= '0';
			Vp            <= (others => (others => '0'));
			Vo			 <= (others => (others => '0'));
			address			<=(others => '0'); 
			Vo_fifo			<=(others => '0');
			Vp_fifo			<=(others => '0');
			frequence		<=(others => '0');
			V_squid_offset	<= (others=> (others=>'0'));
			
		elsif rising_edge(CLK_5Mhz) then
			
			--write_Vp <= '0';
			
			case Current_state is

				when read_fifo =>
				
					if empty = '0' then
						rd_en         <= '1';
						Current_state <= valid_fifo;
					end if;

				when valid_fifo =>
				
					rd_en <= '0';
					
					if valid = '1' then
						---address       <= dout;
						if unsigned(dout(31 downto 24))	=	0	then	--set V0
						Current_state <= config_Vo;
						pixel	<=	To_integer(unsigned(dout(23 downto 16)));
						else
							if unsigned(dout(31 downto 24))	=	1	then	--set Vp
							Current_state <= config_Vp;
							pixel	<=	To_integer(unsigned(dout(23 downto 16)));
							else
								if unsigned(dout(31 downto 24))	=	2	then	--set frequency
								Current_state <= config_fequency;
								pixel	<=	To_integer(unsigned(dout(23 downto 16)));
								else
									if unsigned(dout(31 downto 24))	=	3	then	--set squid offset
									Current_state <= config_squid_offset;
									pixel	<=	To_integer(unsigned(dout(23 downto 16)));
									else
									Current_state <= read_fifo;									
									end if;
								end if;
							end if;			
						end if;				
						--Current_state <= read_fifo_Vo;
					end if;
				
				when config_Vo =>
					
				Vo(pixel) <= x"0000"&dout(15 downto 0);	
				Current_state <= read_fifo;
					
				when config_Vp =>
				
				Vp(pixel) <= x"0000"&dout(15 downto 0);
				Current_state <= read_fifo;				
				
				when config_fequency =>
				
				Current_state <= read_fifo;
				
				when config_squid_offset =>
				
				V_squid_offset(pixel)	<=	signed(dout(15 downto 0));
				Current_state <= read_fifo;
				
				-- when read_fifo_Vo =>

					-- --unsigned_address <= unsigned(address(5 downto 0));
					-- rd_en         <= '1';
					-- Current_state <= valid_fifo_Vo;

				-- when valid_fifo_Vo =>

					-- --int_address <= To_integer(unsigned_address);
					-- rd_en <= '0';
					-- if valid = '1' then
						-- Vo_fifo       <= dout;
						-- Current_state <= read_fifo_Vp;
					-- end if;

				-- when read_fifo_Vp =>

					-- rd_en         <= '1';
					-- Current_state <= valid_fifo_Vp;

				-- when valid_fifo_Vp =>

					-- rd_en <= '0';
					-- if valid = '1' then
						-- Vp_fifo       <= dout;
						-- Current_state <= read_fifo_frequence;
					-- end if;

				-- when read_fifo_frequence =>

					-- rd_en         <= '1';
					-- Current_state <= valid_fifo_frequence;

				-- when valid_fifo_frequence =>

					-- rd_en <= '0';
					-- if valid = '1' then
						-- frequence     <= dout;
						-- Current_state <= format_tab;
					-- end if;

				-- when format_tab =>
				
					-- Vo(To_integer(unsigned(address(5 downto 0)))) <= Vo_fifo;	 		
					-- Vp(To_integer(unsigned(address(5 downto 0)))) <= Vp_fifo;
					
					-- Current_state <= read_fifo_add;
					
						-- -- if empty = '1' then
						-- -- Current_state <= write_register;
						-- -- end if;

				-- -- when write_register =>
					
					-- -- write_Vp      <= '1';
					-- -- Current_state <= read_fifo_add;

				when others =>

			end case;

		end if;
	end process label_case_configure;

----------------------------------------------------
--	FPA_sim
----------------------------------------------------		
	
	label_FPA_sim : entity work.FPA_sim
		port map(
			Reset               => Reset,	
			CLK_5Mhz			=>	CLK_5Mhz,			--	20 MHz
			
			--ENABLE_CLK_1X		=>	CLUSTER_CLK.ENABLE_CLK_1X,	--	enable on 5 	
			
			Vo					=>	Vo,
			write_Vp            => 	write_Vp_wire,
			Vp                  => 	Vp,
			V_squid_offset		=> 	V_squid_offset,
			
			WE_Pulse_Ram         => WE_Pulse_Ram,
			Pulse_Ram_ADDRESS_WR => Pulse_Ram_ADDRESS_WR,
			Pulse_Ram_Data_WR    => Pulse_Ram_Data_WR,
			
			view_pixel           => view_pixel,
			view_pixel_index     => view_pixel_index,
			
			Pulse_Ram_ADDRESS_RD => open,
			Pulse_Ram_Data_RD    => Pulse_Ram_Data_RD,
			
			squid_Ram_ADDRESS_WR => squid_Ram_ADDRESS_WR,
			squid_Ram_Data_WR	 => squid_Ram_Data_WR,
			WE_squid_Ram		 => WE_squid_Ram,
		
			Vtes_out             => Vtes_out,
			feedback_sq1         => feedback_sq1,
			error                => error,
			
			out_squid_adder_centered	=>	out_squid_adder_centered
		);	
	
----------------------------------------------------
--	ok pipe in for Vp
----------------------------------------------------	
	
	
label_okPipeIn_Vp : okPipeIn --okBTPipeIn  
port map (
	okHE	=>	okHE, 
	okEH	=>	okEHx( 2*65-1 downto 1*65 ),  
	ep_addr	=>	x"81", 
    ep_write=>	ep_write_Vp, 
	ep_dataout		=>	ep_dataout_Vp
	);	

----------------------------------------------------
--	fifo pipe in Vp
----------------------------------------------------	
	
okPipeIn_FIFO_vp	:	entity work.fifo_w32_2048_r32_2048 
port map (
	rst		=>	reset,
	wr_clk	=>	okClk,
	rd_clk	=>	CLK_5Mhz,	--	normal clock 20MHz 
	din		=>	ep_dataout_Vp, --// Bus [31 : 0] 
	wr_en	=>	ep_write_Vp,
	rd_en	=>	rd_en_Vp,
	dout	=>	dout_Vp, --// Bus [31 : 0] 
	full	=>	full_Vp,
	empty	=>	empty_Vp,
	valid	=>	valid_Vp

	); 		

----------------------------------------------------
--	FSM VP : read fifo pipo and write LUT Pulse
----------------------------------------------------		
	
	label_case_vp : process(CLK_5Mhz, Reset) is
	begin
		if Reset = '1' then
		
			rd_en_Vp         <= '0';
			Current_state_vp <= read_fifo_add;
			Pulse_Ram_Data_WR    <= (others => '0');
			Pulse_Ram_ADDRESS_WR <= (others => '0');
			WE_Pulse_Ram         <= '0';

		elsif rising_edge(CLK_5Mhz) then
		
		WE_Pulse_Ram      <= '0';
						
			case Current_state_vp is

				when read_fifo_add =>
				
					if empty_Vp = '0' then
						rd_en_Vp         <= '1';
						Current_state_vp <= valid_fifo_add;
					end if;

				when valid_fifo_add =>
					rd_en_Vp <= '0';
					
					if valid_Vp = '1' then
					
						dout_Vp_valid    	   <= dout_Vp;
						Current_state_vp		 <= write_ram;
						
					end if;

				when write_ram		=>
				
					WE_Pulse_Ram      <= '1';

					Pulse_Ram_Data_WR <= dout_Vp_valid(31 downto 16);					
				
					Current_state_vp <= increase_add_wr;
				
				when increase_add_wr =>
					
					Pulse_Ram_ADDRESS_WR <= Pulse_Ram_ADDRESS_WR + 1;
				
					Current_state_vp <= read_fifo_add;
				
				when others =>

			end case;

		end if;
	end process label_case_vp;	
	
----------------------------------------------------
--	ok pipe in for squid
----------------------------------------------------	
	
	
label_okPipeIn_squid : okPipeIn --okBTPipeIn  
port map (
	okHE	=>	okHE, 
	okEH	=>	okEHx( 9*65-1 downto 8*65 ),  
	ep_addr	=>	x"82", 
    ep_write=>	ep_write_squid, 
	ep_dataout		=>	ep_dataout_squid
	);		
	
----------------------------------------------------
--	fifo pipe in squid
----------------------------------------------------	
	
okPipeIn_FIFO_squid	:	entity work.fifo_w32_4096_r32_4096 
port map (
	rst		=>	reset,
	wr_clk	=>	okClk,
	rd_clk	=>	CLK_5Mhz,	--	normal clock 20MHz 
	din		=>	ep_dataout_squid, --// Bus [31 : 0] 
	wr_en	=>	ep_write_squid,
	rd_en	=>	rd_en_squid,
	dout	=>	dout_squid, --// Bus [31 : 0] 
	full	=>	full_squid,
	empty	=>	empty_squid,
	valid	=>	valid_squid

	); 	

----------------------------------------------------
--	FSM squid : read fifo pipe and write squid table
----------------------------------------------------		
	
	label_case_squid : process(CLK_5Mhz, Reset) is
	begin
		if Reset = '1' then
		
			rd_en_squid         <= '0';
			Current_state_squid <= read_fifo_add;
			
			squid_Ram_Data_WR    <= (others => '0');--
			squid_Ram_ADDRESS_WR <= (others => '0');--
			WE_squid_Ram         <= '0';--
			dout_squid_valid 	 <= (others => '0');--

		elsif rising_edge(CLK_5Mhz) then
		
		WE_squid_Ram      <= '0';
						
			case Current_state_squid is

				when read_fifo_add =>
				
					if empty_squid = '0' then
						rd_en_squid         <= '1';
						Current_state_squid <= valid_fifo_add;
					end if;

				when valid_fifo_add =>
					rd_en_squid <= '0';
					
					if valid_squid = '1' then
					
						dout_squid_valid    	   <= dout_squid;
						Current_state_squid		 <= write_ram;
						
					end if;

				when write_ram		=>
				
					WE_squid_Ram      <= '1';

					squid_Ram_Data_WR <= dout_squid_valid(15 downto 0);					
				
					Current_state_squid <= increase_add_wr;
				
				when increase_add_wr =>
					
					squid_Ram_ADDRESS_WR <= squid_Ram_ADDRESS_WR + 1;
				
					Current_state_squid <= read_fifo_add;
				
				when others =>

			end case;

		end if;
	end process label_case_squid;

	
----------------------------------------------------
--	ok wire out ddr3 stamp msb
----------------------------------------------------

label_okWireOut_debug_21 : okWireOut    
port map ( 
	okHE => okHE, 
	okEH => okEHx( 3*65-1 downto 2*65 ), 
	ep_addr => x"21", 
	ep_datain => Vo(0)--ep21wire_three 
	);		
	
----------------------------------------------------
--	ok wire out full flag
----------------------------------------------------

label_okWireOut_debug_22 : okWireOut    
port map ( 
	okHE => okHE, 
	okEH => okEHx( 4*65-1 downto 3*65 ), 
	ep_addr => x"22", 
	ep_datain => Vp(0)--ep22wire_two 
	);		
	
----------------------------------------------------
--	ok wire out ddr3 stamp lsb
----------------------------------------------------

label_okWireOut_debug_23 : okWireOut    
port map ( 
	okHE => okHE, 
	okEH => okEHx( 5*65-1 downto 4*65 ), 
	ep_addr => x"23", 
	ep_datain => Vo(1)--ep23wire_two 
	);		
	
----------------------------------------------------
--	ok wire out
----------------------------------------------------

label_okWireOut_debug_24 : okWireOut    
port map ( 
	okHE => okHE, 
	okEH => okEHx( 6*65-1 downto 5*65 ), 
	ep_addr => x"24", 
	ep_datain => Vp(1)--ep24wire_two 
	);	


----------------------------------------------------
--	ok wire out ddr3 stamp msb
----------------------------------------------------

label_okWireOut_debug_25 : okWireOut    
port map ( 
	okHE => okHE, 
	okEH => okEHx( 7*65-1 downto 6*65 ), 
	ep_addr => x"25", 
	ep_datain => Vo(2)--ep25wire_two 
	);	

----------------------------------------------------
--	ok wire out HK
----------------------------------------------------

label_okWireOut_debug_26 : okWireOut    
port map ( 
	okHE => okHE, 
	okEH => okEHx( 8*65-1 downto 7*65 ), 
	ep_addr => x"26", 
	ep_datain => Vp(2)--ep26wire
	);	

icon_inst : entity work.icon
	Port map (
		CONTROL0 => CONTROL0,
		CONTROL1 => CONTROL1
	 );

----------------------------------------------------
--	ILA
----------------------------------------------------
	
label_ila : entity work.ila 
port map (
    CONTROL =>	CONTROL0, 
    CLK	=>	CLK_5Mhz, 
    TRIG0 	=>	DATA_0 
);

----------------------------------------------------
--	VIO
----------------------------------------------------

vio_conf : entity work.vio
port map (
    CONTROL => CONTROL1,
	clk     => 	CLK_5Mhz,
    SYNC_OUT => SYNC_OUT
	 );

----------------------------------------------------
--	from ADC SQ1
----------------------------------------------------	 
	 
feedback_sq1 <= signed(SYNC_OUT(14 downto 1));
--feedback_sq1 <= (others => '0');


no_linarity_enable	<= SYNC_OUT(0); 	--	only simulation 


-- label_ila_1 : entity work.ila 
-- port map (
    -- CONTROL =>	CONTROL1, 
    -- CLK	=>	CLK_5Mhz, 
    -- TRIG0 	=>	DATA_1 
-- );



--DATA_0(25) <= '0';
--DATA_0(24) <= '0';
--DATA_0(121) <= write_Vp_wire;

DATA_0(138 downto 121) <=	'0'&(std_logic_vector(out_squid_adder_centered));
DATA_0(120 downto 89) <= dout_squid;
DATA_0(88 downto 57) <= dout_Vp;
DATA_0(56 downto 25) <= dout;
DATA_0(24 downto 19) <=	(std_logic_vector(to_unsigned(view_pixel_index,6)));
DATA_0(18 downto 3) <=	(std_logic_vector(Vtes_out));
DATA_0(2) <=	rd_en_squid;
DATA_0(1) <=	rd_en_Vp;
DATA_0(0) <= 	write_Vp_wire;

--	16bits&6bits&32bits	

-- DATA_1(54 downto 37) <=	"000000000000000000";	
-- DATA_1(36)	<=	write_Vp;
-- DATA_1(35)	<=	write_Vp_detect_old;
-- DATA_1(34)	<=	write_Vp_detect;
-- DATA_1(33)	<=	ep00wire(2);
-- DATA_1(32 downto 1) <=	dout_Vp;
-- DATA_1(0) <=  rd_en_Vp;
		
end RTL;