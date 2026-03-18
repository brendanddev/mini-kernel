
; bootsector.asm

;; Starts in 16-bit real mode, loads the kernel from disk into RAM,
;; switches to 32-bit protected mode, then hands control to the C kernel.

[org 0x7c00]                ;; Tell NASM all addresses are relative to 0x7c00
                            ;; This is where the BIOS loads our boot sector in RAM

KERNEL_OFFSET equ 0x1000    ;; The address in RAM where we will load the kernel
                            ;; 0x1000 is a free safe region below the boot sector (0x7c00)
                            ;; 0x1000 → kernel loaded here
                            ;; 0x7C00 → boot sector (us)
                            ;; 0x9000 → stack

    mov dl, 0x80
    mov [BOOT_DRIVE], dl
    ;; mov [BOOT_DRIVE], dl    ;; BIOS automatically puts the boot drive number in DL on boot
                            ;; save it to memory immediately before anything overwrites DL

    mov bp, 0x9000          ;; Set the base pointer to 0x9000, safely above the boot sector
    mov sp, bp              ;; Set the stack pointer to the base pointer to initialize the stack
                            ;; stack grows downward from here

    mov bx, MSG_REAL_MODE   ;; Load the address of MSG_REAL_MODE into BX
    call print              ;; Print the message and a new line
    call print_nl

    call load_kernel        ;; Load the kernel from disk into RAM at 0x1000
                            ;; This must happen in 16-bit real mode because disk_load
                            ;; uses BIOS interrupt int 0x13 which stops working in protected mode
    
    call switch_to_pm       ;; Disable interrupts, load GDT, flip CPU to 32-bit protected mode
    jmp $                   ;; Never reached, here in case


;; Include subroutines, pasted into this file at assembly time
%include "../boot-sector/basics/bootsect_print.asm"
%include "../boot-sector/basics/bootsect_print_hex.asm"
%include "../boot-sector/disk/bootsect_disk.asm"
%include "../boot-sector/32bit/32bit_gdt.asm"
%include "../boot-sector/32bit/32bit_print.asm"
%include "../boot-sector/32bit/32bit_switch.asm"

;; Explicitly declare 16-bit real mode for the load_kernel subroutine
[bits 16]
load_kernel:
    mov bx, MSG_LOAD_KERNEL
    call print
    call print_nl

    mov bx, KERNEL_OFFSET   ;; BX = 0x1000 - tell disk_load where to put the kernel in RAM
    mov dh, 2               ;; DH = 2 - read 2 sectors from disk (kernel is bigger than 512 bytes)
    mov dl, [BOOT_DRIVE]    ;; DL = boot drive number saved earlier
    call disk_load          ;; Read from disk into RAM at 0x1000
    ret

;; Everything below runs in 32-bit protected mode
[bits 32]
BEGIN_PM:
    mov ebx, MSG_PROT_MODE  ;; EBX instead of BX - we are now in 32-bit mode
    call print_string_pm    ;; Print message
                            ;; Uses direct video memory write, BIOS is gone at this point
    call KERNEL_OFFSET      ;; Jump to 0x1000 - where the kernel was loaded from disk
                            ;; kernel_entry.asm is there, which calls main() in kernel
    jmp $


;; Data
BOOT_DRIVE db 0             ;; 1 byte to store the boot drive number
MSG_REAL_MODE db "Started in 16-bit Real Mode", 0
MSG_PROT_MODE db "Landed in 32-bit Protected Mode", 0
MSG_LOAD_KERNEL db "Loading kernel into memory", 0


;; Boot sector padding and signature
times 510 - ($-$$) db 0
dw 0xaa55