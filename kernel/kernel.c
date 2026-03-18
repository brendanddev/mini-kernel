

/**
 * kernel.c
 * 
 * Instead of using BIOS interrupts (int 0x10) like in real mode,
 * we write directly to video memory at 0xb8000 since we are now in 
 * 32-bit protected mode where BIOS interrupts no longer work
 */

 
/*
 * Empty function placed first in the file so the linker puts it at the start
 * of the binary (address 0x0000). This prevents the boot sector from jumping 
 * directly into main() and gives us a controlled entry point instead
 */
void test_entrypoint() {
}

void main() {
    // Cast the memory address 0xb8000 to a char pointer
    // Writing here puts characters on screen without needing the BIOS
    char* video_memory = (char*) 0xb8000;

    // Derefrence the pointer and write 'X' into video memory
    // This is the C equivalent of: mov [edx], 'X' in assembly
    *video_memory = 'X';
}