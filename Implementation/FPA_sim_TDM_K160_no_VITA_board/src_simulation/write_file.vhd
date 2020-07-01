library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_textio.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
--use work.sinus_spica_Pack.all;

use std.textio.all;

entity write_file is	
generic(
	size_data		: integer := 0; 	-- taille de la donnée a extraire du CID (1 ==> 1 bit a extraire, max 32)
	file_name		: string 	-- position du LSB de la donnée a extraire du CID (0 ==> extraction du LSB)
); 	
port(
	clk						: 	in std_logic;
	reset						:	in std_logic;
	data_in 				 	: 	in std_logic_vector (size_data-1 downto 0)

	);
end write_file;


architecture Behavioral of write_file is

begin

process 
------------------------------------------------------------------
file file_signal_output_add	: text;
variable l : line;
variable Value : integer;
variable counter_line : integer := 0;
------------------------------------------------------------------

begin-------------begin of process-----
	file_open(file_signal_output_add, file_name, WRITE_MODE);
	wait until Reset = '0';
	loop
  	wait until clk = '1' and clk'event;--*  and counter_line < 121072; 

		--if data_in /= 0
		--then
			value := conv_integer(signed(data_in));
			write(l, Value); 
			writeline(file_signal_output_add, l);
			counter_line := counter_line + 1;
		--end if;
 
   	end loop;---------------------------------------------------  
end process;---------------------------------------------------- 


end Behavioral;
