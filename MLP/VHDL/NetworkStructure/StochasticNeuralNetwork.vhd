library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;  
use work.all;
use work.utils.all;
use work.parameters.all;

entity StochasticNeuralNetwork is
    generic(
         precision : integer := precision
        );
    port(
        clk : in std_logic; 	

        reset : in std_logic; 
        inputs: in networkInputs(0 to numInputNeurons - 1);
        
        outputs: out networkOutputs(0 to numNeuronsOutput - 1);
        outputsValid: out std_logic
  );
end StochasticNeuralNetwork;

architecture arch of StochasticNeuralNetwork is

constant numInputNeurons : integer := numInputNeurons;
constant numNeuronsHiddenLayer : integer := numNeuronsHiddenLayer;
constant numNeuronsOutput : integer := numNeuronsOutput;

constant hiddenLayerWeights : layerWeights(0 to numNeuronsHiddenLayer - 1) := hiddenLayerWeights;
constant hiddenLayerBiases : layerBiases(0 to numNeuronsHiddenLayer - 1) := hiddenLayerBiases;

constant outputWeights : layerWeights(0 to numNeuronsOutput - 1) := outputWeights;                                      
constant outputBiases : layerBiases(0 to numNeuronsOutput - 1 ) := outputBias;

signal inputStreams : std_logic_vector(0 to numInputNeurons - 1);
signal hiddenLayerOutputStream : std_logic_vector(0 to numNeuronsHiddenLayer - 1);
signal outputLayerStream : std_logic_vector   (0 to numNeuronsOutput - 1);

signal OuputsConversionFinished: std_logic_vector(0 to numNeuronsOutput - 1);
constant numGenPerNeuronHiddenLayer : integer := ((numInputNeurons + 1) * m) + 1;
constant numGenHiddenLayer : integer := numGenPerNeuronHiddenLayer * numNeuronsHiddenLayer;

signal weightGenRandNums : randomNumberVector(0 to numGenPerNeuronHiddenLayer - 1); 
begin
    
    inputNeurons : entity InputLayer (arch)
    GENERIC MAP(
        numInputs => numInputNeurons
    )
    PORT MAP(
        clk => clk,
        reset => reset,
        inputs => inputs,
        inputStreams => inputStreams
    );
	  
    weightsAndBiasRand : for i in 0 to (numGenPerNeuronHiddenLayer - 1) generate
    rng : entity LFSR11  (arch)
    GENERIC MAP(
        seed => numInputNeurons + i + 1
    )
    PORT MAP (
         clk    => clk,
         reset => reset,
         random => weightGenRandNums(i)
    );
    end generate;
    
    hiddenLayer : entity NeuronLayer (arch)
    GENERIC MAP(
        seed => numInputNeurons + 1,
        numInputs => numInputNeurons,
        numNeurons => numNeuronsHiddenLayer,
        weights => hiddenLayerWeights,
        biases => hiddenLayerBiases,
        scales => scalesHiddenLayer 
    )
    PORT MAP (
        clk => clk,
        reset => reset,
        inputs => inputStreams,
        weightGenRandNums => weightGenRandNums,
        outputs => hiddenLayerOutputStream
    );
    
    output : entity NeuronLayer (arch)
    GENERIC MAP(
        seed => numInputNeurons + numGenHiddenLayer + 1,
        numInputs => numNeuronsHiddenLayer,
        numNeurons => numNeuronsOutput,
        weights => outputWeights,
        biases => outputBiases,
        scales => scalesOutputLayer
    )
    PORT MAP (
        clk => clk,
        reset => reset,
        inputs => hiddenLayerOutputStream,
        weightGenRandNums => weightGenRandNums(0 to ( ((numNeuronsHiddenLayer  + 1) * m) + 1)  - 1),
        outputs => outputLayerStream
    );
    
    outputBinary : for i in 0 to (numNeuronsOutput - 1) generate
    neuron : entity StochasticToBinary (arch)
    GENERIC MAP (
        precision => precision
    )
    PORT MAP (
         clk    => clk,
         reset  => reset,
         stochasticStream => outputLayerStream(i),
         binaryResult => outputs(i),
         outputValid => OuputsConversionFinished(i)
    );
    end generate outputBinary;
    outputsValid <= and OuputsConversionFinished;
end arch;
