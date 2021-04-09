-------------------------------------------------------------------------------
-- Copyright (c) 2021 Xilinx, Inc.
-- All Rights Reserved
-------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /    Vendor     : Xilinx
-- \   \   \/     Version    : 14.7
--  \   \         Application: XILINX CORE Generator
--  /   /         Filename   : chipscope_vio.vhd
-- /___/   /\     Timestamp  : Fri Mar 12 16:20:30 Paris, Madrid 2021
-- \   \  /  \
--  \___\/\___\
--
-- Design Name: VHDL Synthesis Wrapper
-------------------------------------------------------------------------------
-- This wrapper is used to integrate with Project Navigator and PlanAhead

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
ENTITY chipscope_vio IS
  port (
    CONTROL: inout std_logic_vector(35 downto 0);
    CLK: in std_logic;
    SYNC_OUT: out std_logic_vector(31 downto 0));
END chipscope_vio;

ARCHITECTURE chipscope_vio_a OF chipscope_vio IS
BEGIN

END chipscope_vio_a;
