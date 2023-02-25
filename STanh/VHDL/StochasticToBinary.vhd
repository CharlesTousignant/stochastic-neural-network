----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/06/2022 11:46:22 AM
-- Design Name: 
-- Module Name: StochasticToBinary - Behavioral
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

entity StochasticToBinary is
    Port ( clk : in std_logic;
           reset: in std_logic;
           enNewConversion : in std_logic;
           stochasticStream : in STD_LOGIC;
           binaryResult : out STD_LOGIC_VECTOR (15 downto 0);
           outputValid : out std_logic
    );
           
end StochasticToBinary;

architecture arch of StochasticToBinary is
signal currConversion : std_logic_vector (15 downto 0) := (others => '0');
begin
    process(clk)
    variable i : integer := 0;
    begin
        if(rising_edge(clk)) then
            if(reset = '1') then
                currConversion  <= (others => '0');
                i := 0;
                outputValid <= '0';
            elsif (enNewConversion = '1') then
                if( i < 2 ** 16 - 1) then
                    outputValid <= '0';
                        if ( stochasticStream = '1') then
                            currConversion <= std_logic_vector ( unsigned(currConversion) + 1); 
                        end if; 
                    i := i + 1;             
                else
                    outputValid <= '1';
                    binaryResult <= currConversion;
                    if (enNewConversion = '1') then
                        i := 0;
                        currConversion <= (others => '0');
                    end if;
                end if;
            end if;
        end if;
    end process;
    

end arch;
