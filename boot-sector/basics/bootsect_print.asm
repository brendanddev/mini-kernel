
; bootsect_print.asm


;; Adds the label, marking this memory address as the entry point of the print function
print:
    ;; Push all, saves all registers onto the stack at once so we dont corrupt callers data
    pusha

    ;; Adds the label marking the top of the loop, jump back here in each iteration
    start:

        ;; Dereference BX to get the byte at the current address in BX - BX is our pointer to walk through the string
        mov al, [bx]
        ;; Compare AL to 0, 'cmp' subtracts without storing the result.
        ;; Just sets the CPU flags so the next instruction can act on them
        cmp al, 0
        ;; Jump if equal, if AL == 0 (null terminator) jump to done
        ;; This is how we know weve reached the end of the string
        je done

        ;; Set BIOS video function to TTY mode
        mov ah, 0x0E
        int 0x10

        ;; Move BX forward by 1 byte, advance our pointer to the next character
        add bx, 1
        ;; Unconditional jump back to start, loop again for the next char
        jmp start

    done:

        ;; Pop all, restore all registers back to what they were before pusha
        ;; the caller gets their registers back exactly as they left them
        popa

        ;; Return, jump back to whatever 'call print' was called from in main
        ret

;; Label as the entry point for the print newline function
print_nl:

    ;; Save all registers
    pusha

    ;; Set BIOS to TTY mode
    mov ah, 0x0E
    mov al, 0x0A    ;; 0x0A = new line
    int 0x10

    mov al, 0x0D    ;; 0x0D = carriage return
    int 0x10

    ;; Restore all registers and return
    popa
    ret