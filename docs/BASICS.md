
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

