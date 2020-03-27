
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
package pulse_package is

constant C_pixel : integer := 34; 
constant C_depth_pulse_memory : integer := 1024; 
type t_Pulse_Ram is array (C_depth_pulse_memory-1 downto 0) of std_logic_vector(31 downto 0);

type 	t_array_Mem_counter_address is array (C_pixel-1 downto 0) of unsigned (9 downto 0);


type 	t_array_Mem_Vp is array (C_pixel-1 downto 0) of std_logic_vector(31 downto 0);
signal 	Vp	:	t_array_Mem_Vp;

end pulse_package;