library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;  	
 
use work.all;

entity BinaryToStochastic is
   GENERIC( 
      a : std_logic_vector(31 downto 0) :=      X"91240000";
      shift0 : std_logic_vector(31 downto 0) := X"0000000C";
      shiftB : std_logic_vector(31 downto 0) := X"00000007";
      shiftC : std_logic_vector(31 downto 0) := X"0000000F";
      shift1 : std_logic_vector(31 downto 0) := X"00000012";
      maskB : std_logic_vector(31 downto 0) :=  X"E4ECED00";
      maskC : std_logic_vector(31 downto 0) :=  X"DFD08000"
   );
   
    port(
		clk : in std_logic; -- l'horloge de la carte à 100 MHz	
		binary: in std_logic_vector (15 downto 0);  
		reset : in std_logic; -- bouton du centre 
		output : out std_logic
    );
end;

architecture arch of BinaryToStochastic is

signal randVec : std_logic_vector(31 downto 0) ;
signal input : unsigned(15 downto 0);
signal randNum : unsigned(15 downto 0);
begin 
--    module_MersenTwister : entity mt_mem(struct)
--          GENERIC MAP(
--        a => a,
--        shift0 => shift0,
--        shiftB => shiftB,
--        shiftC => shiftC,
--        shift1 => shift1,
--        maskB => maskB,
--        maskC => maskC
--      )
      
--      PORT MAP (
--         clk    => clk,
--         ena    => '1',
--         resetn => not(reset) ,
--         random => randVec
--    );

    module_CombinedTausworthe : entity CombinedTausworthe(arch)
    
    GENERIC MAP(
        seed1 => x"12345678",
        seed2 => x"23456789",
        seed3 => x"3456789a"
    )
    
    PORT MAP (
         clk    => clk,
         reset => reset,
         random => randVec
    );
    input <= unsigned(binary);
    randNum <= unsigned(randVec(31 downto 16));
    output <= '1' when (input > randNum) else '0'; 
--    process(clk)
--    begin
--    if (rising_edge(clk)) then
--        if(reset = '1') then
--            output <= '0';
--        else 
--            if(input > randNum) then
--                output <= '1';
--            else 
--                output <= '0';
--            end if;
--        end if;   
--    end if;  
--    end process;
end arch;