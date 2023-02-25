LIBRARY ieee;
USE ieee.std_logic_1164.all;
use std.textio.all;
use ieee.numeric_std.all;
use work.all;
use work.utils.all;
use work.parameters.all;
use work.utilsTreeAdder.all;

entity NeuralNetwork_TB is
-- Port (

-- );
end NeuralNetwork_TB;

architecture arch of NeuralNetwork_TB is

constant C_FILE_NAME :string  := "MLP_results.dat";

signal clk : std_logic;
signal reset : std_logic := '0';
signal outputValid: std_logic;

signal outputs: networkOutputs(0 to numNeuronsOutput - 1);
file fptr: text;

signal inputNeuron: std_logic_vector (31 downto 0):= (others => '0');

signal testIndex : integer := 0;
constant timePertest : integer := 100 * 2**precision;
begin
    process
    begin
        clk <= '0';
        wait for 50 ns;
        clk <= '1';
        wait for 50 ns;
    end process;
    
    process
    begin
        reset <= '1';
        wait for 100ns;
        reset <= '0';
        wait for timePertest * 1ns;
    end process;
    
    top  : entity StochasticNeuralNetwork (arch)
      PORT MAP (
         clk    => clk,
         reset    => reset,
         inputs => test_data(testIndex),
         outputsValid => outputValid,
         outputs => outputs
    );
    
    process
    variable fstatus       :file_open_status;
    variable file_line     :line;
    
    variable highestActivation: unsigned(precision -1  downto 0)  := (others => '0');
    variable highestActivationindex: integer := 15;
    
    variable numImageCorrect: integer := 0;
    begin
        file_open(fstatus, fptr, C_FILE_NAME, write_mode);
        while (testIndex < test_data'length) loop
            wait until clk = '1';
            
            if(outputValid = '1') then
                highestActivation := (others => '0');
                highestActivationindex := 15;
                for i in 0 to numNeuronsOutput - 1 loop
                    write(file_line, string'("'"), left, 0);
                    hwrite(file_line, unsigned(outputs(i)), left, 0);
                    write(file_line, string'(","), left, 0);
                    if( unsigned(outputs(i)) > highestActivation) then
                        highestActivation := unsigned(outputs(i));
                        highestActivationIndex := i;
                    end if;
                end loop;
                writeline(fptr, file_line);
                inputNeuron <= std_logic_vector(unsigned(inputNeuron) + 2**28);
                if(not (testLabels(testIndex) = highestActivationindex)) then
                    report "Did not recognize " & integer'image(testLabels(testIndex)) & ", identified as: " & integer'image(highestActivationIndex);
                else
                    report "Recognized " & integer'image(testLabels(testIndex)) & " properly";
                    numImageCorrect := numImageCorrect + 1;
                end if;  
                  
                testIndex <= testIndex + 1;
                report "Total Images correct: " & integer'image(numImageCorrect) & "accuracy: " & to_string(real(numImageCorrect)/real(testIndex + 1), 3);
            end if;         
         end loop;
    end process;
end arch;
