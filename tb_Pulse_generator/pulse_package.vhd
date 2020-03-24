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
package pulse_package is


type t_Pulse_Ram is array (1023 downto 0) of std_logic_vector(31 downto 0);

end pulse_package;