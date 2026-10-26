# Lab 2 — Seven-segment decoder, demultiplexer and ALU

Three designs that move from fixed truth tables to a parameterised datapath: a BCD
decoder driving the board's displays, a demultiplexer, and an N-bit ALU with carry and
signed overflow flags.

| Design | Entity | What it does |
| --- | --- | --- |
| [bcd_to_7seg](bcd_to_7seg) | `decod_bcd7seg` | Drives one seven-segment display from a 4-bit BCD input |
| [demux_1to8](demux_1to8) | `demux1x8` | Routes a single data bit to one of eight outputs |
| [alu_nbit](alu_nbit) | `ula` | Generic N-bit ALU: 8 operations, carry/borrow and overflow |

Each folder holds the design entity, its `_simu.vhd` testbench and the `pins.ucf`
used to run it on the board.

## Design notes

**Seven-segment decoder.** Both the segments and the display anodes are active low on
the Nexys 2, so each pattern is written with `'0'` for a lit segment — 0 becomes
`0000001` (every segment but g). The anodes are tied to `"1110"`, which keeps a single
display enabled; any input outside 0–9 falls to the `others` branch and blanks the
digit instead of showing a leftover pattern.

**Demultiplexer.** Split in two steps: `sel` picks a one-hot line, and the data bit
gates it. Writing it this way separates addressing from data, so `en = '0'` or
`d = '0'` forces the whole bus low without touching the decode logic.

**ALU.** The operands are zero-extended by one bit before the operation:

```
ax <= signed('0' & a);
bx <= signed('0' & b);
```

The extra position collects the carry out, while the lower N bits stay valid as a
two's complement result — addition has the same bit pattern whether the operands are
read as signed or unsigned, so one adder serves both readings. On subtraction that
same bit is the borrow. Logic operations force the flag to `'0'`, since a carry has no
meaning there.

Overflow is computed per operation from the sign bits:

| Operation | Overflow condition |
| --- | --- |
| `a + b` | operands share a sign and the result's sign differs |
| `a - b` | operands have opposite signs and the result takes b's sign |
| `a + 1` | a is positive and the result turns negative |
| `a - 1` | a is negative and the result turns positive |

`enable = '0'` zeroes the output and both flags, so a disabled ALU never asserts a
stale carry.

### Opcodes

| opcode | Operation | opcode | Operation |
| --- | --- | --- | --- |
| 000 | a + b | 100 | a xor b |
| 001 | a - b | 101 | not a |
| 010 | a and b | 110 | a + 1 |
| 011 | a or b | 111 | a - 1 |

## Verification

| Design | Stimulus | Expected result |
| --- | --- | --- |
| decod_bcd7seg | The 10 BCD digits plus 1010, 1100 and 1111 | Correct pattern per digit; display blank on invalid codes |
| demux1x8 | Enable off, then the 8 values of `sel` with d = '1', then d = '0' | One-hot output only with en = '1' and d = '1', all zeros otherwise |
| ula | All 8 opcodes with operands chosen to exercise each flag | Documented result, carry/borrow and overflow on each line |

The ALU testbench walks the corner cases rather than every input: +1 +1 overflowing to
-2, -1 -1 carrying out, 0 - (+1) borrowing, and increment/decrement crossing zero.

## Board mapping (Nexys 2)

| Design | Inputs | Outputs |
| --- | --- | --- |
| decod_bcd7seg | d(3..0) on SW3..SW0 | seg(6..0) on CA..CG, an(3..0) on AN3..AN0 |
| demux1x8 | sel(2..0) on SW2..SW0, d on SW3, en on SW4 | y(7..0) on LD7..LD0 |
| ula (N = 2) | a on SW1..SW0, b on SW3..SW2, opcode on SW6..SW4, enable on SW7 | y on LD1..LD0, cout on LD2, overflow on LD3 |
