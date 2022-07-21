library std;
use std.standard.all;
use ieee.numeric_std.all;
library ieee;
use ieee.std_logic_1164.all;

entity mux_16_lite is
	port(
		en: in std_logic;
		ip0, ip1: in std_logic_vector(15 downto 0);
		s1 : in std_logic;
		op: out std_logic_vector(15 downto 0)
		);
end entity;

architecture Struct of mux_16_lite is

begin
process (en, ip0, s1) begin
	if en = '1' then
		if s1 = '0' then
			op <= ip0;
		elsif s1 = '1' then
			op <= ip1;
		end if;
	end if;
	end process;
end Struct;