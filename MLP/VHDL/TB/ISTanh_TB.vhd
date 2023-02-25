----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/10/2022 11:54:17 AM
-- Design Name: 
-- Module Name: ISTanh_TB - Behavioral
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
use ieee.numeric_std.all; 
use work.all;
use work.utils.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ISTanh_TB is
--  Port ( );
end ISTanh_TB;

architecture Behavioral of ISTanh_TB is
signal clk : std_logic;
signal reset : std_logic := '0';

constant mPrime : integer := 6;
constant n : integer := 8;
signal ISTanhInput : signed(3 downto 0);
signal ISTanhOuput : std_logic;

begin
    process
    begin
        clk <= '0';
        wait for 50 ns;
        clk <= '1';
        wait for 50 ns;
    end process;
     
     
    process
    begin
        reset <= '1';
        wait for 100ns;
        reset <= '0';
        wait;
    end process;
    
    top  : entity ISTanh (arch)
        GENERIC MAP (
        n => n,
        m => mPrime
        )
      PORT MAP (
         clk    => clk,
         reset    => reset,
         inputStream => ISTanhInput,
         outputStream => ISTanhOuput
    );
    
    process(clk, reset)
    variable count: unsigned(4 downto 0) := to_unsigned(0, 5);
    begin
        if(rising_edge(clk)) then
            if(reset = '1') then
                ISTanhInput <= to_signed(4, 4);
                count := to_unsigned(0, 5);
            else 
                count := count + 1;
                if(count = 0) then
                    ISTanhInput <= to_signed(4, 4);
                elsif(count = 15) then
                    ISTanhInput <= to_signed(-4, 4);
                end if;
            end if;
         end if;
    end process;

end Behavioral;
