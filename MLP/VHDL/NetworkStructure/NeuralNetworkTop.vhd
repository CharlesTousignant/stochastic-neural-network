LIBRARY ieee;
USE ieee.std_logic_1164.all;
use std.textio.all;
use ieee.numeric_std.all;
use work.all;
use work.utils.all;
use work.parameters.all;
use work.utilsTreeAdder.all;

entity NeuralNetworkTop is
Port ( 
     clk : in std_logic;
     reset : in std_logic := '0';
     pb_i: in unsigned(2 downto 0);
     led_o : out unsigned(3 downto 0)
     );
end NeuralNetworkTop;

architecture Behavioral of NeuralNetworkTop is

signal outputs: networkOutputs(0 to numNeuronsOutput - 1);
signal outputsValid: std_logic;

signal startNewConversion: std_logic := '0';
signal halfClock: std_logic := '0';
begin
    top  : entity StochasticNeuralNetwork (arch)
      PORT MAP (
         clk    => halfClock,
         reset    => (reset or startNewConversion),
         inputs => test_data(to_integer(pb_i)),
         outputsValid => outputsValid,
         outputs => outputs
    );
    process(clk) 
    begin
        if(rising_edge (clk)) then
            halfClock  <= not(halfClock);
        end if;
    
    end process;
    
    process(halfClock) 
    variable highestActivation: unsigned(precision - 1 downto 0):= (others => '0');
    variable highestActivationIndex: integer := 15;
    begin
        if(rising_edge (halfClock)) then
            if(outputsValid = '1') then
                highestActivation := (others => '0');
                highestActivationIndex := 15; 
                for i in 0 to 9 loop
                    if( unsigned(outputs(i)) > highestActivation) then
                        highestActivation := unsigned(outputs(i));
                        highestActivationIndex := i;
                    end if; 
                end loop;
                led_o <= to_unsigned(highestActivationIndex, led_o'length);
                startNewConversion <= '1';
            else
                startNewConversion <= '0';      
            end if; 
        end if; 
    end process;
end Behavioral;
