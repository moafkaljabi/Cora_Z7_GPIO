----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Moafk Aljabi
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
-- Each RGB LED has 4 states:
-- 0: Red
-- 1: Green
-- 2: Blue
-- 3: off
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity top is
    Port (
        clk     : in  STD_LOGIC;                     
        led0_r  : out STD_LOGIC;
        led0_g  : out STD_LOGIC;
        led0_b  : out STD_LOGIC;

        led1_r  : out STD_LOGIC;
        led1_g  : out STD_LOGIC;
        led1_b  : out STD_LOGIC;

        btn     : in  STD_LOGIC_VECTOR(1 downto 0)  
    );
end top;

architecture Behavioral of top is

    signal brightness  : STD_LOGIC;
    signal db_btn      : STD_LOGIC_VECTOR(1 downto 0) := (others => '0');
    signal btn_edge    : STD_LOGIC_VECTOR(1 downto 0) := (others => '0');  -- one-clock pulse on press => one color change per press
    signal prev_btn    : STD_LOGIC_VECTOR(1 downto 0) := (others => '0');

    -- State for each LED: 0=Red, 1=Green, 2=Blue, 3=Off
    signal state0      : unsigned(1 downto 0) := "00";  -- start Red
    signal state1      : unsigned(1 downto 0) := "00";  -- start Red

    -- PWM instance stays the same
    component pwm
        generic (
            COUNTER_WIDTH : integer := 8;
            MAX_COUNT     : integer := 255
        );
        port (
            clk     : in  STD_LOGIC;
            duty    : in  STD_LOGIC_VECTOR(7 downto 0);
            pwm_out : out STD_LOGIC
        );
    end component;

    component debouncer
        generic (
            WIDTH        : integer := 2;
            CLOCKS       : integer := 1024;
            CLOCKS_CLOG2 : integer := 10
        );
        port (
            clk  : in  STD_LOGIC;
            din  : in  STD_LOGIC_VECTOR(1 downto 0);
            dout : out STD_LOGIC_VECTOR(1 downto 0)
        );
    end component;

begin

    ----------------------------------------------------------------------
    -- PWM for brightness, will be using 50% Duty cycle
    ----------------------------------------------------------------------
    pwm_inst : pwm
        generic map(
            COUNTER_WIDTH => 8,
            MAX_COUNT     => 255
        )
        port map(
            clk     => clk,
            duty    => x"7F",      --  == 127 decimal == 50% brightness 
            pwm_out => brightness
        );

    ----------------------------------------------------------------------
    -- Debouncer for the two buttons
    ----------------------------------------------------------------------
    debouncer_inst : debouncer
        generic map(
            WIDTH        => 2,
            CLOCKS       => 1024, -- input stable for 1024 clock cycles ~ 8ms at 125 MHz
            CLOCKS_CLOG2 => 10    -- number of bits needed to fit the value(in binary)
        )
        port map(
            clk  => clk,
            din  => btn,
            dout => db_btn
        );

    ----------------------------------------------------------------------
    --  One-cycle pulse when button is pressed
    ----------------------------------------------------------------------
    process(clk)
    begin
        if rising_edge(clk) then
            prev_btn <= db_btn;                     -- Do not use Immediate assignment!
            btn_edge <= db_btn and (not prev_btn);  -- rising edge
        end if;
    end process;

    ----------------------------------------------------------------------
    -- State machine for LED0 (controlled by BTN0)
    ----------------------------------------------------------------------
    process(clk)
    begin
        if rising_edge(clk) then
            if btn_edge(0) = '1' then
                if state0 = "11" then
                    state0 <= "00";      -- Off => Red
                else
                    state0 <= state0 + 1;
                end if;
            end if;
        end if;
    end process;

    ----------------------------------------------------------------------
    -- State machine for LED1 (controlled by BTN1)
    ----------------------------------------------------------------------
    process(clk)
    begin
        if rising_edge(clk) then
            if btn_edge(1) = '1' then
                if state1 = "11" then
                    state1 <= "00";      -- Off => Red
                else
                    state1 <= state1 + 1;
                end if;
            end if;
        end if;
    end process;

    ----------------------------------------------------------------------
    -- RGB output
    ----------------------------------------------------------------------
    -- LED0
    led0_r <= brightness when state0 = "00" else '0';  -- Red
    led0_g <= brightness when state0 = "01" else '0';  -- Green
    led0_b <= brightness when state0 = "10" else '0';  -- Blue
    -- Off when state0 = "11" → all outputs already '0'

    -- LED1
    led1_r <= brightness when state1 = "00" else '0';  -- Red
    led1_g <= brightness when state1 = "01" else '0';  -- Green
    led1_b <= brightness when state1 = "10" else '0';  -- Blue

end Behavioral;
