# Phase 3

Standalone Phase 3 Mini SRC CPU implementation with a finite-state control unit layered on top of the Phase 2 datapath.

## Contents

- `hdl/`
  - Reused datapath, RAM, register, ALU, branch-condition, and select-encode blocks from Phase 2
  - New `control_unit.v` implementing the Phase 3 control FSM
  - New `mini_src_cpu.v` top-level tying the control unit to the datapath
- `tb/phase3tb.v`
  - Full-program functional simulation for the Phase 3 assignment program
- `run_phase3.ps1`
  - ModelSim wrapper for compiling and running the Phase 3 testbench

## Notes

- The control unit follows the Phase 3 fetch sequence and instruction micro-steps from the lab handout.
- The testbench initializes memory locations `0x89` and `0xA3`, loads the assignment program starting at address `0`, places subroutine `subA` at address `0xB2`, then checks the final register, `HI`, `LO`, `MAR`, `MDR`, and RAM values required by the demo guideline.
- `jal` is encoded so the link register is `R12`, matching the Phase 2 and Phase 3 lab material.

## Running

From the `Phase 3` folder:

```powershell
./run_phase3.ps1
```