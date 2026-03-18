
/**
 * ports.c
 * 
 * 
 */


/**
 * Read 1 byte the from the given port
 */
unsigned char port_byte_in(unsigned short port) {
    unsigned char result;

    __asm__("in %%dx, %%al" : "=a" (result) : "d" (port));
    return result;
}

/**
 * Write 1 byte to the given port
 */
void port_byte_out(unsigned short port, unsigned char data) {
    __asm__("out %%al, %%dx" : : "a" (data), "d" (port));
}

/**
 * Read 2 bytes (one word) from the given port
 */
unsigned short port_word_in(unsigned short port) {
    unsigned short result;
    __asm__("in %%dx, %%ax" : "=a" (result) : "d" (port));
    return result;
}

/**
 * Write 2 bytes (one word) to the given port
 */
void port_word_at(unsigned short port, unsigned short data) {
    __asm__("out %%ax, %%dx" : : "a" (data), "d" (port));
}