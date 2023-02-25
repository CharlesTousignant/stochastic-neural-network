----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/30/2022 04:18:22 PM
-- Design Name: 
-- Module Name: STanh_TB - Behavioral
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


LIBRARY ieee;
USE ieee.std_logic_1164.all;
use std.textio.all;
use ieee.numeric_std.all; 
use work.string_ops.all;
use work.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity STanh_TB is
 Port (
    clk: in std_logic;
    reset: in std_logic
 );
end STanh_TB;



architecture Behavioral of STanh_TB is

constant C_FILE_NAME :string  := "DataOut.dat";

signal currVal : std_logic_vector (15 downto 0) := (others => '0');
signal currOutput : std_logic_vector (15 downto 0) := (others => '0');

signal outputValid : std_logic := '0';
signal stochasticStreamCurrVall : std_logic := '0';
signal stochasticStreamCurrOutput : std_logic := '0';

signal enConversion : std_logic := '0';
file fptr: text;
begin

    module_BinaryToStochastic1  : entity BinaryToStochastic (arch)
      PORT MAP (
         clk    => clk,
         reset    => reset,
         binary => currVal,
         output => stochasticStreamCurrVall
    );
    
    module_STanh : entity STanh (arch)
    PORT MAP (
         clk    => clk,
         reset    => reset,
         inputStream => stochasticStreamCurrVall ,
         outputStream => stochasticStreamCurrOutput
    );
    
    module_StochasticToBinary : entity StochasticToBinary (arch)
        PORT MAP (
        clk => clk,
        reset => reset,
        enNewConversion => enConversion,
        stochasticStream => stochasticStreamCurrOutput,
        binaryResult => currOutput,
        outputValid => outputValid
    );
        
    process
    variable fstatus       :file_open_status;
    variable file_line     :line;
    
    begin
        file_open(fstatus, fptr, C_FILE_NAME, write_mode);
        while (unsigned(currVal) <= 2**16 - 1) loop
            wait until clk = '1';
            if(reset = '1') then
                currVal <= (others => '0');
                enConversion <= '0';
            else
                enConversion <= '1';
                if(outputValid = '1') then
                    hwrite(file_line, unsigned(currOutput), left, 0);
                    writeline(fptr, file_line);
                    currVal <= std_logic_vector(unsigned(currVal) + 2**8);
                end if;         
            end if;
         end loop;     
    end process;
end Behavioral;
