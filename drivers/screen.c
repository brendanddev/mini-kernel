// Text-mode screen driver interface.
// Prints text by writing directly to VGA video memory at 0xB8000.
// It keeps track of where the next character goes and exposes simple
// functions for the rest of the kernel.

#include "screen.h"
#include "ports.h"

// In bytes, so cell = offset / 2
static int cursor_offset = 0;

// Convert a (col, row) position to a byte offset into video memory.
// Multiply by 2 because each cell holds a character byte and a color byte.
static int get_offset(int col, int row) {
    return (row * MAX_COLS + col) * 2;
}

// Move the blinking hardware cursor to the given byte offset.
// Takes bytes, converts to a cell number internally, since VGA
// registers count cells
static void set_cursor(int offset) {
    int cell = offset / 2;

    // Cell number can be up to 1999, but each VGA register holds
    // 0-255, so split it
    unsigned char high_byte = cell / 256;
    unsigned char low_byte = cell % 256;

    port_byte_out(VGA_CTRL_PORT, VGA_REG_CURSOR_HIGH);
    port_byte_out(VGA_DATA_PORT, high_byte);

    port_byte_out(VGA_CTRL_PORT, VGA_REG_CURSOR_LOW);
    port_byte_out(VGA_DATA_PORT, low_byte);
}

void clear_screen() {
    char *video = (char *) VIDEO_ADDRESS;
    for (int i = 0; i < MAX_ROWS * MAX_COLS; i++) {
        video[i * 2] = ' ';                     // Character byte
        video[i * 2 + 1] = WHITE_ON_BLACK;      // Color byte
    }
    cursor_offset = 0;
    set_cursor(cursor_offset);
}

void print_at(char *message, int col, int row) {
    if (col >= 0 && row >= 0) {
        cursor_offset = get_offset(col, row);
    }

    char *video = (char *) VIDEO_ADDRESS;
    for (int i = 0; message[i] != 0; i++) {
        // Video memory has no concept of a new line, so acquire current
        // row and jump to column 0 of the next one.
        if (message[i] == '\n') {
            int current_row = cursor_offset / (2 * MAX_COLS);
            cursor_offset = get_offset(0, current_row + 1);
        } else {
            video[cursor_offset] = message[i];
            video[cursor_offset + 1] = WHITE_ON_BLACK;
            cursor_offset += 2;
        }
    }
    set_cursor(cursor_offset);
}

void print(char *message) {
    print_at(message, -1, -1);
}
