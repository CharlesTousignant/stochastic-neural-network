
LIBRARY ieee;
USE ieee.std_logic_1164.all;
use std.textio.all;
use ieee.numeric_std.all; 
use work.utils.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;
  
-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity CombinedTausworthe64 is
   GENERIC( 
      seed: integer
   );
   
  Port (
    clk : in std_logic;
    reset : in std_logic;
    random : out std_logic_vector (63 downto 0) 
    );
end CombinedTausworthe64;

architecture arch of CombinedTausworthe64 is

constant seed1: unsigned := rand_slv(64, (seed - 1) * 3 + 1);
constant seed2: unsigned := rand_slv(64, (seed - 1) * 3 + 2);
constant seed3: unsigned := rand_slv(64, (seed - 1) * 3 + 3);
constant seed4: unsigned := rand_slv(64, (seed - 1) * 3 + 4);
constant seed5: unsigned := rand_slv(64, (seed - 1) * 3 + 5);
begin
    process(clk)
    variable s1 : unsigned (63  downto 0) := unsigned(seed1);
    variable s2 : unsigned (63  downto 0) := unsigned(seed2);
    variable s3 : unsigned (63  downto 0) := unsigned(seed3);
	variable s4 : unsigned (63  downto 0) := unsigned(seed4);
    variable s5 : unsigned (63  downto 0) := unsigned(seed5);
    variable b  : unsigned (63  downto 0) := (others => '0');
   
    begin
        if(rising_edge(clk)) then
            if(reset = '1') then
                s1 := unsigned(seed1);
                s2 := unsigned(seed2);
                s3 := unsigned(seed3);
				s4 := unsigned(seed4);
                s5 := unsigned(seed5);
            end if;
            b := shift_right( shift_left(s1, 1) XOR s1, 53);
            s1 := (shift_left(s1 and X"FFFFFFFFFFFFFFFE", 10)) XOR b;
            
            b := shift_right( shift_left(s2, 24) XOR s2, 50);
            s2 := (shift_left(s2 and X"FFFFFFFFFFFFFE00", 5)) XOR b;
            
            b := shift_right( shift_left(s3, 3) XOR s3, 23);
            s3 := (shift_left(s3 and X"FFFFFFFFFFFFF000", 29)) XOR b;
			
			b := shift_right( shift_left(s4, 5) XOR s4, 24);
            s4 := (shift_left(s4 and X"FFFFFFFFFFFE0000", 23)) XOR b;
			
			b := shift_right( shift_left(s5, 3) XOR s5, 33);
            s5 := (shift_left(s5 and X"FFFFFFFFFF800000", 8)) XOR b;
            random <=  std_logic_vector(s1 XOR s2 XOR s3 XOR s4 XOR s5);
        end if;
    end process;
end arch;
