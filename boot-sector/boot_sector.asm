
; boot_sector.asm
;; The first tiny program on a disk that a computer runs when it starts. 
;; Only 512 bytes because it has to fit in a very specific spot in memory.


mov ah, 0x0e
mov al, 'H'
int 0x10
mov al, 'e'
int 0x10
mov al, 'l'
int 0x10
int 0x10
mov al, 'o'
int 0x10

; Start an infinite loop
loop:
    jmp loop 

; Fill with 510 zeros minus the size of the previous code
times 510-($-$$) db 0

; Magic number
dw 0xaa55