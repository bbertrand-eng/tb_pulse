-------------------------------------------------------------------------------
-- Copyright (c) 2017 Xilinx, Inc.
-- All Rights Reserved
-------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /    Vendor     : Xilinx
-- \   \   \/     Version    : 14.7
--  \   \         Application: XILINX CORE Generator
--  /   /         Filename   : iCON_1.vhd
-- /___/   /\     Timestamp  : Mon Jan 16 17:20:40 Paris, Madrid 2017
-- \   \  /  \
--  \___\/\___\
--
-- Design Name: VHDL Synthesis Wrapper
-------------------------------------------------------------------------------
-- This wrapper is used to integrate with Project Navigator and PlanAhead

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
ENTITY iCON_1 IS
  port (
    CONTROL0: inout std_logic_vector(35 downto 0);
    CONTROL1: inout std_logic_vector(35 downto 0);
    CONTROL2: inout std_logic_vector(35 downto 0);
    CONTROL3: inout std_logic_vector(35 downto 0);
    CONTROL4: inout std_logic_vector(35 downto 0);
    CONTROL5: inout std_logic_vector(35 downto 0));
END iCON_1;

ARCHITECTURE iCON_1_a OF iCON_1 IS
BEGIN

END iCON_1_a;
