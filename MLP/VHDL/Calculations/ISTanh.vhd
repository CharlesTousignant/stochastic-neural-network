library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;  	
use work.utils.all;

entity ISTanh is
    Generic(
        m: integer;
        n: integer
    );
    Port (  clk : in std_logic;
            reset: in std_logic;
            inputStream: in signed(f_log2(m) downto 0);
            outputStream : out std_logic
    );
end ISTanh;

architecture arch of ISTanh is
constant numStates : positive := (n * m);
signal currState : unsigned(f_log2(numStates) - 1 downto 0) := to_unsigned(numStates / 2, f_log2(numStates));

begin
    process(clk)
    variable nextState : signed(f_log2(numStates) downto 0);
    variable nextStateVector : std_logic_vector(f_log2(numStates) downto 0);
    variable currStateSigned : signed(f_log2(numStates) downto 0);
    begin  
        currStateSigned := signed('0' & std_logic_vector(currState));
        if (rising_edge(clk)) then 
            if (reset = '1') then
                currState <= to_unsigned(numStates / 2, currState'length);
				nextState := to_signed(numStates / 2, nextState'length);
            else
				nextState := currStateSigned + inputStream;
                if (nextState(nextState'length - 1) = '1') then -- underflow
                    currState <= to_unsigned(0, currState'length);
                elsif (nextState > numStates) then
					currState <= to_unsigned(numStates, currState'length);
				else
				    nextStateVector := (std_logic_vector(nextState));
					currState <= unsigned(nextStateVector(currState'length - 1 downto 0));
                end if;
            end if;
        end if;
    end process;
    
    outputStream <= '1' when (currState >= numStates/2) else '0';
end arch;
