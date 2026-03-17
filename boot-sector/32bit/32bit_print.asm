
; 32bit_print.asm

;; Demonstrates printing in 32-bit protected mode by writing directly to video memory.
;; In protected mode, BIOS interrupts (int 0x10) no longer work, so instead we write 
;; characters directly to the video memory address 0xb8000 which the GPU reads and
;; displays on screen. Each character takes 2 bytes: the character itself and a color byte.


;; Tell NASM we are in 32-bit protected mode, use 32-bit registers (EAX, EBX, etc.)
[bits 32]

;; Constants, defined at assembly time, replaced with their real values wherever they appear
VIDEO_MEMORY equ 0xb8000        ;; The memory address the GPU reads to display text on screen
WHITE_ON_BLACK equ 0x0f         ;; Color byte, upper 4 bits = background, lower 4 bits = text (white)


print_string_pm:
    pusha                       ;; Save all registers onto the stack
    mov edx, VIDEO_MEMORY       ;; EDX = 0xb8000, our current position in memory


print_string_pm_loop:
    mov al, [ebx]               ;; Dereference EBX, get the byte at the current string position
                                ;; EBX is our pointer walking through the string character by character
    mov ah, WHITE_ON_BLACK      ;; AH = 0x0f, the color byte
                                ;; AX now holds the character (AL) and color (AH) as one 16-bit value

    cmp al, 0                   ;; Check if weve hit null terminator (end of string)
    je print_string_pm_done     ;; If AL == 0, we are done, jump out of loop

    mov [edx], ax               ;; Write AX (character + color) directly into video memory
                                ;; the GPU reads this and displays it on screen - no BIOS needed
    add ebx, 1                  ;; Advance EBX by 1 byte, move to the next character in the string
    add edx, 2                  ;; Advance EDX by 2 bytes, each screen position takes 2 bytes

    jmp print_string_pm_loop    ;; Loop back and process next character

print_string_pm_done:
    popa                        ;; Restore all registers
    ret                         ;; Return to caller

