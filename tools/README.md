# tools

Helpers I wrote to make the lab workflow faster. Not part of any assignment.

## grava.sh

Builds a lab project if needed and programs it onto the Nexys 2 in a single command.
ISE 14.7 runs in a Docker container here, so every step goes through `docker exec`:
`xtclsh` for synthesis and `impact` for the JTAG download.

```
./grava.sh              # list the projects, with the date of each bitstream
./grava.sh bcd          # program the project whose name contains "bcd"
./grava.sh ula -r       # force a rebuild before programming
```

What it does beyond calling the tools:

- **Identifies the connected board.** Runs `impact ... identify` and reads the IDCODE
  from the JTAG chain to tell an XC3S500E apart from an XC3S1200E.
- **Retargets the project when the board differs.** If the connected FPGA is not the one
  the `.xise` targets, it rewrites the device, family, package and speed grade through
  `xtclsh`, and patches the constraint file: LD4..LD7 sit on different pins in the two
  Nexys 2 revisions, while LD0..LD3, the switches and the displays do not move.
- **Rebuilds only when something changed.** Compares the timestamps of the `.vhd` and
  `.ucf` sources against the newest `.bit` — testbenches are excluded, since they
  never affect the bitstream.
- **Fails with the actual error.** On a failed build it prints the `ERROR` lines from
  the ISE log instead of the whole transcript; on a failed download, the cable and IDCODE
  lines from the iMPACT log.
- **Warns about a retargeted project.** If the project was saved for a board other than
  the usual one, it says so at the end, so the version handed in is not left pointing at
  the wrong device.

### Requirements

A running container named `xilinx-ise` with ISE 14.7 inside, the projects directory
mounted at `/projects`, the board connected over USB, and `docker` plus `lsusb`
on the host. Set `XILINX_PROJECTS` to point at your projects directory; it defaults to
mine.
