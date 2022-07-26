library std;
use std.standard.all;

library ieee;
use ieee.std_logic_1164.all;

use ieee.numeric_std.all;
entity RF is 
	port(A1, A2, A3 : in std_logic_vector(2 downto 0);
		  D3: in std_logic_vector(15 downto 0);
		  
		clk, rd, wr, R7_wr, reset: in std_logic ; -- No separate control for PC required; simply drive 111 to A3
		D1, D2: out std_logic_vector(15 downto 0));
end entity;

architecture RF_behave of RF is 
 
type registerFile is array(0 to 7) of std_logic_vector(15 downto 0);
signal registers: registerFile;

begin 

process (clk)
begin 
	if((clk'event and clk = '0')) then
		if (reset = '1') then
			for i in 0 to 7 loop
				registers(i) <= "0000000000000000";
			end loop;
		elsif (wr = '1') then
			registers(to_integer(unsigned(A3))) <= D3;
		end if;
	end if;
end process;

process (clk, A1, A2)
begin
	if(rd = '1') then
		D1 <= registers(to_integer(unsigned(A1)));
		D2 <= registers(to_integer(unsigned(A2)));
	end if;
end process;
		  
end RF_behave;
	    
