## Switches (R inputs)
set_property PACKAGE_PIN V17 [get_ports {SW[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {SW[0]}]
set_property PACKAGE_PIN V16 [get_ports {SW[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {SW[1]}]
set_property PACKAGE_PIN W16 [get_ports {SW[2]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {SW[2]}]

## Buttons (KEY[0] = clk, KEY[1] = L)
set_property PACKAGE_PIN U18 [get_ports {KEY[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {KEY[0]}]
set_property PACKAGE_PIN T18 [get_ports {KEY[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {KEY[1]}]

## LEDs (LEDR outputs)
set_property PACKAGE_PIN U16 [get_ports {LEDR[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {LEDR[0]}]
set_property PACKAGE_PIN E19 [get_ports {LEDR[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {LEDR[1]}]
set_property PACKAGE_PIN U19 [get_ports {LEDR[2]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {LEDR[2]}]

## Disable clock buffer warning for manual button clocking
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets KEY_IBUF[0]]