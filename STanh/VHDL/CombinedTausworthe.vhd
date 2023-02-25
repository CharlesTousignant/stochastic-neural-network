----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/13/2022 04:21:49 PM
-- Design Name: 
-- Module Name: CombinedTausworthe - Behavioral
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

use ieee.numeric_std.all; 

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity CombinedTausworthe is
   GENERIC( 
      seed1 : unsigned(31 downto 0) := X"12345678";
      seed2 : unsigned(31 downto 0) := X"23456789";
      seed3 : unsigned(31 downto 0) := X"3456789a"
   );
   
  Port (
    clk : in std_logic;
    reset : in std_logic;
    random : out std_logic_vector (31 downto 0) 
    );
end CombinedTausworthe;

architecture arch of CombinedTausworthe is

begin
    process(clk)
    variable s1 : unsigned (31 downto 0) := seed1;
    variable s2 : unsigned (31 downto 0) := seed2;
    variable s3 : unsigned (31 downto 0) := seed3;
    variable b : unsigned (31 downto 0) := (others => '0');
    begin
        
        if(rising_edge(clk)) then
            if(reset = '1') then
                s1 := seed1;
                s2 := seed2;
                s3 := seed3;
            end if;
            b := shift_right( shift_left(s1, 13) XOR s1, 19);
            s1 := (shift_left(s1 and X"FFFFFFFE", 12)) XOR b;
            
            b := shift_right( shift_left(s2, 2) XOR s2, 25);
            s2 := (shift_left(s2 and X"FFFFFFF8", 4)) XOR b;
            
            b := shift_right( shift_left(s3, 3) XOR s3, 11);
            s3 := (shift_left(s3 and X"FFFFFFF0", 17)) XOR b;
            random <=  std_logic_vector(s1 XOR s2 XOR s3);
        end if;
    end process;
    

end arch;
