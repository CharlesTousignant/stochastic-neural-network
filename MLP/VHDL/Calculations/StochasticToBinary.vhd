library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;  

entity StochasticToBinary is
    Generic(
        precision : integer
    );
    Port ( clk : in std_logic;
           reset: in std_logic;
           stochasticStream : in STD_LOGIC;
           binaryResult : out STD_LOGIC_VECTOR (precision - 1 downto 0);
           outputValid : out std_logic
    );
           
end StochasticToBinary;

architecture arch of StochasticToBinary is
signal currConversion : std_logic_vector (precision - 1 downto 0) := (others => '0');
begin
    process(clk)
    variable i : integer := 0;
    begin
        if(rising_edge(clk)) then
            if(reset = '1') then
                i := 0;
                currConversion <= (others => '0');
                outputValid <= '0';
            elsif( i < 2 ** precision - 1) then
                outputValid <= '0';
                    if ( stochasticStream = '1') then
                        currConversion <= std_logic_vector ( unsigned(currConversion) + 1); 
                    end if; 
                i := i + 1;             
            else
                outputValid <= '1';
                binaryResult <= currConversion;
                i := 0;
            end if;
        end if;
    end process;
end arch;
