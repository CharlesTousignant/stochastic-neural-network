LIBRARY ieee;
USE ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;
use ieee.numeric_std.all; 
use work.all;
use work.utils.all;
use work.utilsTreeAdder.all;

entity BipolarStochasticMultiplier is
    GENERIC( 
        numInputs: integer;
        mutliplicationWeights: neuronWeights(0 to numInputs - 1);
        scale: integer
    );
    Port (
        clk: in std_logic;
        reset: in std_logic;
        inputs: in std_logic_vector(0 to numInputs - 1);
		weightGenRandNums : in randomNumberVector(0 to numInputs * scale - 1);
        multiplicationResults: out ISStreams(0 to numInputs - 1)
    ); 
end BipolarStochasticMultiplier;

architecture arch of BipolarStochasticMultiplier is
signal weightStream : std_logic_vector(0 to numInputs * scale - 1);
signal addResult : ISStreams(0 to numInputs - 1);
begin
    
      gen_stochStream : for i in 0 to (numInputs * scale - 1) generate
      module_BinaryToStochastic  : entity BinaryToStochasticNoSeed (arch)
      PORT MAP (
         clk    => clk,
         reset    => reset,
		 randVec => weightGenRandNums(i),
         binary => (mutliplicationWeights(i / scale)),
         output => weightStream(i)
      );
      end generate gen_stochStream;
	
	 gen_weightAdd : for i in 0 to (numInputs - 1) generate
      WeightsAdder  : entity StochasticAdder (arch)
      GENERIC MAP(
        numInputs => scale
      )
      PORT MAP (
         clk    => clk,
         reset    => reset,
         inputs => weightStream((scale* i) to scale*(i + 1) - 1),
         addResult => addResult(i)
    );
    end generate gen_weightAdd;
    
	process(clk)
	variable index: integer := 0;
	begin
	   if(rising_edge(clk)) then
	       if(reset = '1') then
	           multiplicationResults <= (others => (to_signed(0, multiplicationResults(0)'length)));
	       else
               for i in inputs'range loop
                   for j in 0 to scale - 1 loop
                       multiplicationResults(i) <= inputs (i) and addResult(i);
                   end loop;
               end loop;
           end if;
       end if;
	end process;
end arch;
