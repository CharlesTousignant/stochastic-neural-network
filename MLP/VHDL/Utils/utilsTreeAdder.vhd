library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.utils.all;

package utilsTreeAdder is
    type ISStreams is array (natural range<>) of signed(f_log2(m) downto 0);
    function multResAdderLoop(multRes: ISStreams; maxVal: integer) return signed;
end package;

package body utilsTreeAdder is
	function multResAdderLoop(multRes: ISStreams; maxVal: integer) return signed is
		variable h: signed(f_log2(multRes'length * m) downto 0);
		variable cappedResult: std_logic_vector(h'length -1 downto 0);
		variable cappedResultSigned: signed(f_log2(maxVal) downto 0);
	begin
		h := to_signed(0, h'length);
		for i in multRes'range loop
		  h := h + multRes(i);
		end loop;
		cappedResult := std_logic_vector(maximum(minimum(h, maxVal), -maxVal));
		cappedResultSigned := signed(cappedResult(f_log2(maxVal) downto 0));
		return cappedResultSigned;
	end function multResAdderLoop;
end package body;