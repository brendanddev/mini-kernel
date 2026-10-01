#ifndef SCREEN_H
#define SCREEN_H

// Declares the functions for interacting with the hardware screen.

// VGA text mode memory starts here. Writing to it changes what is on screen.
#define VIDEO_ADDRESS 0xb8000

// VGA controller registers used to control the hardware cursor. 
#define VGA_CTRL_PORT        0x3D4
#define VGA_DATA_PORT        0x3D5

// Register numbers golding the cursor position as a cell number.
#define VGA_REG_CURSOR_HIGH  14
#define VGA_REG_CURSOR_LOW   15

// Text grid is 80 columns by 25 rows.
#define MAX_ROWS 25
#define MAX_COLS 80

#define WHITE_ON_BLACK 0x0f

// Fill the whole screen with blanks and move the cursor to the top left.
void clear_screen();

// Print a null terminated string starting at (col, row), 0-indexed
// from the top left. Pass -1 for col and row to continue from the
// current cursor position.
void print_at(char *message, int col, int row);

// Print a null terminated string at the current cursor position.
void print(char *message);

#endif
