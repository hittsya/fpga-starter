create_clock -name OscilatorMain -period 20.000 [get_ports {clk}]

set_false_path -from [get_ports {i_switch_1}]
set_false_path -from [get_ports {rst}]

set_false_path -to [get_ports {o_leds[*]}]