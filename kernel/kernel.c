// The core of the kernel and the first C code to run.
// The boot sector loads the kernel to 0x1000 and switches the 
// CPU to 32-bit protected mode, then `kernel_entry.asm` calls `main()`
// here.

// Empty function placed first in the file so the linker puts it at the start
// of the binary (address 0x0000). This prevents the boot sector from jumping 
// directly into main() and gives us a controlled entry point instead.
void test_entrypoint() { }

void main() {
    // // Cast the memory address 0xb8000 to a char pointer
    // // Writing here puts characters on screen without needing the BIOS
    char* video_memory = (char*) 0xb8000;

    // // Derefrence the pointer and write 'X' into video memory
    // // This is the C equivalent of: mov [edx], 'X' in assembly
    // *video_memory = 'X';

    // Fill all 80x25 cells with blank spaces
    for (int i = 0; i < 80 * 25; i++) {
        video_memory[i * 2] = ' ';
        video_memory[i * 2 + 1] = 0x0F;
    }

    video_memory[0] = 'H';
    video_memory[2] = 'i';
}
