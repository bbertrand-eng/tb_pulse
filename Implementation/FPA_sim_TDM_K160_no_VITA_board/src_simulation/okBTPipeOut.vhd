--------------------------------------------------------------------------
-- okBTPipeOut.vhd
--
-- This entity simulates the "Block Throttled Output Pipe" endpoint.
--
--------------------------------------------------------------------------
-- Copyright (c) 2005-2010 Opal Kelly Incorporated
-- $Rev: 4 $ $Date: 2014-05-20 16:57:47 -0700 (Tue, 20 May 2014) $
--------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use work.parameters.all;
use work.mappings.all;

entity okBTPipeOut is
	port (
		okHE           : in   std_logic_vector(112 downto 0);
		okEH           : out  std_logic_vector(64 downto 0);
		ep_addr        : in   std_logic_vector(7 downto 0);
		ep_read        : out  std_logic;
		ep_blockstrobe : out  std_logic;
		ep_datain      : in   std_logic_vector(31 downto 0);
		ep_ready       : in   std_logic);
end okBTPipeOut;

architecture arch of okBTPipeOut is
	signal ti_read        : std_logic;
	signal ti_addr        : std_logic_vector(7 downto 0);
	signal ti_blockstrobe : std_logic;
	
begin
	ti_read          <= okHE(okHE_READ);
	ti_addr          <= okHE(okHE_ADDRH downto okHE_ADDRL);
	ti_blockstrobe   <= okHE(okHE_BLOCKSTROBE);
	
	okEH(okEH_DATAH downto okEH_DATAL) <= ep_datain when (ti_addr = ep_addr) else (others => '0');
	okEH(okEH_READY) <= ep_ready when (ti_addr = ep_addr) else '0';
	ep_read <= '1' when ((ti_read = '1') and (ti_addr = ep_addr)) else '0';
	ep_blockstrobe <= '1' when ((ti_blockstrobe = '1') and (ti_addr = ep_addr)) else '0';
	okEH(okEH_REGREADDATAH downto okEH_REGREADDATAL) <= (others => '0');
	
end arch;