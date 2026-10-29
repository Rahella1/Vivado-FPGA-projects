# --- Clock Signal (100MHz system clock on Basys 3) ---
set_property PACKAGE_PIN W5 [get_ports clk]							
    set_property IOSTANDARD LVCMOS33 [get_ports clk]
    create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk]
    
# --- Push Buttons ---
# Center Button (btnC) used as Asynchronous Reset
set_property PACKAGE_PIN U18 [get_ports btnC]						
    set_property IOSTANDARD LVCMOS33 [get_ports btnC]
 
# --- Slide Switches ---
# sw[0] used as data input 'in'
set_property PACKAGE_PIN V17 [get_ports {sw[0]}]					
    set_property IOSTANDARD LVCMOS33 [get_ports {sw[0]}]
    
# --- LEDs (State vector [9:0] and Outputs) ---
# LEDs 0 to 9 map to state[9:0] (one-hot state tracking)
set_property PACKAGE_PIN U16 [get_ports {led[0]}]					
    set_property IOSTANDARD LVCMOS33 [get_ports {led[0]}]
set_property PACKAGE_PIN E19 [get_ports {led[1]}]					
    set_property IOSTANDARD LVCMOS33 [get_ports {led[1]}]
set_property PACKAGE_PIN V19 [get_ports {led[2]}]					
    set_property IOSTANDARD LVCMOS33 [get_ports {led[2]}]
set_property PACKAGE_PIN W18 [get_ports {led[3]}]					
    set_property IOSTANDARD LVCMOS33 [get_ports {led[3]}]
set_property PACKAGE_PIN U15 [get_ports {led[4]}]					
    set_property IOSTANDARD LVCMOS33 [get_ports {led[4]}]
set_property PACKAGE_PIN U14 [get_ports {led[5]}]					
    set_property IOSTANDARD LVCMOS33 [get_ports {led[5]}]
set_property PACKAGE_PIN V14 [get_ports {led[6]}]					
    set_property IOSTANDARD LVCMOS33 [get_ports {led[6]}]
set_property PACKAGE_PIN V13 [get_ports {led[7]}]					
    set_property IOSTANDARD LVCMOS33 [get_ports {led[7]}]
set_property PACKAGE_PIN V3  [get_ports {led[8]}]					
    set_property IOSTANDARD LVCMOS33 [get_ports {led[8]}]
set_property PACKAGE_PIN W3  [get_ports {led[9]}]					
    set_property IOSTANDARD LVCMOS33 [get_ports {led[9]}]

# LEDs 10 to 13 (Unused / off)
set_property PACKAGE_PIN U3 [get_ports {led[10]}]					
    set_property IOSTANDARD LVCMOS33 [get_ports {led[10]}]
set_property PACKAGE_PIN P3 [get_ports {led[11]}]					
    set_property IOSTANDARD LVCMOS33 [get_ports {led[11]}]
set_property PACKAGE_PIN N3 [get_ports {led[12]}]					
    set_property IOSTANDARD LVCMOS33 [get_ports {led[12]}]
set_property PACKAGE_PIN P1 [get_ports {led[13]}]					
    set_property IOSTANDARD LVCMOS33 [get_ports {led[13]}]

# LEDs 14 and 15 map to out1 and out2
set_property PACKAGE_PIN L1 [get_ports {led[14]}]					
    set_property IOSTANDARD LVCMOS33 [get_ports {led[14]}]
set_property PACKAGE_PIN P1 [get_ports {led[15]}]					
    set_property IOSTANDARD LVCMOS33 [get_ports {led[15]}]
    # LED 14 maps to out1
set_property PACKAGE_PIN L1 [get_ports {led[14]}]					
    set_property IOSTANDARD LVCMOS33 [get_ports {led[14]}]

# LED 15 maps to out2
set_property PACKAGE_PIN R3 [get_ports {led[15]}]					
    set_property IOSTANDARD LVCMOS33 [get_ports {led[15]}]