library std;
use std.standard.all;
use ieee.numeric_std.all;
library ieee;
use ieee.std_logic_1164.all;

entity mux_16 is
	port(
		en: in std_logic;
		ip0, ip1, ip2, ip3: in std_logic_vector(15 downto 0);
		s1, s2: in std_logic;
		op: out std_logic_vector(15 downto 0)
		);
end entity;

architecture Struct of mux_16 is

begin
	process (en, ip0, ip1, ip2, ip3) begin
	if (en = '1') then
		if (s1 = '0' and s2 = '0') then
			op <= ip0;
		elsif (s1 = '0' and s2 = '1') then
			op <= ip1;
		elsif (s1 = '1' and s2 = '0') then
			op <= ip2;
		elsif (s1 = '1' and s2 = '1') then
			op <= ip3;
		end if;
	end if;
	end process;
end Struct;