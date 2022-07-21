library std;
use std.standard.all;

library ieee;
use ieee.std_logic_1164.all;

entity outputlogic is
	port(ir : inout std_logic_vector(15 downto 0);
		rst : in std_logic;
		clk : in std_logic;
		C : in std_logic;
		Z : in std_logic;
		Rf_a3 : in std_logic_vector(2 downto 0);
		rst_i : out std_logic;
		
		control_signal : out std_logic_vector(29 downto 0);
		nextstate : inout std_logic_vector(4 downto 0));
end outputlogic;

architecture arch of outputlogic is
component flag is 
   port (
    din  : in  std_logic;
	 enable: in std_logic;
	 clk     : in  std_logic;
    dout : out std_logic );
end component;

signal currentstate: std_logic_vector(4 downto 0);
begin 
	
	statelogic_ist : process(currentstate, rst, ir, Rf_a3, C, Z)

	variable control_variable :  std_logic_vector(29 DOWNTO 0);
	
	begin 
		if rst = '1' then
			control_variable := (others =>'0');
			control_variable(24) := '1';
			control_variable(25) := '1';
			
			nextstate <= "00000";

		elsif currentstate = "00000" then --s0
			control_variable := (others => '0');
			control_variable(5) := '1';
			control_variable(6) := '1';
			
			nextstate <= "00001";
			
		elsif currentstate = "00001" then --s1
			control_variable := (others => '0');
			control_variable(18) := '1';
			control_variable(12) := '1';
			control_variable(13) := '1';
			
			if ir(15 downto 12) = "0001" then --opcode for (add family - adi)
				if ((ir(1 downto 0) = "10") and C ='0') then
					nextstate <= "00000";
				elsif ((ir(1 downto 0) = "01") and Z ='0') then
					nextstate <= "00000";
				elsif (ir(1 downto 0) = "11") then
					nextstate <= "00100";
				else
					nextstate <= "00010";
				end if;
			
			elsif ir(15 downto 12) = "0000" then --opcode for adi
				nextstate <= "00101";
				
			elsif ir(15 downto 12) = "0010" then  --opcode for nand family
				if ((ir(1 downto 0) = "10") and C ='0') then
					nextstate <= "00000";
				elsif ((ir(1 downto 0) = "01") and Z ='0') then
					nextstate <= "00000";
				else
					nextstate <= "00010";
				end if;
				
			elsif ir(15 downto 12) = "0110" then --opcode for lhi
				nextstate <= "00111";
				
			elsif (ir(15 downto 12) = "0111") or (ir(15 downto 12) = "0101") then --opcode for lw and sw
				nextstate <= "01000";
				
			elsif (ir(15 downto 12) = "1100") or (ir(15 downto 12) = "1101") then --opcode for lm and sm
				nextstate <= "10001";
				
			elsif ir(15 downto 12) = "1000" then --opcode for beq
				nextstate <= "00010";
				
			elsif (ir(15 downto 12) = "1001") or (ir(15 downto 12) = "1010") then --opcode for jal and jlr
				nextstate <= "01100";
				
			elsif ir(15 downto 12) = "1011" then --opcode for jr1
				nextstate <= "01111";
				
			else --unknown instruction or ib
				nextstate <= "00000";
			
			end if;			

			
		elsif currentstate = "00010" then --s2
			control_variable := (others => '0');
			control_variable(6) := '1';
			control_variable(8) := '1';
			control_variable(10) := '1';
			control_variable(11) := '1';
			if ir(0) = '1' then
				control_variable(5) := '1';
			elsif ir(15) = '1' then
				control_variable(5) := '1';
				control_variable(6) := '0';
				
			end if;
			
			if Z = '1' then
				nextstate <= "01011";
			else
				nextstate <= "00011";
			end if;
		
		
		elsif currentstate = "00011" then --s3
			control_variable := (others => '0');
			control_variable(11) := '1';
			control_variable(12) := '1';
			control_variable(14) := '1';
			control_variable(15) := '1';
			control_variable(17) := '1';
			
			nextstate <= "00000";
			
		elsif currentstate = "00100" then --s4
			control_variable := (others => '0');
			control_variable(5) := '1';
			control_variable(6) := '1';
			control_variable(8) := '1';
			control_variable(9) := '1';
			
			nextstate <= "00011";
			
			
		elsif currentstate = "00101" then --s5
			control_variable := (others => '0');
			control_variable(5) := '1';
			control_variable(6) := '1';
			control_variable(9) := '1';
			control_variable(10) := '1';
			control_variable(11) := '1';
			control_variable(26) := '1';
			
			nextstate <= "00110";
		
		elsif currentstate = "00110" then --s6
			control_variable := (others => '0');
			control_variable(12) := '1';
			control_variable(15) := '1';
			control_variable(17) := '1';
			
			nextstate <= "00000";
		
		elsif currentstate = "00111" then --L0
			control_variable := (others => '0');
			control_variable(12) := '1';
			control_variable(14) := '1';
			control_variable(16) := '1';
			
			nextstate <= "00000";
			
		elsif currentstate = "01000" then --L1
			control_variable := (others => '0');
			control_variable(8) := '1';
			control_variable(9) := '1';
			control_variable(10) := '1';
			control_variable(11) := '1';
			control_variable(26) := '1';
			
			if ir(13) = '1' then
				nextstate <= "01001";
			else
				nextstate <= "01010";
			end if;
			
		elsif currentstate = "01001" then --L2
			control_variable := (others => '0');
			control_variable(0) := '1';
			control_variable(3) := '1';
			control_variable(12) := '1';
			control_variable(14) := '1';
			control_variable(16) := '1';
			control_variable(17) := '1';
			
			nextstate <= "00000";
		
		elsif currentstate = "01010" then --L3
			control_variable := (others => '0');
			control_variable(1) := '1';
			control_variable(3) := '1';
			control_variable(11) := '1';
			
			nextstate <= "00000";
			
		elsif currentstate = "01011" then --B1
			control_variable := (others => '0');
			control_variable(5) := '1';
			control_variable(6) := '1';
			control_variable(9) := '1';
			control_variable(10) := '1';
			control_variable(18) := '1';
			control_variable(19) := '1';
			control_variable(26) := '1';
			
			ir(15 downto 12) <= "1111";
			nextstate <= "00001";
			
		elsif currentstate = "01100" then --B2
			control_variable := (others => '0');
			control_variable(12) := '1';
			control_variable(14) := '1';
			
			if ir(12)='1' then
				nextstate <= "01101";
			else
				nextstate <= "01110";
			end if;
		
		elsif currentstate = "01101" then --B3
			control_variable := (others => '0');
			control_variable(5) := '1';
			control_variable(6) := '1';
			control_variable(9) := '1';
			control_variable(10) := '1';
			control_variable(18) := '1';
			control_variable(19) := '1';
			control_variable(26) := '1';
			control_variable(27) := '1';
			
			ir(15 downto 12) <= "1111";
			nextstate <= "00001";
			
		elsif currentstate = "01110" then --B4
			control_variable := (others => '0');
			control_variable(11) := '1';
			control_variable(19) := '1';
			control_variable(20) := '1';
			
			ir(15 downto 12) <= "1111";
			nextstate <= "00001";
		
		elsif currentstate = "01111" then --B5
			control_variable := (others => '0');
			control_variable(8) := '1';
			control_variable(9) := '1';
			control_variable(10) := '1';
			control_variable(11) := '1';
			control_variable(26) := '1';
			control_variable(27) := '1';
			
			nextstate <= "10000";
		
		elsif currentstate = "10000" then --B6
			control_variable := (others => '0');
			control_variable(19) := '1';
			
			ir(15 downto 12) <= "1111";
			nextstate <= "00001";
		end if;

	control_signal <= control_variable;

	end process;					
end arch ;