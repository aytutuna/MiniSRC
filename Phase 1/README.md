# Phase 1 (Mini SRC) — Functional Simulation

This folder contains a minimal Phase 1 datapath implementation (single-bus mux style) and a single testbench that runs the control sequences from **CPU Phase1** Sections 3.1–3.13.

## Folder layout

- `hdl/` — Verilog modules (datapath + ALU + mul/div)
- `tb/` — ModelSim testbench

## What’s implemented (Phase 1 scope)

- Bus mux (priority select) driven by `R*out`, `PCout`, `MDRout`, `Zlowout`, `Zhighout`, `HIout`, `LOout`
- Registers: `R0..R15`, `PC`, `IR`, `MAR`, `MDR` (with Read-controlled input mux), `Y`, `Z` (64-bit), `HI`, `LO`
- ALU ops controlled directly by testbench: `AND/OR/ADD/SUB/MUL/DIV/SHR/SHRA/SHL/ROR/ROL/NEG/NOT` and `IncPC`
- **Add/Sub do not use `+`/`-`** (bitwise ripple-carry adder). Mul/Div use algorithmic `+`/`-` per the lab rules.

## How to run in ModelSim

From a ModelSim transcript, `cd` into this folder and run:

```tcl
vlib work
vlog -work work hdl/adder32.v hdl/reg32.v hdl/reg64.v hdl/mdr.v hdl/booth_mul32.v hdl/div32_signed.v hdl/alu.v hdl/Datapath.v tb/phase1tb.v
vsim -voptargs=+acc work.phase1tb
run -all
```

If it’s correct, you’ll see:

- `Phase 1: all tests passed.`

## Waves to add (demo-friendly)

Add these signals:

- `Clock`, `Clear`
- Control: `PCout`, `Zlowout`, `MDRout`, `R*out`, `*in`, `ADD/SUB/...`
- Datapath: `BusMuxOut`, `PC`, `IR`, `Y`, `Z`, `HI`, `LO`, `R0..R7` (or all registers)

## Common issues

- **Multiple *out signals high** → bus priority picks the first one; keep one source active per cycle.
- **Shift/rotate count**: this testbench uses `R4out` in the execute step so the amount comes from `R4[4:0]`.

## Quartus note (fitter “too many pins”)

`hdl/Datapath.v` keeps the big “waveform observability” signals (PC/IR/R0..R15/Z/etc.) as **internal nets**, not top-level outputs. This lets you set `Datapath` as the Quartus **Top-level entity** without overflowing the FPGA I/O pin count.

For ModelSim, you can still view these by hierarchy (and the provided testbench mirrors them onto local wires).
