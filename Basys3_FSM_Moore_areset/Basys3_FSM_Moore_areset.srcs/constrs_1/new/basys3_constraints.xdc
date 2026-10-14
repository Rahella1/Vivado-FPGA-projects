# Clock signal (100 MHz onboard oscillator)
set_property PACKAGE_PIN W5 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk]

# Switches
# Asynchronous Reset (SW15)
set_property PACKAGE_PIN R2 [get_ports areset]
set_property IOSTANDARD LVCMOS33 [get_ports areset]

# Input 'in' (SW0)
set_property PACKAGE_PIN V17 [get_ports in]
set_property IOSTANDARD LVCMOS33 [get_ports in]

# LEDs
# Output 'out' (LED15)
set_property PACKAGE_PIN L1 [get_ports out]
set_property IOSTANDARD LVCMOS33 [get_ports out]