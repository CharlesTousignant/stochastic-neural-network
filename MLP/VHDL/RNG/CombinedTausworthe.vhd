LIBRARY ieee;
USE ieee.std_logic_1164.all;
use std.textio.all;
use ieee.numeric_std.all; 
use work.utils.all;

entity CombinedTausworthe is
   GENERIC( 
      seed: integer
   );
   
  Port (
    clk : in std_logic;
    reset : in std_logic;
    random : out std_logic_vector (31 downto 0) 
    );
end CombinedTausworthe;

architecture arch of CombinedTausworthe is

constant seed1: std_logic_vector(31 downto 0) := seeds(seed);
constant seed2: std_logic_vector(31 downto 0) := seeds(seed + 1);
constant seed3: std_logic_vector(31 downto 0) := seeds(seed + 3);
begin
    process(clk)
    variable s1 : unsigned (31 downto 0) := unsigned(seed1);
    variable s2 : unsigned (31 downto 0) := unsigned(seed2);
    variable s3 : unsigned (31 downto 0) := unsigned(seed3);
    variable b : unsigned (31 downto 0) := (others => '0');
   
    begin
        if(rising_edge(clk)) then
            if(reset = '1') then
                s1 := unsigned(seed1);
                s2 := unsigned(seed2);
                s3 := unsigned(seed3);
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
