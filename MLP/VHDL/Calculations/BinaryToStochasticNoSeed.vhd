library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;  	
 
use work.all;

entity BinaryToStochasticNoSeed is
   
    port(
		clk : in std_logic;
		randVec : std_logic_vector(31 downto 0);
		binary: in std_logic_vector (31 downto 0);  
		reset : in std_logic; 
		output : out std_logic
    );
end;

architecture arch of BinaryToStochasticNoSeed is

signal input : unsigned(31 downto 0);
signal randNum : unsigned(31 downto 0);

begin 
    input <= unsigned(binary);
    randNum <= unsigned(randVec);
    output <= '1' when (input > randNum) else '0'; 
end arch;