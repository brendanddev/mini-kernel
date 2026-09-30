NAME    := mini-kernel
VERSION := 0.1.0

# $@ = target file
# $< = first dependency
# $^ = all dependencies

all: run

# Link kernel_entry.o and kernel.o into kernel.bin at address 0x1000
kernel.bin: kernel_entry.o kernel.o
	x86_64-elf-ld -m elf_i386 -o $@ -Ttext 0x1000 $^ --oformat binary

# Build kernel with debug symbols (ELF format, not binary)
kernel.elf: kernel_entry.o kernel.o
	x86_64-elf-ld -m elf_i386 -o $@ -Ttext 0x1000 $^

# Assemble kernel_entry.asm to a 32-bit ELF object file
kernel_entry.o: boot/kernel_entry.asm
	nasm $< -f elf32 -o $@

# Compile kernel.c to a 32-bit object file
kernel.o: kernel/kernel.c
	x86_64-elf-gcc -ffreestanding -m32 -g -c $< -o $@

# Assemble the boot sector
bootsect.bin: boot/bootsector.asm
	nasm $< -f bin -o $@

# Combine boot sector and kernel into one disk image
os-image.bin: bootsect.bin kernel.bin
	cat $^ > $@

# Create a proper floppy image
floppy.img: os-image.bin
	dd if=/dev/zero of=floppy.img bs=1024 count=1440
	dd if=os-image.bin of=floppy.img conv=notrunc

# Run
run: floppy.img
	qemu-system-x86_64 -drive format=raw,file=floppy.img,if=floppy,index=0

# Debug - open QEMU paused and connects GDB
debug: floppy.img kernel.elf
	qemu-system-i386 -drive format=raw,file=floppy.img,if=floppy,index=0 -s -S &
	x86_64-elf-gdb kernel.elf -ex "set architecture i386" -ex "target remote localhost:1234"

# Disassemble kernel for debugging
kernel.dis: kernel.bin
	ndisasm -b 32 $< > $@

# Clean all build artifacts
clean:
	rm -f *.bin *.o *.dis *.img