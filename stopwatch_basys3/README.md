# Basys3 Digital Stopwatch

A 4-digit stopwatch for the Digilent Basys3 (Artix-7 `xc7a35tcpg236-1`)
written in Verilog for Vivado.

## Controls
| Input | Function |
|---|---|
| `btnC` (center) | Start / Stop |
| `btnU` (up)     | Lap: freeze the display (time keeps running); press again to release |
| `btnD` (down)   | Reset: stop and clear to zero |
| `sw0`           | 0 = `SS.cc` (seconds.hundredths), 1 = `MM.SS` (minutes.seconds) |
| `LED0`          | Lit while running |
| `LED1`          | Lit while the display is frozen by Lap |

Range: 00:00.00 to 99:59.99, then wraps to zero.

## Architecture
```
 btnC/U/D --> debounce x3 --> start/lap/reset pulses
                                   |
 100 MHz --> clk_divider (100 Hz tick)
                                   v
                           stopwatch_core  (BCD counters, lap register)
                                   |
 sw0 --(2-FF sync)--> display select mux
                                   v
                           seg7_display (multiplexed, active-low)
```

| File | Purpose |
|---|---|
| `src/stopwatch_top.v`  | Top level, wires everything together |
| `src/debounce.v`       | 2-flop synchronizer + 10 ms stability filter + press pulse |
| `src/clk_divider.v`    | 100 MHz -> 100 Hz (10 ms) tick |
| `src/stopwatch_core.v` | BCD time counter, start/stop, lap, reset |
| `src/seg7_display.v`   | 4-digit multiplexer, segment decoder, decimal point |
| `sim/tb_stopwatch_core.v` | Self-checking test: counting, lap, rollover, stop/resume, reset |
| `sim/tb_debounce.v`    | Self-checking test: glitch rejection, bounce handling |
| `constraints/basys3_stopwatch.xdc` | Pins, 100 MHz clock, false paths on async inputs |
| `build.tcl`            | Creates the Vivado project |
| `build_bitstream.tcl`  | Creates project, runs synth + impl, writes the `.bit` and reports |

## Build
**Easiest (command line):**
```
vivado -mode batch -source build_bitstream.tcl
```
Produces `stopwatch_top.bit`, `timing_summary.rpt`, `utilization.rpt`.

**GUI:**
1. `vivado -mode batch -source build.tcl`, then open `stopwatch_proj/stopwatch.xpr`
2. Run Synthesis -> Run Implementation -> Generate Bitstream

## Simulate
In the Vivado GUI: Flow Navigator > Simulation > Run Behavioral Simulation
(default sim top is `tb_stopwatch_core`; to run the debounce test, set
`tb_debounce` as the simulation top). Both print PASS/FAIL to the Tcl console.

Or with Icarus Verilog:
```
iverilog -g2012 -o core.vvp src/stopwatch_core.v sim/tb_stopwatch_core.v && vvp core.vvp
```

## Program the board
Connect via USB, power on, then Hardware Manager > Open Target > Auto Connect >
Program Device > select `stopwatch_top.bit`.

## Real-world design notes
- **Debouncing:** mechanical buttons bounce for several ms; each press is
  filtered for 10 ms and converted to exactly one pulse.
- **Synchronizers:** buttons and the switch are asynchronous to the clock,
  so each goes through a two-flop synchronizer to avoid metastability.
- **Timing:** `set_false_path` on async inputs; check `timing_summary.rpt`
  for WNS >= 0 at 100 MHz.
- **Accuracy:** the board's crystal sets accuracy (typically tens of ppm).
  Timebase phase restarts on start/stop, so the first interval after start
  is a full 10 ms.

## Ideas to extend
- Store several laps in a small RAM and scroll through them with btnL/btnR
- Countdown timer mode with a buzzer on a PMOD pin
- Send lap times to a PC over UART (the Basys3 USB-UART)
- Convert the control logic to an explicit FSM (IDLE / RUNNING / STOPPED)
