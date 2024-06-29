library ieee;
use ieee.std_logic_1164.all;


entity led_shift_reg is
	port
	(
		rst		 : in  std_logic;
		clk		 : in  std_logic;
		i_switch_1: in  std_logic;
		o_leds    : out std_logic_vector(1 to 4)
	);
end entity;


architecture rtl of led_shift_reg is
	constant DEBOUNCE_TIMESTAMP: integer := 25_000_00;

	signal button_pressed  : std_logic;
	signal switch_delay    : std_logic;
	signal shift_register  : std_logic_vector(1 to 4);
	signal sync            : std_logic_vector(1 downto 0);
	signal debounced_switch: std_logic;
	signal counter         : integer;
begin
	o_leds <= shift_register;
	
	sync_proc: process(rst, clk)
	begin
		if rst = '0' then
			sync <= "11";
			
		elsif rising_edge(clk) then
			sync(0) <= i_switch_1;
			sync(1) <= sync(0);
		end if;
	end process;
	
	button_debounce: process(rst, clk)
	begin
		if rst = '0' then
			counter 			  <= 0  ;
			debounced_switch <= '1';
			
		elsif rising_edge(clk) then
			if sync(1) = '0' then
				if counter < DEBOUNCE_TIMESTAMP then
					counter <= counter + 1;
				end if;
			else			
				if counter > 0 then
					counter <= counter - 1;
				end if;
			end if;
			
			if counter = DEBOUNCE_TIMESTAMP then
				debounced_switch <= '0';
			elsif counter = 0 then
				debounced_switch <= '1';
			end if;
		end if;
	end process;
	
	button_on_press: process(rst, clk)
	begin
		if rst = '0' then
			switch_delay   <= '1';
			button_pressed <= '0';
			
		elsif rising_edge(clk) then
			switch_delay <= debounced_switch;
			
			if debounced_switch = '0' and switch_delay = '1' then
				button_pressed <= '1';
			else
				button_pressed <= '0';
			end if;
		end if;
	end process;
	
	shift_proc: process(rst, clk)
	begin
		if rst = '0' then
			shift_register <= "0111";
			
		elsif rising_edge(clk) then
			if button_pressed = '1' then				
				shift_register <= shift_register(4) & shift_register(1 to 3);
			end if;
		end if;
	end process;
	
end rtl;