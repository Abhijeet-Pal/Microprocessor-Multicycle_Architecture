library ieee;
use ieee.std_logic_1164.all;

entity Full_Adder is
	port(carry,x_in,y_in: in std_logic;  -- carry, input 1, input 2
		c_out,s_out: out std_logic);     -- carry out and sum out
end entity;

architecture Add of Full_Adder is
	signal s1: std_logic;
begin
	s1 <= x_in xor y_in;
	s_out <= s1 xor carry;
	c_out <= ((x_in and y_in) or (y_in and carry) or (carry and x_in));
end Add;