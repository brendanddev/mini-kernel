
# Boot Sector

The boot sector is the **first 512 bytes of a disk**. When a computer powers on, the BIOS reads those 512 bytes into RAM and executes them. It is the very first code that runs, before any operating system, drivers, before anything.

At this stage, you have:
- No OS
- No standard library
- No file system
- Just your 512 bytes, the CPU, and the BIOS

---

## The Boot Process

```
Power On
    ↓
BIOS Runs (built into mobo)
    ↓
BIOS performs POST (power on self test), checking hardware
    ↓
BIOS looks for bootable disk
    ↓
BIOS reads first 512 bytes of disk into RAM at address 0x7c00
    ↓
BIOS checks bytes 511-512 for the boot signature (0x550xaa)
    ↓
If valid → BIOS jumps to 0x7c00 and code runs
If invalid → BIOS tries next device or shows no bootable device
```

In this case, QEMU emulates the entire process, it pretends to be a real x86 PC, including the BIOS. The `.bin` file is treated as the disk.

---

## Why 0x7c00?

The BIOS always loads the boot sector at memory address `0x7c00`. This is a convention that dates back to the original IBM PC in 1981 and has never changed.

The lower region of RAM is reserved:
```
0x0000 - 0x03FF   →  Interrupt Vector Table (BIOS sets this up)
0x0400 - 0x04FF   →  BIOS Data Area
0x0500 - 0x7BFF   →  Free (but conventionally left alone)
0x7C00 - 0x7DFF   →  Your boot sector lives here (512 bytes)
0x7E00 onwards    →  Free to use
```

This is why all memory references in the code must be offset by `0x7c00`, NASM calculates addresses from the zero but the code is actually sitting at `0x7c00` in RAM.

---

## The Boot Signature

The last two bytes of the boot sector must be `0x55 0xaa`. The BIOS checks for this before handing over execution. Without it, the disk is not considered bootable.

```asm
dw 0xaa55   ;; Define 2 bytes, stored as 55 AA in memory (littl endian)
```

> Note: `0xaa55` written as a word gets stored as `55 aa` because x86 is **little endian**, multi byte values are stored with the least significant byte first.

In `xxd` output you can always see this at the very end:
 
```
000001f0: 0000 0000 0000 0000 0000 0000 0000 55aa
```

---

## The 512 Byte Layout

```
Byte 0        →  start of the code
...
Byte N        →  end of the code
Byte N+1      →  start of zero padding
...
Byte 509      →  end of zero padding
Byte 510-511  →  0x55 0xAA (boot signature)
```
 
The zero padding is handled automatically by NASM:
 
```asm
times 510-($-$$) db 0    ;; fill from end of code to byte 510 with zeros
dw 0xaa55                ;; boot signature at bytes 511-512
```
 
- `$$` = start of the section (beginning of the binary)
- `$` = current address (where we are now)
- `$-$$` = how many bytes of code have been written
- `510-($-$$)` = how many bytes are left to fill

---

## [org 0x7c00]

`org` is a NASM directive that tells NASM to calculate all addresses as if the code starts at the given address. Without it, NASM assumes `0x0000`.

```asm
[org 0x7C00]    ;; all labels and addresses calculated from 0x7C00
```

This is the cleanest fix to the memory addressing problem. Instead of manually adding `0x7c00` to every label, you declare it once at the top and NASM handles the rest.

You will see `[org 0x7C00]` at the top of virtually every boot sector ever written.

---

## Infinite Loop

Boot sectors end with an infinite loop to stop the CPU from executing whatever random bytes come after the code:

```asm
jmp $    ;; jump to current address — loops forever
```
 
`$` means "current address" in NASM. So `jmp $` literally means "jump to here" —
the CPU just spins in place. Without this, the CPU would continue executing the
zero padding as instructions, which would cause undefined behavior.

---

## What is a Bootable Disk?

A bootable disk is any storage device (hard drive, USB, CD, floppy) whose first 512 bytes end with the boot signature `0x55 0xaa` at bytes 511-512. That signature is the only thing the BIOS checks, if its there, the BIOS considers the disk bootable and hands over execution.

The disk itself dosent know its 'bootable', its just bytes. The BIOS is the one that reads byte 511 and 512 and makes the decision based on what it finds there.

---

## Is a Disk a Linear Sequence of Bytes?

Technically, a disk is just a flat linear sequence of bytes, addressed from byte 0 onwards:
```
Byte 0      →   First byte on the disk
Byte 1      →   Second byte on the disk
...
Byte 510    →   Second to last byte of the boot sector
Byte 511    →   0x55 (first byte of the boot signature)
Byte 512    →   0xaa (second byte of the boot signature)
Byte 513    →   Start of the rest of the disk, (kernel, data, etc. lives here)
...
```

> When the BIOS says "read the first 512 bytes", it litterally reads bytes 0 through 511 from the start of the disk and copies them into RAM.

---

## Is RAM a Linear Sequence of Bytes?

Technically, RAM is also a flat linear sequence of bytes, each with a unique address:
```
Address 0x0000  →   Byte 0
Address 0x0001  →   Byte 1
...
Address 0x7c00  →   Byte 31744  (Where the boot sector gets loaded)
Address 0x7c01  →   Byte 31745  (Second byte of the boot sector)
...
```

> When the BIOS loads the boot sector, it is litterally copying 512 bytes from the disk into RAM starting at address `0x7c00`. From that point on, the CPU reads the instructions out of RAM sequentially, one byte at a time, `0x7c00` onwards.

Both disk and RAM are linear, the difference is:
- **Disk**: persistent storage, survives power off, slower to access
- **RAM**: temporary, wiped on power off, fast to access, where code actually executes














