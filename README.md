# Basys 3 FPGA Verilog Projects

This repository contains Verilog digital circuit implementations targeting the Digilent Basys 3 FPGA development board (Xilinx Artix-7), built and simulated with Vivado 2026.1.

## Projects

| Project | Topic |
|---|---|
| [basys3_4digit_bcd](./basys3_4digit_bcd) | Multiplexed 4-digit BCD counter |
| [3bit-lfsr-basys3](./3bit-lfsr-basys3) | 3-bit LFSR |
| [Basys3_FSM_Moore_areset](./Basys3_FSM_Moore_areset) | Moore FSM with asynchronous reset |

### 4-Digit Multiplexed BCD Counter (`basys3_4digit_bcd`)

A complete 4-digit BCD counter with physical display multiplexing and hardware control inputs.

- **Architecture:** Cascaded `bcd_digit` modules with carry-out generation, driving a 1 Hz clock divider and a 1 kHz display refresh multiplexer.
- **Display Output:** Active-LOW 7-segment decoder mapping BCD values to the Basys 3 onboard 4-digit display.
- **Control Inputs:**
  - `ena_sw` (SW0 / `V17`): Counter enable/pause switch.
  - `reset` (BTNC / `U18`): Synchronous active-HIGH counter reset.
- **Simulation:** Verified via `tb_bcd_digit.v` testbench with custom waveform configuration (`tb_bcd_digit_behav.wcfg`).

## Tools
- Board: Digilent Basys 3 (Artix-7 XC7A35T-1CPG236C)
- Software: Xilinx Vivado 2026.1
- Language: Verilog

## Author
Rahel Aregawi | [LinkedIn](https://www.linkedin.com/in/rahel-aregawi-359014135/)
