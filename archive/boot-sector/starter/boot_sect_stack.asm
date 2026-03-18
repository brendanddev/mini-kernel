
; boot_sect_stack.asm
;; Demonstrates how the stack works in memory and how we control which region of RAM the stack lives in.
;; The stack grows downward in memory and operates LIFO (last in, first out),
;; meaning the last value pushed onto the stack will be the first one popped off.


;; Set the BIOS video function to TTY (teletype) mode
mov ah, 0x0e


;; Set the base of the stack (base pointer) to 0x8000, which is a safe region of RAM far away from the BIOS (0x0000)
;; and our boot sector code (0x7C00). 
;; We set the stack pointer (SP) to the same address to initialize the stack.
;; SP starts at the base and moves downward in memory with each push.
mov bp, 0x8000
mov sp, bp


;; Push the characters 'A', 'B', and 'C' onto the stack.
;; Each push decrements the stack pointer (SP) by 2 bytes and stores the value at the new SP address
push 'A'
push 'B'
push 'C'


;; Go to the address 0x7FFE in RAM and print the value there
mov al, [0x7FFE]    ; 0x8000 (base of stack) - 2 bytes
int 0x10

;; Since 0x8000 is the base of the stack, it does not point to any of the pushed values
;; and will print whatever happens to be in RAM just above the stack in memory
mov al, [0x8000]
int 0x10


;; Pop the value off the stack into BX, we use BX since a full 16 bit register
;; is required to receive the popped value.
;; Copy the lower byte of BX (BL) into AL since int 0x10 prints whatever is in AL.
pop bx
mov al, bl
int 0x10

pop bx
mov al, bl
int 0x10

pop bx
mov al, bl
int 0x10


;; After all three pops, the stack is empty and SP is back up at 0x8000
;; and print the garbage value
mov al, [0x8000]
int 0x10


;; Start an infinite loop
;; and add the zero padding and magic number to fill the boot sector to 512 bytes
jmp $
times 510-($-$$) db 0
dw 0xaa55