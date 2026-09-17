# Lab 1 — Combinational blocks

Four combinational designs described in VHDL as concurrent boolean equations, each
verified in ISim and mapped to the Nexys 2 switches and LEDs.

| Design | Entity | What it does |
| --- | --- | --- |
| [decoder_3to8](decoder_3to8) | `decoder_sem_enable` | 3-to-8 decoder: asserts exactly one of b0..b7 for each value of a2a1a0 |
| [decoder_3to8_enable](decoder_3to8_enable) | `decoder_com_enable` | Same decoder gated by `en`: all outputs low while `en = '0'` |
| [priority_encoder_8to3](priority_encoder_8to3) | `encoder_com_prioridade` | 8-to-3 priority encoder: y2y1y0 is the index of the highest active input |
| [abs_comparator_2bit](abs_comparator_2bit) | `comparador_abs` | Absolute-value comparator for two 2-bit two's complement numbers |

Each folder holds the design entity, its `_simu.vhd` testbench and the `pins.ucf`
used to run it on the board.

## Design notes

**Decoders.** Each output is the minterm of the three address bits, written directly as
an AND of the inputs and their complements. The enable version ANDs every minterm with
`en`, so the whole output bus is forced low when the block is disabled.

**Priority encoder.** Built from the reduced sum-of-products form rather than a chain of
comparisons, so the three outputs are independent two-level expressions:

```
y2 = x7 + x6 + x5 + x4
y1 = x7 + x6 + !x5·!x4·(x3 + x2)
y0 = x7 + !x6·x5 + !x6·!x4·x3 + !x6·!x4·!x2·x1
```

The negated terms are what enforce priority: a lower input only reaches the output when
every higher one is inactive. With no input active the output is 000, the same code as
x0, which is the usual ambiguity of an encoder without a valid flag.

**Absolute-value comparator.** Inputs are two-bit two's complement numbers
(00 = 0, 01 = +1, 10 = -2, 11 = -1), so the magnitudes are 0, 1, 2 and 1. `s` is high
whenever the two magnitudes match, which reduces to three cases:

```
s = (a0·b0)                      -- both have magnitude 1  (+1 or -1)
  + (!a1·!a0·!b1·!b0)            -- both zero
  + (a1·!a0·b1·!b0)              -- both -2
```

Written this way the design ignores the sign bit on its own and compares magnitudes
directly, instead of computing `a = b or a = -b` and ORing the two results.

## Verification

| Design | Stimulus | Expected result |
| --- | --- | --- |
| decoder_sem_enable | All 8 address values, 50 ns each | One-hot output walking b0 -> b7 |
| decoder_com_enable | The same sweep with `en = '0'`, then with `en = '1'` | Outputs all low in the first pass, one-hot in the second |
| encoder_com_prioridade | One active input at a time, then several simultaneous | Code of the active input; with several active, the highest wins |
| comparador_abs | All 16 combinations of (a, b) | `s = '1'` on the 6 pairs of equal magnitude |

## Board mapping (Nexys 2)

| Design | Inputs | Outputs |
| --- | --- | --- |
| decoder_sem_enable | a0..a2 on SW0..SW2 | b0..b7 on LD0..LD7 |
| decoder_com_enable | a0..a2 on SW0..SW2, en on SW3 | b0..b7 on LD0..LD7 |
| encoder_com_prioridade | x1..x7 on SW0..SW6 | y0..y2 on LD0..LD2 |
| comparador_abs | a0,a1 on SW0,SW1 and b0,b1 on SW4,SW5 | s on LD0 |

## Reproducing

Create an ISE project for the Spartan-3E device on the Nexys 2, add the design file and
its testbench, then run *Simulate Behavioral Model* in ISim. To run it on hardware, add
`pins.ucf`, generate the programming file and download it with iMPACT or Digilent Adept.
