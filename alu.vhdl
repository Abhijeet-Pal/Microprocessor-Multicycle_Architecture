library std;
use std.standard.all;
library ieee;
use ieee.std_logic_1164.all;

entity alu is 
	port( X,Y : in std_logic_vector(15 downto 0);  --cb1, cb2 control bits
		cb1,cb2 : in std_logic ;
		C_in: in std_logic;
		C_out, Z_out: out std_logic;
		S_out : out std_logic_vector(15 downto 0));
end entity;

architecture alu_behave of alu is
	signal sig1,sig2,sig3: std_logic_vector(15 downto 0);
	signal car1, car2 : std_logic;

	component Sixteen_Adder is
			port(x,y: in std_logic_vector(15 downto 0);
		z: out std_logic_vector(15 downto 0);
		c_in: in std_logic;
		c_out: out std_logic);
	end component;

	component comparator is
	port(x,y: in std_logic_vector(15 downto 0);
		comp_out: out std_logic); 
	end component;

	component Sixteen_Nand is
	port(x,y: in std_logic_vector(15 downto 0);
		z: out std_logic_vector(15 downto 0));
	end component;

begin
	a: Sixteen_Adder port map (x => X, y => Y, z => sig1, c_in => C_in, c_out => car1);
	b: comparator port map (x => X, y => Y, comp_out => car2);
	c: Sixteen_Nand port map (x => X, y => Y, z => sig3);

	process (cb1, cb2, sig1, sig2, sig3, car1, car2)   
	begin
		if (cb1 = '1' and cb2 = '1') then
			S_out <= sig1; -- ADD operation
			C_out <= car1;
			Z_out <= not (sig1(0) or sig1(1) or sig1(2) or sig1(3) or sig1(4) or sig1(5) or sig1(6) or sig1(7) or sig1(8) or sig1(9) or sig1(10) or sig1(11) or sig1(12) or sig1(13) or sig1(14) or sig1(15));
		elsif (cb1 = '1' and cb2 = '0') then
			S_out <= (0 => car2, others => '0'); --comparison operation
			C_out <= C_in;
			Z_out <= car2;
		elsif (cb1 = '0' and cb2 = '1') then
			S_out <= sig3; -- NAND operation
			C_out <= C_in;
			Z_out <= not (sig3(0) or sig3(1) or sig3(2) or sig3(3) or sig3(4) or sig3(5) or sig3(6) or sig3(7) or sig3(8) or sig3(9) or sig3(10) or sig3(11) or sig3(12) or sig3(13) or sig3(14) or sig3(15));
		end if;
	end process;

end alu_behave;
