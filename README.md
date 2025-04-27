# Floating Point Unit (FPU) Integration - EECE 321 Project

## Project Overview

This project extends the Archer RV32I single-cycle processor by integrating a Floating Point Unit (FPU) that supports IEEE-754 compliant single-precision operations. Specifically, the FPU handles:

- Floating point addition (`FADD.S`)
- Floating point subtraction (`FSUB.S`)
- Floating point multiplication (`FMUL.S`)
- Floating point load (`FLW`) and store (`FSW`) operations

The FPU was designed and verified separately, and then integrated into the processor datapath alongside the ALU.

---

## Files and Structure

| File | Purpose |
|-----|---------|
| `sp_add.v` | Single precision floating-point addition module |
| `sp_sub.v` | Single precision floating-point subtraction module |
| `sp_mul.v` | Single precision floating-point multiplication module |
| `sp_class.v` | Floating point classifier module (used internally) |
| `FPU.v` | Wrapper module that selects between add, sub, mul |
| `archer_rv32i_single_cycle.v` | Top-level processor design |
| `archer_rv32i_single_cycle_tb.v` | Testbench for processor |
| `rom.v` | Instruction memory module |
| `sram.v` | Data memory module |
| `regfile.v` | Register file module (extended to expose x1-x4) |
| `archerdefs.v` | Macro definitions (XLEN, etc.) |


---

## How It Works

- The FPU operates **in parallel** with the ALU.
- A control signal (`instruction_type`) selects whether to use ALU or FPU output.
- The FPU decodes the operation (add, sub, mul) based on opcode fields.
- Floating point load/store operations use the data memory directly, with appropriate wiring.

---

## How to Simulate

1. Open Vivado and open the project.
2. Make sure all Verilog files are added properly.
3. Set the top module to `archer_rv32i_single_cycle_tb`.
4. Run "Elaborate Design".
5. Run "Simulate Behavioral Model".


---

## Testbench Summary

- **Registers x1 and x2** are manually preloaded with 1.0 (`0x3f800000`).
- **Instruction Memory** is preloaded with the following program:

  | Address | Instruction |
  |---------|-------------|
  | 0x00 | `FADD.S x3, x1, x2` |
  | 0x04 | `FMUL.S x4, x1, x2` |
  | 0x08 | `FSUB.S x5, x1, x2` |
  | 0x0C | `FSW f2, 0(x1)` |
  | 0x10 | `FADD.S f2, f2, f2` |
  | 0x14 | `FLW f2, 0(x1)` |
  | 0x18 | `FADD.S f3, f2, f2` |

- After simulation, the following outputs are expected:

  | Register | Expected Value |
  |----------|----------------|
  | x1 | `3f800000` (1.0) |
  | x2 | `3f800000` (1.0) |
  | x3 | `40000000` (2.0) |
  | x4 | `3f800000` (1.0) |
  | x5 | `00000000` (0.0) |


---

## Special Notes

- The register file (`regfile.v`) was modified to expose registers x1-x4 for easy monitoring.
- A floating-point classifier (`sp_class.v`) was used inside FPU modules to correctly handle special cases (zero, NaN, infinity, etc.).
- Floating-point numbers follow the IEEE-754 single precision format.

---

## Project Status

✅ Floating-point addition tested and validated.  
✅ Floating-point subtraction tested and validated.  
✅ Floating-point multiplication tested and validated.  
✅ Floating-point load and store tested and validated.

---

## Credits

- Developed as part of EECE 321 - Computer Organization and Design, Spring 2025
- Based on the Archer open-source CPU project by Embedded and Reconfigurable Computing Lab, American University of Beirut.

