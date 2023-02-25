library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.utils.all;
use work.all;

entity InputLayer is
    Generic(
        numInputs: integer
    );
  Port (
        clk: in std_logic;
        reset: in std_logic;
        inputs: in networkInputs(0 to numInputs - 1);
        inputStreams: out std_logic_vector(0 to numInputs - 1)
         );
end InputLayer;

architecture arch of InputLayer is

begin
    INPUT : for i in 0 to (numInputs - 1) generate
    InputNeuron  : entity BinaryToStochastic (arch)
    GENERIC MAP( 
        seed => i + 1
    )
    PORT MAP (
     clk    => clk,
     reset    => reset,
     binary => inputs(i),
     output => inputStreams(i)
    );
    end generate INPUT;
end arch;
