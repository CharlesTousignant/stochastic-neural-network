library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;  	
 
use work.all;

entity BinaryToStochastic is
   GENERIC( 
      seed: integer
   );
   
    port(
		clk : in std_logic;
		binary: in std_logic_vector (31 downto 0);  
		reset : in std_logic;
		output : out std_logic
    );
end;

architecture arch of BinaryToStochastic is

signal randVec : std_logic_vector(31 downto 0) ;
signal input : unsigned(31 downto 0);
signal randNum : unsigned(31 downto 0);
begin 

    rng : entity LFSR11 (arch)
    GENERIC MAP(
        seed => seed
    )
    PORT MAP (
         clk    => clk,
         reset => reset,
         random => randVec
    );
    input <= unsigned(binary);
    randNum <= unsigned(randVec);
    output <= '1' when (input > randNum) else '0'; 
end arch;