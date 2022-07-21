library std;
use std.standard.all;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Reg is 
	port(
		 d_in  : in std_logic_vector(15 DOWNTO 0);
		 en  : in std_logic; 
		 rst : in std_logic; 
		 clk : in std_logic;
		 d_out   : out std_logic_vector(15 DOWNTO 0)); 
end Reg;

architecture Struct of Reg is

begin
    process(clk, rst)
    begin
        if rst = '1' then
            d_out <= "0000000000000000";
        elsif (clk'event and clk = '1') then
            if en = '1' then
                d_out <= d_in;
            end if;
        end if;
    end process;
end Struct;