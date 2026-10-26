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

## Labs

| # | Lab | Topic | Status |
| --- | --- | --- | --- |
| 01 | [Combinational blocks](labs/01-combinational-blocks) | 3-to-8 decoders, 8-to-3 priority encoder, absolute-value comparator | Simulated and run on the board |
| 02 | [Seven-segment, demux and ALU](labs/02-seven-segment-demux-alu) | BCD to seven-segment decoder, 1-to-8 demultiplexer, generic N-bit ALU | Simulated and run on the board |
| 04 | [Digital clock](labs/04-digital-clock) | 24-hour clock: prescalers, BCD counters and multiplexed displays | Simulated and run on the board |

## Repository structure

```
labs/
  NN-topic/
    README.md              -- what the lab covers, design notes and verification
    <design>/              -- one folder per design, when the lab has several
      <design>.vhd         -- synthesisable VHDL
      <design>_simu.vhd    -- ISim testbench
      pins.ucf             -- Nexys 2 pin assignments
tools/
  grava.sh                 -- builds a project and programs it onto the board
```

A lab with a single multi-component design (lab 4) keeps its files directly in the lab
folder instead.

## Simulating a design (ISim)

1. Open ISE and create a project targeting the Spartan-3E device on the Nexys 2.
2. Add the design `.vhd` as a design source and the matching `_simu.vhd` as a
   simulation source.
3. Select the testbench in the hierarchy, switch the view to **Simulation**, and run
   *Simulate Behavioral Model*.

Designs with generics (the clock) take small divisor values in simulation; the defaults
in the entity are the ones used for synthesis.

## Running on the Nexys 2

1. Add the design's `pins.ucf` to the project.
2. Run *Generate Programming File* and download the bitstream with iMPACT or Digilent
   Adept — or use [`tools/grava.sh`](tools), which does both and retargets the project
   if the connected board is the other Nexys 2 revision.

## Roadmap

Verilog and SystemVerilog designs will be added alongside the VHDL work as I progress
through Cadence's RTL design training.
