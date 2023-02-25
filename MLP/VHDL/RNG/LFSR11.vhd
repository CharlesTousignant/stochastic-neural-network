library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;  	
use work.all;
use work.utils.all;

entity LFSR11 is 
    generic(seed: integer);
    port (
	clk : in std_logic;
	reset: in std_logic;
    random: out std_logic_vector(31 downto 0)
	);
end LFSR11;

architecture arch of LFSR11 is	
constant stateSize : integer := 11;
constant seed1: std_logic_vector(stateSize - 1 downto 0) := seeds(seed)(stateSize - 1 downto 0);
constant differentTaps: LFSRPolynomial  := 
(
x"402",
x"40B",
x"415",
x"416",
x"423",
x"431",
x"432",
x"438",
x"43D",
x"446",
x"44A",
x"44F",
x"454",
x"458",
x"467",
x"468",
x"470",
x"473",
x"475",
x"47A",
x"486",
x"489",
x"492",
x"494",
x"49D",
x"49E",
x"4A2",
x"4A4",
x"4A8",
x"4AD",
x"4B9",
x"4BA",
x"4BF",
x"4C1",
x"4C7",
x"4D5",
x"4D6",
x"4DC",
x"4E3",
x"4EC",
x"4F2",
x"4FB",
x"500",
x"503",
x"509",
x"50A",
x"514",
x"524",
x"530",
x"536",
x"53C",
x"53F",
x"542",
x"548",
x"54E",
x"553",
x"555",
x"559",
x"55A",
x"56A",
x"56F",
x"574",
x"577",
x"578",
x"57D",
x"581",
x"584",
x"588",
x"599",
x"59F",
x"5A0",
x"5A5",
x"5AC",
x"5AF",
x"5B2",
x"5B7",
x"5BE",
x"5C3",
x"5C5",
x"5C9",
x"5CA",
x"5D7",
x"5DB",
x"5DE",
x"5E4",
x"5ED",
x"5EE",
x"5F3",
x"5F6",
x"605",
x"606",
x"60C",
x"60F",
x"62B",
x"630",
x"635",
x"639",
x"642",
x"644",
x"64B"
);

--constant chosenTaps : std_logic_vector (stateSize - 1 downto 0) :=  differentTaps( to_integer(unsigned(seed1) mod 100))(0 to stateSize -1 );
constant chosenTaps : std_logic_vector (stateSize - 1 downto 0) :=  differentTaps(0)(0 to stateSize -1 );
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
	
	random <= state & (31 - stateSize downto 0 => '0');
end arch;