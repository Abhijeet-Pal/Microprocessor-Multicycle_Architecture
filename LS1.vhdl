library std;
use std.standard.all;
use ieee.numeric_std.all;
library ieee;
use ieee.std_logic_1164.all;

entity LS1 is    -- left shift 1
   port(ip: in std_logic_vector(15 downto 0);
			op: out std_logic_vector(15 downto 0));
end entity;

architecture Struct of LS1 is

begin
	op(15 downto 1) <= ip(14 downto 0);
	op(0) <= '0';
	
end Struct;