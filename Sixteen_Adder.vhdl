library ieee;
use ieee.std_logic_1164.all;

entity Sixteen_Adder is
	port(x,y: in std_logic_vector(15 downto 0);
		z: out std_logic_vector(15 downto 0);
		c_in: in std_logic;
		c_out: out std_logic); -- Carry flags is output, zero set by main ALU
end entity;

architecture SixteenAdd of Sixteen_Adder is
	signal s1 : std_logic_vector(15 downto 0);
	component Full_Adder is
port(carry,x_in,y_in: in std_logic;  -- carry, input 1, input 2
		c_out,s_out: out std_logic);     -- carry out and sum out
	end component;

begin
	s1(0) <= c_in;
	bit_1: Full_Adder
		port map (s1(0),x(0),y(0),s1(1),z(0));
	bit_2: Full_Adder
		port map (s1(1),x(1),y(1),s1(2),z(1));
	bit_3: Full_Adder
		port map (s1(2),x(2),y(2),s1(3),z(2));
	bit_4: Full_Adder
		port map (s1(3),x(3),y(3),s1(4),z(3));
	bit_5: Full_Adder
		port map (s1(4),x(4),y(4),s1(5),z(4));
	bit_6: Full_Adder
		port map (s1(5),x(5),y(5),s1(6),z(5));
	bit_7: Full_Adder
		port map (s1(6),x(6),y(6),s1(7),z(6));
	bit_8: Full_Adder
		port map (s1(7),x(7),y(7),s1(8),z(7));
	bit_9: Full_Adder
		port map (s1(8),x(8),y(8),s1(9),z(8));
	bit_10: Full_Adder
		port map (s1(9),x(9),y(9),s1(10),z(9));
	bit_11: Full_Adder
		port map (s1(10),x(10),y(10),s1(11),z(10));
	bit_12: Full_Adder
		port map (s1(11),x(11),y(11),s1(12),z(11));
	bit_13: Full_Adder
		port map (s1(12),x(12),y(12),s1(13),z(12));
	bit_14: Full_Adder
		port map (s1(13),x(13),y(13),s1(14),z(13));
	bit_15: Full_Adder
		port map (s1(14),x(14),y(14),s1(15),z(14));
	bit_16: Full_Adder
		port map (s1(15),x(15),y(15),c_out,z(15));

end SixteenAdd;