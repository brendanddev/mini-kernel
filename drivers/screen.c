// Text-mode screen driver interface.
// Prints text by writing directly to VGA video memory at 0xB8000.
// It keeps track of where the next character goes and exposes simple
// functions for the rest of the kernel.

#include "screen.h"

// In bytes, so cell = offset / 2
static int cursor_offset = 0;

// Convert a (col, row) position to a byte offset into video memory.
// Multiply by 2 because each cell holds a character byte and a color byte.
static int get_offset(int col, int row) {
    return (row * MAX_COLS + col) * 2;
}

void clear_screen() {
    char *video = (char *) VIDEO_ADDRESS;
    for (int i = 0; i < MAX_ROWS * MAX_COLS; i++) {
        video[i * 2] = ' ';                     // Character byte
        video[i * 2 + 1] = WHITE_ON_BLACK;      // Color byte
    }
    cursor_offset = 0;
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
}

void print(char *message) {
    print_at(message, -1, -1);
}
