----------------------------------------------------------------------------------
-- Company       : CNRS - INSU - IRAP
-- Engineer      : Christophe OZIOL
-- Create Date   : 21/09/2017 
-- Design Name   : DRE XIFU FPGA_BOARD
-- Module Name   : Athena_package - Behavioral 
-- Project Name  : Athena XIfu DRE
-- Target Devices: Virtex 6 LX 240
-- Tool versions : ISE-14.7
-- Description   : Athena Package constants and parameter
--						 
-- Dependencies: 
--
-- Revision: 
-- Revision 0.1  - Adaptation FPGA_BOARD
-- Revision 0.01 - File Created
-- Additional Comments: 
--
---------------------------------------oOOOo(o_o)oOOOo-----------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.math_real.all;
--	  use WORK.PCIEX_PACKAGE.ALL;

--use ieee.std_logic_unsigned.all;
--use ieee.std_logic_arith.all;
--use std.textio.all;
---------------------------------------------------------------
--
-- PACKAGE
--
---------------------------------------------------------------
--! @brief-- Dependencies schematics -- 
--! @detail file:work_dependencies.svg
package athena_package is


-- Global Number of channel
constant C_Nb_channel 			: integer := 2; -- Number of channel
-- Global Number of pixel per channel
constant C_Nb_pixel 				: integer := 41; -- Number of pixel per channel
-- Number of configuration Registers 
constant C_NB_REG_CONF			: integer := ((C_Nb_channel*(C_Nb_pixel*2))+ (C_Nb_channel*4))+1+2;-- +1 GSE +2 ADDITIONNAL COMMANDS ;
-- Number of config Registers send on HK bus
constant C_NB_HK_FIFO			: integer := 255; -- +1 header(176) + 4 (multiple de 4);

----------------------------------------------------------------------------
-- Size DDS definitions
----------------------------------------------------------------------------

------------------------------------------------------------------------------
---- Parameters related to the control of the DDS
------------------------------------------------------------------------------
---------------------------------------------------------------------------------
-- Parameters related to the control of the DDS (use the software designed for)
---------------------------------------------------------------------------------
constant C_size_counter					: positive	:= 20;								-- Size of the counter, determines the frequency step Fstep = Fs/2**counter_size
constant C_REF_SINE_Depth				: positive 	:= 11; 								-- Depth of ROM for one period sine wave, (ROM_Depth-2) for a quarter of period
constant C_Size_ROM_Sine				: positive 	:= 18; 								-- Size of sine field in the DDS ROM
constant C_Size_ROM_delta				: positive 	:= 10;								-- Size of delta field in the DDS ROM 																			
----------------------------------------------------------------------------

constant C_Size_intrp 					: positive  := C_size_counter - C_REF_SINE_Depth; 	-- Size of interpolator field in the DDS counter
constant C_Size_quarter			  		: positive 	:= 2; 							-- Size of quarter field of the DDS counter
constant C_Size_DDS						: positive 	:= C_Size_ROM_Sine + 1 + 1; 		-- +1 sign bit PLUS +1 bit to reach -2^N (and not be limited by the limit (-2^N)+1)
constant C_REF_SINE_length				: integer  	:= 2**C_REF_SINE_Depth;
constant C_Size_dds_phi           		: positive  := 8;							-- Size of phases settings 
constant C_Size_dds_phi_ini       		: positive  := 12;  						-- Size of phase initial settings 
constant C_Size_bias_amplitude    		: positive  := 8; 							-- Size of the bias amplitude setting
constant C_Size_FEEDBACK_ST1_adder_out    		: integer := C_Size_DDS+2;		-- Number of feedback output bits (5 --> 2^5 = 64 closest number to 40)
constant C_Size_FEEDBACK_ST2_adder_out    		: integer := C_Size_DDS+4;		-- Number of feedback output bits (5 --> 2^5 = 64 closest number to 40)
constant C_Size_FEEDBACK_ST3_adder_out    		: integer := C_Size_DDS+6;		-- Number of feedback output bits (5 --> 2^5 = 64 closest number to 40)
constant C_Size_feedback_compensation_gain    	: integer := 16;					-- Number of feedback compensation gain 
constant C_Size_BIAS_ST1_adder_out        			: integer := C_Size_DDS+2;		-- Number of bias output bits (5 --> 2^5 = 64 closest number to 40)
constant C_Size_BIAS_ST2_adder_out        			: integer := C_Size_DDS+4;		-- Number of bias output bits (5 --> 2^5 = 64 closest number to 40)
constant C_Size_BIAS_ST3_adder_out        			: integer := C_Size_DDS+6;		-- Number of bias output bits (5 --> 2^5 = 64 closest number to 40)
constant C_nb_bits_wait_relock	        			: integer := 3;		-- Number of bits for relock length selection
---------------------------------------------------------------------------------
-- Parameters related to the control of the TEST BIAS MODULATION DDS (use the software designed for)
---------------------------------------------------------------------------------
constant C_size_mod_counter				: positive	:= 24;								-- Size of the counter, determines the frequency step Fstep = Fs/2**counter_size
constant C_mod_REF_SINE_depth			: positive 	:= 9; 								-- Depth of ROM for one period sine wave, (ROM_Depth-2) for a quarter of period
constant C_size_mod_rom_sine		   	: positive 	:= 13; 								-- Size of sine field in the DDS Modulation ROM
constant C_size_mod_rom_delta			: positive 	:= 7;								-- Size of delta field in the DDS Modulation ROM 																			
constant C_size_mod_intrp 				: positive  := C_size_mod_counter - C_mod_REF_SINE_depth;-- Size of interpolator field in the DDS counter
constant C_size_mod_dds					: positive 	:= C_size_mod_rom_sine + 1 + 1;
constant C_mod_REF_SINE_length			: integer  	:= 2**C_mod_REF_SINE_depth;

--------------------------------------------------------------------
constant C_Size_In_Real 				: positive := 12;	-- Size of input  <<<<<<<<<<--------------- should be 12
constant C_Size_science					: positive := 16;	-- Size of science data at output (I/Q)
constant C_Size_bias					: positive := 16;	-- Size of bias signal (for a whole channel, before bit selection for the DAC)
constant C_Size_one_bias				: positive := 16;	-- Size of pixel bias signal 
constant C_Size_gain					: positive := 8;	-- Size of BBFB gain
constant C_Size_one_feedback			: positive := C_Size_ROM_Sine + 1 + 1;	-- Size of feedback signal at BBFB output (single pixel)
constant C_Size_feedback				: positive := 22;	-- Size of feedback signal (for a whole channel, before bit selection for the DAC)
constant C_Constant_FB				: signed (C_Size_science-1 downto 0) := to_signed(256,C_Size_science);--"000000001000000000";--:=(others => '0');100 Hexa find by test
constant C_Size_bias_increment_ramp	: positive := 19; 	-- Number of bias_increment_rampe bits 20
constant C_Size_DAC					: integer  := 16; 	-- Number of DAC output bits 16
constant C_Size_DAC_FILTER_coeff	: integer  := 20; 	-- Number of DAC filter coeff bits 20
constant C_Size_SCI_FILTER_coeff	: integer  := 25; 	-- size of science filter coeff bits 25
constant C_Size_DC_notch_coeff		: integer  := 25; 	-- size of DAC filter coeff bits 25
constant C_order_DAC_FILTER			: integer  := 36; 	-- DAC filter order 36
constant C_Size_bias_to_DAC			: integer  := C_Size_DAC; -- Number of bias bits 16
constant C_Size_feedback_to_DAC		: integer  := C_Size_DAC; -- Number of feedback output bits 16

--- ####################### Function of the chain loop gain ###############
--constant Size_Accu					: integer := 29 + Size_science; -- RIGHT FOR THE WHOLE CHAIN => see demux firmware justification doc
--constant Size_Accu					: integer := 20 + Size_science; -- FOR USE ONLY FOR DRE DEVELOPMENTS ->20
--constant Size_Accu					: integer := (Size_In_Real+Size_sines) + 0 + Size_science;
constant C_Size_Accu					: integer := (C_Size_In_Real+C_Size_DDS) + C_Size_science -4;
--- #######################################################################



----------------------------------------------------------------------------
-- Parameters related to the control of the bias slope at start up
constant C_Size_slope_counter : positive := 24; -- Size of the counter which is controlling the bias slope at start-up
constant C_max_slope_counter  : positive := 2**C_Size_slope_counter-1;
--constant Size_slope_speed   : positive := 16; -- Size of the counter step parameter
constant C_Size_slope_factor  : positive := 10; -- Size of the slope value used to multiply the bias signal (MSB of the slope counter)

--CREATE type for array 32 bits register
type t_ARRAY32bits 	is array (natural range <>) of std_logic_vector(31 downto 0);
type t_ARRAY16bits 	is array (natural range <>) of std_logic_vector(15 downto 0);
type t_ARRAY32bitsU is array (natural range <>) of unsigned(31 downto 0);

--------- Create type for N channels signals -------------
type t_bias 							is array (C_Nb_channel-1 downto 0) of signed	(C_Size_bias_to_DAC-1 downto 0);		--type array of bias output
type t_in_phys 							is array (C_Nb_channel-1 downto 0) of signed	(C_Size_In_Real-1 downto 0);	--type array of physique input
type t_feedback 						is array (C_Nb_channel-1 downto 0) of signed	(C_Size_feedback-1 downto 0);	--type array of feedback input
type t_feedback_to_DAC					is array (C_Nb_channel-1 downto 0) of signed	(C_Size_feedback_to_DAC-1 downto 0);	--type array of feedback input
type t_science 							is array (C_Nb_pixel-1 downto 0) 	 of signed	(C_Size_science-1 downto 0);	--type array of science output
type t_science_channel					is array (C_Nb_channel-1 downto 0) of t_science;	--type array of science output
type t_TP_science_channel				is array (C_Nb_channel-1 downto 0) of signed (C_Size_science-1 downto 0);	--type array of science output
type t_register_ADC128 					is array (7 downto 0) 				 of std_logic_vector (11 downto 0);
type t_register_ADC128_ARRAY			is array (C_Nb_channel-1 downto 0) of t_register_ADC128;
type t_register_MUXED_ADC128			is array (14 downto 0) 				 of std_logic_vector (11 downto 0);
type t_register_MUXED_ADC128_ARRAY		is array (C_Nb_channel-1 downto 0) of	t_register_MUXED_ADC128;
type t_register_ALL_ADC128				is array ((23*C_Nb_channel)-1 downto 0)of std_logic_vector (11 downto 0);
type t_register_CDCM_SPI				is array (3 downto 0)  				 of std_logic_vector (31 downto 0);
type t_DAC_SPI_address 					is array (C_Nb_channel-1 downto 0) of std_logic_vector(4 downto 0);	
type t_std_logic_3_array 				is array (C_Nb_channel-1 downto 0) of std_logic_vector(2 downto 0);
type t_std_logic_array 					is array (C_Nb_channel-1 downto 0) of std_logic;
type t_std_logic_vector_array 			is array (C_Nb_channel-1 downto 0) of std_logic_vector(0 downto 0);
type t_std_logic_7_array 				is array (C_Nb_channel-1 downto 0) of std_logic_vector(6 downto 0);
type t_std_logic_8_array 				is array (C_Nb_channel-1 downto 0) of std_logic_vector(7 downto 0);
type t_unsigned_8_array 				is array (C_Nb_channel-1 downto 0) of unsigned(7 downto 0);
type t_std_logic_12_array 				is array (C_Nb_channel-1 downto 0) of std_logic_vector(11 downto 0);
type t_signed_12_array 					is array (C_Nb_channel-1 downto 0) of signed(11 downto 0);
type t_std_logic_16_array 				is array (C_Nb_channel-1 downto 0) of std_logic_vector(15 downto 0);
type t_Pulse_Ram is array ((2**C_REF_SINE_Depth)-1 downto 0) of std_logic_vector(31 downto 0);

-- CONTROL and STATUS of CLOCK AND CDCM7005
type t_CONTROL_CMM
	is record --type of CONTROL CDCM CLOCK GENERAL INPUT SELECT and RESET OF MMCM FPGA INTERNAL PLL
		CLK_CDCM_SELECT			: std_logic;-- software CLK_SELECT
		CLK_CDCM_PLL_RESET		: std_logic;-- software internal MMCM of CDCM clock reset
	end record;
type t_STATUS_CMM
	is record --type of STATUS CDCM CLOCK GENERAL INPUT SELECTED and RESET/LOCKED OF MMCM FPGA INTERNAL PLL
		CDCM_RESETn				: std_logic;-- Hardware CDCM RESET
		CLK_CDCM_SELECT			: std_logic;-- software CLK_SELECT
		CLK_CDCM_PLL_RESET		: std_logic;-- software internal MMCM of CDCM clock reset
		CLK_LOCKED_CDCM			: std_logic;-- internal MMCM of FPGA clock LOCKED on CDCM CLOCK INPUT
		CLK_LOCKED_200MHz		: std_logic;-- internal MMCM of FPGA clock LOCKED on 200MHz CLOCK INPUT
	end record;
type t_STATUS_CDCM
	is record --type of STATUS CDCM CLOCK GENERAL INPUT SELECTED and RESET/LOCKED OF MMCM FPGA INTERNAL PLL
		STATUS_REF				: std_logic;-- Hardware CDCM RESET
		PLL_LOCK				: std_logic;-- software CLK_SELECT
		STATUS_VCXO				: std_logic;-- software internal MMCM of CDCM clock reset
	end record;

-- CONTROL and STATUS of ADC RHF1201
type t_CONTROL_RHF1201 
	is record --type of RHF1201 CONTROL MODE SLEW RATE ad DATA FORMAT (signed/not signed) 
		SLEW_RATE_CONTROL		: std_logic; -- SLEW RATE control of RHF1201
		DATA_FORMAT_SEL_N		: std_logic; -- Data format select of RHF1201
		ADC_ON					: std_logic; -- On of clock ADC
	end record;
type t_CONTROL_RHF1201S	 	is array (C_Nb_channel-1 downto 0) of t_CONTROL_RHF1201;	-- type N CHANNELS array of CHANNEL CONTROL (CONTROL_PIXELS,Config_BBFB)

type t_STATUS_RHF1201 
	is record --type of RHF1201 STATUS OUT_OF_RANGE and ADC_READY
		OUT_OF_RANGE			: std_logic; -- Out of range RHF1201
		ADC_OE_N				: std_logic; -- Output enable bar status
		ADC_READY				: std_logic; -- RHF1201 Ready
	end record;
type t_STATUS_RHF1201S 		is array (C_Nb_channel-1 downto 0) of t_STATUS_RHF1201;	-- type N CHANNELS array of CHANNEL CONTROL (CONTROL_PIXELS,Config_BBFB)
	
-- CONTROL and STATUS of DAC AD9726
type t_CONTROL_AD9726
	is record --type of AD9726 CONTROL DAC RESET and DAC CLOCK/DATA ON
		DAC_RESET				: std_logic; -- RESET of DAC AD9726
		DAC_ON					: std_logic; -- Data and CLOCK AD9726 on
	end record;
type t_CONTROL_AD9726_CHANNEL 
	is record --type of CONTROL of 1 channel with 2 AD9726 (DACF/DACB)
		DACF					: t_CONTROL_AD9726; -- Control of DACF AD9726
		DACB					: t_CONTROL_AD9726; -- Control of DACB AD9726
	end record;
type t_CONTROL_AD9726S	 	is array (C_Nb_channel-1 downto 0) of t_CONTROL_AD9726_CHANNEL;	-- type N CHANNELS array of CHANNEL CONTROL (CONTROL_PIXELS,Config_BBFB)
type t_STATUS_AD9726
	is record --type of AD9726 STATUS DAC_RESET output status, DAC_ON status, SPI logic status
		DAC_RESET				: std_logic; -- STATUS of RESET of AD9726
		DAC_ON					: std_logic; -- AD9726 ouput and digital clock out ON
	end record;
type t_STATUS_AD9726_CHANNEL
	is record --type of STATUS of 1 channel with 2 AD9726 (DACF/DACB) 
		DACF					: t_STATUS_AD9726; -- STATUS of DACF AD9726
		DACB					: t_STATUS_AD9726; -- STATUS of DACB AD9726
	end record;
type t_STATUS_AD9726S 		is array (C_Nb_channel-1 downto 0) of t_STATUS_AD9726_CHANNEL;	-- type N CHANNELS array of CHANNEL CONTROL (CONTROL_PIXELS,Config_BBFB)

--SPI CONTROL AND STATUS
type t_CONTROL_SPI 
	is record --type of CDCM CONTROL (increment,amplitude,Phases,resetBBFB,Integrator Gain BBFB)
		SPI_data_to_send		: std_logic_vector(31 downto 0);
		Select_SPI_Channel		: std_logic_vector(4 downto 0);
		SPI_write 				: std_logic;
	end record;

type t_STATUS_SPI 
	is record --type of SPI STATUS(Received DATA, SPI_READY)
		SPI_data_Received		: std_logic_vector(7 downto 0);
		SPI_ready 				: std_logic;
	end record;

type t_CONTROL_GSE	is
		record
			select_TM					: unsigned (3 downto 0);
			select_HK					: unsigned (1 downto 0);
			START_SENDING_TM			: STD_LOGIC;
			START_SENDING_HK			: STD_LOGIC;
			
		end record;
type t_CONTROL_PIXEL
	is record --type of PIXEL CONTROL (increment,amplitude,Phases,resetBBFB,Integrator Gain BBFB)
		increment						: unsigned (C_size_counter-1 downto 0);-- pixel increment bias counter_size bits
		BIAS_amplitude					: unsigned (C_Size_bias_amplitude-1 downto 0);-- pixel amplitude bias size_bias_amplitude bits
		PHI_DELAY						: unsigned (C_Size_dds_phi-1 downto 0);-- pixel COMPENSATION DELAY PHASE size_dds_phi bits
		PHI_INITIAL						: unsigned (C_Size_dds_phi_ini-1 downto 0);-- pixel INITIAL PHASE Size_dds_phi_ini bits
		PHI_ROTATE						: unsigned (C_Size_dds_phi-1 downto 0);-- pixel ROTATEIQ OUPUT PHASE Size_dds_phi bits
		gain_BBFB						: unsigned (C_Size_gain-1 downto 0);-- pixel BBFB INTEGRATOR GAIN Size_gain bits
		SW1								: std_logic; -- selection mode PID loop
		SW2								: unsigned (1 downto 0);-- selection mode PID loop
	end record;
type t_CONTROL_PIXELS 		is array (C_Nb_pixel-1 downto 0) of t_CONTROL_PIXEL; -- create array of PIXEL CONTROL (increment,amplitude,Phases,resetBBFB,Integrator Gain BBFB)

type t_CONTROL_CHANNEL	is 
		record
			FEEDBACK_truncation			: unsigned (1 downto 0);
			BIAS_truncation				: unsigned (1 downto 0);
			BIAS_slope_speed			: unsigned (1 downto 0);
			BIAS_modulation_increment	: unsigned (C_size_mod_counter-1 downto 0);
			BIAS_modulation_amplitude	: unsigned (C_Size_bias_amplitude-1 downto 0);
			Send_pulse					: STD_LOGIC;
			Pulse_Amplitude				: unsigned (7 downto 0);
			Pulse_timescale				: unsigned (3 downto 0);
			FEEDBACK_Enable				: STD_LOGIC;
			BIAS_Enable					: STD_LOGIC;
			select_Input				: unsigned (1 downto 0);
			non_linearity_ON			: STD_LOGIC;
			START_STOP					: STD_LOGIC;
			Loop_control				: unsigned (3 downto 0);
			feedback_reverse			: STD_LOGIC;
			FEEDBACK_compensation_gain 	: unsigned (15 downto 0);
			Delock_level				: signed(C_Size_In_Real-1 downto 0);
			Delock_on					: STD_LOGIC;
			manual_delock				: STD_LOGIC;
			Wait_for_relock				: unsigned (C_nb_bits_wait_relock-1 downto 0);
			CONTROL_PIXELS				: t_CONTROL_PIXELS;
		end record;
type t_CONTROL_CHANNELS 	is array (C_Nb_channel-1 downto 0) of t_CONTROL_CHANNEL;	-- type N CHANNELS array of CHANNEL CONTROL (CONTROL_PIXELS,Config_BBFB)

type t_STATUS_CHANNEL	is 
		record
			DELOCK_COUNT					: std_logic_VECTOR (7 downto 0);	  -- quantitiy of delock done
		end record;

type t_STATUS_CHANNELS 	is array (C_Nb_channel-1 downto 0) of t_STATUS_CHANNEL;	-- type N CHANNELS array of CHANNEL STATUS
													
-- create a M Channels pixels control signals array type (for the Nb_Pixel pixels for Nb_channel channel)
type t_IDENTIFIER
 	is record --type of CONTROL (ALL CONTROLS)
		BOARD_ID					: std_logic_VECTOR (15 downto 0); -- BOARD SERIAL NUMBER
		MODEL_ID					: std_logic_VECTOR (3 downto 0);  -- MODEL OF BOARD IDENTIFIER (PROTO,DM,FM,QM,EM...)
		BOARD_VERSION				: std_logic_VECTOR (11 downto 0); -- VERSION OF BOARD IDENTIFIER
		FIRMWARE_ID					: std_logic_VECTOR (15 downto 0); -- FPGA FIRMWARE ID
		NB_CHANNEL					: std_logic_VECTOR (1 downto 0);  -- NB of CHANNEL in FPGA
		NB_PIXEL					: std_logic_VECTOR (6 downto 0);  -- NB of PIXEL Per CHANNEL in FPGA
	end record;

type t_CONTROL
	is record --type of CONTROL (ALL CONTROLS)
		DACs_RESET			: std_logic; --GENERAL DACs RESET
		GSE 				: t_CONTROL_GSE;
		CMM					: t_CONTROL_CMM;
		CHANNELs 			: t_CONTROL_CHANNELS;
		RHF1201s			: t_CONTROL_RHF1201S;
		AD9726s				: t_CONTROL_AD9726S;
		SPI 				: t_CONTROL_SPI;
	end record;
type t_STATUS
	is record --type of STATUS (ALL STATUS)
		IDENTIFIER		: t_IDENTIFIER;
		CHANNELS		: t_STATUS_CHANNELS;
		SPI_CONTROLER	: t_STATUS_SPI;
		RHF1201s		: t_STATUS_RHF1201S; -- RHF1201S STATUS
		AD9726s			: t_STATUS_AD9726S; -- AD9726 STATUS for each channel
		CMM				: t_STATUS_CMM; -- CMM and CLOCK STATUS
		CDCM			: t_STATUS_CDCM; -- CMM and CLOCK STATUS
	end record;
end athena_package;