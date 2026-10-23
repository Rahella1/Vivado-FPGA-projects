# Clock signal (100 MHz on Basys 3)
set_property PACKAGE_PIN W5 [get_ports clk]							
    set_property IOSTANDARD LVCMOS33 [get_ports clk]
    create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk]
    
# Buttons
set_property PACKAGE_PIN U18 [get_ports btnC]							
    set_property IOSTANDARD LVCMOS33 [get_ports btnC]
set_property PACKAGE_PIN T18 [get_ports btnU]							
    set_property IOSTANDARD LVCMOS33 [get_ports btnU]
    
# Single LED (LD0)
set_property PACKAGE_PIN U16 [get_ports led]					
    set_property IOSTANDARD LVCMOS33 [get_ports led]