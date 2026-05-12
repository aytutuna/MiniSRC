# Phase 3

Standalone Phase 3 Mini SRC CPU implementation with a finite-state control unit layered on top of the Phase 2 datapath.

## Contents

- `hdl/`
  - Reused datapath, RAM, register, ALU, branch-condition, and select-encode blocks from Phase 2
  - New `control_unit.v` implementing the Phase 3 control FSM
  - New `mini_src_cpu.v` top-level tying the control unit to the datapath
- `tb/phase3tb.v`
  - Full-program functional simulation for a small reference program

## Notes

- The control unit implements a basic fetch/decode/execute FSM for the supported instruction set.
- The testbench is a full-program simulation: it initializes a few RAM locations, loads a small program image, runs it, then checks final register/`HI`/`LO`/`MAR`/`MDR` and RAM state.
- `jal` uses `R12` as the link register in this project.