LIBRARY ieee;
USE ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;
use ieee.numeric_std.all; 
use work.all;
use work.utils.all;
use work.utilsTreeAdder.all;
use work.parameters.all;


entity SigmoidNeuron is
    GENERIC( 
      numInputs: integer;
      inputWeights : neuronWeights(0 to numInputs - 1);
      bias : neuronBias;
      scale: integer
   );
  Port ( 
      clk: in std_logic;
      reset: in std_logic;
      inputs: in std_logic_vector(0 to numInputs - 1);
	  weightGenRandNums : in randomNumberVector( ( numInputs + 1) * m downto 0);
      result: out std_logic
   );
end SigmoidNeuron;

architecture arch of SigmoidNeuron is

constant mPrime : integer := numInputs + 1;
signal multiplicationResults : ISStreams(0 to numInputs - 1); 
 
signal biasStreams : std_logic_vector(0 to m - 1) := (others =>'0');
signal biasISStream : signed(f_log2(m) downto 0);

signal multiplicationAndBiasStreams : ISStreams(0 to numInputs);
signal addResult : signed(f_log2(mPrime) downto 0) := (others => '0');

signal tanhResult : std_logic := '0';
begin
     Multiplication : entity BipolarStochasticMultiplier (arch)
     GENERIC MAP (
         numInputs => numInputs,
         mutliplicationWeights => inputWeights,
         scale => m
     )
     PORT MAP (
         clk    => clk,
         reset    => reset,
         inputs => inputs,
         weightGenRandNums => weightGenRandNums( (numInputs * m) - 1 downto 0),
         multiplicationResults => multiplicationResults     
     );
     
      BiasGen : for i in 0 to (m - 1) generate
      module_BinaryToStochasticBias  : entity BinaryToStochasticNoSeed (arch)
      PORT MAP (
         clk    => clk,
         reset    => reset,
         binary => bias,
         randVec => weightGenRandNums(numInputs + i),
         output => biasStreams(i)
      );
      end generate BiasGen;
     
      biasAdder  : entity StochasticAdder (arch)
      GENERIC MAP(
        numInputs => m
      )
      PORT MAP (
         clk    => clk,
         reset    => reset,
         inputs => biasStreams,
         addResult => biasISStream
    );
    
    multiplicationAndBiasStreams <= multiplicationResults & biasISStream;
    addResult <= multResAdderLoop(multiplicationAndBiasStreams, mPrime );

    Tanh : entity ISTanh (arch)
    GENERIC MAP(
        n => 2 * scale / m,
		m => mPrime
    )
    PORT MAP (
         clk    => clk,
         reset    => reset,
         inputStream => addResult,
         outputStream => tanhResult
    );
       
    result <= tanhResult;
end arch;
