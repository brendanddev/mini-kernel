
; bootsect_main.asm


[org 0x7c00]

    ;; Set the stack 
    mov bp, 0x80000
    mov sp, bp

    mov bx, 0x9000
    mov dh, 2
    call disk_load

    mov dx, [0x90000]
    call print_hex

    call print_nl

    mov dx, [0x9000 + 512]
    call print_hex

    jmp $


%include "bootsect_print.asm"
%include "bootsect_printhex.asm"
%include "bootsect_disk.asm"

; Magic number
times 510 - ($-$$) db 0
dw 0xaa55

;; Boot sector = sector 1 of cylinder 0 of head of hdd 0
times 256 dw 0xdada     ; Sector 2 = 512 bytes
times 256 dw 0xface     ; Sector 3 = 512 bytes

