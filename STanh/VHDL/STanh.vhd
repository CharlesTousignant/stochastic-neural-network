----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/22/2022 11:08:42 AM
-- Design Name: 
-- Module Name: STanh - Behavioral
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


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;  	
 

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity STanh is
    Generic(
        n: unsigned(7 downto 0) := to_unsigned(16, 8)
    );
    Port (  clk : in std_logic;
            reset: in std_logic;
            inputStream: in std_logic;
            outputStream : out std_logic
    );
end STanh;

architecture arch of STanh is
signal currState : unsigned(7 downto 0) := n / 2;
begin
    process(clk)
    begin
        if(rising_edge(clk)) then 
            if(reset = '1') then
                currState <= n/2;
            else
                if(inputStream = '1') then
                    if(not (currState = n - 1)) then
                        currState <= currState + 1;
                    end if;
                else
                    if(not (currState = 0)) then
                        currState <= currState -1;
                    end if;
                end if;
            
            end if;
        end if;
    end process;
    
    outputStream <= '1' when (currState >= n/2) else '0';
end arch;
