// Wrappers around the x86 `in` and `out` instructions, for reading
// and writing bytes and words on I/O ports. Since there is no native
// `in`/`out` in C, inline assmbly is needed, so other drivers call these
// instead of touching the hardware directly.

#include "ports.h"

// Read 1 byte the from the given port.
uint8_t port_byte_in(uint16_t port) {
    uint8_t result;
    __asm__("in %%dx, %%al" : "=a" (result) : "d" (port));
    return result;
}

// Write 1 byte to the given port.
void port_byte_out(uint16_t port, uint8_t data) {
    __asm__("out %%al, %%dx" : : "a" (data), "d" (port));
}

// Read 2 bytes (one word) from the given port.
uint16_t port_word_in(uint16_t port) {
    uint16_t result;
    __asm__("in %%dx, %%ax" : "=a" (result) : "d" (port));
    return result;
}

// Write 2 bytes (one word) to the given port.
void port_word_out(uint16_t port, uint16_t data) {
    __asm__ volatile("out %%ax, %%dx" : : "a" (data), "d" (port));
}
