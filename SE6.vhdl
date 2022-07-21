library std;
use std.standard.all;
library ieee;
use ieee.std_logic_1164.all;


entity se6 is 
	port( se_in : in std_logic_vector(5 downto 0);
		
		  se_out: out std_logic_vector(15 downto 0));
end entity;

architecture behave_se6 of se6 is 

begin 

process (se_in)
begin


	-- Normal SE
		se_out(5 downto 0) <= se_in(5 downto 0); 
		se_out(15) <= se_in(5);
		se_out(14) <= se_in(5); 
		se_out(13) <= se_in(5);
		se_out(12) <= se_in(5); 
		se_out(11) <= se_in(5);
		se_out(10) <= se_in(5);
		se_out(9) <= se_in(5);
		se_out(8) <= se_in(5);
		se_out(7) <= se_in(5);
		se_out(6) <= se_in(5);

end process;
end behave_se6; 

  

