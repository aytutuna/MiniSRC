# MiniSRC

MiniSRC is a small, self-contained Verilog CPU project organized in phases. Each phase builds on the previous one, starting from a manually-controlled datapath and ending with a board-oriented top level.

The objective of this project is to design, simulate, and eventually implement a simple RISC Computer (Mini SRC), consisting of a simple RISC processor, memory, and I/O. The simulation demo is completed. The design targets the Cyclone V chip (5CEBA4F23C7) on the DE0-CV development board, but the FPGA/hardware implementation demo has not been completed yet.

## What’s in each phase

- **Phase 1**: Core datapath blocks + a direct-control testbench (functional simulation).
- **Phase 2**: Datapath + RAM + basic I/O ports + instruction-level testbench.
- **Phase 3**: Full CPU by adding a finite-state control unit on top of the Phase 2 datapath.
- **Phase 4**: Phase 3 CPU plus FPGA/board wrapper modules (clock divider, 7-seg output, pin template).

Each phase folder is standalone: it contains its own `hdl/` sources and a `tb/` testbench.

## Tools used

- Quartus II 13.1
- ModelSim

## Quick start

This project is simulated by launching **ModelSim Simulation and Quartus**.

1. Create/open a Quartus project.
2. Add the files in `hdl/` and `tb/`.
3. Run: **Tools → Run Simulation Tool → RTL Simulation**.

## Notes

- This project is written to be easy to simulate and inspect in waves.
- If you synthesize to an FPGA, you may want to trim “debug visibility” signals from top-level ports and keep them internal.
