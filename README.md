# Vivado-FPGA-projects
# Basys 3 FPGA Verilog Projects

This repository contains Verilog digital circuit implementations targeting the Digilent Basys 3 FPGA development board (Xilinx Artix-7).

## Projects

### 1. 4-Digit Multiplexed BCD Counter (`basys3_4digit_bcd`)
A complete 4-digit BCD counter with physical display multiplexing and hardware control inputs.

* **Architecture:** Cascaded `bcd_digit` modules with carry-out generation, driving a 1 Hz clock divider and a 1 kHz display refresh multiplexer.
* **Display Output:** Active-LOW 7-segment decoder mapping BCD values to the Basys 3 onboard 4-digit display.
* **Control Inputs:** 
  * `ena_sw` (SW0 / `V17`) — Counter enable/pause switch.
  * `reset` (BTNC / `U18`) — Synchronous active-HIGH counter reset.
* **Simulation:** Verified via `tb_bcd_digit.v` testbench with custom waveform configuration (`tb_bcd_digit_behav.wcfg`).
