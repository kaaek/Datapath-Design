lui x1, 0x10000    # x1 = 0x10000000
lui x2, 0x3f80
addi x2, x2, 0     # x2 = 0x3f800000 (+1 in decimal)
sw x2, 0(x1)       # Store x2 into memory
lui x2, 0x40e0
addi x2, x2, 0x0   # x2 = 0x40e00000 (+7 in decimal)
sw x2, 4(x1)       # Store x2 into memory
flw f1, 0(x1)      # load 1.0 into f1
flw f2, 4(x1)      # load 7.0 into f2
fadd.s f3, f1, f2   # f3 = 1.0 + 7.0 = 8.0 (0x41000000)
fsub.s f4, f2, f1   # f3 = 7.0 - 1.0 = 6.0 (0x40c00000)
fmul.s f5, f1, f2   # f5 = 1.0 * 7.0 = 7.0 (0x40e00000)
fsw f3, 8(x1)
fsw f4, 12(x1)
fsw f5, 16(x1)