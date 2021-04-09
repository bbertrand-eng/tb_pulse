--------------------------------------------------------------------------------
-- sim_tf.vhd
--
-- Version: USB3
-- Language: VHDL
--
-- A test fixture example that illustrates how to simulate FrontPanel
-- designs.
--
--------------------------------------------------------------------------------
-- Copyright (c) 2005-2014 Opal Kelly Incorporated
-- $Rev: 0 $ $Date: 2014-12-4 16:07:50 -0700 (Thur, 4 Dec 2014) $
--------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_textio.all;
use work.FrontPanel.all;

library STD;
use std.textio.all;

--use work.mappings.all;
use work.parameters.all;


entity TestBench is
end TestBench;

architecture simulate of TestBench is




	component FPAsim_OK_TOP is port(
	
		reset		: in	STD_LOGIC;	--	only simulation
	
		sys_clkp	: in	STD_LOGIC;								-- input	  wire         sys_clkp,
		sys_clkn	: in 	STD_LOGIC;								-- input  wire         sys_clkn,
		
		okUH      : in     STD_LOGIC_VECTOR(4 downto 0);
		okHU      : out    STD_LOGIC_VECTOR(2 downto 0);
		okUHU     : inout  STD_LOGIC_VECTOR(31 downto 0);
		okAA      : inout  STD_LOGIC;
		
		led       : out    STD_LOGIC_VECTOR(3 downto 0)
		
	);
	end component;



	signal led : std_logic_vector(7 downto 0);
	signal start		: std_logic;

	-- FrontPanel Host --------------------------------------------------------------------------

	signal okUH       : std_logic_vector(4 downto 0) := b"00000";
	signal okHU       : std_logic_vector(2 downto 0);
	signal okUHU      : std_logic_vector(31 downto 0);
	signal okAA       : std_logic;

	---------------------------------------------------------------------------------------------

	-- okHostCalls Simulation Parameters & Signals ----------------------------------------------
	constant tCK        : time := 5 ns; --Half of the hi_clk frequency @ 1ns timing = 100MHz
	constant Tsys_clk   : time := 2.5 ns; --Half of the hi_clk frequency @ 1ns timing = 100MHz
	
	signal   hi_clk     : std_logic;
	signal   hi_drive   : std_logic := '0';
	signal   hi_cmd     : std_logic_vector(2 downto 0) := "000";
	signal   hi_busy    : std_logic;
	signal   hi_datain  : std_logic_vector(31 downto 0) := x"00000000";
	signal   hi_dataout : std_logic_vector(31 downto 0) := x"00000000";

	signal sys_clkp   	: std_logic;
	signal sys_clkn   	: std_logic;
	
	signal reset		: std_logic;	
	signal reset_sim	: std_logic;

	
	-- Clocks
	signal sys_clk    : std_logic := '0';
	
	signal view_data  : std_logic_vector(7 downto 0);

	type PIPEIN_ARRAY is array (0 to 16383) of std_logic_vector(7 downto 0);
	signal pipeIn_signal   : PIPEIN_ARRAY;	
	signal pipeIn_signal_squid : PIPEIN_ARRAY;
	
	-- type PIPEIN_ARRAY_SQUID is array (0 to 16383) of std_logic_vector(7 downto 0);	
	-- signal pipeIn_signal_squid : PIPEIN_ARRAY_SQUID;	

	signal	pipeInSize_count 		:	integer;
	signal	pipeInSize_count_squid	:	integer;	
	
	
	---------------------------------------------------------------------------------------------

	--------------------------------------------------------------------------
	-- Begin functional body
	--------------------------------------------------------------------------
begin

	dut : FPAsim_OK_TOP port map (
	
		reset		=>	reset,
	
		sys_clkp	=>	sys_clkp,--: in	STD_LOGIC;								-- input	  wire         sys_clkp,
		sys_clkn	=>	sys_clkn,--: in 	STD_LOGIC;								-- input  wire         sys_clkn,
	
	
		okUH		=>	okUH,		--: in    STD_LOGIC_VECTOR (4  downto 0);			-- input  wire [4:0]   okUH,
		okHU		=>	okHU,		--: out   STD_LOGIC_VECTOR (2  downto 0);			-- output wire [2:0]   okHU,
		okUHU		=>	okUHU	--: inout STD_LOGIC_VECTOR (31 downto 0);			-- inout  wire [31:0]  okUHU,
--		okAA		--: inout STD_LOGIC;								-- inout  wire         okAA,					REMOVED FOR SIMULATION
		
		);



	-- okHostCalls Simulation okHostCall<->okHost Mapping  --------------------------------------
	okUH(0)          <= hi_clk;
	okUH(1)          <= hi_drive;
	okUH(4 downto 2) <= hi_cmd; 
	hi_datain        <= okUHU;
	hi_busy          <= okHU(0); 
	okUHU            <= hi_dataout when (hi_drive = '1') else (others => 'Z');
	---------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------
--
-- clock
--
----------------------------------------------------------------------------------------------	
	
	-- Clock Generation
	hi_clk_gen : process is
	begin
		hi_clk <= '0';
		wait for tCk;
		hi_clk <= '1'; 
		wait for tCk; 
	end process hi_clk_gen;

	sys_clk_gen : process is
	begin
		sys_clk <= '0';
		sys_clkp <= '0';
		sys_clkn <= '1';
		wait for Tsys_clk;
		sys_clk <= '1';
		sys_clkp <= '1';
		sys_clkn <= '0'; 
		wait for Tsys_clk; 
	end process sys_clk_gen;
	-- Simulation Process


label_read_file_pulse	: process
------------------------------------------------------------------

file DONNEES : text;
variable MY_LINE : line;
variable data		: std_logic_vector(31 downto 0);	
variable i_signal : integer;
-------------------------------------------------------------------

begin-------------begin of process-----
file_open(DONNEES, "fake_pulse_CBE.txt", read_mode);
--ep_write	<= '0';
--ep_dataout	<= (others => '0');
i_signal := 0;
pipeInSize_count <= 0;
wait until reset = '0' and reset' event;
	
   loop
   
  	wait until (hi_clk = '1' and hi_clk' event); 
	
		if (not endfile(DONNEES))
		then
		--ep_write	<= '1';  
		readline(DONNEES,MY_LINE); 
		hread(MY_LINE,data);
		pipeInSize_count <= pipeInSize_count + 1;
		pipeIn_signal(i_signal) <= data(7 downto 0);
		i_signal := i_signal+1;
		pipeIn_signal(i_signal) <= data(15 downto 8);
		i_signal := i_signal+1;
		pipeIn_signal(i_signal) <= data(23 downto 16);
		i_signal := i_signal+1;
		pipeIn_signal(i_signal) <= data(31 downto 24);
		i_signal := i_signal+1;
		else
		--ep_write	<= '0';
		end if;
		
  	end loop;---------
  	
end process;------------------------------------------------------

label_read_file_squid	: process
------------------------------------------------------------------

file DONNEES : text;
variable MY_LINE : line;
variable data		: std_logic_vector(31 downto 0);	
variable i_signal : integer;
-------------------------------------------------------------------

begin-------------begin of process-----
file_open(DONNEES, "SQUID_tab.txt", read_mode);
--ep_write	<= '0';
--ep_dataout	<= (others => '0');
i_signal := 0;
pipeInSize_count_squid <= 0;
wait until reset = '0' and reset' event;
	
   loop
   
  	wait until (hi_clk = '1' and hi_clk' event); 
	
		if (not endfile(DONNEES))
		then
		--ep_write	<= '1';  
		readline(DONNEES,MY_LINE); 
		hread(MY_LINE,data);
		pipeInSize_count_squid <= pipeInSize_count_squid + 1;
		pipeIn_signal_squid(i_signal) <= data(7 downto 0);
		i_signal := i_signal+1;
		pipeIn_signal_squid(i_signal) <= data(15 downto 8);
		i_signal := i_signal+1;
		pipeIn_signal_squid(i_signal) <= data(23 downto 16);
		i_signal := i_signal+1;
		pipeIn_signal_squid(i_signal) <= data(31 downto 24);
		i_signal := i_signal+1;
		else
		--ep_write	<= '0';
		end if;
		
  	end loop;---------
  	
end process;------------------------------------------------------

	
----------------------------------------------------------------------------------------------
--
-- Reset
--
----------------------------------------------------------------------------------------------

Reset 		<= '1', '0' after 100 ns ;
reset_sim	<= '1', '0' after 600 ns ;

start		<= '0', '1' after 25 us;
	
	
sim_process : process is

--<<<<<<<<<<<<<<<<<<< OKHOSTCALLS START PASTE HERE >>>>>>>>>>>>>>>>>>>>-- 

	-----------------------------------------------------------------------
	-- User defined data for pipe and register procedures
	-----------------------------------------------------------------------
	variable BlockDelayStates : integer := 5;    -- REQUIRED: # of clocks between blocks of pipe data
	variable ReadyCheckDelay  : integer := 5;    -- REQUIRED: # of clocks before block transfer before
	                                             --    host interface checks for ready (0-255)
	variable PostReadyDelay   : integer := 5;    -- REQUIRED: # of clocks after ready is asserted and
	                                             --    check that the block transfer begins (0-255)

	variable pipeOutSize      : integer := 1024; -- REQUIRED: byte (must be even) length of default
                                               --    PipeOut; Integer 0-2^32
	variable registerSetSize  : integer := 32;   -- Size of array for register set commands.
                                                                                            
	-----------------------------------------------------------------------
	-- Required data for procedures and functions
	-----------------------------------------------------------------------
	-- If you require multiple pipe arrays, you may create more arrays here
	-- duplicate the desired pipe procedures as required, change the names
	-- of the duplicated procedure to a unique identifiers, and alter the
	-- pipe array in that procedure to your newly generated arrays here.
	
	variable	counter			: std_logic_vector(7 downto 0);
	variable	data_config		: std_logic_vector(31 downto 0);
	variable value_out: std_logic_vector(7 downto 0);		

	file 		DONNEES	: text;
	variable 	MY_LINE : line;
	variable i  : integer;
	variable pipeInSize       : integer := 1024; -- REQUIRED: byte (must be even) length of default
                                               --    PipeIn; Integer 0-2^32
	variable  data	: std_logic_vector(7 downto 0);
	
--	type PIPEIN_ARRAY is array (0 to pipeInSize - 1) of std_logic_vector(7 downto 0);
	variable pipeIn   : PIPEIN_ARRAY;	
	


	type PIPEOUT_ARRAY is array (0 to pipeOutSize - 1) of std_logic_vector(7 downto 0);
	variable pipeOut  : PIPEOUT_ARRAY;

	type STD_ARRAY is array (0 to 31) of std_logic_vector(31 downto 0);
	variable WireIns    :  STD_ARRAY; -- 32x32 array storing WireIn values
	variable WireOuts   :  STD_ARRAY; -- 32x32 array storing WireOut values 
  	variable Triggered  :  STD_ARRAY; -- 32x32 array storing IsTriggered values
	
	type REGISTER_ARRAY is array (0 to registerSetSize - 1) of std_logic_vector(31 downto 0);
	variable u32Address  : REGISTER_ARRAY;
	variable u32Data     : REGISTER_ARRAY;
	variable u32Count    : std_logic_vector(31 downto 0);
	variable ReadRegisterData    : std_logic_vector(31 downto 0);
	
	constant DNOP                  : std_logic_vector(2 downto 0) := "000";
	constant DReset                : std_logic_vector(2 downto 0) := "001";
	constant DWires                : std_logic_vector(2 downto 0) := "010";
	constant DUpdateWireIns        : std_logic_vector(2 downto 0) := "001";
	constant DUpdateWireOuts       : std_logic_vector(2 downto 0) := "010";
	constant DTriggers             : std_logic_vector(2 downto 0) := "011";
	constant DActivateTriggerIn    : std_logic_vector(2 downto 0) := "001";
	constant DUpdateTriggerOuts    : std_logic_vector(2 downto 0) := "010";
	constant DPipes                : std_logic_vector(2 downto 0) := "100";
	constant DWriteToPipeIn        : std_logic_vector(2 downto 0) := "001";
	constant DReadFromPipeOut      : std_logic_vector(2 downto 0) := "010";
	constant DWriteToBlockPipeIn   : std_logic_vector(2 downto 0) := "011";
	constant DReadFromBlockPipeOut : std_logic_vector(2 downto 0) := "100";
	constant DRegisters            : std_logic_vector(2 downto 0) := "101";
	constant DWriteRegister        : std_logic_vector(2 downto 0) := "001";
	constant DReadRegister         : std_logic_vector(2 downto 0) := "010";
	constant DWriteRegisterSet     : std_logic_vector(2 downto 0) := "011";
	constant DReadRegisterSet      : std_logic_vector(2 downto 0) := "100";

	-----------------------------------------------------------------------
	-- FrontPanelReset
	-----------------------------------------------------------------------
	procedure FrontPanelReset is
		variable i : integer := 0;
		variable msg_line           : line;
	begin
			for i in 31 downto 0 loop
				WireIns(i) := (others => '0');
				WireOuts(i) := (others => '0');
				Triggered(i) := (others => '0');
			end loop;
			wait until (rising_edge(hi_clk)); hi_cmd <= DReset;
			wait until (rising_edge(hi_clk)); hi_cmd <= DNOP;
			wait until (hi_busy = '0');
	end procedure FrontPanelReset;

	-----------------------------------------------------------------------
	-- SetWireInValue
	-----------------------------------------------------------------------
	procedure SetWireInValue (
		ep   : in  std_logic_vector(7 downto 0);
		val  : in  std_logic_vector(31 downto 0);
		mask : in  std_logic_vector(31 downto 0)) is
		
		variable tmp_slv32 :     std_logic_vector(31 downto 0);
		variable tmpI      :     integer;
	begin
		tmpI := CONV_INTEGER(ep);
		tmp_slv32 := WireIns(tmpI) and (not mask);
		WireIns(tmpI) := (tmp_slv32 or (val and mask));
	end procedure SetWireInValue;

	-----------------------------------------------------------------------
	-- GetWireOutValue
	-----------------------------------------------------------------------
	impure function GetWireOutValue (
		ep : std_logic_vector) return std_logic_vector is
		
		variable tmp_slv32 : std_logic_vector(31 downto 0);
		variable tmpI      : integer;
	begin
		tmpI := CONV_INTEGER(ep);
		tmp_slv32 := WireOuts(tmpI - 16#20#);
		return (tmp_slv32);
	end GetWireOutValue;

	-----------------------------------------------------------------------
	-- IsTriggered
	-----------------------------------------------------------------------
	impure function IsTriggered (
		ep   : std_logic_vector;
		mask : std_logic_vector(31 downto 0)) return BOOLEAN is
		
		variable tmp_slv32   : std_logic_vector(31 downto 0);
		variable tmpI        : integer;
		variable msg_line    : line;
	begin
		tmpI := CONV_INTEGER(ep);
		tmp_slv32 := (Triggered(tmpI - 16#60#) and mask);

		if (tmp_slv32 >= 0) then
			if (tmp_slv32 = 0) then
				return FALSE;
			else
				return TRUE;
			end if;
		else
			write(msg_line, STRING'("***FRONTPANEL ERROR: IsTriggered mask 0x"));
			hwrite(msg_line, mask);
			write(msg_line, STRING'(" covers unused Triggers"));
			writeline(output, msg_line);
			return FALSE;        
		end if;     
	end IsTriggered;

	-----------------------------------------------------------------------
	-- UpdateWireIns
	-----------------------------------------------------------------------
	procedure UpdateWireIns is
		variable i : integer := 0;
	begin
		wait until (rising_edge(hi_clk)); hi_cmd <= DWires; 
		wait until (rising_edge(hi_clk)); hi_cmd <= DUpdateWireIns; 
		wait until (rising_edge(hi_clk));
		hi_drive <= '1'; 
		wait until (rising_edge(hi_clk)); hi_cmd <= DNOP; 
		for i in 0 to 31 loop
			hi_dataout <= WireIns(i);  wait until (rising_edge(hi_clk)); 
		end loop;
		wait until (hi_busy = '0');  
	end procedure UpdateWireIns;
   
	-----------------------------------------------------------------------
	-- UpdateWireOuts
	-----------------------------------------------------------------------
	procedure UpdateWireOuts is
		variable i : integer := 0;
	begin
		wait until (rising_edge(hi_clk)); hi_cmd <= DWires; 
		wait until (rising_edge(hi_clk)); hi_cmd <= DUpdateWireOuts; 
		wait until (rising_edge(hi_clk));
		wait until (rising_edge(hi_clk)); hi_cmd <= DNOP; 
		wait until (rising_edge(hi_clk)); hi_drive <= '0'; 
		wait until (rising_edge(hi_clk)); wait until (rising_edge(hi_clk)); 
		for i in 0 to 31 loop
			wait until (rising_edge(hi_clk)); WireOuts(i) := hi_datain; 
		end loop;
		wait until (hi_busy = '0'); 
	end procedure UpdateWireOuts;

	-----------------------------------------------------------------------
	-- ActivateTriggerIn
	-----------------------------------------------------------------------
	procedure ActivateTriggerIn (
		ep  : in  std_logic_vector(7 downto 0);
		bit : in  integer) is 
		
		variable tmp_slv5 :     std_logic_vector(4 downto 0);
	begin
		tmp_slv5 := CONV_std_logic_vector(bit, 5);
		wait until (rising_edge(hi_clk)); hi_cmd <= DTriggers;
		wait until (rising_edge(hi_clk)); hi_cmd <= DActivateTriggerIn;
		wait until (rising_edge(hi_clk));
		hi_drive <= '1';
		hi_dataout <= (x"000000" & ep);
		wait until (rising_edge(hi_clk)); hi_dataout <= SHL(x"00000001", tmp_slv5); 
		hi_cmd <= DNOP;
		wait until (rising_edge(hi_clk)); hi_dataout <= x"00000000";
		wait until (hi_busy = '0');
	end procedure ActivateTriggerIn;

	-----------------------------------------------------------------------
	-- UpdateTriggerOuts
	-----------------------------------------------------------------------
	procedure UpdateTriggerOuts is
	begin
		wait until (rising_edge(hi_clk)); hi_cmd <= DTriggers;
		wait until (rising_edge(hi_clk)); hi_cmd <= DUpdateTriggerOuts;
		wait until (rising_edge(hi_clk));
		wait until (rising_edge(hi_clk)); hi_cmd <= DNOP;
		wait until (rising_edge(hi_clk)); hi_drive <= '0';
		wait until (rising_edge(hi_clk)); wait until (rising_edge(hi_clk));
		wait until (rising_edge(hi_clk));
		
		for i in 0 to (UPDATE_TO_READOUT_CLOCKS-1) loop
				wait until (rising_edge(hi_clk));  
		end loop;
		
		for i in 0 to 31 loop
			wait until (rising_edge(hi_clk)); Triggered(i) := hi_datain;
		end loop;
		wait until (hi_busy = '0');
	end procedure UpdateTriggerOuts;

	-----------------------------------------------------------------------
	-- WriteToPipeIn
	-----------------------------------------------------------------------
	procedure WriteToPipeIn (
		ep      : in  std_logic_vector(7 downto 0);
		length  : in  integer) is

		variable len, i, j, k, blockSize : integer;
		variable tmp_slv8                : std_logic_vector(7 downto 0);
		variable tmp_slv32               : std_logic_vector(31 downto 0);
	begin
		len := (length / 4); j := 0; k := 0; blockSize := 1024;
		tmp_slv8 := CONV_std_logic_vector(BlockDelayStates, 8);
		tmp_slv32 := CONV_std_logic_vector(len, 32);
		
		wait until (rising_edge(hi_clk)); hi_cmd <= DPipes;
		wait until (rising_edge(hi_clk)); hi_cmd <= DWriteToPipeIn;
		wait until (rising_edge(hi_clk)); 
		hi_drive <= '1';
		hi_dataout <= (x"0000" & tmp_slv8 & ep);
		wait until (rising_edge(hi_clk)); hi_cmd <= DNOP;
		hi_dataout <= tmp_slv32;
		for i in 0 to len - 1 loop
			wait until (rising_edge(hi_clk));
			hi_dataout(7 downto 0) <= pipeIn(i*4);
			hi_dataout(15 downto 8) <= pipeIn((i*4)+1);
			hi_dataout(23 downto 16) <= pipeIn((i*4)+2);
			hi_dataout(31 downto 24) <= pipeIn((i*4)+3);
			j := j + 4;
			if (j = blockSize) then
				for k in 0 to BlockDelayStates - 1 loop
					wait until (rising_edge(hi_clk));
				end loop;
				j := 0;
			end if;
		end loop;
		wait until (hi_busy = '0');
	end procedure WriteToPipeIn;

	-----------------------------------------------------------------------
	-- ReadFromPipeOut
	-----------------------------------------------------------------------
	procedure ReadFromPipeOut (
		ep     : in  std_logic_vector(7 downto 0);
		length : in  integer) is
		
		variable len, i, j, k, blockSize : integer;
		variable tmp_slv8                : std_logic_vector(7 downto 0);
		variable tmp_slv32               : std_logic_vector(31 downto 0);
	begin
		len := (length / 4); j := 0; blockSize := 1024;
		tmp_slv8 := CONV_std_logic_vector(BlockDelayStates, 8);
		tmp_slv32 := CONV_std_logic_vector(len, 32);
		
		wait until (rising_edge(hi_clk)); hi_cmd <= DPipes;
		wait until (rising_edge(hi_clk)); hi_cmd <= DReadFromPipeOut;
		wait until (rising_edge(hi_clk));
		hi_drive <= '1';
		hi_dataout <= (x"0000" & tmp_slv8 & ep);
		wait until (rising_edge(hi_clk)); hi_cmd <= DNOP;
		hi_dataout <= tmp_slv32;
		wait until (rising_edge(hi_clk));
		hi_drive <= '0';
		for i in 0 to len - 1 loop
			wait until (rising_edge(hi_clk));
			pipeOut(i*4) := hi_datain(7 downto 0);
			pipeOut((i*4)+1) := hi_datain(15 downto 8);
			pipeOut((i*4)+2) := hi_datain(23 downto 16);
			pipeOut((i*4)+3) := hi_datain(31 downto 24);
			j := j + 4;
			if (j = blockSize) then
				for k in 0 to BlockDelayStates - 1 loop
					wait until (rising_edge(hi_clk));
				end loop;
				j := 0;
			end if;
		end loop;
		wait until (hi_busy = '0');
	end procedure ReadFromPipeOut;

	-----------------------------------------------------------------------
	-- WriteToBlockPipeIn
	-----------------------------------------------------------------------
	procedure WriteToBlockPipeIn (
		ep          : in std_logic_vector(7 downto 0);
		blockLength : in integer;
		length      : in integer) is
		
		variable len, i, j, k, blockSize, blockNum : integer;
		variable tmp_slv8                          : std_logic_vector(7 downto 0);
		variable tmp_slv16                         : std_logic_vector(15 downto 0);
		variable tmp_slv32                         : std_logic_vector(31 downto 0);
	begin
		len := (length/4); blockSize := (blockLength/4); j := 0; k := 0;
		blockNum := (len/blockSize);
		tmp_slv8 := CONV_std_logic_vector(BlockDelayStates, 8);
		tmp_slv16 := CONV_std_logic_vector(blockSize, 16);
		tmp_slv32 := CONV_std_logic_vector(len, 32);
		
		wait until (rising_edge(hi_clk)); hi_cmd <= DPipes;
		wait until (rising_edge(hi_clk)); hi_cmd <= DWriteToBlockPipeIn;
		wait until (rising_edge(hi_clk));
		hi_drive <= '1';
		hi_dataout <= (x"0000" & tmp_slv8 & ep);
		wait until (rising_edge(hi_clk)); hi_cmd <= DNOP;
		hi_dataout <= tmp_slv32;
		wait until (rising_edge(hi_clk)); hi_dataout <= x"0000" & tmp_slv16;
		wait until (rising_edge(hi_clk));
		tmp_slv16 := (CONV_std_logic_vector(PostReadyDelay, 8) & CONV_std_logic_vector(ReadyCheckDelay, 8));
		hi_dataout <= x"0000" & tmp_slv16;
		for i in 1 to blockNum loop
			while (hi_busy = '1') loop wait until (rising_edge(hi_clk)); end loop;
			while (hi_busy = '0') loop wait until (rising_edge(hi_clk)); end loop;
			wait until (rising_edge(hi_clk)); wait until (rising_edge(hi_clk));
			for j in 1 to blockSize loop
				hi_dataout(7 downto 0) <= pipeIn(k);
				hi_dataout(15 downto 8) <= pipeIn(k+1);
				hi_dataout(23 downto 16) <= pipeIn(k+2);
				hi_dataout(31 downto 24) <= pipeIn(k+3);
				wait until (rising_edge(hi_clk)); k:=k+4;
			end loop;
			for j in 1 to BlockDelayStates loop 
				wait until (rising_edge(hi_clk)); 
			end loop;
		end loop;
		wait until (hi_busy = '0');
	end procedure WriteToBlockPipeIn;

	-----------------------------------------------------------------------
	-- ReadFromBlockPipeOut
	-----------------------------------------------------------------------
	procedure ReadFromBlockPipeOut (
		ep          : in std_logic_vector(7 downto 0);
		blockLength : in integer;
		length      : in integer) is
		
		variable len, i, j, k, blockSize, blockNum : integer;
		variable tmp_slv8                          : std_logic_vector(7 downto 0);
		variable tmp_slv16                         : std_logic_vector(15 downto 0);
		variable tmp_slv32                         : std_logic_vector(31 downto 0);
	begin
		len := (length/4); blockSize := (blockLength/4); j := 0; k := 0;
		blockNum := (len/blockSize);
		tmp_slv8 := CONV_std_logic_vector(BlockDelayStates, 8);
		tmp_slv16 := CONV_std_logic_vector(blockSize, 16);
		tmp_slv32 := CONV_std_logic_vector(len, 32);
		
		wait until (rising_edge(hi_clk)); hi_cmd <= DPipes;
		wait until (rising_edge(hi_clk)); hi_cmd <= DReadFromBlockPipeOut;
		wait until (rising_edge(hi_clk));
		hi_drive <= '1';
		hi_dataout <= (x"0000" & tmp_slv8 & ep);
		wait until (rising_edge(hi_clk)); hi_cmd <= DNOP;
		hi_dataout <= tmp_slv32;
		wait until (rising_edge(hi_clk)); hi_dataout <= x"0000" & tmp_slv16;
		wait until (rising_edge(hi_clk));
		tmp_slv16 := (CONV_std_logic_vector(PostReadyDelay, 8) & CONV_std_logic_vector(ReadyCheckDelay, 8));
		hi_dataout <= x"0000" & tmp_slv16;
		wait until (rising_edge(hi_clk)); hi_drive <= '0';
		for i in 1 to blockNum loop
			while (hi_busy = '1') loop wait until (rising_edge(hi_clk)); end loop;
			while (hi_busy = '0') loop wait until (rising_edge(hi_clk)); end loop;
			wait until (rising_edge(hi_clk)); wait until (rising_edge(hi_clk));
			for j in 1 to blockSize loop
				pipeOut(k) := hi_datain(7 downto 0); 
				pipeOut(k+1) := hi_datain(15 downto 8);
				pipeOut(k+2) := hi_datain(23 downto 16);
				pipeOut(k+3) := hi_datain(31 downto 24);
				wait until (rising_edge(hi_clk)); k:=k+4;
			end loop;
			for j in 1 to BlockDelayStates loop wait until (rising_edge(hi_clk)); end loop;
		end loop;
		wait until (hi_busy = '0');
	end procedure ReadFromBlockPipeOut;
	
	-----------------------------------------------------------------------
	-- WriteRegister
	-----------------------------------------------------------------------
	procedure WriteRegister (
		address  : in  std_logic_vector(31 downto 0);
		data     : in  std_logic_vector(31 downto 0)) is
	begin
		wait until (rising_edge(hi_clk)); hi_cmd <= DRegisters;
		wait until (rising_edge(hi_clk)); hi_cmd <= DWriteRegister;
		wait until (rising_edge(hi_clk));
		hi_drive <= '1';
		hi_cmd <= DNOP;
		wait until (rising_edge(hi_clk)); hi_dataout <= address; 
		wait until (rising_edge(hi_clk)); hi_dataout <= data;
		wait until (hi_busy = '0'); hi_drive <= '0';  
	end procedure WriteRegister;
	
	-----------------------------------------------------------------------
	-- ReadRegister
	-----------------------------------------------------------------------
	procedure ReadRegister (
		address  : in  std_logic_vector(31 downto 0);
		data     : out std_logic_vector(31 downto 0)) is
	begin
		wait until (rising_edge(hi_clk)); hi_cmd <= DRegisters;
		wait until (rising_edge(hi_clk)); hi_cmd <= DReadRegister;
		wait until (rising_edge(hi_clk));
		hi_drive <= '1';
		hi_cmd <= DNOP;
		wait until (rising_edge(hi_clk)); hi_dataout <= address; 
		wait until (rising_edge(hi_clk)); hi_drive <= '0';
		wait until (rising_edge(hi_clk));
		wait until (rising_edge(hi_clk)); data := hi_datain;
		wait until (hi_busy = '0');
	end procedure ReadRegister;
	
	
	-----------------------------------------------------------------------
	-- WriteRegisterSet
	-----------------------------------------------------------------------
	procedure WriteRegisterSet is
		variable i             :     integer;
		variable u32Count_int  :     integer;
	begin
	  u32Count_int := CONV_INTEGER(u32Count);
		wait until (rising_edge(hi_clk)); hi_cmd <= DRegisters;
		wait until (rising_edge(hi_clk)); hi_cmd <= DWriteRegisterSet;
		wait until (rising_edge(hi_clk));
		hi_drive <= '1';
		hi_cmd <= DNOP;
		wait until (rising_edge(hi_clk)); hi_dataout <= u32Count; 
		for i in 1 to u32Count_int loop
			wait until (rising_edge(hi_clk)); hi_dataout <= u32Address(i-1);
			wait until (rising_edge(hi_clk)); hi_dataout <= u32Data(i-1);
			wait until (rising_edge(hi_clk)); wait until (rising_edge(hi_clk));
		end loop;
		wait until (hi_busy = '0'); hi_drive <= '0';  
	end procedure WriteRegisterSet;
	
	-----------------------------------------------------------------------
	-- ReadRegisterSet
	-----------------------------------------------------------------------
	procedure ReadRegisterSet is
		variable i             :     integer;
		variable u32Count_int  :     integer;
	begin
	  u32Count_int := CONV_INTEGER(u32Count);
		wait until (rising_edge(hi_clk)); hi_cmd <= DRegisters;
		wait until (rising_edge(hi_clk)); hi_cmd <= DReadRegisterSet;
		wait until (rising_edge(hi_clk));
		hi_drive <= '1';
		hi_cmd <= DNOP;
		wait until (rising_edge(hi_clk)); hi_dataout <= u32Count; 
		for i in 1 to u32Count_int loop
			wait until (rising_edge(hi_clk)); hi_dataout <= u32Address(i-1);
			wait until (rising_edge(hi_clk)); hi_drive <= '0'; 
			wait until (rising_edge(hi_clk)); 
			wait until (rising_edge(hi_clk)); u32Data(i-1) := hi_datain;
			hi_drive <= '1';
		end loop;
		wait until (hi_busy = '0');
	end procedure ReadRegisterSet;
	
	-----------------------------------------------------------------------
	-- Available User Task and Function Calls:
	--    FrontPanelReset;              -- Always start routine with FrontPanelReset;
	--    SetWireInValue(ep, val, mask);
	--    UpdateWireIns;
	--    UpdateWireOuts;
	--    GetWireOutValue(ep);          -- returns a 16 bit SLV
	--    ActivateTriggerIn(ep, bit);   -- bit is an integer 0-15
	--    UpdateTriggerOuts;
	--    IsTriggered(ep, mask);        -- returns a BOOLEAN
	--    WriteToPipeIn(ep, length);    -- pass pipeIn array data; length is integer
	--    ReadFromPipeOut(ep, length);  -- pass data to pipeOut array; length is integer
	--    WriteToBlockPipeIn(ep, blockSize, length);   -- pass pipeIn array data; blockSize and length are integers
	--    ReadFromBlockPipeOut(ep, blockSize, length); -- pass data to pipeOut array; blockSize and length are integers
	--    WriteRegister(addr, data);  
	--    ReadRegister(addr, data);
	--    WriteRegisterSet();  
	--    ReadRegisterSet();
	--
	-- *  Pipes operate by passing arrays of data back and forth to the user's
	--    design.  If you need multiple arrays, you can create a new procedure
	--    above and connect it to a differnet array.  More information is
	--    available in Opal Kelly documentation and online support tutorial.
	-----------------------------------------------------------------------

--<<<<<<<<<<<<<<<<<<< OKHOSTCALLS END PASTE HERE >>>>>>>>>>>>>>>>>>>>>>--


variable NO_MASK            : std_logic_vector(31 downto 0) := x"ffff_ffff";

-- LFSR/Counter modes
variable MODE_LFSR          : integer := 0;    -- Will set 0th bit
variable MODE_COUNTER       : integer := 1;    -- Will set 1st bit

-- Off/Continuous/Piped modes for LFSR/Counter
variable MODE_OFF           : integer := 2;   -- Will set 2nd bit
variable MODE_CONTINUOUS    : integer := 3;   -- Will set 3rd bit
variable MODE_PIPED         : integer := 4;   -- Will set 4th bit

variable msg_line           : line;     -- type defined in textio.vhd

variable j                  : natural;
variable ep01value          : std_logic_vector(31 downto 0);
variable ep20value          : std_logic_vector(31 downto 0);
variable ReadPipe           : PIPEOUT_ARRAY;

variable RegOutData         : REGISTER_ARRAY;
variable RegInData          : REGISTER_ARRAY;
variable RegAddresses       : REGISTER_ARRAY;



variable 	Value : integer;
variable	counter_line : integer := 0;


-------------------------------------------------------------------
-- Check_LFSR
-- Sets the LFSR register mode to either Fibonacci LFSR or Counter
-- Seeds the register using WireIns
-- Checks and prints the current value using a WireOut
-------------------------------------------------------------------
procedure Check_LFSR (mode : integer) is
begin
	-- Set LFSR/Counter to run continuously
	ActivateTriggerIn(x"40", MODE_CONTINUOUS);

	ActivateTriggerIn(x"40", mode);
	if mode = MODE_LFSR then
		write(msg_line, STRING'("Mode: LFSR"));
	elsif mode = MODE_COUNTER then
		write(msg_line, STRING'("Mode: Counter"));
	end if;
	writeline(output, msg_line);

	-- Seed LFSR with initial value
	ep01value := x"5672_3237";
	SetWireInValue(x"01", ep01value, NO_MASK);
	UpdateWireIns;

	-- Check value on LFSR
	for i in 0 to 4 loop
		UpdateWireOuts;
		ep20value := GetWireOutValue(x"20");
		write(msg_line, STRING'("Read value: 0x"));
		hwrite(msg_line, STD_LOGIC_VECTOR'(ep20value));
		writeline(output, msg_line);
	end loop;
	writeline(output, msg_line);   -- Formatting

end procedure Check_LFSR;

-------------------------------------------------------------------
-- Check_PipeOut
-- Selects Piped mode and the specified LFSR register mode
-- Reads in values from the LFSR using a PipeOut endpoint
-- Prints the values in the proper sequence to form a
--    complete 32-bit value
-------------------------------------------------------------------
procedure Check_PipeOut (mode : integer) is
begin
	-- Set modes
	ActivateTriggerIn(x"40", MODE_PIPED);
	ActivateTriggerIn(x"40", mode);

	-- Read values
	ReadFromPipeOut(x"a0", pipeOutSize);
	-- Display values
	if mode = MODE_LFSR then
		write(msg_line, STRING'("PipeOut LFSR excerpt: "));
	elsif mode = MODE_COUNTER then
		write(msg_line, STRING'("PipeOut Counter excerpt: "));
	end if;
	writeline(output, msg_line);
	j := 0;
	while j < 32 loop
		ReadPipe(j) := pipeOut(j);
		ReadPipe(j+1) := pipeOut(j+1);
		ReadPipe(j+2) := pipeOut(j+2);
		ReadPipe(j+3) := pipeOut(j+3);
		write(msg_line, STRING'("0x"));
		hwrite(msg_line, STD_LOGIC_VECTOR'(ReadPipe(j+3)) & STD_LOGIC_VECTOR'(ReadPipe(j+2)));
		hwrite(msg_line, STD_LOGIC_VECTOR'(ReadPipe(j+1)) & STD_LOGIC_VECTOR'(ReadPipe(j)));
		writeline(output, msg_line);
		j := j + 4;
	end loop;
	writeline(output, msg_line);   -- Formatting
end procedure Check_PipeOut;

-------------------------------------------------------------------
-- Check_Registers
-- Stops the LFSR from updating (optional)
-- Sets up 32 values and 32 addresses
-- Sends the values to the FPGA and reads them back
-- Prints a comparison
-------------------------------------------------------------------
procedure Check_Registers is
begin
	-- Disable LFSR updating (optional)
	ActivateTriggerIn(x"40", MODE_OFF);

	-- Set up Register arrays
	for i in 0 to registerSetSize-1 loop
		RegOutData(i) := conv_std_logic_vector(i*23, registerSetSize);
		RegAddresses(i) := conv_std_logic_vector(i+3, registerSetSize);
		RegInData(i) := x"0000_0000";
	end loop;

	-- Send data
	for i in 0 to registerSetSize-1 loop
		WriteRegister(RegAddresses(i), RegOutData(i));
	end loop;

	write(msg_line, STRING'("Write to and read from block RAM using registers: "));
	writeline(output, msg_line);
	write(msg_line, STRING'("--------------------------------------------------"));
	writeline(output, msg_line);    -- formatting

	-- Retrieve data
	for i in 0 to registerSetSize-1 loop
		ReadRegister(RegAddresses(i), RegInData(i));
		write(msg_line, STRING'("Expected: "));
		hwrite(msg_line, STD_LOGIC_VECTOR'(RegOutData(i)));
		write(msg_line, STRING'(" Received: "));
		hwrite(msg_line, STD_LOGIC_VECTOR'(RegInData(i)));
		writeline(output, msg_line);
	end loop;
	writeline(output, msg_line);    --formatting

end procedure Check_Registers;


begin

	FrontPanelReset;
	
	wait for 20 ns;

	-- Reset 
	SetWireInValue(x"00", x"0000_0001", NO_MASK);
	UpdateWireIns;
	
	wait for 500 ns;
	SetWireInValue(x"00", x"0000_0000", NO_MASK);
	UpdateWireIns;
	
	counter   	:= (others => '0');
	data_config := (others => '0');
	value_out 	:= (others => '0');
	
	-- conf			
	wait for 10 us;
	pipeIn := pipeIn_signal;
	WriteToPipeIn(x"81", pipeInSize_count*4);
	
	wait for 250 us;

	pipeIn := pipeIn_signal_squid;
	WriteToPipeIn(x"82", pipeInSize_count_squid*4);
	
	wait for 250 us;	
	
	
	
	
	-- -- start on and truncation and heat
--
-- ---------------------start heat and stop heat, start pixel and bbfb-------------------------------
	
	-- VO
	
	pipeIn(0) :=	x"FF";	
	pipeIn(1) :=	x"FF";
	pipeIn(2) :=	x"00";	--pixel 0
	pipeIn(3) :=	x"00";	--V0
	
	
	-- Vp

	pipeIn(4) :=	x"00";	
	pipeIn(5) :=	x"08";	
	pipeIn(6) :=	x"00";	--pixel 0
	pipeIn(7) :=	x"01";	--Vp
	wait for 10 ns;	
	--
	
	WriteToPipeIn(x"80", 8);	--	usb3 injection 4 bytes
	wait for 10 ns;

	-- VO
	
	pipeIn(0) :=	x"FF";	
	pipeIn(1) :=	x"FF";
	pipeIn(2) :=	x"01";	--pixel 1
	pipeIn(3) :=	x"00";	--V0
	
	
	-- Vp

	pipeIn(4) :=	x"00";	
	pipeIn(5) :=	x"08";	
	pipeIn(6) :=	x"01";	--pixel 1
	pipeIn(7) :=	x"01";	--Vp
	wait for 10 ns;	
	--
	
	WriteToPipeIn(x"80", 8);	--	usb3 injection 4 bytes
	wait for 10 ns;
	

	-- VO
	
	pipeIn(0) :=	x"FF";	
	pipeIn(1) :=	x"FF";
	pipeIn(2) :=	x"02";	--pixel 2
	pipeIn(3) :=	x"00";	--V0
	
	
	-- Vp

	pipeIn(4) :=	x"00";	
	pipeIn(5) :=	x"08";	
	pipeIn(6) :=	x"02";	--pixel 2
	pipeIn(7) :=	x"01";	--Vp
	wait for 10 ns;	
	--
	
	WriteToPipeIn(x"80", 8);	--	usb3 injection 4 bytes
	wait for 10 ns;

		-- VO
	
	pipeIn(0) :=	x"FF";	
	pipeIn(1) :=	x"FF";
	pipeIn(2) :=	x"03";	--pixel 3
	pipeIn(3) :=	x"00";	--V0
	
	
	-- Vp

	pipeIn(4) :=	x"00";	
	pipeIn(5) :=	x"08";	
	pipeIn(6) :=	x"03";	--pixel 3
	pipeIn(7) :=	x"01";	--Vp
	wait for 10 ns;	
	--
	
	WriteToPipeIn(x"80", 8);	--	usb3 injection 4 bytes
	wait for 10 ns;

	--
	
	-- VO
	
	pipeIn(0) :=	x"FF";	
	pipeIn(1) :=	x"FF";
	pipeIn(2) :=	x"04";	--pixel 4
	pipeIn(3) :=	x"00";	--V0
	
	
	-- Vp

	pipeIn(4) :=	x"00";	
	pipeIn(5) :=	x"08";	
	pipeIn(6) :=	x"04";	--pixel 4
	pipeIn(7) :=	x"01";	--Vp
	wait for 10 ns;	
	--
	
	WriteToPipeIn(x"80", 8);	--	usb3 injection 4 bytes
	wait for 10 ns;
	
	-- VO
	
	pipeIn(0) :=	x"FF";	
	pipeIn(1) :=	x"FF";
	pipeIn(2) :=	x"05";	--pixel 5
	pipeIn(3) :=	x"00";	--V0
	
	
	-- Vp

	pipeIn(4) :=	x"00";	
	pipeIn(5) :=	x"08";	
	pipeIn(6) :=	x"05";	--pixel 5
	pipeIn(7) :=	x"01";	--Vp
	wait for 10 ns;	
	--
	
	WriteToPipeIn(x"80", 8);	--	usb3 injection 4 bytes
	wait for 10 ns;


	-- VO
	
	pipeIn(0) :=	x"FF";	
	pipeIn(1) :=	x"FF";
	pipeIn(2) :=	x"06";	--pixel 6
	pipeIn(3) :=	x"00";	--V0
	
	
	-- Vp

	pipeIn(4) :=	x"00";	
	pipeIn(5) :=	x"08";	
	pipeIn(6) :=	x"06";	--pixel 6
	pipeIn(7) :=	x"01";	--Vp
	wait for 10 ns;	
	--
	
	WriteToPipeIn(x"80", 8);	--	usb3 injection 4 bytes
	wait for 10 ns;
	
	
		-- VO
	
	pipeIn(0) :=	x"FF";	
	pipeIn(1) :=	x"FF";
	pipeIn(2) :=	x"07";	--pixel 7
	pipeIn(3) :=	x"00";	--V0
	
	
	-- Vp

	pipeIn(4) :=	x"00";	
	pipeIn(5) :=	x"08";	
	pipeIn(6) :=	x"07";	--pixel 7
	pipeIn(7) :=	x"01";	--Vp
	wait for 10 ns;	
	--
	
	WriteToPipeIn(x"80", 8);	--	usb3 injection 4 bytes
	wait for 10 ns;
	
	-- VO
	
	pipeIn(0) :=	x"FF";	
	pipeIn(1) :=	x"FF";
	pipeIn(2) :=	x"08";	--pixel 8
	pipeIn(3) :=	x"00";	--V0
	
	
	-- Vp

	pipeIn(4) :=	x"00";	
	pipeIn(5) :=	x"08";	
	pipeIn(6) :=	x"08";	--pixel 8
	pipeIn(7) :=	x"01";	--Vp
	wait for 10 ns;	
	--
	
	WriteToPipeIn(x"80", 8);	--	usb3 injection 4 bytes
	wait for 10 ns;

	-- VO
	
	pipeIn(0) :=	x"FF";	
	pipeIn(1) :=	x"FF";
	pipeIn(2) :=	x"09";	--pixel 9
	pipeIn(3) :=	x"00";	--V0
	
	
	-- Vp

	pipeIn(4) :=	x"00";	
	pipeIn(5) :=	x"08";	
	pipeIn(6) :=	x"09";	--pixel 9
	pipeIn(7) :=	x"01";	--Vp
	wait for 10 ns;	
	--
	
	WriteToPipeIn(x"80", 8);	--	usb3 injection 4 bytes
	wait for 10 ns;

		-- VO
	
	pipeIn(0) :=	x"FF";	
	pipeIn(1) :=	x"FF";
	pipeIn(2) :=	x"0a";	--pixel a
	pipeIn(3) :=	x"00";	--V0
	
	
	-- Vp

	pipeIn(4) :=	x"00";	
	pipeIn(5) :=	x"08";	
	pipeIn(6) :=	x"0a";	--pixel a
	pipeIn(7) :=	x"01";	--Vp
	wait for 10 ns;	
	--
	
	WriteToPipeIn(x"80", 8);	--	usb3 injection 4 bytes
	wait for 10 ns;
	
	-- VO
	
	pipeIn(0) :=	x"FF";	
	pipeIn(1) :=	x"FF";
	pipeIn(2) :=	x"0B";	--pixel b
	pipeIn(3) :=	x"00";	--V0
	
	
	-- Vp

	pipeIn(4) :=	x"00";	
	pipeIn(5) :=	x"08";	
	pipeIn(6) :=	x"0b";	--pixel b
	pipeIn(7) :=	x"01";	--Vp
	wait for 10 ns;	
	--
	WriteToPipeIn(x"80", 8);	--	usb3 injection 4 bytes
	wait for 10 ns;
		
		-- VO
	
	pipeIn(0) :=	x"FF";	
	pipeIn(1) :=	x"FF";
	pipeIn(2) :=	x"0C";	--pixel C
	pipeIn(3) :=	x"00";	--V0
	
	
	-- Vp

	pipeIn(4) :=	x"00";	
	pipeIn(5) :=	x"08";	
	pipeIn(6) :=	x"0C";	--pixel C
	pipeIn(7) :=	x"01";	--Vp
	wait for 10 ns;	
	--
	
	WriteToPipeIn(x"80", 8);	--	usb3 injection 4 bytes
	wait for 10 ns;
	
		-- VO
	
	pipeIn(0) :=	x"FF";	
	pipeIn(1) :=	x"FF";
	pipeIn(2) :=	x"0d";	--pixel d
	pipeIn(3) :=	x"00";	--V0
	
	
	-- Vp

	pipeIn(4) :=	x"00";	
	pipeIn(5) :=	x"08";	
	pipeIn(6) :=	x"0d";	--pixel d
	pipeIn(7) :=	x"01";	--Vp
	wait for 10 ns;	
	--
	
	WriteToPipeIn(x"80", 8);	--	usb3 injection 4 bytes
	wait for 10 ns;


	-- VO
	
	pipeIn(0) :=	x"FF";	
	pipeIn(1) :=	x"FF";
	pipeIn(2) :=	x"0e";	--pixel e
	pipeIn(3) :=	x"00";	--V0
	
	
	-- Vp

	pipeIn(4) :=	x"00";	
	pipeIn(5) :=	x"08";	
	pipeIn(6) :=	x"0e";	--pixel e
	pipeIn(7) :=	x"01";	--Vp
	wait for 10 ns;	
	--
	
	WriteToPipeIn(x"80", 8);	--	usb3 injection 4 bytes
	wait for 10 ns;
	
		-- VO
	
	pipeIn(0) :=	x"FF";	
	pipeIn(1) :=	x"FF";
	pipeIn(2) :=	x"0f";	--pixel f
	pipeIn(3) :=	x"00";	--V0
	
	
	-- Vp

	pipeIn(4) :=	x"00";	
	pipeIn(5) :=	x"08";	
	pipeIn(6) :=	x"0f";	--pixel f
	pipeIn(7) :=	x"01";	--Vp
	wait for 10 ns;	
	--
	
	WriteToPipeIn(x"80", 8);	--	usb3 injection 4 bytes
	wait for 10 ns;
	
	-- VO
	
	pipeIn(0) :=	x"FF";	
	pipeIn(1) :=	x"FF";
	pipeIn(2) :=	x"10";	--pixel 10
	pipeIn(3) :=	x"00";	--V0
	
	
	-- Vp

	pipeIn(4) :=	x"00";	
	pipeIn(5) :=	x"08";	
	pipeIn(6) :=	x"10";	--pixel 10
	pipeIn(7) :=	x"01";	--Vp
	wait for 10 ns;	
	--
	
	WriteToPipeIn(x"80", 8);	--	usb3 injection 4 bytes
	wait for 10 ns;	


	-- VO
	
	pipeIn(0) :=	x"FF";	
	pipeIn(1) :=	x"FF";
	pipeIn(2) :=	x"11";	--pixel 11
	pipeIn(3) :=	x"00";	--V0
	
	
	-- Vp

	pipeIn(4) :=	x"00";	
	pipeIn(5) :=	x"08";	
	pipeIn(6) :=	x"11";	--pixel 11
	pipeIn(7) :=	x"01";	--Vp
	wait for 10 ns;	
	--
	
	WriteToPipeIn(x"80", 8);	--	usb3 injection 4 bytes
	wait for 10 ns;	
	

	
		-- VO
	
	pipeIn(0) :=	x"FF";	
	pipeIn(1) :=	x"FF";
	pipeIn(2) :=	x"12";	--pixel 12
	pipeIn(3) :=	x"00";	--V0
	
	
	-- Vp

	pipeIn(4) :=	x"00";	
	pipeIn(5) :=	x"08";	
	pipeIn(6) :=	x"12";	--pixel 12
	pipeIn(7) :=	x"01";	--Vp
	wait for 10 ns;	
	--
	
	WriteToPipeIn(x"80", 8);	--	usb3 injection 4 bytes
	wait for 10 ns;	


		-- VO
	
	pipeIn(0) :=	x"FF";	
	pipeIn(1) :=	x"FF";
	pipeIn(2) :=	x"13";	--pixel 13
	pipeIn(3) :=	x"00";	--V0
	
	
	-- Vp

	pipeIn(4) :=	x"00";	
	pipeIn(5) :=	x"08";	
	pipeIn(6) :=	x"13";	--pixel 13
	pipeIn(7) :=	x"01";	--Vp
	wait for 10 ns;	
	--
		
	WriteToPipeIn(x"80", 8);	--	usb3 injection 4 bytes
	wait for 10 ns;	

		-- VO
	
	pipeIn(0) :=	x"FF";	
	pipeIn(1) :=	x"FF";
	pipeIn(2) :=	x"14";	--pixel 14
	pipeIn(3) :=	x"00";	--V0
	
	
	-- Vp

	pipeIn(4) :=	x"00";	
	pipeIn(5) :=	x"08";	
	pipeIn(6) :=	x"14";	--pixel 14
	pipeIn(7) :=	x"01";	--Vp
	wait for 10 ns;	
	--
	
	WriteToPipeIn(x"80", 8);	--	usb3 injection 4 bytes
	wait for 10 ns;	

			-- VO
	
	pipeIn(0) :=	x"FF";	
	pipeIn(1) :=	x"FF";
	pipeIn(2) :=	x"15";	--pixel 15
	pipeIn(3) :=	x"00";	--V0
	
	
	-- Vp

	pipeIn(4) :=	x"00";	
	pipeIn(5) :=	x"08";	
	pipeIn(6) :=	x"15";	--pixel 15
	pipeIn(7) :=	x"01";	--Vp
	wait for 10 ns;	
	--
	
	WriteToPipeIn(x"80", 8);	--	usb3 injection 4 bytes
	wait for 10 ns;	


		-- VO
	
	pipeIn(0) :=	x"FF";	
	pipeIn(1) :=	x"FF";
	pipeIn(2) :=	x"16";	--pixel 16
	pipeIn(3) :=	x"00";	--V0
	
	
	-- Vp

	pipeIn(4) :=	x"00";	
	pipeIn(5) :=	x"08";	
	pipeIn(6) :=	x"16";	--pixel 16
	pipeIn(7) :=	x"01";	--Vp
	wait for 10 ns;	
	--
	
	WriteToPipeIn(x"80", 8);	--	usb3 injection 4 bytes
	wait for 10 ns;	

		-- VO
	
	pipeIn(0) :=	x"FF";	
	pipeIn(1) :=	x"FF";
	pipeIn(2) :=	x"17";	--pixel 17
	pipeIn(3) :=	x"00";	--V0
	
	
	-- Vp

	pipeIn(4) :=	x"00";	
	pipeIn(5) :=	x"08";	
	pipeIn(6) :=	x"17";	--pixel 17
	pipeIn(7) :=	x"01";	--Vp
	wait for 10 ns;	
	--
	
	WriteToPipeIn(x"80", 8);	--	usb3 injection 4 bytes
	wait for 10 ns;		

		-- VO
	
	pipeIn(0) :=	x"FF";	
	pipeIn(1) :=	x"FF";
	pipeIn(2) :=	x"18";	--pixel 18
	pipeIn(3) :=	x"00";	--V0
	
	
	-- Vp

	pipeIn(4) :=	x"00";	
	pipeIn(5) :=	x"08";	
	pipeIn(6) :=	x"18";	--pixel 18
	pipeIn(7) :=	x"01";	--Vp
	wait for 10 ns;	
	--
	
	WriteToPipeIn(x"80", 8);	--	usb3 injection 4 bytes
	wait for 10 ns;	


			-- VO
	
	pipeIn(0) :=	x"FF";	
	pipeIn(1) :=	x"FF";
	pipeIn(2) :=	x"19";	--pixel 19
	pipeIn(3) :=	x"00";	--V0
	
	
	-- Vp

	pipeIn(4) :=	x"00";	
	pipeIn(5) :=	x"08";	
	pipeIn(6) :=	x"19";	--pixel 19
	pipeIn(7) :=	x"01";	--Vp
	wait for 10 ns;	
	--
	
	WriteToPipeIn(x"80", 8);	--	usb3 injection 4 bytes
	wait for 10 ns;	
	
		-- VO
	
	pipeIn(0) :=	x"FF";	
	pipeIn(1) :=	x"FF";
	pipeIn(2) :=	x"1A";	--pixel 1A
	pipeIn(3) :=	x"00";	--V0
	
	
	-- Vp

	pipeIn(4) :=	x"00";	
	pipeIn(5) :=	x"08";	
	pipeIn(6) :=	x"1A";	--pixel 1A
	pipeIn(7) :=	x"01";	--Vp
	wait for 10 ns;	
	--
	
	WriteToPipeIn(x"80", 8);	--	usb3 injection 4 bytes
	wait for 10 ns;		

		-- VO
	
	pipeIn(0) :=	x"FF";	
	pipeIn(1) :=	x"FF";
	pipeIn(2) :=	x"1B";	--pixel 1B
	pipeIn(3) :=	x"00";	--V0
	
	
	-- Vp

	pipeIn(4) :=	x"00";	
	pipeIn(5) :=	x"08";	
	pipeIn(6) :=	x"1B";	--pixel 1B
	pipeIn(7) :=	x"01";	--Vp
	wait for 10 ns;	
	--
	
	WriteToPipeIn(x"80", 8);	--	usb3 injection 4 bytes
	wait for 10 ns;	

		-- VO
	
	pipeIn(0) :=	x"FF";	
	pipeIn(1) :=	x"FF";
	pipeIn(2) :=	x"1C";	--pixel 1C
	pipeIn(3) :=	x"00";	--V0
	
	
	-- Vp

	pipeIn(4) :=	x"00";	
	pipeIn(5) :=	x"08";	
	pipeIn(6) :=	x"1C";	--pixel 1C
	pipeIn(7) :=	x"01";	--Vp
	wait for 10 ns;	
	--
	
	WriteToPipeIn(x"80", 8);	--	usb3 injection 4 bytes
	wait for 10 ns;	

			-- VO
	
	pipeIn(0) :=	x"FF";	
	pipeIn(1) :=	x"FF";
	pipeIn(2) :=	x"1D";	--pixel 1D
	pipeIn(3) :=	x"00";	--V0
	
	
	-- Vp

	pipeIn(4) :=	x"00";	
	pipeIn(5) :=	x"08";	
	pipeIn(6) :=	x"1D";	--pixel 1D
	pipeIn(7) :=	x"01";	--Vp
	wait for 10 ns;	
	--
	
	WriteToPipeIn(x"80", 8);	--	usb3 injection 4 bytes
	wait for 10 ns;	


		-- VO
	
	pipeIn(0) :=	x"FF";	
	pipeIn(1) :=	x"FF";
	pipeIn(2) :=	x"1E";	--pixel 1E
	pipeIn(3) :=	x"00";	--V0
	
	
	-- Vp

	pipeIn(4) :=	x"00";	
	pipeIn(5) :=	x"08";	
	pipeIn(6) :=	x"1E";	--pixel 1E
	pipeIn(7) :=	x"01";	--Vp
	wait for 10 ns;	
	--
	
	WriteToPipeIn(x"80", 8);	--	usb3 injection 4 bytes
	wait for 10 ns;	

		-- VO
	
	pipeIn(0) :=	x"FF";	
	pipeIn(1) :=	x"FF";
	pipeIn(2) :=	x"1F";	--pixel 1F
	pipeIn(3) :=	x"00";	--V0
	
	
	-- Vp

	pipeIn(4) :=	x"00";	
	pipeIn(5) :=	x"08";	
	pipeIn(6) :=	x"1F";	--pixel 1F
	pipeIn(7) :=	x"01";	--Vp
	wait for 10 ns;	
	--
	WriteToPipeIn(x"80", 8);	--	usb3 injection 4 bytes
	wait for 10 ns;	
		-- VO
	
	pipeIn(0) :=	x"FF";	
	pipeIn(1) :=	x"FF";
	pipeIn(2) :=	x"20";	--pixel 20
	pipeIn(3) :=	x"00";	--V0
	
	
	-- Vp

	pipeIn(4) :=	x"00";	
	pipeIn(5) :=	x"08";	
	pipeIn(6) :=	x"20";	--pixel 20
	pipeIn(7) :=	x"01";	--Vp
	wait for 10 ns;	
	--
	
	WriteToPipeIn(x"80", 8);	--	usb3 injection 4 bytes
	wait for 10 ns;	

		-- VO
	
	pipeIn(0) :=	x"FF";	
	pipeIn(1) :=	x"FF";
	pipeIn(2) :=	x"21";	--pixel 21
	pipeIn(3) :=	x"00";	--V0
	
	
	-- Vp

	pipeIn(4) :=	x"00";	
	pipeIn(5) :=	x"08";	
	pipeIn(6) :=	x"21";	--pixel 21
	pipeIn(7) :=	x"01";	--Vp
	wait for 10 ns;	
	--
	
	WriteToPipeIn(x"80", 8);	--	usb3 injection 4 bytes
	wait for 10 ns;	
	

	
	
	wait for 4ms;

	-- apply all
	SetWireInValue(x"00", x"0000_0004", NO_MASK);
	UpdateWireIns;
	
	wait for 1000 ns;
	SetWireInValue(x"00", x"0000_0000", NO_MASK);
	UpdateWireIns;
	
	
	-- --pipeIn(0) := x"00000000";	--	reg 1	pixel one
	-- pipeIn(0) :=	x"01";	
	-- pipeIn(1) :=	x"00";
	-- pipeIn(2) :=	x"00";
	-- pipeIn(3) :=	x"00";	
	-- --pipeIn(1) := x"00000002";
	-- pipeIn(4) :=	x"15";	--	heat on 
	-- pipeIn(5) :=	x"00";
	-- pipeIn(6) :=	x"00";
	-- pipeIn(7) :=	x"80";	--	start on	

	-- WriteToPipeIn(x"80", 8);	--	usb3 injection 4*2 bytes
	
	-- --pipeIn(0) := x"00000000";	--	reg 1	pixel one
	-- pipeIn(0) :=	x"01";	
	-- pipeIn(1) :=	x"00";
	-- pipeIn(2) :=	x"00";
	-- pipeIn(3) :=	x"00";	
	-- --pipeIn(1) := x"00000002";
	-- pipeIn(4) :=	x"14";	--	heat off 
	-- pipeIn(5) :=	x"00";
	-- pipeIn(6) :=	x"00";
	-- pipeIn(7) :=	x"80";	--	start on	

	-- WriteToPipeIn(x"80", 8);	--	usb3 injection 4*2 bytes
	
	-- --pipeIn(0) := x"00000000";	--	reg 1	pixel one
	-- pipeIn(0) :=	x"33";	
	-- pipeIn(1) :=	x"00";
	-- pipeIn(2) :=	x"00";
	-- pipeIn(3) :=	x"00";	
	-- --pipeIn(1) := x"00000002";
	-- pipeIn(4) :=	x"ae";	
	-- pipeIn(5) :=	x"80";
	-- pipeIn(6) :=	x"08";	--	start on pixel
	-- pipeIn(7) :=	x"00";			
	
	-- WriteToPipeIn(x"80", 8);	--	usb3 injection 4*2 bytes
----------------------------------------------------------------------------	
---------------------stop five pixels---------------------------------------	
	-- wait for 3000 us;
	-- --pipeIn(0) := x"00000000";	--	reg 1	pixel one
	-- pipeIn(0) :=	x"01";	
	-- pipeIn(1) :=	x"00";
	-- pipeIn(2) :=	x"00";
	-- pipeIn(3) :=	x"00";	
	-- --pipeIn(1) := x"00000002";
	-- pipeIn(4) :=	x"14";	--	start off and truncation
	-- pipeIn(5) :=	x"00";
	-- pipeIn(6) :=	x"00";
	-- pipeIn(7) :=	x"00";	--	heat off
	
	-- WriteToPipeIn(x"80", 8);	--	usb3 injection 4*2 bytes

	-- --pipeIn(0) := x"00000000";	--	reg 2	pixel one
	-- pipeIn(0) :=	x"06";	
	-- pipeIn(1) :=	x"00";
	-- pipeIn(2) :=	x"00";
	-- pipeIn(3) :=	x"00";	
	-- --pipeIn(1) := x"00000002";
	-- pipeIn(4) :=	x"14";	--	start off and truncation
	-- pipeIn(5) :=	x"00";
	-- pipeIn(6) :=	x"00";
	-- pipeIn(7) :=	x"00";	--	heat off
	
	-- WriteToPipeIn(x"80", 8);	--	usb3 injection 4*2 bytes	

	-- --pipeIn(0) := x"00000000";	--	reg 3	pixel one
	-- pipeIn(0) :=	x"0B";	
	-- pipeIn(1) :=	x"00";
	-- pipeIn(2) :=	x"00";
	-- pipeIn(3) :=	x"00";	
	-- --pipeIn(1) := x"00000002";
	-- pipeIn(4) :=	x"14";	--	start off and truncation
	-- pipeIn(5) :=	x"00";
	-- pipeIn(6) :=	x"00";
	-- pipeIn(7) :=	x"00";	--	heat off
	
	-- WriteToPipeIn(x"80", 8);	--	usb3 injection 4*2 bytes	
	
	-- --pipeIn(0) := x"00000000";	--	reg 4	pixel one
	-- pipeIn(0) :=	x"10";	
	-- pipeIn(1) :=	x"00";
	-- pipeIn(2) :=	x"00";
	-- pipeIn(3) :=	x"00";	
	-- --pipeIn(1) := x"00000002";
	-- pipeIn(4) :=	x"14";	--	start off and truncation
	-- pipeIn(5) :=	x"00";
	-- pipeIn(6) :=	x"00";
	-- pipeIn(7) :=	x"00";	--	heat off
	
	-- WriteToPipeIn(x"80", 8);	--	usb3 injection 4*2 bytes	

	-- --pipeIn(0) := x"00000000";	--	reg 5	pixel one
	-- pipeIn(0) :=	x"15";	
	-- pipeIn(1) :=	x"00";
	-- pipeIn(2) :=	x"00";
	-- pipeIn(3) :=	x"00";	
	-- --pipeIn(1) := x"00000002";
	-- pipeIn(4) :=	x"14";	--	start off and truncation
	-- pipeIn(5) :=	x"00";
	-- pipeIn(6) :=	x"00";
	-- pipeIn(7) :=	x"00";	--	heat off
	
	-- WriteToPipeIn(x"80", 8);	--	usb3 injection 4*2 bytes		
---------------------------------------------------------------------------------	

	-- --	start on and truncation clear heat	
	-- wait for 1 ms;
	-- --pipeIn(0) := x"00000001";	--	reg 1	command1
	-- pipeIn(0) :=	x"00";
	-- pipeIn(1) :=	x"00";
	-- pipeIn(2) :=	x"00";
	-- pipeIn(3) :=	x"00";
	-- --pipeIn(1) := x"00000014";	--	clear heat	
	-- pipeIn(4) :=	x"06";	-- start on and truncation
	-- pipeIn(5) :=	x"00";
	-- pipeIn(6) :=	x"00";
	-- pipeIn(7) :=	x"00";	--heat off
	-- WriteToPipeIn(x"80", 8);	--	usb3 injection 4*2 bytes	
	
	-- -- popt 	
	-- wait for 700 us;	
	-- -- --pipeIn(0) := x"00000001";	--	reg 1	command1
	-- pipeIn(0) :=	x"01";
	-- pipeIn(1) :=	x"00";
	-- pipeIn(2) :=	x"00";
	-- pipeIn(3) :=	x"00";
	-- -- --pipeIn(1) := x"000001"&x"14";	--	Popt
	-- -- --22551014
	-- pipeIn(4) :=	x"14";
	-- pipeIn(5) :=	x"10";
	-- pipeIn(6) :=	x"55";
	-- pipeIn(7) :=	x"22";
	
	-- WriteToPipeIn(x"80", 8);	--	usb3 injection 4*2 bytes	

	-- wait for 20 ns;

	-- -- start simulate data 
	-- SetWireInValue(x"00", x"0000_0004", NO_MASK);
	-- UpdateWireIns;


	-- for indice_loop in 0 to 5000 loop	

		-- -- read wire
		-- UpdateWireOuts;	
		-- pipeInSize := conv_integer(GetWireOutValue(x"21"));
		
		-- -- read pipe out
		-- ReadFromPipeOut(x"A0", (pipeInSize-1)*16);



	-- wait for 1000 ns;	
		
	-- end loop;	
	
	
	-- for i_32bits in 0 to ((pipeInSize-1)/4) loop
		-- --for i in (0+(i_32bits*4)) to (3+(i_32bits*4)) loop
			-- i:=0+(i_32bits*4);
			-- pipeIn(i) := data_config(7 downto 0);
			-- i:=1+(i_32bits*4);
			-- pipeIn(i) := data_config(15 downto 8);
			-- i:=2+(i_32bits*4);
			-- pipeIn(i) := data_config(23 downto 16);
			-- i:=3+(i_32bits*4);
			-- pipeIn(i) := data_config(31 downto 24);
		-- --end loop;
	-- data_config := data_config + '1';	
	-- end loop;	
	
	--WriteToPipeIn(x"80", pipeInSize);
	
	--ReadFromPipeOut(x"A0", pipeInSize);
	
	wait;
	
	Check_Registers;
end process;
end simulate;