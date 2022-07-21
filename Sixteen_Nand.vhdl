library ieee;
use ieee.std_logic_1164.all;

entity Sixteen_Nand is
	port(x,y: in std_logic_vector(15 downto 0);
		z: out std_logic_vector(15 downto 0));
end entity;

architecture snand of Sixteen_Nand is

begin
	z <= not (x and y);
end snand;