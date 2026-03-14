# mini-os-asm

An experimental mini operating system - work in progress.

---

## Commands

### Assemble
```bash
nasm -f bin boot_sector.asm -o boot_sector.bin
nasm -f bin boot_sect_memory.asm -o boot_sect_memory.bin
nasm -f bin boot_sect_stack.asm -o boot_sect_stack.bin
```

### Run
```bash
qemu-system-x86_64 boot_sector.bin
qemu-system-x86_64 boot_sect_memory.bin
qemu-system-x86_64 boot_sect_stack.bin
```

### Inspect
```bash
xxd boot_sector.bin          # hex dump (default)
xxd -b boot_sector.bin       # binary
xxd -p boot_sector.bin       # plain hex, no offsets
```

---

## Tools

- **NASM** — assembler, compiles `.asm` source to raw binary
- **QEMU** — x86 system emulator, runs the binary as if it were real hardware

---

