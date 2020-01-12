create_clock -name clk [get_ports *clk]  -period 6

set_input_delay  -clock clk -max 5 [all_inputs]
set_input_delay  -clock clk -min 4 [all_inputs]
set_output_delay -clock clk -max 5 [all_outputs]
set_output_delay -clock clk -min 4 [all_outputs]



