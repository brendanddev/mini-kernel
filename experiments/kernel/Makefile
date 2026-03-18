
# $@ = target file
# $< = first dependency
# $^ = all dependencies

all: run

kernel.bin: kernel_entry.o kernel.o
	x86_64-elf-ld -m elf_i386 -o $@ -Ttext 0x1000 $^ --oformat binary

kernel_entry.o: kernel_entry.asm
	nasm $< -f elf32 -o $@

kernel.o: kernel.c
	x86_64-elf-gcc -ffreestanding -m32 -c $< -o $@

bootsect.bin: bootsector.asm
	nasm $< -f bin -o $@

os-image.bin: bootsect.bin kernel.bin
	cat $^ > $@

floppy.img: os-image.bin
	dd if=/dev/zero of=floppy.img bs=1024 count=1440
	dd if=os-image.bin of=floppy.img conv=notrunc

run: floppy.img
	qemu-system-x86_64 -drive format=raw,file=floppy.img,if=floppy,index=0

kernel.dis: kernel.bin
	ndisasm -b 32 $< > $@

clean:
	rm -f *.bin *.o *.dis *.img