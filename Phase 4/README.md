# Phase 4

Standalone Phase 4 Mini SRC implementation based on the working Phase 3 CPU core, extended with FPGA/board-oriented wrapper modules.

## Contents

- `hdl/`
  - Phase 3 CPU core plus Phase 4 additions
  - `ram512x32.v` preloads a full program image and required data words
  - `phase4_de0_cv_top.v` board-facing wrapper
  - `clock_divider.v` slows the board clock for visible execution
  - `hex7seg.v` drives the two 7-segment displays from the low byte of `Out.Port`
- `tb/phase4tb.v`
  - Full-program functional simulation for the included program image
- `phase4_de0_cv_template.qsf`
  - Quartus pin-assignment template for the board I/O

## Notes

- The RAM image includes a program, a loop starting at address `0x29`, a `subA` subroutine at address `0xB2`, and a few fixed data words.
- `Datapath.v` and `mini_src_cpu.v` expose `OutPort_value` and `OutPortValue` so the board wrapper and testbench can observe the output port directly.
- The Phase 4 testbench overrides RAM location `0x88` to `0x0000000F` only for simulation speed.