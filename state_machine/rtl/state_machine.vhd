library ieee;
use ieee.std_logic_1164.all;

entity state_machine is
	port
	(
		rst       : in  std_logic;
		clk       : in  std_logic;
		i_switches: in  std_logic_vector(3 downto 1);
		o_leds    : out std_logic_vector(3 downto 1)
	);
end entity;

architecture rtl of state_machine is
	component PLL is
		port
		(
			areset  : in  std_logic  := '0';
			inclk0  : in  std_logic  := '0';
			c0		  : out std_logic 
		);
	end component;


	type state_machine_dt is (EN_LED_1, EN_LED_2, EN_LED_3);
	
	signal sm_state    : state_machine_dt;
	signal sm_clk_25mhz: std_logic;

begin

	PLL1: PLL
	port map
		(
			areset  => not(rst),
			inclk0  => clk,
			c0		  => sm_clk_25mhz
		);


	sm_proc_1: process(rst, sm_clk_25mhz) 
	begin
	
		if rst = '0' then
			sm_state <= EN_LED_1;
			o_leds   <= "111";
	
		elsif rising_edge(sm_clk_25mhz) then
			
			case sm_state is 
			
				when EN_LED_1 =>
					o_leds <= "110";
					
					if i_switches(1) = '0' then
						sm_state <= EN_LED_2;
					end if;
					
				when EN_LED_2 =>
					o_leds <= "101";
					
					if i_switches(2) = '0' then
						sm_state <= EN_LED_3;
					end if;
					
				when EN_LED_3 =>
					o_leds <= "011";
					
					if i_switches(3) = '0' then
						sm_state <= EN_LED_1;
					end if;
					
					
				when others  =>
					sm_state <= EN_LED_1;
			end case;
			
		end if;
		
	end process;
end rtl;