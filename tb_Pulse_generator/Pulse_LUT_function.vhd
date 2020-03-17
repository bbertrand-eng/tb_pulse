----------------------------------------------------------------------------------
-- Company       : CNRS - INSU - IRAP
-- Engineer      : Antoine CLENET / Christophe OZIOL 
-- Create Date   : 12:14:36 05/26/2015 
-- Design Name   : DRE XIFU FPGA_BOARD
-- Module Name   : Pulse_Emulator - Behavioral 
-- Project Name  : Athena XIfu DRE
-- Target Devices: Virtex 6 LX 240
-- Tool versions : ISE-14.7
-- Description: 	XXX function stored into the LUT with linear interpolation. The table must be generated using the "Function_LUT_SCRIPT.py" Python script
-- 			INSTANTIATION :
--				Size_in 	=> 22,
--				Size_out	=> 11,
-- Revision: 
-- Revision 0.1 - File Created
-- Additional Comments: 
--
---------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.math_real.all;
use work.athena_package.all;


entity LUT_func is
    Generic (
		C_Size_in			: positive;	-- 18
		C_Size_out			: positive	-- 14
		);
    Port ( 
--RESET
		RESET				: in  std_logic;
--CLOCK
		CLK_156k				: in  std_logic;
		ENABLE_CLK_1X		: in  std_logic;
		WE_Pulse_Ram 		: in  std_logic;
		Pulse_Ram_ADDRESS	: in  unsigned (9 downto 0);
		Pulse_Ram_ADDRESS_RD: in  unsigned (9 downto 0);
		Pulse_Ram_Data		: in  STD_LOGIC_VECTOR (31 downto 0);
		Func_in 			: in  unsigned(C_Size_in-1 downto 0);
		Func_out 			: out STD_LOGIC_VECTOR(31 downto 0)
		);
end LUT_func;

--! @brief-- BLock diagrams schematics -- 
--! @detail file:work.LUT_func.Behavioral.svg
architecture Behavioral of LUT_func is

constant C_ROM_Depth 		: integer:= 11;			--  <======
constant C_Size_ROM_Sig 	: integer:= 16;		--  <======
constant C_Size_ROM_Delta	: integer:= 16;			--  <======

-- signal 	LUT_data : std_logic_vector(32-1 downto 0);-- la ram fait maintenat tout le temps 32 bits C_Size_ROM_Sig+C_Size_ROM_Delta
-- signal	Sig	: signed(C_Size_ROM_Sig downto 0);
-- signal  Sig2 : signed(C_Size_ROM_Sig downto 0);
-- signal	Delta	: signed(C_Size_ROM_Delta-1 downto 0);
-- signal	Intrp : signed(C_Size_in-C_ROM_Depth-1+1 downto 0);	--+1 for the sign bit
-- signal  Intrp_2 : signed(C_Size_in-C_ROM_Depth-1+1 downto 0);
-- signal	DeltIntrp : signed(Delta'length+Intrp'length-1 downto 0);
-- signal	Func_out_buf : signed(C_Size_out-1+1 downto 0);
signal  Pulse_Ram : t_Pulse_Ram;

begin
P_Write_Pulse_Ram: process (CLK_156k)
begin
	if rising_edge(CLK_156k) then
		if (WE_Pulse_Ram ='1') then
			Pulse_Ram(to_integer(Pulse_Ram_ADDRESS))	<= Pulse_Ram_Data;
		end if;
	end if;
end process;


P_readout: process (CLK_156k)
begin
	if rising_edge(CLK_156k) then

		Func_out	<= Pulse_Ram(to_integer(Pulse_Ram_ADDRESS_RD));
			-- LUT_data 		<= Pulse_Ram(to_integer(Func_in(C_Size_in-1 downto C_Size_in-C_ROM_Depth)));
			-- Intrp			<= signed('0' & Func_in(C_Size_in-C_ROM_Depth-1 downto 0));
			-- Intrp_2			<= Intrp;
			-- Delta 			<= signed(LUT_data(C_Size_ROM_Delta-1 downto 0));
			-- Sig 			<= signed('0' & LUT_data(C_Size_ROM_Sig+C_Size_ROM_Delta-1 downto C_Size_ROM_Delta));
			-- Sig2			<= Sig;
			-- DeltIntrp 		<= Delta*Intrp_2;
			-- Func_out_buf	<= resize(Sig2 + DeltIntrp(DeltIntrp'length-2 downto DeltIntrp'length-Delta'length-1),Func_out_buf'length);
		
	end if;
end process;

--Func_out		<= unsigned(Func_out_buf(Func_out_buf'length-2 downto 0));

end Behavioral;