library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;  	
use work.all;
use work.utils.all;

entity LFSR32 is 
    generic(
        seed: integer
    );
    port (
	   clk, reset : in std_logic;
        random: out std_logic_vector(31 downto 0)
	);
end LFSR32;

architecture arch of LFSR32 is	
constant stateSize : integer := 32;
constant seed1: std_logic_vector(stateSize - 1 downto 0) := seeds(seed);
type LFSRPolynomial32 is array(natural range<>) of std_logic_vector(stateSize - 1 downto 0);
constant differentTaps: LFSRPolynomial := 
(
x"80000057",
x"80000062",
x"8000007A",
x"80000092",
x"800000B9",
x"800000BA",
x"80000106",
x"80000114",
x"8000012D",
x"8000014E",
x"8000016C",
x"8000019F",
x"800001A6",
x"800001F3",
x"8000020F",
x"800002CC",
x"80000349",
x"80000370",
x"80000375",
x"80000392",
x"80000398",
x"800003BF",
x"800003D6",
x"800003DF",
x"800003E9",
x"80000412",
x"80000414",
x"80000417",
x"80000465",
x"8000046A",
x"80000478",
x"800004D4",
x"800004F3",
x"8000050B",
x"80000526",
x"8000054C",
x"800005B6",
x"800005C1",
x"800005EC",
x"800005F1",
x"8000060D",
x"8000060E",
x"80000629",
x"80000638",
x"80000662",
x"8000066D",
x"80000676",
x"800006AE",
x"800006B0",
x"800006BC",
x"800006D6",
x"8000073C",
x"80000748",
x"80000766",
x"8000079C",
x"800007B7",
x"800007C3",
x"800007D4",
x"800007D8",
x"80000806",
x"8000083F",
x"80000850",
x"8000088D",
x"800008E1",
x"80000923",
x"80000931",
x"80000934",
x"8000093B",
x"80000958",
x"80000967",
x"800009D5",
x"80000A25",
x"80000A26",
x"80000A54",
x"80000A92",
x"80000AC4",
x"80000ACD",
x"80000B28",
x"80000B71",
x"80000B7B",
x"80000B84",
x"80000BA9",
x"80000BBE",
x"80000BC6",
x"80000C34",
x"80000C3E",
x"80000C43",
x"80000C7F",
x"80000CA2",
x"80000CEC",
x"80000D0F",
x"80000D22",
x"80000D28",
x"80000D4E",
x"80000DD7",
x"80000E24",
x"80000E35",
x"80000E66",
x"80000E74",
x"80000EA6"
);

--constant chosenTaps : std_logic_vector (stateSize - 1 downto 0) :=  differentTaps( to_integer(unsigned(seed1) mod 100));
constant chosenTaps : std_logic_vector (stateSize - 1 downto 0) := x"80000062";
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
	
	random <= state;
end arch;