
library ieee;

use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
--use ieee.std_logic_arith.all;
use ieee.numeric_std.all;
use work.pulse_package.all;

--use work.Spacewire_Pack.all;

entity SQUID is
	port(
--RESET
			Reset		 		:	in  STD_LOGIC;
--CLOCKs
    		CLK_5Mhz			: 	in  STD_LOGIC;
			--ENABLE_CLK_1X		: 	in  STD_LOGIC
			feedback_sq1        : 	in	signed(13 downto 0);
			Vtes_out            : 	in	signed(15 downto 0);
			
			out_perfect_squid_wide_positif	:	out	signed(17 downto 0)
			
			
	);
end entity;

architecture rtl of SQUID is

	signal	feedback_sq1_wide				:	signed(15 downto 0);
	signal	out_perfect_squid				:	signed(15 downto 0);	
	signal	out_perfect_squid_wide			:	signed(16 downto 0);

	--signal	out_perfect_squid_add			:	signed(15 downto 0);

begin

label_squid : process(Reset, CLK_5Mhz)
begin
if Reset = '1' then

else
    if CLK_5Mhz='1' and CLK_5Mhz'event then
		
    end if;  -- clock
end if;  -- reset 
end process;
--end generate label_generate_start_pulse_pixel; 

	feedback_sq1_wide		<=	resize(feedback_sq1,16);	
	out_perfect_squid		<=	Vtes_out - feedback_sq1_wide;	

	out_perfect_squid_wide	<=	resize(out_perfect_squid,17);	
	
	--out_perfect_squid_add	<=	feedback_sq1_wide+out_perfect_squid; 	
	out_perfect_squid_wide_positif	<=	resize(out_perfect_squid_wide,18) + 65536; 



end RTL;