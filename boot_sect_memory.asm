

; boot_sect_memory.asm
;; Demonstrates how labels in assembly are just memory addresses.
;; The BIOS (emulated by QEMU) loads this boot sector into RAM at 0x7C00,
;; so all memory references must be relative to that address. Otherwise 
;; were pointing to the wrong place in memory.


;; Move the value '0x0e' into the AH register
mov ah, 0x0e

;; ATTEMPT 1

;; Move the value '1' into the AL register
;; Then run the interrupt instruction with the value '0x10' to print the character in AL to the screen
mov al, "1"
int 0x10

;; Move the address of the label 'the_secret' into the AL register
;; Then run the interrupt to print the address value
mov al, the_secret
int 0x10

;; Prints a newline
mov al, 0x0A    ; newline character in ASCII
int 0x10
mov al, 0x0D    ; carriage return character in ASCII
int 0x10

;; ATTEMPT 2

;; Move the value '2' into the AL register and print to the screen
mov al, "2"
int 0x10
;; Move the value at the address of 'the_secret' into the AL register and print to the screen
mov al, [the_secret]
int 0x10
;; BIOS places the bootsector at binary address 0x7C00, so the label 'the_secret' is located at 0x7C00 + offset of 'the_secret'.


;; Print a newline
mov al, 0x0A
int 0x10
mov al, 0x0D
int 0x10



;; ATTEMPT 3


;; Move the value '3' into the AL register and print to the screen
mov al, "3"
int 0x10
;; Move the offset of 'the_secret' as calculated by NASM into the BX register
;; NASM calculates this offset from the start of the file, for example 0x002D
mov bx, the_secret
;; Add 0x7C00 (where the BIOS loaded the boot sector in RAM) to get the real memory address
;; 0x002D (NASM offset) + 0x7C00 (where our code is in RAM) = 0x7C2D (the real address of 'X')
add bx, 0x7C00
;; Dereference the memory address stored in the BX register, we go to the address 0x7C2D in RAM
;; and get the value stored there ('X') and move it into the AL register, then print to the screen
mov al, [bx]
int 0x10
;; If we tried to do mov al, [ax] instead, this is illegal because AL is part of the AX register,
;; and the same register cannot be used as both the destination and source address in one instruction.



;; ATTEMPT 4

;; Here we try a shortcut because we already know that the X is stored at the byte 0x2D in our binary,
;; so we can just directly read from the memory address 0x7C2D without needing to calculate it first.
;; This works but is not recommended since we would need to recount the label offsets everytime the code changes
mov al, "4"
int 0x10
mov al, [0x7C2D]
int 0x10



;; Start an infinite loop
;; The 'jmp $' instruction causes the CPU to jump to the current address, effectively creating an infinite loop.
jmp $



;; Create a label called 'the_secret' 
the_secret:
    ;; Define the byte 'X' (0x58 in hex, 88 in decimal) at this location in memory
    db "X"


;; Add the zero padding and magic number to fill the boot sector to 512 bytes
;; The 'times' directive is used to fill the remaining space in the boot sector with zeros.
;; The expression '510-($-$$)' calculates the number of bytes to fill with zeros by taking the total 
;; size of the boot sector (510 bytes) and subtracting the size of the code that has been written so far (calculated as the current address '$' minus the start address '$$').
times 510-($-$$) db 0

;; Boot signature (magic number) - BIOS checks for 0x55 0xAA at bytes 511-512
;; to confirm this is a valid bootable sector
dw 0xaa55

