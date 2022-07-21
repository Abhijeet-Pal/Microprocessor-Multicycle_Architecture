library std;
use std.standard.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity T1 is 
	port(
		 d_in  : in std_logic_vector(15 downto 0);
		 en  : in std_logic; 
		 
		 clk : in std_logic;
		 d_out   : out std_logic_vector(15 downto 0)); 
end T1;

architecture Struct of T1 is

begin
    process(clk)
    begin
        
        if rising_edge(clk) then
            if en = '1' then
                d_out <= d_in;
            end if;
        end if;
    end process;
end Struct;