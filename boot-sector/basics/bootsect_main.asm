
; bootsect_main.asm


[org 0x7C00]    ;; Tell NASM that all addresses are relative to 0x7C00 (where BIOS loads us in RAM)


;; The main routine which makes sure the parameters are ready and then calls the function

;; Load the address of WELCOME_MSG into BX and call the print subroutine
;; Then call print_nl to print a newline and carriage return
mov bx, WELCOME_MSG
call print
call print_nl

;; Load the address of GOODBYE_MSG into BX and call the print subroutine
;; Then call print_nl to newline
mov bx, GOODBYE_MSG
call print
call print_nl

;; Load the value 0x12FE into DX and call the print_hex subroutine
;; This prints the value 0x12FE as a hexadecimal string to the screen
mov dx, 0x12FE
call print_hex


;; Hang in infinite loop
jmp $


;; Include subroutines
;; These are inserted by NASM at assembly time, not at runtime
%include "bootsect_print.asm"
%include "bootsect_print_hex.asm"


;; Defining data

WELCOME_MSG:
    db 'Hello, World', 0    ; Place 6 bytes in memory (H, e, l, l, o, 0x00)

GOODBYE_MSG:
    db 'Goodbye', 0


; Zero padding and magic number
times 510-($-$$) db 0       ;; pad to 510 bytes with zeros
dw 0xaa55                   ;; boot signature, BIOS checks for this at bytes 511-512



