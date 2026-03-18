

; bootsect_print_hex.asm
;; Takes a hex value in DX and prints it as a human readable hex string


print_hex:
    pusha       ; Save all registers onto the stack
    mov cx, 0   ; Used as index variable, CX = 0


    hex_loop:
        cmp cx, 4           ; Compare CX to 4 - we loop 4 times, once for each hex digit
        je end              ; If CX == 4 we have processed all 4 digits, jump to end

        mov ax, dx          ;; Copy DX into AX so we can work on it without modifying DX
        and ax, 0x000F      ;; Mask the lower 4 bits to isolate just the last hex digit
        
        add al, 0x30        ;; Add 0x30 (48 in decimal) to convert to ASCII
        
        cmp al, 0x39        ;; 0x39 = '9' in ASCII, check if digit is 0-9 or A-F
        jle step2           ;; If AL <= '9', it is a number digit, jump to step2
        
        add al, 7           ;; Add 7 to skip the gap between '9' and 'A' in ASCII

    step2:
        mov bx, HEX_OUT + 5 ;; Point BX to the last character position in '0x0000'
        sub bx, cx          ;; Move BX left by CX positions, filling right to left
        mov [bx], al        ;; Write the ASCII digit into the correct position in HEX_OUT
        ror dx, 4           ;; Rotate DX right by 4 bits, brings the next hex digit

        add cx, 1           ;; Increment loop counter
        jmp hex_loop        ;; Loop back

    end:
        mov bx, HEX_OUT     ;; Point BX to the start of our now filled HEX_OUT string
        call print          ;; Print it

        popa                ;; Restore all registers
        ret                 ;; Return to caller
    

;; String to display the hex representation
HEX_OUT:
    db '0x0000', 0



