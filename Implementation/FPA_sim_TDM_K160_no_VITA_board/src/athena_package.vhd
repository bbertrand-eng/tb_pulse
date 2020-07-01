----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:56:10 04/01/2015 
-- Design Name: 
-- Module Name:    athena_package - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
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
package athena_package is


-- Global Number of channel
constant Nb_channel 			: integer := 2; -- Number of channel
-- Global Number of pixel per channel
constant Nb_pixel 				: integer := 41; -- Number of pixel per channel
constant C_NB_REG_CONF			: integer := ((Nb_channel*(Nb_pixel*2))+ (Nb_channel*3))+1+2+3;-- +1 GSE +2 ADDITIONNAL COMMANDS +3 to complete read 32;

----------------------------------------------------------------------------
-- Size DDS definitions
----------------------------------------------------------------------------

------------------------------------------------------------------------------
---- Parameters related to the control of the DDS
------------------------------------------------------------------------------
---------------------------------------------------------------------------------
-- Parameters related to the control of the DDS (use the software designed for)
---------------------------------------------------------------------------------
constant counter_size				: positive	:= 16;																				-- Size of the counter, determines the frequency step Fstep = Fs/2**counter_size
constant ROM_Depth					: positive 	:= 9; 																			-- Depth of ROM for one period sine wave, (ROM_Depth-2) for a quarter of period
constant Size_ROM_Sine			   : positive 	:= 18; 																			-- Size of sine field in the DDS ROM
constant Size_ROM_delta				: positive 	:= 12;																				-- Size of delta field in the DDS ROM 																			
----------------------------------------------------------------------------

constant Size_intrp 					: positive  := counter_size - ROM_Depth; 												-- Size of interpolator field in the DDS counter
constant Size_quarter			  	: positive 	:= 2; 																			-- Size of quarter field of the DDS counter
constant Size_DDS_Sine_Out			: positive 	:= Size_ROM_Sine + 1 + 1; 													-- +1 sign bit PLUS +1 bit to reach -2^N (and not be limited by the limit (-2^N)+1)
constant Size_DDS						: positive 	:= Size_DDS_Sine_Out;
constant ROM_Range					: integer  	:= 2**ROM_Depth;
constant Size_dds_phi           	: positive  := 8;  																			-- Size of phases settings 
constant Size_dds_phi_ini       	: positive  := 12;  																			-- Size of phases settings 
constant Size_bias_amplitude    	: positive  := 8; 																			-- Size of the bias amplitude setting
--constant Size_feedback_adder_out				: integer := Nb_pixel + Size_DDS_Sine_Out+1; 																				-- Number of feedback output bits 30
--constant Size_BIAS_adder_out					: integer := Nb_pixel + Size_DDS_Sine_Out+1; 										-- Number of feedback output bits =Nb_PIXEL+ 1 +Size_DDS_Sine_Out
constant Size_feedback_adder_out    			: integer := 5 + Size_DDS+1;			-- Number of feedback output bits (5 --> 2^5 = 64 closest number to 40)
constant Size_feedback_compensation_gain    	: integer := 16;				-- Number of feedback compensation gain 
constant Size_BIAS_adder_out        			: integer := 5 + Size_DDS+1;			-- Number of bias output bits (5 --> 2^5 = 64 closest number to 40)



--constant Size_dds_counter_addr  : positive := 10; -- Size of ROM address field in the DDS counter
--constant Size_dds_counter_intrp : positive := 10; -- Size of interpolator field in the DDS counter
--constant Size_dds_counter       : positive := Size_dds_counter_addr + Size_dds_counter_intrp;
--constant Size_dds_phi           : positive := 8;  -- Size of phases settings 
--constant Size_bias_amplitude    : positive := 10; -- Size of the bias amplitude setting
--constant Size_rom_dds_address   : positive := Size_dds_counter_addr - 2; -- Size of ROM address 	
--constant Size_rom               : positive := 2**Size_rom_dds_address;   -- Size of ROM	
--constant Size_ROM_dds_data      : positive := 23; -- Size of ROM data 	
--constant Size_ROM_dds_sine      : positive := 13; -- Size of the "Sine" filed in the ROM data 
--constant Size_ROM_dds_slope     : positive := 10; -- Size of the "Slope" field in the ROM data
------------------------------------------------------------------------------
----constant Size_ROM_delta			  : positive := 10; -- 
--constant ROM_Depth					: positive := 10; -- Depth of ROM
--constant Size_ROM_Sine			  : positive := 13; -- Size of sine field in the DDS ROM
--constant Size_ROM_delta				: positive := 4;--integer((log(20000000.0/10.0)/log(2.0))) - Rom_Depth;-- Size of delta field in the DDS ROM = integer((log(FS/F_resolution)/log(2.0))) - Rom_Depth 
--constant Size_quarter			  	: positive := 2; -- Size of quarter field of the DDS counter
--constant Size_dds_counter_addr  	: positive := ROM_Depth; -- Size of ROM address field in the DDS counter
--constant Size_dds_counter_intrp 	: positive := ROM_Depth; -- Size of interpolator field in the DDS counter
--constant Size_dds_counter       	: positive := Size_dds_counter_addr + Size_dds_counter_intrp;
--constant Size_rom_dds_address   	: positive := Size_dds_counter_addr-2; -- Size of ROM address 	
--constant Size_rom               : positive := 2**Size_dds_counter_addr;   -- Size of ROM	
--constant Size_ROM_dds_data      : positive := Size_ROM_Sine + Size_ROM_delta; -- Size of ROM data 	
--constant Size_ROM_dds_sine      : positive := Size_ROM_Sine; -- Size of the "Sine" filed in the ROM data 
--constant Size_ROM_dds_slope     : positive := Size_ROM_delta; -- Size of the "Slope" field in the ROM data
----------------------------------------------------------------------------------
--PARAMETERS HP FILTER
------------------------------
constant HPFacc_size 	: positive 	:= 28; -- Size of HighPass Filter accumulator
constant HPF_size_in  	: positive 	:= 16; -- Size of HighPass Filter input
constant HPF_size_out  	: positive 	:= 16; -- Size of HighPass Filter output
constant	HPF_gain_size	: positive	:= 12; --12 bits -- 2^HPF_gain_size bit division into HPF -> sets the high cutoff frequency

--------------------------------------------------------------------

--constant Size_dds_counter 			: positive := 20;
--constant Size_dds_counter_addr	: positive := 10;	-- ROM size
--constant Size_dds_counter_intrp	: positive := 10;	-- ROM size
--constant Size_dds_phi				: positive := 8;	-- Size of phases settings 
--constant Size_bias_amplitude		: positive := 11;	-- Size of bias amplitude setting 
--constant Size_ROM_dds_data			: positive := 29;	-- Size of ROM data 	
--constant Size_ROM_dds_address		: positive := 29;	-- Size of ROM data 	
--constant Size_ROM_dds_sine			: positive := 18;	-- Size of the "Sine" filed in the ROM data 
--constant Size_ROM_dds_slope		: positive := 11;	-- Size of the "Slope" field in the ROM data
constant Size_sines  				: positive := Size_DDS_Sine_Out;	-- Size of DDS output
constant Size_In_Real 				: positive := 12;	-- Size of input  <<<<<<<<<<--------------- should be 12
constant Size_science				: positive := 16;	-- Size of science data at output (I/Q)
constant Size_bias					: positive := 16;	-- Size of bias signal (for a whole channel, before bit selection for the DAC)
constant Size_one_bias				: positive := 16;	-- Size of pixel bias signal 
constant Size_gain					: positive := 8;	-- Size of BBFB gain
--constant Size_accu					: positive := 22; -- Size of I/Q accumulators
constant Size_one_feedback			: positive := Size_ROM_Sine + 1 + 1;	-- Size of feedback signal at BBFB output (single pixel)
constant Size_feedback				: positive := 22;	-- Size of feedback signal (for a whole channel, before bit selection for the DAC)
constant Constant_FB					: signed(Size_sines-1 downto 0) := to_signed(128,Size_sines);--"000000001000000000";--:=(others => '0');
constant Size_bias_increment_ramp: positive := 19; -- Number of bias_increment_rampe bits 20
constant Size_DAC						: integer := 16; -- Number of DAC output bits 16
constant Size_bias_to_DAC			: integer := Size_DAC; -- Number of bias bits 16
constant Size_feedback_to_DAC		: integer := Size_DAC; -- Number of feedback output bits 16
constant Size_Accu					: integer := integer(realmax(real(Size_DDS),real(Size_In_Real+Size_gain+1)));

----------------------------------------------------------------------------
-- Parameters related to the control of the bias slope at start up
constant Size_slope_counter : positive := 24; -- Size of the counter which is controlling the bias slope at start-up
constant max_slope_counter  : positive := 2**Size_slope_counter-1;
--constant Size_slope_speed   : positive := 16; -- Size of the counter step parameter
constant Size_slope_factor  : positive := 10; -- Size of the slope value used to multiply the bias signal (MSB of the slope counter)

--CREATE type for array 32 bits register
type ARRAY32bits 	is array (integer range <>) of std_logic_vector(31 downto 0);
type ARRAY16bits 	is array (natural range <>) of std_logic_vector(15 downto 0);
type ARRAY32bitsU is array (natural range <>) of unsigned(31 downto 0);

--------- Create type for N channels signals -------------
type t_bias 					is array (Nb_channel-1 downto 0) of signed	(Size_bias_to_DAC-1 downto 0);		--type array of bias output
type t_in_phys 				is array (Nb_channel-1 downto 0) of signed	(Size_In_Real-1 downto 0);	--type array of physique input
type t_feedback 				is array (Nb_channel-1 downto 0) of signed	(Size_feedback-1 downto 0);	--type array of feedback input
type t_feedback_to_DAC		is array (Nb_channel-1 downto 0) of signed	(Size_feedback_to_DAC-1 downto 0);	--type array of feedback input
type t_science 				is array (Nb_pixel-1 downto 0) 	of signed	(Size_science-1 downto 0);	--type array of science output
type t_science_channel		is array (Nb_channel-1 downto 0) of t_science;	--type array of science output
type t_register_ADC128 		is array (0 to 7) of std_logic_vector (11 downto 0);

type t_CONTROL_PIXEL_BBFB is record --type of PIXEL CONTROL (increment,amplitude,Phases,resetBBFB,Integrator Gain BBFB)

										increment						: unsigned (counter_size-1 downto 0);-- := "000011001000000000000"pixel increment bias 20 bits
										BIAS_amplitude					: unsigned (Size_bias_amplitude-1 downto 0);-- := B"00000001000"pixel amplitude bias 11 bits
										PHI_DELAY						: unsigned (Size_dds_phi-1 downto 0);--:="00000000" pixel COMPENSATION DELAY PHASE 8bits
										PHI_INITIAL						: unsigned (Size_dds_phi_ini-1 downto 0);--:="00000000" pixel START PHASE 12bits
										PHI_ROTATE						: unsigned (Size_dds_phi-1 downto 0);--:="00000000" pixel ROTATEIQ OUPUT PHASE 8bits
										gain_BBFB						: unsigned (Size_gain-1 downto 0);--:="00001000" pixel BBFB INTEGRATOR GAIN
										SW1								: std_logic;
										SW2								: unsigned (1 downto 0);
													
							end record;
type t_CONTROL_RHF1201 is record --type of PIXEL CONTROL (increment,amplitude,Phases,resetBBFB,Integrator Gain BBFB)

													SLEW_RATE_CONTROL		: std_logic; -- SLEW RATE control of RHF1201
													DATA_FORMAT_SEL_N		: std_logic; -- Data format select of RHF1201
													ADC_ON					: std_logic; -- ON/OFF RHF1201
							end record;
type t_STATUS_RHF1201 is record --type of PIXEL CONTROL (increment,amplitude,Phases,resetBBFB,Integrator Gain BBFB)

													OUT_OF_RANGE			: std_logic; -- Out of range RHF1201
													ADC_READY				: std_logic; -- RHF1201 Ready
							end record;
type 	t_CONTROL_SPI is record --type of CDCM CONTROL (increment,amplitude,Phases,resetBBFB,Integrator Gain BBFB)

													SPI_data_to_send		: unsigned(31 downto 0);
													Select_SPI_Channel	: unsigned(4 downto 0);
													SPI_write 				: std_logic;
							end record;
type 	t_STATUS_SPI is record --type of SPI STATUS(increment,amplitude,Phases,resetBBFB,Integrator Gain BBFB)

													SPI_Received_data		: unsigned(7 downto 0);
													SPI_ready 				: std_logic;
							end record;
-- create a pixel control signal array type for the N pixels
type t_CONTROL_PIXELS is array (Nb_Pixel-1 downto 0) of t_CONTROL_PIXEL_BBFB; -- create array of PIXEL CONTROL (increment,amplitude,Phases,resetBBFB,Integrator Gain BBFB)



type t_CONTROL_GSE	is
		record
			select_TM					: unsigned (3 downto 0);
			select_HK					: unsigned (1 downto 0);
			START_SENDING_TM			: STD_LOGIC;
			START_SENDING_HK			: STD_LOGIC;
			START_STOP					: STD_LOGIC;
			
		end record;

type t_CONTROL_CHANNEL	is 
		record
			FEEDBACK_truncation			: unsigned (1 downto 0);
			FEEDBACK_compensation_gain : unsigned (15 downto 0);
			BIAS_truncation				: unsigned (1 downto 0);
			BIAS_slope_speed				: unsigned (1 downto 0);
			BIAS_modulation_increment	: unsigned (23 downto 0);
			BIAS_modulation_amplitude	: unsigned (7 downto 0);
			FEEDBACK_Enable				: STD_LOGIC;
			BIAS_Enable						: STD_LOGIC;
			select_Input					: unsigned (1 downto 0);
			DACF_on							: STD_LOGIC;
			DACB_on							: STD_LOGIC;
			Loop_control					: unsigned (3 downto 0);
			CONTROL_PIXELS					: t_CONTROL_PIXELS;
		end record;
													
-- create a M Channels pixels control signals array type (for the Nb_Pixel pixels for Nb_channel channel)

type t_CONTROL_CHANNELS 	is array (Nb_channel-1 downto 0) of t_CONTROL_CHANNEL;	-- type N CHANNELS array of CHANNEL CONTROL (CONTROL_PIXELS,Config_BBFB)
type t_CONTROL_RHF1201S	 	is array (Nb_channel-1 downto 0) of t_CONTROL_RHF1201;	-- type N CHANNELS array of CHANNEL CONTROL (CONTROL_PIXELS,Config_BBFB)
type t_STATUS_RHF1201S 		is array (Nb_channel-1 downto 0) of t_STATUS_RHF1201;	-- type N CHANNELS array of CHANNEL CONTROL (CONTROL_PIXELS,Config_BBFB)
----------------------------------------------------------------------------
-- ML605 AND FMC COMTROLER
----------------------------------------------------------------------------

COMPONENT RHF1201_controler
    Port (
 			  CLK_4X					: in  STD_LOGIC;
			  CLK_1X					: in  STD_LOGIC;
           ENABLE_CLK_1X		: in  STD_LOGIC;
			  RESET 					: in  STD_LOGIC;
		  
			  CONTROL_RHF1201		: in	t_CONTROL_RHF1201;
			  STATUS_RHF1201		: out	t_STATUS_RHF1201;
           OUT_OF_RANGE_ADC	: in  STD_LOGIC;
           OUT_OF_RANGE 		: out STD_LOGIC;
           DIN 					: in  SIGNED (11 downto 0);
           DOUT 					: out SIGNED (11 downto 0);
           DATA_READY 			: in  STD_LOGIC;
           CLOCK_TO_ADC 		: out STD_LOGIC;
           CLOCK_FROM_ADC 		: in  STD_LOGIC;
			  ADC_READY				: OUT STD_LOGIC;
           OE_N 					: out STD_LOGIC;
           SLEW_RATE_CONTROL 	: out STD_LOGIC;
           DATA_FORMAT_SEL_N 	: out STD_LOGIC
			  );
end COMPONENT RHF1201_controler;

COMPONENT ADC128S102_controler is
	port ( 
			Reset	         	: in    std_logic; 
			clk_4X	      	: in    std_logic; 
			ENABLE_CLK_1X  	: in    std_logic;  
			-- Control
			 
			Output_registers  : out   t_register_ADC128; -- array de 8 std_logic_vector (max de channel qu'on peut acquérir)
			Start             : in    std_logic; 
			Read_register		: in    std_logic; 
			Done              : out   std_logic; -- indique que le registre est Ã  jour (toutes les valeurs demandÃ©es sont updatées)
			-- ADC
			Sclk       			: out   std_logic;
			Dout  		     	: in    std_logic;
			Din       		 	: out   std_logic;
			Cs_n 	   			: out   std_logic
			 
			 );
end COMPONENT ADC128S102_controler;

COMPONENT CONF_sender_USB30
    Port ( 
			START_SENDING_CONF		: in  std_logic;	
-- CLOCKS	
			CLK_4X						: in  std_logic; --CLK_4X
			CLK_1X						: in std_logic; --CLK_1X = clk4X div 4
			ENABLE_CLK_1X_DIV64		: in  std_logic; --CLK_1X_DIV64
			ONE_SECOND					: in  std_logic;
			CONF							: in  std_logic;
			CONF_AUTO					: in  std_logic;
-- TO USB 3.0 manager
			RESET							: in  std_logic;         CONF_usb_Data				: OUT STD_LOGIC_VECTOR (7 downto 0);
         CONF_usb_Rdy_n				: in 	STD_LOGIC;
         CONF_usb_WR					: out	STD_LOGIC

			);
end COMPONENT CONF_sender_USB30;

COMPONENT ram_config
  PORT (
    clka 		: IN 	STD_LOGIC;
    wea 			: IN 	STD_LOGIC_VECTOR(0 DOWNTO 0);
    addra 		: IN 	STD_LOGIC_VECTOR(6 DOWNTO 0);
    dina 		: IN 	STD_LOGIC_VECTOR(31 DOWNTO 0);
    clkb 		: IN 	STD_LOGIC;
    addrb 		: IN 	STD_LOGIC_VECTOR(6 DOWNTO 0);
    doutb 		: OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
  );
END COMPONENT;

COMPONENT fifo_out_to_daq_32_32
  PORT (
    rst 			: IN 	STD_LOGIC;
    wr_clk 		: IN 	STD_LOGIC;
    rd_clk 		: IN 	STD_LOGIC;
    din 			: IN 	STD_LOGIC_VECTOR(31 DOWNTO 0);
    wr_en 		: IN 	STD_LOGIC;
    rd_en 		: IN 	STD_LOGIC;
    dout 		: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    full 		: OUT STD_LOGIC;
    valid 		: OUT STD_LOGIC;
    empty 		: OUT STD_LOGIC
  );
END COMPONENT;

COMPONENT fifo_out_to_HK_32_8
  PORT (
    rst 			: IN 	STD_LOGIC;
    wr_clk 		: IN 	STD_LOGIC;
    rd_clk 		: IN 	STD_LOGIC;
    din 			: IN 	STD_LOGIC_VECTOR(31 DOWNTO 0);
    wr_en 		: IN 	STD_LOGIC;
    rd_en 		: IN 	STD_LOGIC;
    dout 		: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    full 		: OUT STD_LOGIC;
    almost_full: OUT STD_LOGIC;
    valid 		: OUT STD_LOGIC;
    empty 		: OUT STD_LOGIC
  );
END COMPONENT;

COMPONENT fifo_in_config_8_to_32
  PORT (
    rst 			: IN 	STD_LOGIC;
    wr_clk 		: IN 	STD_LOGIC;
    rd_clk 		: IN 	STD_LOGIC;
    din 			: IN 	STD_LOGIC_VECTOR(7 DOWNTO 0);
    wr_en 		: IN 	STD_LOGIC;
    rd_en 		: IN 	STD_LOGIC;
    dout 		: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    almost_full: OUT STD_LOGIC;
    full 		: OUT STD_LOGIC;
    valid 		: OUT STD_LOGIC;
    empty 		: OUT STD_LOGIC
  );
END COMPONENT;


--
COMPONENT Select_output_to_HK is
    Port ( 
-- FROM XIFU
			ADC128_registers				: in  t_register_ADC128;
			ADC128_Done						: in  std_logic;
			ADC128_start_HK_USB30		: out std_logic;
			ADC128_Read_register			: out std_logic;
			regCONFIG       				: in  ARRAY32bits(0 to C_NB_REG_CONF-1);--4);
			STATUS							: in  std_logic_vector(31 downto 0);

--			OUTPUT SELECTOR 				: AT CLK_1X 10MHz, 32 bits Words
			select_HK						: in  unsigned (1 downto 0);
			START_SENDING_HK				: in  std_logic;	
-- CLOCKS	
--			CLK_4X							: in  std_logic; --CLK_4X
			CLK_1X_DIV64					: in  std_logic; --CLK_1X_DIV64
--			CLK_1X_DIV64					: in  std_logic; --CLK_1X_DIV64
			ONE_SECOND						: in  std_logic;
-- TO USB 3.0 manager
			RESET								: in  std_logic;			rd_en_HK_usb_fifo				: in  std_logic;			HK_TO_USB_SEND					: out std_logic_vector(7 downto 0);			empty_HK_usb_fifo				: out std_logic;			valid_HK_usb_fifo				: out std_logic;			HK_CLK_to_usb_fifo			: in  std_logic
			);
end COMPONENT Select_output_to_HK;


COMPONENT USB30_IO_converter is
    Port ( 
		
-- FEOM USB_3.0 manager
         DAQ_CLK_USB_OUT		: in  STD_LOGIC; -- 10MHz
	-- DAQ 32 bits for science link
         DAQ_usb_Data			: in  STD_LOGIC_VECTOR (31 downto 0);
         DAQ_usb_Rdy_n			: out STD_LOGIC;
         DAQ_usb_WR 				: in  STD_LOGIC;
	-- DATA SENDING 1MHz 8 bits for HK link
         HK_usb_Data				: in  STD_LOGIC_VECTOR (7 downto 0);
         HK_usb_Rdy_n			: out STD_LOGIC;
         HK_usb_WR 				: in  STD_LOGIC;
	-- DATA RECEIVED 1MHz 8 bits for Config link
			CONF_usb_Data			: out STD_LOGIC_VECTOR (7 downto 0);
			CONF_usb_Rdy_n			: in  STD_LOGIC;
         CONF_usb_WR				: out STD_LOGIC;

-- TO FMC_USB 3.0 Link I/O
		-- DAQ_CLK_usb_OUT
		HPC1_CLK_P					: out STD_LOGIC;
		HPC1_CLK_N					: out STD_LOGIC;
		-- DAQ DATA 32 bits for science link
		HPC1_DAQ_D_P				: out STD_LOGIC_VECTOR (31 downto 0);
		HPC1_DAQ_D_N				: out STD_LOGIC_VECTOR (31 downto 0);

		-- DAQ RDY_N for science link
		HPC1_DAQ_RDYN_P			: in  STD_LOGIC;
		HPC1_DAQ_RDYN_N			: in  STD_LOGIC;
		-- DAQ WR 32 for science link
		HPC1_DAQ_WR_P				: out STD_LOGIC;
		HPC1_DAQ_WR_N				: out STD_LOGIC;

-- DATA SENDING 1MHz 8 bits for HK link
		HPC1_HK_D_P					: out STD_LOGIC_VECTOR (7 downto 0);
		HPC1_HK_D_N					: out STD_LOGIC_VECTOR (7 downto 0);
		-- HK RDY_N for science link
		HPC1_HK_RDYN_P				: in  STD_LOGIC;
		HPC1_HK_RDYN_N				: in  STD_LOGIC;
		-- HK WR 32 for science link
		HPC1_HK_WR_P				: out STD_LOGIC;
		HPC1_HK_WR_N				: out STD_LOGIC;
		
-- DATA RECEIVING 1MHz 8 bits for CONFIG link
		HPC1_CONF_D_P				: in STD_LOGIC_VECTOR (7 downto 0);
		HPC1_CONF_D_N				: in STD_LOGIC_VECTOR (7 downto 0);
		-- CONF RDY_N for science link
		HPC1_CONF_RDYN_P			: out  STD_LOGIC;
		HPC1_CONF_RDYN_N			: out  STD_LOGIC;
		-- CONF WR 32 for science link
		HPC1_CONF_WR_P				: in STD_LOGIC;
		HPC1_CONF_WR_N				: in STD_LOGIC
			);
end COMPONENT USB30_IO_converter;

COMPONENT Select_output_to_TM is
    Port ( 
-- FROM XIFU
			OUT_SCIENCE_I 			: in  t_science_channel;
			OUT_SCIENCE_Q 			: in  t_science_channel;
			IN_PHYS	 				: in  t_in_phys;--signed(Size_In_Real-1 downto 0)
         FEEDBACK 				: in   t_feedback_to_DAC;--signed(Size_feedback_TO_DAC-1 downto 0)
         BIAS 						: in  t_bias;--signed(Size_bias_TO_DAC-1 downto 0)
			
--			OUTPUT SELECTOR 		: AT CLK_1X 30MHz, up to 3 32 bits Words
	select_TM						: in  unsigned (3 downto 0); 
	START_SENDING_TM				: in  STD_LOGIC ;
	SW_TM								: out STD_LOGIC ;

-- CLOCKS	
			CLK_4X					: in  std_logic; --CLK_4X
			ENABLE_CLK_2X			: in  std_logic;
			ENABLE_CLK_1X			: in  std_logic;
			ENABLE_CLK_1X_DIV32	: in  std_logic;
			ENABLE_CLK_1X_DIV64	: in  std_logic;
			ENABLE_CLK_1X_DIV128	: in  std_logic;

-- TO USB 3.0 manager
			RESET						: in  std_logic;			rd_en_DAQ_usb_fifo	: in  std_logic;			DATA_TO_USB_SEND		: out std_logic_vector(31 downto 0);			empty_DAQ_usb_fifo	: out std_logic;			valid_DAQ_usb_fifo	: out std_logic;			DAQ_CLK_to_usb_fifo	: in  std_logic

			);
end COMPONENT Select_output_to_TM;


----------------------------------------------------------------------------
--	
-- USB 3.0 link manager
--
----------------------------------------------------------------------------

COMPONENT USB30_links_manager is
    Port ( 
-- RESET	
			RESET							: in std_logic; --RESET
-- CLOCKS	
			CLK_4X						: in std_logic; --CLK_4X
			CLK_1X						: in std_logic; --CLK_1X = clk4X div 4
			ENABLE_CLK_1X_DIV64		: in  std_logic; --CLK_1X_DIV64
-- CONFIG
			regCONFIG	    			: out ARRAY32bits(0 to C_NB_REG_CONF-1);
			control_GSE					: out t_control_GSE;
			control_channels			: out t_control_channels;
			CONTROL_RHF1201S			: out	t_CONTROL_RHF1201S;
			Pixels_rd_conf				: out integer range 0 to Nb_Pixel;
			CONF_ADDRESS_out			: out integer ;
			CONF_RECEIVED_DATA_out	: out std_logic_vector(31 downto 0);

			LOOP_ON						: in  std_logic;
-- Data control For XIFU selected ACQ data
			DATA_TO_USB_SEND			: in 	STD_LOGIC_VECTOR (31 downto 0);
			rd_en_DAQ_usb_fifo		: out STD_LOGIC;
			empty_DAQ_usb_fifo		: in	STD_LOGIC;
			valid_DAQ_usb_fifo		: in	STD_LOGIC;
			DAQ_CLK_to_usb_fifo		: out STD_LOGIC; -- 10MHz
-- Data control For XIFU selected HK data
			HK_TO_USB_SEND				: in 	STD_LOGIC_VECTOR (7 downto 0);
			rd_en_HK_usb_fifo			: out STD_LOGIC;
			empty_HK_usb_fifo			: in	STD_LOGIC;
			valid_HK_usb_fifo			: in	STD_LOGIC;
			HK_CLK_to_usb_fifo		: out STD_LOGIC; -- 10MHz
-- TO USB_3.0 manager
         DAQ_CLK_USB_OUT			: out STD_LOGIC; -- 10MHz
	-- DAQ 32 bits for science link
         DAQ_usb_Data				: out STD_LOGIC_VECTOR (31 downto 0);
         DAQ_usb_Rdy_n				: in  STD_LOGIC;
         DAQ_usb_WR 					: out STD_LOGIC;
--         START_SENDING_usb_DAQ 	: in  STD_LOGIC;
	-- DATA SENDING 1MHz 8 bits for HK link
         HK_usb_Data					: out STD_LOGIC_VECTOR (7 downto 0);
         HK_usb_Rdy_n				: in  STD_LOGIC;
         HK_usb_WR 					: out STD_LOGIC;
--         START_SENDING_usb_HK		: in  STD_LOGIC;
	-- DATA RECEIVED 1MHz 8 bits for Config link
		-- STATUS SENDING BAD ADDRESS RECEIVED			
			Bad_conf_register_write : out std_logic;
         CONF_usb_Data				: in  STD_LOGIC_VECTOR (7 downto 0);
         CONF_usb_Rdy_n				: out STD_LOGIC;
         CONF_usb_WR					: in 	STD_LOGIC
			);

end COMPONENT USB30_links_manager;

----------------------------------------------------------------------------
--
-- Athena XIFU COMPONENTS
--
----------------------------------------------------------------------------
component channel is
    Port
		(
-- Clock in ports
      CLK_4X 					: in  	STD_LOGIC;
      ENABLE_CLK_1X 			: in  	STD_LOGIC;
      ENABLE_CLK_1X_DIV32 	: in  	STD_LOGIC;
      ENABLE_CLK_1X_DIV64 	: in  	STD_LOGIC;
      ENABLE_CLK_1X_DIV128 : in  	STD_LOGIC;
  -- Status and control signals
		RESET 					: in  	STD_LOGIC;
		CONTROL_CHANNEL		: in	  	t_CONTROL_CHANNEL;
		START_STOP				: in  	STD_LOGIC;
		SW_TM						: in		std_logic;

		Sequencer				: in 		unsigned(1 downto 0);

  -- Physique signals
		IN_PHYS 					: in  	signed	(Size_In_Real-1 downto 0);
      BIAS 						: out  	signed	(Size_bias_to_dac-1 downto 0);
      FEEDBACK 				: out  	signed	(Size_feedback_to_dac-1 downto 0);
      OUT_SCIENCE_I			: out  	t_science;
      OUT_SCIENCE_Q			: out  	t_science
		);
	end component;
----------------------------------------------------------------------------
-- input channel select
----------------------------------------------------------------------------

component Select_input is
     Port (
	  ADC 				: in  signed(Size_In_Real-1 downto 0);
     INT_SQUID			: in  signed(Size_In_Real-1 downto 0);
     IN_PHYS			: out signed(Size_In_Real-1 downto 0);
	  select_input		: in  unsigned (1 downto 0)

			);
end component;
--component Select_output is
--   Port ( 
--			OUT_SCIENCE	 	: in  signed(Size_science-1 downto 0);
--			INT_SQUID 		: in  signed(Size_In_Real-1 downto 0);
--         FEEDBACK 		: in  signed(Size_feedback_TO_DAC-1 downto 0);
--         BIAS 				: in  signed(Size_bias_TO_DAC-1 downto 0);
--         OUT_PHYS 		: out signed(Size_DAC-1 downto 0);
--			select_output	: in unsigned (1 downto 0)
--			); 
--end component Select_output;
----------------------------------------------------------------------------
-- HP FILTER
----------------------------------------------------------------------------

component HPFilter is
    Port (  reset				: in		std_logic;
				clk_4X			: in		std_logic;
				enable_Clk_1X  : in		std_logic;
				In_sig 			: in  	signed(HPF_size_in-1 downto 0);
				Out_sig 			: out  	signed(HPF_size_out-1 downto 0));
end component HPFilter;


----------------------------------------------------------------------------
-- Pixel module (DDS + BBFB)
----------------------------------------------------------------------------
component pixel is

	Port (
			CLK_4X					:	in std_logic;
			ENABLE_CLK_1X			:	in std_logic;
			ENABLE_CLK_1X_DIV256	:	in std_logic;
			Reset						:	in std_logic;
			CONTROL_PIXEL_BBFB	:	in t_CONTROL_PIXEL_BBFB;
			START_STOP				:	in std_logic;
			Sequencer				:	in unsigned(1 downto 0);
			SW_TM						:	in std_logic;
			In_phys					:	in signed(Size_In_Real-1 downto 0);
			Bias						:	out signed(Size_DDS-1 downto 0);
			Feedback					:	out signed(Size_one_Feedback-1 downto 0);
			OutI						:	out signed(Size_science-1 downto 0);
			OutQ						:	out signed(Size_science-1 downto 0);
			
			view_Science_data_in_CIC_I	:	out	signed(Size_science-1 downto 0);			
			view_Science_data_in_CIC_Q	:	out	signed(Size_science-1 downto 0)
		);
end component;

----------------------------------------------------------------------------
-- BBFB module
----------------------------------------------------------------------------
component BBFB is
    Port ( 	
    	CLK_4X			: in std_logic;
    	ENABLE_CLK_1X	: in std_logic;
		reset				: in std_logic;	  
		START_STOP		: in std_logic;

		In_Real			: in signed(Size_In_Real-1 downto 0);
								
		SW1				: in std_logic;
		SW2				: in unsigned(1 downto 0);
		gain_BBFB		: in unsigned(Size_gain-1 downto 0);	
		
		DemoduI			: in signed(Size_DDS_Sine_Out-1 downto 0);	-- For de-modulation (in-phase signal   -> cos)
		DemoduQ			: in signed(Size_DDS_Sine_Out-1 downto 0);	-- For de-modulation (quadrature signal -> sine)
		RemoduI			: in signed(Size_DDS_Sine_Out-1 downto 0);	-- For re-modulation (in-phase signal   -> cos)
		RemoduQ			: in signed(Size_DDS_Sine_Out-1 downto 0);	-- For re-modulation (quadrature signal -> sine)
				
		Feedback			: out signed(Size_one_feedback-1 downto 0);
								
		Out_science_I	: out signed(Size_science-1 downto 0);
		Out_science_Q	: out signed(Size_science-1 downto 0)
		);
end component;


----------------------------------------------------------------------------
-- Sine wave generator
----------------------------------------------------------------------------
component Sine_generator is
port ( 
	CLK_4X			: in std_logic;
	ENABLE_CLK_1X	: in std_logic;
	Reset          : in std_logic;
	START_STOP     : in std_logic;
	sequencer      : in unsigned(1 downto 0);
	increment      : in unsigned(counter_size-1 downto 0);
	phi_delay      : in unsigned(Size_dds_phi-1 downto 0);
	phi_rotate     : in unsigned(Size_dds_phi-1 downto 0);
	phi_initial    : in unsigned(Size_dds_phi_ini-1 downto 0);
	bias_amplitude : in unsigned(Size_bias_amplitude-1 downto 0); -- pixel bias amplitude
	bias           : out signed(Size_DDS_Sine_Out-1 downto 0);
	demoduI_buff   : out signed(Size_DDS_Sine_Out-1 downto 0);
	demoduQ_buff   : out signed(Size_DDS_Sine_Out-1 downto 0);
	remoduI_buff   : out signed(Size_DDS_Sine_Out-1 downto 0);
	remoduQ_buff   : out signed(Size_DDS_Sine_Out-1 downto 0)
    );
		
end component;

----------------------------------------------------------------------------
-- DDS input controller (phases => counters)
----------------------------------------------------------------------------
component DDS_signals_ctrl is	
	port(
		CLK_4X			: in std_logic;
		ENABLE_CLK_1X	: in std_logic;
		reset 			: in std_logic; 
		START_STOP		: in std_logic;
		counter_step	: in unsigned(counter_size-1 downto 0); 
		phi_delay		: in unsigned(Size_dds_phi-1 downto 0);
		phi_rotate		: in unsigned(Size_dds_phi-1 downto 0);  -- NOT USED YET
		phi_initial		: in unsigned(Size_dds_phi_ini-1 downto 0);
		
		count_DemoduI	: out unsigned(counter_size-1 downto 0);
		count_DemoduQ 	: out unsigned(counter_size-1 downto 0);
		count_RemoduI 	: out unsigned(counter_size-1 downto 0);
		count_RemoduQ	: out unsigned(counter_size-1 downto 0)
	);
end component;

----------------------------------------------------------------------------
-- DDS
----------------------------------------------------------------------------
component DDS_generic is
port		(
			Reset       		: in std_logic;
			Clk         		: in std_logic;
    
			counter     		: in unsigned(counter_size-1 downto 0);

    -- "-2" because the 2 MSB are not used for the ROM address
			address_rom 		: out unsigned((ROM_Depth-2)-1 downto 0);

			sine_previous : in unsigned(Size_ROM_sine-1 downto 0);
			delta_previous: in unsigned(Size_ROM_delta-1 downto 0);
    
			dds_previous  : out signed(Size_DDS_Sine_Out-1 downto 0)
			);

end component;	

----------------------------------------------------------------------------
-- DDS ROM
----------------------------------------------------------------------------
component ROM_dds is
	port(
		Clk				: in std_logic;
		RESET				: in std_logic;
		EN					: in std_logic;
		Address_ROM		: in unsigned((ROM_Depth-2)-1 downto 0);
		sine				: out unsigned(Size_ROM_sine-1 downto 0);
		delta				: out unsigned(Size_ROM_delta-1 downto 0)
	);
end component;

----------------------------------------------------------------------------
-- multiplier Real x Complex => Complex
----------------------------------------------------------------------------
component Real_Mult_Complex is
    Generic (
    	Size_R			: positive;
		Size_IQ_in		: positive;
		Size_IQ_out		: positive
		);
    Port ( 
		CLK_4X			: in std_logic;
		ENABLE_CLK_1X	: in std_logic;
		Reset				: in std_logic;
    	R_in				: in signed(Size_R-1 downto 0);
      I_in				: in signed(Size_IQ_in-1 downto 0);
      Q_in				: in signed(Size_IQ_in-1 downto 0);
      I_out				: out signed(Size_R+Size_IQ_in-1 downto Size_R+Size_IQ_in-Size_IQ_out);
      Q_out				: out signed(Size_R+Size_IQ_in-1 downto Size_R+Size_IQ_in-Size_IQ_out)
		);
end component;

----------------------------------------------------------------------------
-- multiplier Complex x Complex => Real part
----------------------------------------------------------------------------
Component Complex_Mult_Complex_toReal is
    Generic (
				Size1				: positive;
				Size2				: positive;
				Size_out			: positive
				);
    Port 	(
				CLK_4X			: in std_logic;
				ENABLE_CLK_1X	: in std_logic;
				Reset				: in std_logic;
				I1_in				: in signed(Size1-1 downto 0);
				Q1_in				: in signed(Size1-1 downto 0);
				I2_in				: in signed(Size2-1 downto 0);
				Q2_in				: in signed(Size2-1 downto 0);
				Real_out			: out signed(Size1+Size2-1 downto Size1+Size2-Size_out)
				);
end component;

----------------------------------------------------------------------------
-- multiplier Complex x Complex => Real part
----------------------------------------------------------------------------
component Integrator is
	Generic	( 		
				Size_in			:	positive;
				Size_out			:	positive 
				);
    Port 	(
				CLK_4X			: in std_logic;
				ENABLE_CLK_1X	: in std_logic;
				reset				: in std_logic;
				
				START_STOP		: in std_logic;
				
				Sig_in			: in signed(Size_in-1 downto 0);
				Gain				: in unsigned(Size_gain-1 downto 0);
				Sig_out			: out signed(Size_out-1 downto 0)
		);
end component;

component BIAS_modulation is
	Port (
			CLK_4X							:	in  std_logic;
			ENABLE_CLK_1X					:	in  std_logic;
			Reset								:	in  std_logic;
			START_STOP						:	in  std_logic;
			Sequencer						:	in  unsigned(1 downto 0);
			BIAS_modulation_increment	: 	in  unsigned (23 downto 0);
			BIAS_modulation_amplitude	: 	in  unsigned (7 downto 0);
			BIAS_in							:	in  signed(Size_DDS-1 downto 0);
			BIAS_Out							:	out signed(Size_DDS-1 downto 0)
			);
end component BIAS_modulation;

component feedback_gain_compensation is
Port 	(
		CLK_4X				: in std_logic;
		ENABLE_CLK_1X		: in std_logic;
		Reset					: in std_logic;
		Compensation_Gain	: in unsigned(Size_feedback_compensation_gain-1 downto 0);
		START_STOP			: in std_logic;
    
		feedback_in			: in  signed(Size_feedback_adder_out-1 downto 0);
		feedback_out		: out signed(Size_feedback_adder_out + Size_feedback_compensation_gain -1 downto 0)
		);
end component feedback_gain_compensation;

component slope_bias is
Port 	(
		CLK_4X			: in std_logic;
		ENABLE_CLK_1X	: in std_logic;
		Reset				: in std_logic;
		slope_speed		: in unsigned(1 downto 0);
		START_STOP		: in std_logic;
    
		bias_in			: in signed(Size_bias_to_DAC-1 downto 0);
		bias_out			: out signed(Size_bias_to_DAC-1 downto 0)
		);
end component;

component digital_TRC is

port	( 
		CLK_4X						: in std_logic;
		ENABLE_CLK_1X				: in std_logic;
		
		reset 						: in std_logic;
	
		signal_in_BIAS				: in signed (Size_BIAS_adder_out-1 downto 0);
		signal_in_FEEDBACK		: in signed (Size_feedback_adder_out + Size_feedback_compensation_gain -1 downto 0);
		
		BIAS_truncation			: in unsigned (1 downto 0);
		FEEDBACK_truncation		: in unsigned (1 downto 0);
		signal_out_BIAS			: out signed (Size_bias_to_dac-1 downto 0);
		signal_out_FEEDBACK		: out signed (Size_feedback_to_dac-1 downto 0)
		);
		
end component;

----------------------------------------------------------------------------
-- Science filter 
----------------------------------------------------------------------------

component science_filter_CIC is
	 generic
		(
		size_in  			: positive := 30;
		size_out 			: positive := 16
		);
    Port 
		(
				CLK_4X		 			: in STD_LOGIC;
				ENABLE_CLK_1X 			: in STD_LOGIC;
				ENABLE_CLK_1X_DIV256	: in STD_LOGIC;
				reset    				: in STD_LOGIC;
				START_STOP				: in std_logic;

				data_in  				: in signed(size_in-1 downto 0);
--				rfd 	  					: out STD_LOGIC;
--				rdy      				: out STD_LOGIC;
				data_out 				: out signed(size_out-1 downto 0)
		);
end component;

component Integrator_CIC is
	 Generic	(
				size_in  		: positive := 16;
				size_out 		: positive :=17
				);
    Port 	(
				CLK_4X			: in std_logic;
				ENABLE_CLK_1X	: in std_logic;
				START_STOP		: in std_logic;

				reset 			: in std_logic;
				Int_in_dat 		: in  signed(size_in-1 downto 0);
				Int_out_dat 	: out signed(size_out-1 downto 0));
end component;

-- Declaration comb_CIC
component Comb_CIC
	 generic
		( 
		size_in  				: positive := 52;
		size_out 				: positive := 52
		);
    Port
		(
				CLK_4X		 			: in STD_LOGIC;
				ENABLE_CLK_1X_DIV256	: in STD_LOGIC;
				reset 					: in 	std_logic;
				comb_in_dat 			: in  signed(size_in-1 downto 0);
				comb_out_dat			: out signed(size_out-1 downto 0)
      );
    end component;

----------------------------------------------------------------------------
-- component adder for output FeedBack and Bias signals
----------------------------------------------------------------------------

component Adder_channel is
 	 generic 
		(
		Nb_bits_inA			: positive :=16;
		Nb_bits_inB			: positive :=16;
		Nb_bits_out			: positive :=30
		);
    Port
		(
		In_signalA : in   signed (Nb_bits_inA -1 downto 0);
		In_signalB : in   signed (Nb_bits_inB -1 downto 0);
      Out_signal : out  signed (Nb_bits_out-1 downto 0)
		);
end component;

-----------------------------------------------------------------------------------
-- SQUID
-----------------------------------------------------------------------------------
component Squid_generic
	 Generic 
		(
		Size_in 		: positive :=12;
		Size_out 	: positive :=18
		);
    Port 
		(
		CLk_4X			: in std_logic;
		Enable_CLK_1X  : in std_logic;
		reset			   : in std_logic;
		In_Squid 		: in 	signed(Size_in-1 downto 0);
      In_Feedback 	: in  signed(Size_in-1 downto 0);
		Out_Squid 		: out  signed(Size_out-1 downto 0)
		);
end component;

end athena_package;