library ieee;
use ieee.std_logic_1164.all;

entity pwm_led is
	port
	(
		clk  : in  std_logic;
		o_pwm: out std_logic
	);
end entity;

architecture rtl of pwm_led is 
	signal pwm_counter: integer range 0 to 50_000_000;
begin
	pwm_proc: process(clk)
	begin
		if rising_edge(clk) then
			if pwm_counter > 49_999_999 then
				pwm_counter <= 0;
			else
				pwm_counter <= pwm_counter + 1;
			end if;
			
			if pwm_counter > 25_000_000 then
				o_pwm <= '1';
			else
				o_pwm <= '0';
			end if;
		end if;
	end process;
end rtl;