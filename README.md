# Basys 3 FPGA Verilog Projects

This repository contains Verilog digital circuit implementations targeting the Digilent Basys 3 FPGA development board (Xilinx Artix-7), built and simulated with Vivado 2026.1.

## Projects

| Project | Topic |
|---|---|
| [project_01_led_blinker](./project_01_led_blinker) | LED blinker |
| [bcd_digit_project_1](./bcd_digit_project_1) | Single BCD digit counter |
| [basys3_4digit_bcd](./basys3_4digit_bcd) | Multiplexed 4-digit BCD counter |
| [stopwatch_basys3](./stopwatch_basys3) | Stopwatch |
| [shift_register_4bit](./shift_register_4bit) | 4-bit shift register |
| [3bit-lfsr-basys3](./3bit-lfsr-basys3) | 3-bit LFSR |
| [Basys3_FSM_Moore_areset](./Basys3_FSM_Moore_areset) | Moore FSM with asynchronous reset |
| [basys3_fsm_onehot](./basys3_fsm_onehot) | FSM with one-hot state encoding |
| [fsm_3state_detector](./fsm_3state_detector) | 3-state FSM detector |
| [serial_receiver_fsm](./serial_receiver_fsm) | Serial receiver FSM |

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
