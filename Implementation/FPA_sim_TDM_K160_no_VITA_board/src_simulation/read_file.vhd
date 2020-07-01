library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_textio.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


use std.textio.all;

entity read_file is	
port(
	okClk						: 	in std_logic;
	reset						:	in std_logic;
	ep_write					:	inout std_logic;
	ep_dataout					:	out std_logic_vector(31 downto 0)

	);
end read_file;


architecture Behavioral of read_file is

begin


----------------------------------------------------
--	ONLY simulation
----------------------------------------------------


process
------------------------------------------------------------------

file DONNEES : text;
variable MY_LINE : line;
variable data		: std_logic_vector(31 downto 0);	

-------------------------------------------------------------------

begin-------------begin of process-----
file_open(DONNEES, "REG_big_endian.txt", read_mode);
ep_write	<= '0';
ep_dataout	<= (others => '0');

wait until reset = '0' and reset' event;
	
   loop
   
  	wait until (okClk = '1' and okClk' event); 
	
		if ep_write = '0'  and (not endfile(DONNEES))
		then
		ep_write	<= '1';  
		readline(DONNEES,MY_LINE); 
		hread(MY_LINE,data);
		ep_dataout <= data;
		else
		ep_write	<= '0';
		end if;
		
  	end loop;---------
  	
end process;------------------------------------------------------


end Behavioral;
