library std;
use std.standard.all;
library ieee;
use ieee.std_logic_1164.all;
library ieee;
use ieee.numeric_std.all; 


entity flag is
  port (
    din  : in  std_logic;
	 en: in std_logic;
	 clk     : in  std_logic;
    dout : out std_logic );
end flag;

architecture Struct of flag is

begin  -- behave
process(clk)
begin 
  if(clk'event and clk = '0') then
    if en = '1' then
      dout <= din;
    end if;
  end if;
end process;
end Struct;