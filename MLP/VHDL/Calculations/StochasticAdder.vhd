library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 
use work.all;
use work.utils.all;

entity StochasticAdder is
    GENERIC( 
      numInputs: integer
   );
  Port (
      clk: in std_logic;
      reset: in std_logic;
      inputs: in std_logic_vector(numInputs - 1 downto 0);
      addResult: out signed(f_log2(numInputs) downto 0) -- +1 for sign
  );
end StochasticAdder;

architecture arch of StochasticAdder is
constant minValue : signed(f_log2(numInputs) downto 0) := to_signed(-numInputs, f_log2(numInputs) + 1);
begin

    process(clk)
    variable unsignedInputSum : unsigned(f_log2(numInputs) - 1 downto 0);
    begin
        if(rising_edge(clk)) then
           if(reset = '1') then
                addResult <= to_signed(0, addResult'length);
           else
               unsignedInputSum := to_unsigned(bitAdderTree(inputs), unsignedInputSum'length);
               addResult <= (minValue + signed('0' & std_logic_vector(unsignedInputSum)) + signed('0' & std_logic_vector(unsignedInputSum))); -- conversion to bipolar integer stochastic
           end if;         
        end if;
	end process;
end arch;
