----------------------------------------------------------------------------------
-- Company       : CNRS - INSU - IRAP
-- Engineer      : Christophe OZIOL 
-- 
-- Create Date   : 12:14:36 05/26/2015 
-- Design Name   : DRE XIFU ML605
-- Module Name   : CMM- rtl 
-- Project Name  : Athena XIfu DRE
-- Target Devices: Vitex 6 LX 240
-- Tool versions : ISE-14.7
-- Description   : Clock management Module
--						 Create the enables clocks and the sequencer
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
---------------------------------------oOOOo(o_o)oOOOo-----------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library work;
use work.pulse_package.all;

--use work.FPAsim_OK_TOP_pack.all;



entity CMM is
    Port (
			GLOBAL_CLK 				: in STD_LOGIC; -- =160 MHz to have CLK_1X = 20 MHz
			RESET 					: in STD_LOGIC;
			CLUSTER_CLK				: out	t_CLUSTER_CLK;
			
			sequencer				: out unsigned (1 downto 0)
);
end CMM;

architecture Behavioral of CMM is

signal cmpt_sequencer	: unsigned (29 downto 0);

begin

clk_div: process(RESET, GLOBAL_CLK)
	begin
		if RESET = '1' then
		cmpt_sequencer <= (others=>'0');
		else 
			if (rising_edge(GLOBAL_CLK)) then
				cmpt_sequencer			<= cmpt_sequencer + 1 ;
			end if;
		end if;
	end process; 	
	
	
CLUSTER_CLK.CLK_4X  				<= GLOBAL_CLK; -- 61MHz
CLUSTER_CLK.ENABLE_CLK_2X  			<= cmpt_sequencer(0); -- 30MHz
CLUSTER_CLK.ENABLE_CLK_1X  			<= cmpt_sequencer(1)and cmpt_sequencer(0); -- 15MHz
CLUSTER_CLK.ENABLE_CLK_1X_DIV32 	<= cmpt_sequencer(5) and cmpt_sequencer(4) and cmpt_sequencer(3) and cmpt_sequencer(2) and cmpt_sequencer(1) and cmpt_sequencer(0);
CLUSTER_CLK.ENABLE_CLK_1X_DIV64		<= cmpt_sequencer(6) and cmpt_sequencer(5) and cmpt_sequencer(4) and cmpt_sequencer(3) and cmpt_sequencer(2) and cmpt_sequencer(1) and cmpt_sequencer(0);
CLUSTER_CLK.ENABLE_CLK_1X_DIV128	<= cmpt_sequencer(7) and cmpt_sequencer(6) and cmpt_sequencer(5) and cmpt_sequencer(4) and cmpt_sequencer(3) and cmpt_sequencer(2) and cmpt_sequencer(1) and cmpt_sequencer(0);
CLUSTER_CLK.ENABLE_CLK_1X_DIV256	<= cmpt_sequencer(8) and cmpt_sequencer(7) and cmpt_sequencer(6) and cmpt_sequencer(5) and cmpt_sequencer(4) and cmpt_sequencer(3) and cmpt_sequencer(2) and cmpt_sequencer(1) and cmpt_sequencer(0);


sequencer							<= cmpt_sequencer (1 downto 0);	
	
	




--CLUSTER_CLK.CLK_4X  					<= cmpt_sequencer(0);
--CLUSTER_CLK.ENABLE_CLK_2X  		<= cmpt_sequencer(1) and cmpt_sequencer(0);
--CLUSTER_CLK.ENABLE_CLK_1X  		<= cmpt_sequencer(2) and cmpt_sequencer(1) and cmpt_sequencer(0);
--CLUSTER_CLK.ENABLE_CLK_1X_DIV32 	<= cmpt_sequencer(6) and cmpt_sequencer(5) and cmpt_sequencer(4) and cmpt_sequencer(3) and cmpt_sequencer(2) and cmpt_sequencer(1) and cmpt_sequencer(0);
--CLUSTER_CLK.ENABLE_CLK_1X_DIV64	<= cmpt_sequencer(7) and cmpt_sequencer(6) and cmpt_sequencer(5) and cmpt_sequencer(4) and cmpt_sequencer(3) and cmpt_sequencer(2) and cmpt_sequencer(1) and cmpt_sequencer(0);
--CLUSTER_CLK.ENABLE_CLK_1X_DIV128	<= cmpt_sequencer(8) and cmpt_sequencer(7) and cmpt_sequencer(6) and cmpt_sequencer(5) and cmpt_sequencer(4) and cmpt_sequencer(3) and cmpt_sequencer(2) and cmpt_sequencer(1) and cmpt_sequencer(0);

end Behavioral;

