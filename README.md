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

## Repository structure

```
labs/
  01-combinational-blocks/
    README.md              -- what the lab covers, design notes and verification
    <design>/
      <design>.vhd         -- synthesisable VHDL
      <design>_simu.vhd    -- ISim testbench
      pins.ucf             -- Nexys 2 pin assignments
```

Each design is self-contained: the entity, the testbench that verifies it and the
constraints that put it on the board.

## Simulating a design (ISim)

1. Open ISE and create a project targeting the Spartan-3E device on the Nexys 2.
2. Add the design `.vhd` as a design source and the matching `_simu.vhd` as a
   simulation source.
3. Select the testbench in the hierarchy, switch the view to **Simulation**, and run
   *Simulate Behavioral Model*.

## Running on the Nexys 2

1. Add the design's `pins.ucf` to the project.
2. Run *Generate Programming File* and download the bitstream with iMPACT or Digilent
   Adept.

## Roadmap

Verilog and SystemVerilog designs will be added alongside the VHDL work as I progress
through Cadence's RTL design training.
