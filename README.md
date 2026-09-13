# microelectronics

VHDL designs and simulations developed for **TE351 – Microeletrônica**, Electrical
Engineering at UFPR.

Everything built during the semester lives here: RTL sources, testbenches, simulation
results and the constraints used to run each design on hardware.

| | |
| --- | --- |
| **Course** | TE351 – Microeletrônica (UFPR) |
| **Language** | VHDL |
| **Toolchain** | AMD/Xilinx ISE 14.7 · ISim |
| **Target board** | Digilent Nexys 2 (Xilinx Spartan-3E) |

## Repository structure

```
labs/
  01-<topic>/
    src/           -- synthesisable VHDL
    tb/            -- testbenches
    sim/           -- ISim waveform configs (.wcfg) and captured results
    constraints/   -- Nexys 2 pin assignments (.ucf)
    README.md      -- what the lab does, how it was verified, results
```

Each lab is self-contained: the sources, the testbench that verifies them and the
evidence that it works.

## Simulating a design (ISim)

1. Open ISE and create a project targeting the Spartan-3E device on the Nexys 2.
2. Add the files from `src/` as design sources and the ones from `tb/` as simulation
   sources.
3. Select the testbench in the hierarchy, switch the view to **Simulation**, and run
   *Simulate Behavioral Model*.
4. Load the matching `.wcfg` from `sim/` to get the same signal set and formatting.

## Running on the Nexys 2

1. Add the lab's `.ucf` from `constraints/` to the project.
2. Run *Generate Programming File* and download the bitstream with iMPACT or Digilent
   Adept.

## Labs

| # | Lab | Topic | Status |
| --- | --- | --- | --- |
| 01 | — | — | — |

Filled in as the semester progresses.

## Roadmap

Verilog and SystemVerilog designs will be added alongside the VHDL work as I progress
through Cadence's RTL design training.
