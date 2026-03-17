# Phase 2

Standalone Phase 2 Mini SRC datapath implementation and functional simulation.

## Contents

- `hdl/`
  - Phase 2 datapath with RAM, select-and-encode logic, revised `R0`, `CON` flip-flop, and I/O ports
  - Reused arithmetic/register blocks from Phase 1 to keep the folder self-contained
- `tb/phase2tb.v`
  - Functional testbench covering `ld`, `ldi`, `st`, `addi`, `andi`, `ori`, `brzr`, `brnz`, `brpl`, `brmi`, `jr`, `jal`, `mfhi`, `mflo`, `in`, and `out`
- `run_phase2.ps1`
  - PowerShell wrapper for compiling and running the testbench in ModelSim

## Running

From the `Phase 2` folder:

```powershell
./run_phase2.ps1
```

The script creates a local ModelSim `work` library, compiles everything in `hdl/`, compiles `tb/phase2tb.v`, then runs the simulation in console mode.
