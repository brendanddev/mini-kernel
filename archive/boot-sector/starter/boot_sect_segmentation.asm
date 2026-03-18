
;; boot_sect_segmentation.asm
;; Demonstrates how to address memory with 16-bit real mode segmentation.

;; cs - Register for code
;; ds - Register for data
;; ss - Register for stack
;; es - Register for extra (user defined)


mov ah, 0x0e                ;; Set BIOS to TTY mode so we can print characters

;; Dereference the_secret and load the byte at that address into AL
;; NASM calculated the offset from the start of the file (0x001x), 
;; but without [org 0x7c00] or a segment register set, the CPU has no idea we are
;; at 0x7c00 in RAM, so it looks at the wrong address and prints garbage since we
;; derferenced the wrong memory location
mov al, [the_secret]
int 0x10

mov bx, 0x7c0               ;; Load 0x7c0 into BX (notice not 0x7c00)
mov ds, bx                  ;; Set the Data Segment register to 0x7c0

;; Now the Data Segment is set, so the CPU calculates the real address as:
;; DS * 16 + offset = 0x7c0 * 0x10 + offset = 0x7c00 + offset
;; Which calculates the correct location in memory and prints the 'X'
mov al, [the_secret]
int 0x10

;; Use the Extra Segment register, ES hasnt been set yet so it defaults to 0x0000
;; This will print garbage because:
;; 0x0000 * 16 + offset = wrong address
mov al, [es:the_secret]
int 0x10

mov bx, 0x7c0               ;; Load 0x7c0 into BX 
mov es, bx                  ;; Set the extra segment register to 0x7c0
mov al, [es:the_secret]     ;; Now ES register has been set correctly
int 0x10                    ;; 0x7c0 * 16 + offset = 0x7c00 + offset, prints 'X'


jmp $

the_secret:
    db "X"

times 510 - ($-$$) db 0
dw 0xAA55