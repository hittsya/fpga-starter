library ieee;
use ieee.std_logic_1164.all;

entity switch_and_led is
	port
	(
		i_switch_1: in  std_logic;
		o_led_1   : out std_logic
	);
end entity;

architecture rtl of switch_and_led is
	
begin
	 o_led_1 <= i_switch_1;
end rtl;