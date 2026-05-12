# Phase 1 — Datapath Functional Simulation

This folder contains a minimal single-bus datapath (mux-based) plus a direct-control testbench. The testbench drives the per-cycle control signals so you can validate the datapath and ALU behavior in simulation.

## Folder layout

- `hdl/` — Verilog modules (datapath + ALU + mul/div)
- `tb/` — ModelSim testbench

## What’s implemented (Phase 1 scope)

- Bus mux (priority select) driven by `R*out`, `PCout`, `MDRout`, `Zlowout`, `Zhighout`, `HIout`, `LOout`
- Registers: `R0..R15`, `PC`, `IR`, `MAR`, `MDR` (with Read-controlled input mux), `Y`, `Z` (64-bit), `HI`, `LO`
- ALU ops controlled directly by testbench: `AND/OR/ADD/SUB/MUL/DIV/SHR/SHRA/SHL/ROR/ROL/NEG/NOT` and `IncPC`
- Add/Sub are implemented with a bitwise ripple-carry adder (no built-in `+`/`-`). Mul/Div use algorithmic implementations.

## FPGA / Quartus note (fitter “too many pins”)

`hdl/Datapath.v` keeps the big “waveform observability” signals (PC/IR/R0..R15/Z/etc.) as **internal nets**, not top-level outputs. This lets you set `Datapath` as the Quartus **Top-level entity** without overflowing the FPGA I/O pin count.

For ModelSim, you can still view these by hierarchy (and the provided testbench mirrors them onto local wires).
