
# Basics

A reference for connecting fundamental number system knowledge to low-level OS/assembly development.

---

## Bits and Bytes

- 1 bit = a single 0 or 1
- 8 bits = 1 byte → values from 0–255 (0x00–0xFF)
- A byte always fits in exactly **2 hex digits** — this is why hex is used everywhere in low-level work
- Binary is too verbose to read, decimal doesn't map cleanly to bytes, hex is the sweet spot

---

## Number Systems

The same value, four ways:

| Decimal (base 10) | Binary (base 2) | Hexadecimal (base 16) | Octal (base 8) |
|-------------------|-----------------|-----------------------|-----------------|
| 0                 | 0000 0000       | 0x00                  | 000             |
| 14                | 0000 1110       | 0x0E                  | 016             |
| 32                | 0010 0000       | 0x20                  | 040             |
| 64                | 0100 0000       | 0x40                  | 100             |
| 72                | 0100 1000       | 0x48                  | 110             |
| 255               | 1111 1111       | 0xFF                  | 377             |

> `0x48` = 72 = `'H'` in ASCII — the first character printed by `boot_sector.asm`

---

## Why Hex in Assembly / OS Dev

When you look at a raw binary file with `xxd`, every byte shows up as 2 hex digits:
```
b4 0e b0 48 cd 10
```

That's 6 bytes. Each pair is one byte. Compare reading that vs binary:
```
10110100 00001110 10110000 01001000 11001101 00010000
```

Same data. Hex is just far more readable at this scale.

---

## How It All Connects

```
An .asm file

```

---

## Registers

Registers are small storage slots directly inside the CPU, much faster than RAM. The CPU uses them to hold values it is currently working with. You cannot execute instructions directly on values in RAM, you load them into registers first, operate on them, then write back.

The main x86 registers:

```
AX (16 bit) -> Accumulator, split into AH (high byte) and AL (low byte)

BX (16 bit) -> Base, split into BH and BL, often used as a memory pointer

CX (16 bit) -> Counter, used in loops (iterations)

DX (16 bit) -> Data, used in I/O operations

SP (16 bit) -> Stack pointer, tracks the top of the stack (managed by CPU automatically)

BP (16 bit) -> Base pointer, marks the base of the stack
```

AX split into high and low byte:

```
AX (16 bit)
┌─────────┬─────────┐
│   AH    │   AL    │
│(hi byte)│(lo byte)│
└─────────┴─────────┘
```

The same applues to BX -> BH / BL, CX -> CH / CL, DX -> DH, DL

> `mov al, [ax]` is **illegal** — you cannot use the same register as both the source
> address and the destination in one instruction. This is why BX is used as an
> intermediary pointer when dereferencing — AL and BX are completely separate registers.

---

## Segment Registers

In 16-bit real mode, memory is addressed using segment registers. The CPU calculates the real memory address as:

```
real address = segment register * 16 + offset
```

The four segment registers:

```
CS -> Code segment, used for code execution (where my instructions live)

DS -> Data segment, used automatically when accessing memory labels

SS -> Stack segment, used for the stack

ES -> Extra segment, general purpose, used explicitly with [es:label]
```

You cannot load a value directly into a segment register, you must go through a general purpose register first:

```asm
mov ds, 0x7c0    ;; illegal, cannot load immediate value into segment register
mov bx, 0x7c0    ;; legal
mov ds, bx       ;; legal — move from general register into segment register
```

Why `0x7C0` and not `0x7C00`? Because the CPU multiplies the segment register by 16:
 
```
0x7C0 * 16 = 0x7C00  ← the real address of our boot sector in RAM
```

---

## Memory Addressing

Labels in assembly are just memory addresses calculated by NASM from the start of a file. The BIOS loads the boot sector into RAM at `0x7C00`, so all addresses must be offset correctly.

```
NASM thinks label is at:   0x002D   (offset from start of file)
BIOS loaded us at:       + 0x7C00   (where our code is in RAM)
Real address in RAM:     = 0x7C2D
```

Square brackets `[]` dereference a memory address — get the **value AT** that address:
 
```asm
mov al, the_secret      ;; AL = the address itself     (e.g. 0x002D) — wrong
mov al, [the_secret]    ;; AL = the value AT that address (e.g. 0x58 = 'X') — closer
```

This is the same as `*pointer` in C. Without correcting for `0x7C00`, even `[the_secret]`
points to the wrong place in RAM.
 
Three ways to fix the offset problem:
 
```asm
;; Option 1 — manually add 0x7C00 using a register
mov bx, the_secret
add bx, 0x7C00
mov al, [bx]
 
;; Option 2 — hardcode the corrected address (fragile, breaks if code changes)
mov al, [0x7C2D]
 
;; Option 3 — use [org 0x7C00] at the top of your file (cleanest)
[org 0x7C00]
mov al, [the_secret]    ;; NASM now calculates all addresses relative to 0x7C00
```

---

## The Stack

A region of RAM used for temporary storage. Operates LIFO, the last value pushed is the first value popped off. The stack grows downward in memory.

```asm
mov bp, 0x8000
mov sp, bp
```


How the stack looks after pushing A, B, C:
 
```
0x8000   ← BP (base, never moves — nothing stored here)
0x7FFE   ← 'A' stored here after push 'A'
0x7FFC   ← 'B' stored here after push 'B'
0x7FFA   ← 'C' stored here after push 'C'  ← SP is here
```
 
Popping comes out in reverse order (LIFO):
 
```
pop  →  C   (last in, first out)
pop  →  B
pop  →  A
```
 
`pop` requires a 16-bit register as destination, you cannot pop directly into AL (8-bit). 

Use BX as an intermediary and copy the lower byte BL into AL:

```asm
pop bx        ;; pop into BX (16-bit) — required
mov al, bl    ;; copy lower byte of BX into AL
int 0x10      ;; print it
```

`pusha` and `popa` push and pop **all registers** at once — used at the start and end of
subroutines to preserve the caller's register state. Think of it like saving temp variables
before a function runs and restoring them after:
 
```asm
print:
    pusha        ;; save all registers — caller's values are safe
    ...          ;; freely modify AX, BX, CX etc
    popa         ;; restore all registers — caller gets them back exactly as they were
    ret
```

---

## BIOS Interrupts

---

## NASM Directibves vs Instructions

---