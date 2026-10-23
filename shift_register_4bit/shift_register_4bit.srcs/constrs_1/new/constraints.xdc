## Clock
set_property PACKAGE_PIN W5 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -period 10.000 -name sys_clk [get_ports clk]

## Control inputs (buttons / switches)
set_property PACKAGE_PIN U18 [get_ports areset]
set_property PACKAGE_PIN T18 [get_ports load]
set_property PACKAGE_PIN W19 [get_ports ena]
set_property IOSTANDARD LVCMOS33 [get_ports {areset load ena}]

## data[3:0] -> switches SW0-SW3
set_property PACKAGE_PIN V17 [get_ports {data[0]}]
set_property PACKAGE_PIN V16 [get_ports {data[1]}]
set_property PACKAGE_PIN W16 [get_ports {data[2]}]
set_property PACKAGE_PIN W17 [get_ports {data[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {data[*]}]

## q[3:0] -> LEDs LD0-LD3
set_property PACKAGE_PIN U16 [get_ports {q[0]}]
set_property PACKAGE_PIN E19 [get_ports {q[1]}]
set_property PACKAGE_PIN U19 [get_ports {q[2]}]
set_property PACKAGE_PIN V19 [get_ports {q[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {q[*]}]