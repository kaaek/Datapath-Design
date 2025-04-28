# Floating Point Unit (FPU) Integration with Archer RV32I Processor

## Project Overview

This project enhances the Archer RV32I single-cycle processor by integrating support for IEEE-754 single-precision floating-point operations.  
The implemented FPU supports three operations:

- **Floating Point Addition (FADD.S)**
- **Floating Point Subtraction (FSUB.S)**
- **Floating Point Multiplication (FMUL.S)**

The integration allows the processor to execute floating-point instructions alongside the existing RV32I integer instruction set.

---

## Implemented Modules

- **sp_class.v**: Classifies an IEEE-754 floating point number (normal, subnormal, NaN, infinity, zero).
- **sp_add.v**: Performs floating-point addition (FADD.S).
- **sp_sub.v**: Performs floating-point subtraction (FSUB.S).
- **sp_mul.v**: Performs floating-point multiplication (FMUL.S).
- **FPU.v**: Top-level module that connects sp_add, sp_sub, and sp_mul based on the opcode provided.
- **fregfile.v**: Floating-point register file (parallel to the integer regfile).

---

## Integration with Archer RV32I

The FPU was integrated into the Archer pipeline as follows:

- Added a **Floating Point Register File (FRF)** to hold floating point values.
- Extended the **control unit** (`control.v`) to generate new control signals:
  - **FRegWrite**: Floating point register write enable.
  - **FPUOp**: 2-bit opcode for the FPU (00: ADD, 01: SUB, 10: MUL).
  - **FMemToReg**: Selects between FPU output and data memory output.
  - **FMemWrite**: Selects whether a memory write comes from a floating-point register or an integer register.
- **Modified datapath**:
  - Added FPU instantiation.
  - Routed operands from FRF to the FPU.
  - Routed FPU result back to FRF.
- **Maintained full support** for the original RV32I instruction set, extending Archer capabilities without affecting original functionality.

---

## Testing

- Each individual module (sp_class, sp_add, sp_sub, sp_mul, FPU) has been tested with dedicated testbenches.
- **Archer** has been tested with a preloaded ROM containing floating-point instructions:
  - **ADD.S** test
  - **SUB.S** test
  - **MUL.S** test
  - **Floating-point load/store tests**

### Example FPU Testbench Results

| Operation                  | Result       |
|-----------------------------|--------------|
| ADD (1.0 + 1.0)             | 0x40000000 (2.0) |
| SUB (1.0 - 1.0)             | 0x00000000 (0.0) |
| MUL (2.0 * 3.0)             | 0x40C00000 (6.0) |
| MUL (tiny * tiny)           | 0x00000000 (underflow) |
| ADD (inf + 1.0)             | 0x7F800000 (inf) |
| SUB (inf - inf)             | 0x7FBFFFFF (NaN) |
| MUL (inf * 0)               | 0x7FC00000 (NaN) |

---

## File List

- `sp_class.v`
- `sp_add.v`
- `sp_sub.v`
- `sp_mul.v`
- `FPU.v`
- `fregfile.v`
- `archer_rv32i_single_cycle.v`
- `control.v`
- `rom.v`
- `pc.v`
- `other_archer_rv32_single_cycle_tb.v` (testbench)

---

## Instructions for Running

1. **Open Vivado** and create a new project.
2. **Add all Verilog source files** listed above to the project.
3. **Set `other_archer_rv32_single_cycle_tb.v` as the top module** for simulation.
4. **Run Behavioral Simulation** to observe processor operation and FPU results.
5. **Check ROM** contents to confirm that floating-point instructions are preloaded.
6. **Observe register file outputs** for expected floating-point results.

---

## Notes

- Floating-point instructions are identified via opcodes and passed directly to the FPU.
- The FPU module is **fully combinational** (no internal clocks).
- Special cases (NaNs, Infs, subnormals) are handled according to IEEE-754 standards.
- **ROM** needs to be populated with RISC-V machine code representing floating point programs.
