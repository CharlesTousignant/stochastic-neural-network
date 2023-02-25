--incrementerVHDL.vhd

LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity NeuralNetWrapper is
	generic (
		WIDTH : integer := 32;
		numPixels : integer := 784;
		numOutputs : integer := 10
	);
  port(
    clk : in std_logic;
    rst : in std_logic;
    
    
    image: in std_logic_vector((numPixels*WIDTH) - 1 downto 0);
    imageValid: in std_logic;
    
    netResult : out std_logic_vector((numOutputs*WIDTH)-1 downto 0);
    outputValid : out std_logic
  ); 
end NeuralNetWrapper;

architecture arch of NeuralNetWrapper is

begin
	process(clk)
	variable pixelIndex : integer := 0;
	begin
		if (rising_edge(clk)) then
			if(imageValid = '1') then
			    for i in 0 to numOutputs - 1 loop
			        for j in 0 to WIDTH - 1 loop
			            netResult(i*WIDTH + j) <= image(i*WIDTH + j);
			        end loop;
			    end loop;
			    outputValid <= '1';
            else
                outputValid <= '0';            
			end if;
		end if;
	end process;

end arch; 