# Phase 4

Standalone Phase 4 Mini SRC implementation based on the working Phase 3 CPU core, extended for the FPGA-board demo requirements.

## Contents

- `hdl/`
  - Phase 3 CPU core plus Phase 4 additions
  - `ram512x32.v` preloads the full Phase 4 handout program and required data words
  - `phase4_de0_cv_top.v` board-facing wrapper
  - `clock_divider.v` slows the board clock for visible execution
  - `hex7seg.v` drives the two 7-segment displays from the low byte of `Out.Port`
- `tb/phase4tb.v`
  - Full-program functional simulation for the Phase 4 handout program
- `run_phase4.ps1`
  - ModelSim wrapper for compiling and running the Phase 4 testbench
- `phase4_de0_cv_template.qsf`
  - Quartus pin-assignment template for the required board I/O

## Notes

- The Phase 4 RAM image includes the original Phase 3 program, the new Phase 4 loop starting at address `0x29`, the `subA` subroutine at `0xB2`, and the required memory words at `0x88`, `0x89`, and `0xA3`.
- `Datapath.v` and `mini_src_cpu.v` expose `OutPort_value` and `OutPortValue` so the board wrapper and testbench can observe the output port directly.
- The Phase 4 testbench overrides RAM location `0x88` to `0x0000000F` only for simulation speed. The synthesizable RAM still keeps the handout value `0x0000FFFF`.

## Running

From the `Phase 4` folder:

```powershell
./run_phase4.ps1
```