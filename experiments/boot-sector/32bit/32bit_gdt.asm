
; 32bit_gdt.asm

;; Defines the Global Descriptor Table (GDT) required before switching to 32-bit protected mode.
;; The GDT is a data structure that tells the CPU how memory is organized, where each segment
;; starts, how big it is, and what it can be used for (code, data, stack). 
;; We define three entries: a required null descriptor, a code segment, and a data segment,
;; both covering the full 4GB address space (flat memory model).


;; Null descriptor
;; The first entry in the GDT is always 8 bytes of zeros.
gdt_start:
    dd 0x0          ;; 4 byte
    dd 0x0          ;; 4 byte


;; Code segment descriptor
gdt_code:
    dw 0xffff       ;; Limit bits 0-15 -> 0xFFFF (segment covers full 4GB)   
    dw 0x0          ;; Base bits 0-15 -> 0x0000 (segment starts at address 0)
    db 0x0          ;; Base bits 16-23 -> 0x00 (still base address 0)
    db 10011010b    ;; Access byte -> defines type, privelege, and validity
    db 11001111b    ;; Flags + limit -> 32 bit mode, 4kb granularity, upper limit bits
    db 0x0          ;; Base bits 24-31 -> 0x00 (completes the base address)


;; Data segment descriptor
;; GDT for data segment. Base and length identical to code segment
gdt_data:
    dw 0xffff
    dw 0x0
    db 0x0
    db 10011010b
    db 11001111b
    db 0x0


gdt_end:

;; GDT descriptor
;; The small structure passed to lgdt. 
;; This tells the CPU two things: how big the GDT is and where it lives in RAM
gdt_descriptor:
    dw gdt_end - gdt_start - 1      ;; Size (16 bit), always one less of its true size
    dd gdt_start                    ;; Address (32 bit)


;; Segment constants
;; These calculate the offset of each descriptor within the GDT
CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start