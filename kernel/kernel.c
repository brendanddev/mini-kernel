// The core of the kernel and the first C code to run.
// The boot sector loads the kernel to 0x1000 and switches the 
// CPU to 32-bit protected mode, then `kernel_entry.asm` calls `main()`
// here.

#include "../drivers/screen.h"

// Empty function placed first in the file so the linker puts it at the start
// of the binary (address 0x0000). This prevents the boot sector from jumping 
// directly into main() and gives us a controlled entry point instead.
void test_entrypoint() { }

void main() {
    clear_screen();
    print(KERNEL_NAME " v" KERNEL_VERSION "\n");
    print("Hello from the kernel!\n");
}
