library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.all;
use work.utils.all;

entity NeuronLayer is
  Generic(
    seed: integer;
    numInputs: positive;
    numNeurons: positive;
    weights: layerWeights;
    biases: layerBiases;
    scales: layerScales
  );
  Port (
    clk: in std_logic;
    reset: in std_logic;
    inputs: in std_logic_vector(0 to numInputs - 1);
    weightGenRandNums : in randomNumberVector(0 to ( ((numInputs + 1) * m) + 1)  - 1); 
    outputs: out std_logic_vector(0 to numNeurons - 1)
   );
end NeuronLayer;

architecture arch of NeuronLayer is
begin
    Layer : for i in 0 to (numNeurons - 1) generate
    neuron : entity SigmoidNeuron (arch)
    GENERIC MAP (
        numInputs => numInputs,
        inputWeights => weights(i),
        bias => biases(i),
        scale => scales(i)
    )
    PORT MAP (
         clk    => clk,
         reset  => reset,
         inputs => inputs,
         weightGenRandNums => weightGenRandNums,
         result => outputs(i)
    );
    end generate Layer;
end arch;