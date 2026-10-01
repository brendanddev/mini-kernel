NAME    := mini-kernel
VERSION := 0.2.0
BUILD   := build

# $@ = target file
# $< = first dependency
# $^ = all dependencies

# Shared C flags, including the identity macros for kernel.c
CFLAGS := -ffreestanding -m32 -g \
          -DKERNEL_NAME=\"$(NAME)\" \
          -DKERNEL_VERSION=\"$(VERSION)\"

all: run

# Link all objects into kernel.bin at address 0x1000.
# kernel_entry.o must stay first so its code sits at the start of the binary.
$(BUILD)/kernel.bin: $(BUILD)/kernel_entry.o $(BUILD)/kernel.o $(BUILD)/screen.o $(BUILD)/port.o
	x86_64-elf-ld -m elf_i386 -o $@ -Ttext 0x1000 $^ --oformat binary

# Build kernel with debug symbols (ELF format, not binary)
$(BUILD)/kernel.elf: $(BUILD)/kernel_entry.o $(BUILD)/kernel.o $(BUILD)/screen.o $(BUILD)/port.o
	x86_64-elf-ld -m elf_i386 -o $@ -Ttext 0x1000 $^

# Assemble kernel_entry.asm to a 32-bit ELF object file
$(BUILD)/kernel_entry.o: boot/kernel_entry.asm | $(BUILD)
	nasm $< -f elf32 -o $@

# Compile kernel.c to a 32-bit object file
$(BUILD)/kernel.o: kernel/kernel.c drivers/screen.h | $(BUILD)
	x86_64-elf-gcc $(CFLAGS) -c $< -o $@

# Compile the screen driver
$(BUILD)/screen.o: drivers/screen.c drivers/screen.h drivers/ports.h | $(BUILD)
	x86_64-elf-gcc $(CFLAGS) -c $< -o $@

# Compile the port I/O wrappers
$(BUILD)/port.o: drivers/port.c drivers/ports.h | $(BUILD)
	x86_64-elf-gcc $(CFLAGS) -c $< -o $@

# Assemble the boot sector
$(BUILD)/bootsect.bin: boot/bootsector.asm | $(BUILD)
	nasm $< -f bin -o $@

# Combine boot sector and kernel into one disk image
$(BUILD)/os-image.bin: $(BUILD)/bootsect.bin $(BUILD)/kernel.bin
	cat $^ > $@

# Create a proper floppy image
$(BUILD)/floppy.img: $(BUILD)/os-image.bin
	dd if=/dev/zero of=$@ bs=1024 count=1440
	dd if=$< of=$@ conv=notrunc

# Run
run: $(BUILD)/floppy.img
	qemu-system-x86_64 -name $(NAME) -drive format=raw,file=$(BUILD)/floppy.img,if=floppy,index=0

# Debug: open QEMU paused and connects GDB
debug: $(BUILD)/floppy.img $(BUILD)/kernel.elf
	qemu-system-i386 -drive format=raw,file=$(BUILD)/floppy.img,if=floppy,index=0 -s -S &
	x86_64-elf-gdb $(BUILD)/kernel.elf -ex "set architecture i386" -ex "target remote localhost:1234"

# Disassemble kernel for debugging
$(BUILD)/kernel.dis: $(BUILD)/kernel.bin
	ndisasm -b 32 $< > $@

# Create the build directory if it doesn't exist
$(BUILD):
	mkdir -p $(BUILD)

# Clean all build artifacts
clean:
	rm -rf $(BUILD)

.PHONY: all run debug clean
