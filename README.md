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
# -ffreestanding — no OS, no standard library, bare metal
x86_64-elf-gcc -ffreestanding -c function.c -o function.o
x86_64-elf-gcc -ffreestanding -c localvars.c -o localvars.o
x86_64-elf-gcc -ffreestanding -c functioncalls.c -o functioncalls.o
x86_64-elf-gcc -ffreestanding -c pointers.c -o pointers.o
```

### Link
```bash
# link object file to raw binary, placed at address 0x0
x86_64-elf-ld -o function.bin -Ttext 0x0 --oformat binary function.o
x86_64-elf-ld -o localvars.bin -Ttext 0x0 --oformat binary localvars.o
x86_64-elf-ld -o functioncalls.bin -Ttext 0x0 --oformat binary functioncalls.o
x86_64-elf-ld -o pointers.bin -Ttext 0x0 --oformat binary pointers.o
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
# hex dump
xxd boot_sector.bin                             # hex dump (default)
xxd -b boot_sector.bin                          # binary — shows actual bits
xxd -p boot_sector.bin                          # plain hex, no offsets

# compare object file vs raw binary
xxd function.o                                  # ELF object — machine code + metadata
xxd function.bin                                # raw binary — just machine code

# disassemble
x86_64-elf-objdump -d function.o                # AT&T syntax
x86_64-elf-objdump -d -M intel function.o       # Intel syntax — matches NASM
x86_64-elf-objdump -d -M intel localvars.o
x86_64-elf-objdump -d -M intel functioncalls.o
x86_64-elf-objdump -d -M intel pointers.o
ndisasm -b 32 function.bin                      # disassemble raw binary
```

---

## Tools

- **NASM** — assembler, compiles `.asm` source to raw binary
- **QEMU** — x86 system emulator, runs the binary as if it were real hardware
- **x86_64-elf-gcc** — cross compiler, compiles C to bare metal object files
- **x86_64-elf-ld** — linker, links object files into a raw binary
- **x86_64-elf-objdump** — disassembler, inspect machine code in object files
- **xxd** — hex dump utility, inspect raw bytes of any file
- **ndisasm** — disassembler for raw binaries (comes with NASM)

---

## References

- [cfenollosa/os-tutorial](https://github.com/cfenollosa/os-tutorial) — the tutorial this project tries to follow
- [OSDev Wiki](https://wiki.osdev.org/Expanded_Main_Page) — comprehensive reference for OS development concepts
- [The Little Book About OS Development](https://littleosbook.github.io/) — accessible guide to writing an OS from scratch