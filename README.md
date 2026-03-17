# mini-os-asm

An experimental mini operating system - work in progress.

---

## Commands

### Assemble
```bash
nasm -f bin boot_sector.asm -o boot_sector.bin
nasm -f bin boot_sect_memory.asm -o boot_sect_memory.bin
nasm -f bin boot_sect_stack.asm -o boot_sect_stack.bin
nasm -f bin bootsect_main.asm -o bootsect_main.bin
nasm -f bin boot_sect_segmentation.asm -o boot_sect_segmentation.bin
nasm -f bin 32bit_main.asm -o 32bit_main.bin
```

### Compile (C)
```bash
# compile to object file — -ffreestanding means no OS, no standard library
x86_64-elf-gcc -ffreestanding -c function.c -o function.o
x86_64-elf-gcc -ffreestanding -c localvars.c -o localvars.o
```

### Link
```bash
# link object file to raw binary, placed at address 0x0
x86_64-elf-ld -o function.bin -Ttext 0x0 --oformat binary function.o
```

### Run
```bash
qemu-system-x86_64 boot_sector.bin
qemu-system-x86_64 boot_sect_memory.bin
qemu-system-x86_64 boot_sect_stack.bin
qemu-system-x86_64 bootsect_main.bin
qemu-system-x86_64 boot_sect_segmentation.bin
qemu-system-x86_64 32bit_main.bin
```

### Inspect
```bash
xxd boot_sector.bin          # hex dump (default)
xxd -b boot_sector.bin       # binary
xxd -p boot_sector.bin       # plain hex, no offsets

x86_64-elf-objdump -d function.o           # disassemble object file (AT&T syntax)
x86_64-elf-objdump -d -M intel function.o  # disassemble (Intel syntax — matches NASM)

x86_64-elf-objdump -d -M intel localvars.o
```

---

## Tools

- **NASM** — assembler, compiles `.asm` source to raw binary
- **QEMU** — x86 system emulator, runs the binary as if it were real hardware

---

## References

- [cfenollosa/os-tutorial](https://github.com/cfenollosa/os-tutorial) — the tutorial this project tries to follow
- [OSDev Wiki](https://wiki.osdev.org/Expanded_Main_Page) — comprehensive reference for OS development concepts
- [The Little Book About OS Development](https://littleosbook.github.io/) — accessible guide to writing an OS from scratch