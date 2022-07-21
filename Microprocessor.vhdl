library std;
use std.standard.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;

entity Microprocessor is
   port(
			clk: in std_logic;
			Clock_50: in std_logic;
			rst_m: in std_logic);
end entity;

architecture Struct of Microprocessor is

component alu is
	port( X,Y : in std_logic_vector(15 downto 0);  --cb1, cb2 control bits
		cb1,cb2 : in std_logic ;
		C_in: in std_logic;
		C_out, Z_out: out std_logic;
		S_out : out std_logic_vector(15 downto 0));
end component;

component mux_16 is
	port(
		en: in std_logic;
		ip0, ip1, ip2, ip3: in std_logic_vector(15 downto 0);
		s1, s2: in std_logic;
		op: out std_logic_vector(15 downto 0)
		);
end component;

component mux_16_lite is
		port(
		en: in std_logic;
		ip0, ip1: in std_logic_vector(15 downto 0);
		s1 : in std_logic;
		op: out std_logic_vector(15 downto 0)
		);
end component;

component mux_3 is
	port(
		en: in std_logic;
		ip0, ip1, ip2, ip3: in std_logic_vector(2 downto 0);
		s1, s2: in std_logic;
		op: out std_logic_vector(2 downto 0)
		);
end component;



component  flag is 
  port (
    din  : in  std_logic;
	 en: in std_logic;
	 clk     : in  std_logic;
    dout : out std_logic );
end  component;



component RF is 
	port(A1, A2, A3 : in std_logic_vector(2 downto 0);
		  D3: in std_logic_vector(15 downto 0);
		  
		clk, rd, wr, R7_wr, reset: in std_logic ; -- No separate control for PC required; simply drive 111 to A3
		D1, D2: out std_logic_vector(15 downto 0));
end component;




component se9 is
	port( se_in : in std_logic_vector(8 downto 0);
		
		  se_out: out std_logic_vector(15 downto 0));
end component;
component se6 is
	port( se_in : in std_logic_vector(5 downto 0);
		
		  se_out: out std_logic_vector(15 downto 0));
end component;

component LS1 is
   port(ip: in std_logic_vector(15 downto 0);
			op: out std_logic_vector(15 downto 0));
end component;

component LS7 is 
   port(ip: in std_logic_vector(8 downto 0);
			op: out std_logic_vector(15 downto 0));
end component;



component T1 is 
	port(
		 d_in  : in std_logic_vector(15 downto 0);
		 en  : in std_logic; 
		 
		 clk : in std_logic;
		 d_out   : out std_logic_vector(15 downto 0)); 
end component;


component T2 is 
	port(
		 d_in  : in std_logic_vector(15 downto 0);
		 en  : in std_logic; 
		 
		 clk : in std_logic;
		 d_out   : out std_logic_vector(15 downto 0)); 
end component;


component PC is 
		port(
		 d_in  : in std_logic_vector(15 downto 0);
		 en  : in std_logic; 
		 rst : in std_logic; 
		 clk : in std_logic;
		 d_out   : out std_logic_vector(15 downto 0)); 
end component;

component Reg is 
	port(
		 d_in  : in std_logic_vector(15 downto 0);
		 en  : in std_logic; 
		 rst : in std_logic;
		 clk : in std_logic;
		 d_out   : out std_logic_vector(15 downto 0)); 
end component;

component memory is 
	
	port (wr, rd, init : in std_logic; 
			Add_in, D_in: in std_logic_vector(15 downto 0);
			Y_out: out std_logic_vector(15 downto 0)); 
end component;

component outputlogic is
	port(ir : in std_logic_vector(15 downto 0);
		rst : in std_logic;
		clk : in std_logic;
		C : in std_logic;
		Z : in std_logic;
		Rf_a3 : in std_logic_vector(2 downto 0);
		rst_i : out std_logic;
		
		control_signal : out std_logic_vector(29 downto 0);
		nextstate : inout std_logic_vector(4 downto 0));
end component;

--1bit
signal IR_en, rst, g_init, g_rst, rd, wr, R7wr, Mem_wr, Mem_rd, add1, add2, data1, alu_fn1, alu_fn2, alu_a1, alu_a2, alu_b1, alu_b2, se_en, I_J, A3_m1, A3_m2, D3_m1, D3_m2, PC_en, T1_m1, T1_m2, T1_en, T2_en, carry, carryflag, cen, zero, zeroflag, zen : std_logic;
--16bits
signal ir, Mem_add, Mem_write, Mem_data, alu_a, alu_b, alu_out, pc_out, t1_mux_out, t1_out, t2_out, SE6_out, SE9_out, SE_out, rf_d1, rf_d2, LS1_out, LS7_out, rf_d3_out : std_logic_vector(15 downto 0);
--3bits
signal rf_a1, rf_a2, rf_a3, ir11_9, ir8_6, ir5_3, rf_a3_out : std_logic_vector(2 downto 0);

signal ir8_0 : std_logic_vector(8 downto 0);
signal ir5_0 : std_logic_vector(5 downto 0);
signal ir7_0,PEN_next,PEN_in_reg,PEN_out_reg : std_logic_vector(7 downto 0);
--signal control_signal: std_logic_vector(37 downto 0);
signal nextstate: std_logic_vector(4 downto 0);
begin
	--Mem
	mem : memory port map (wr => Mem_wr, rd => Mem_rd, init => g_init, Add_in => Mem_add, D_in => Mem_write, Y_out => Mem_data);
	mem_add_mux : mux_16 port map (en => Mem_rd or Mem_wr, ip0 => pc_out,  ip1 => alu_out,  ip2 => t1_out,  ip3 => "0000000000000000", s1 => add1, s2 => add2, op => mem_add);
	mem_data_mux : mux_16_lite port map (en => Mem_wr, ip0 => rf_d1,  ip1 => t2_out, s1 => data1, op => mem_data);
	--ALU
	alu_working : alu port map  (X => alu_a, Y => alu_b, cb1 => alu_fn1, cb2 => alu_fn2, C_in => carry, C_out => carryflag, Z_out => zeroflag, S_out => alu_out);
	alu_a_mux : mux_16 port map (en => alu_fn1 or alu_fn2, ip0 => pc_out,  ip1 => rf_d1,  ip2 => t1_out,  ip3 => "0000000000000000", s1 => alu_a1, s2 => alu_a2, op => alu_a);
	alu_b_mux : mux_16 port map (en => alu_fn1 or alu_fn2, ip0 => "0000000000000001", ip1 => rf_d2, ip2 => LS1_out, ip3 => SE_out, s1 => alu_b1, s2 => alu_b2, op => alu_b);
	se_6_9_mux : mux_16_lite port map (en => se_en, ip0 => SE6_out,  ip1 => SE9_out, s1 => I_J, op => SE_out);
	--RF
	rf_working : RF port map (A1 => ir11_9, A2 => ir8_6, A3 => rf_a3_out, D3 => rf_d3_out, clk => clk, rd => rd, wr => wr, R7_wr => R7wr, reset => g_rst, D1 => rf_d1, D2 => rf_d2);
	rf_a3_mux : mux_3 port map (en => wr, ip0 => "111",  ip1 => ir8_6, ip2 => ir11_9, ip3 => ir5_3, s1 => A3_m1, s2 => A3_m2, op => rf_a3_out);
	rf_d3_mux : mux_16 port map (en => wr, ip0 => t1_out,  ip1 => alu_out,  ip2 => LS7_out,  ip3 => Mem_data, s1 => D3_m1, s2 => D3_m2, op => rf_d3_out);
	--PC
	pc_working : PC port map (d_in => t1_out, en => PC_en, rst => g_rst, clk => clk, d_out => pc_out);
	--T1
	t1_working : T1 port map (d_in => t1_mux_out, en => T1_en, clk => clk, d_out => t1_out);
	t1_mux : mux_16 port map (en => t1_en, ip0 => alu_out,  ip1 => rf_d1,  ip2 => rf_d2,  ip3 => "0000000000000000", s1 => T1_m1, s2 => T1_m2, op => t1_mux_out);
	--T2
	t2_working : T2 port map (d_in => Mem_data, en => T2_en, clk => clk, d_out => t2_out);
	--SE6
	SE61 : se6 port map (se_in => ir5_0, se_out => SE6_out);
	--SE9
	SE91 : se9 port map (se_in => ir8_0, se_out => SE9_out);
	--LS1
	LS11 : LS1 port map (ip => rf_d2, op => LS1_out);
	--LS7
	LS77 : LS7 port map (ip => ir8_0, op => LS7_out);
	--flags
	carry1 : flag port map (din => carryflag, en => cen, clk => clk, dout => carry);
	zero1 : flag port map (din => zeroflag, en => zen, clk => clk, dout => zero);
	--IR
	IR_reg: Reg port map (d_in => Mem_data, en => '1', rst => g_rst, clk => clk, d_out => ir);
	
	ir5_0 <= ir(5 downto 0);
	ir7_0 <= ir(7 downto 0);
	ir8_0 <= ir(8 downto 0);
	ir5_3 <= ir(5 downto 3);
	ir8_6 <= ir(8 downto 6);
	ir11_9 <= ir(11 downto 9);
	
	outputlogic_inst: outputlogic port map (ir => ir, rst => g_rst, clk => clk, C=> carry, Z => zero, Rf_a3 => rf_a3_out, rst_i => g_rst,
	--Mem
	control_signal(0)=>Mem_rd,
	control_signal(1)=>Mem_wr,
	control_signal(2)=>add1,
	control_signal(3)=>add2,
	control_signal(4)=>data1,
	--ALU
	control_signal(5)=>alu_fn1,
	control_signal(6)=>alu_fn2,
	control_signal(7)=>alu_a1,
	control_signal(8)=>alu_a2,
	control_signal(9)=>alu_b1,
	control_signal(10)=>alu_b2,
	--RF
	control_signal(11)=>rd,
	control_signal(12)=>wr,
	control_signal(13)=>R7wr,
	control_signal(14)=>A3_m1,
	control_signal(15)=>A3_m2,
	control_signal(16)=>D3_m1,
	control_signal(17)=>D3_m2,
	--PC
	control_signal(18)=>PC_en,
	--T1
	control_signal(19)=>T1_en,
	control_signal(20)=>T1_m1,
	control_signal(21)=>T1_m2,
	--T2
	control_signal(22)=>T2_en,
	--IR
	control_signal(23)=>IR_en,
	--global reset
	control_signal(24)=>g_rst,
	--global init
	control_signal(25)=>g_init,
	--useful
	control_signal(26)=>se_en,
	control_signal(27)=>I_J,
	control_signal(28)=>cen,
	control_signal(29)=>zen,
	
	nextstate=>nextstate);
	
end Struct;