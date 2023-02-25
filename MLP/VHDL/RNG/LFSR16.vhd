library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;  	
use work.all;
use work.utils.all;

entity LFSR16 is 
    generic(seed: integer);
    port (
	clk, reset : in std_logic;
    random: out std_logic_vector(31 downto 0)
	);
end LFSR16;

architecture arch of LFSR16 is	
constant stateSize : integer := 16;
constant seed1: std_logic_vector(stateSize - 1 downto 0) := seeds(seed)(15 downto 0);
constant differentTaps: LFSRPolynomial := 
(
x"8016",
x"801C",
x"801F",
x"8029",
x"805E",
x"806B",
x"8097",
x"809E",
x"80A7",
x"80AE",
x"80CB",
x"80D0",
x"80D6",
x"80DF",
x"80E3",
x"810A",
x"810C",
x"8112",
x"8117",
x"812E",
x"8136",
x"8142",
x"8148",
x"8150",
x"8172",
x"818E",
x"81A5",
x"81B4",
x"81B8",
x"81C3",
x"81C6",
x"81CF",
x"81D1",
x"81EE",
x"81FC",
x"8214",
x"822B",
x"8233",
x"8241",
x"8244",
x"8248",
x"825F",
x"8260",
x"8299",
x"82A3",
x"82B4",
x"82C3",
x"82E1",
x"82EE",
x"82F5",
x"8320",
x"8325",
x"8329",
x"8345",
x"8361",
x"83B5",
x"83B6",
x"83BC",
x"83C1",
x"83F8",
x"8406",
x"8430",
x"845F",
x"846A",
x"846F",
x"8471",
x"8478",
x"847D",
x"849C",
x"84BE",
x"84C5",
x"84D2",
x"84D7",
x"84E1",
x"84E2",
x"84F3",
x"84F9",
x"853E",
x"8540",
x"855D",
x"8562",
x"8580",
x"8589",
x"858A",
x"85A8",
x"85AE",
x"85E6",
x"85E9",
x"85F2",
x"8607",
x"860E",
x"8610",
x"8634",
x"8638",
x"863D",
x"8646",
x"864A",
x"8651",
x"8657",
x"8679"
);

constant chosenTaps : std_logic_vector (stateSize - 1 downto 0) :=  differentTaps( to_integer(unsigned(seed1) mod 100));
signal state : std_logic_vector (stateSize - 1 downto 0) :=  seed1;
begin	
						    
    process(clk)
    variable newBit: std_logic;
    begin
    if (rising_edge(clk)) then
    
        if(reset = '1') then
            state <= seed1;
        else    
            newBit := xor(state and chosenTaps);
            state <= state(stateSize - 2 downto 0) & newBit;
        end if;
    end if;
	end process;
	
	random <= state & x"0000";
end arch;