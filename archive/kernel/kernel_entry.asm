
; kernel_entry.asm

;; The entry point that bridges the boot sector and the C kernel.
;; When the boot sector finishes switching to 32-bit protected mode,
;; it jumps here. This file then calls the C main() function. We need
;; this because we cannot jump directly from assembly into C, we need
;; explicitly call the C entry point

[bits 32]       ;; We are in 32-bit protected mode, use 32-bit registers
[extern main]   ;; Tell NASM that 'main' defined in another file (kernel.c)
                ;; 'extern' means: "this label exists, but not in this file,
                ;; " - the linker will find it and connect them "

call main       ;; Call the main() function
                ;; The linker resolves 'main' to the address of main() in kernel.c

jmp $           ;; Infinite loop, if main() ever returns, hang here
                ;; prevents the CPI executing garbage after the kernel exits        
