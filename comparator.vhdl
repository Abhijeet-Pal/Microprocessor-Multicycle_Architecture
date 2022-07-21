library ieee;
use ieee.std_logic_1164.all;

entity comparator is
	port(x,y: in std_logic_vector(15 downto 0);
		comp_out: out std_logic);
end entity;

architecture equality of comparator is
	signal s : std_logic_vector(15 downto 0);
	signal comp : std_logic;
begin
	process (x) begin
	comp <= '0';
	for i in 0 to 15 loop
		s(i) <= (x(i) xor y(i));
		comp <= (comp or s(i));
	end loop;
	comp_out <= comp;
	end process;
end equality;