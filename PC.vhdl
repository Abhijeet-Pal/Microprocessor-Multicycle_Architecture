library std;
use std.standard.all;

library ieee;
use ieee.std_logic_1164.all;

entity PC is 
	port(
		 d_in  : in std_logic_vector(15 DOWNTO 0);
		 en  : in std_logic; 
		 rst : in std_logic; 
		 clk : in std_logic;
		 d_out   : out std_logic_vector(15 DOWNTO 0)); 
end PC;

architecture Struct of PC is

begin
    process(clk, rst)
    begin
        if rst = '1' then
            d_out <= "0000000000000000";
        elsif rising_edge(clk) then
            if en = '1' then
                d_out <= d_in;
            end if;
        end if;
    end process;
end Struct;