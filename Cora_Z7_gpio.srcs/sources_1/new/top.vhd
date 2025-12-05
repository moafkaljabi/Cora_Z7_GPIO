----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/05/2025 04:39:06 AM
-- Design Name: 
-- Module Name: top - Structural
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity top is 
Port (
    clk     : in    std_logic;
    
    led0_r  : out   std_logic;
    led0_g  : out   std_logic;
    led0_b  : out   std_logic;

    led1_r  : out   std_logic;
    led1_g  : out   std_logic:
    led1_b  : out   std_logic;

    btn     : in    std_logic_vector(1 downto 0)

    
);
end top;

architecture Structural of top is

    -- Signals


begin

    -- processes 


end Structural;