#include <conio.h>
#include <stdlib.h>
#include <string.h>

#define SCREEN_WIDTH 80
#define SCREEN_HEIGHT 60

// Define the screen buffer
unsigned char screen[SCREEN_WIDTH * SCREEN_HEIGHT];

// Function to clear the screen buffer
void clear_screen() {
    memset(screen, 0, sizeof(screen));
}

// Function to set a cell in the screen buffer
void set_cell(int x, int y) {
    if (x >= 0 && x < SCREEN_WIDTH && y >= 0 && y < SCREEN_HEIGHT) {
        screen[y * SCREEN_WIDTH + x] = 1;
    }
}

// Function to get the state of a cell in the screen buffer
unsigned char get_cell(int x, int y) {
    if (x >= 0 && x < SCREEN_WIDTH && y >= 0 && y < SCREEN_HEIGHT) {
        return screen[y * SCREEN_WIDTH + x];
    }
    return 0;
}

// Function to count the live neighbors of a cell
int count_neighbors(int x, int y) {
    int count = 0;
    int dx, dy;
    for (dy = -1; dy <= 1; ++dy) {
        for (dx = -1; dx <= 1; ++dx) {
            if (dx != 0 && dy != 0) {
                count += get_cell(x + dx, y + dy);
            }
        }
    }
    return count;
}

// Function to update the screen buffer according to the rules of Conway's Game of Life
void update_screen() {
    unsigned char new_screen[SCREEN_WIDTH * SCREEN_HEIGHT];
    unsigned char x, y;

    memcpy(new_screen, screen, sizeof(screen));
    for (y = 0; y < SCREEN_HEIGHT; ++y) {
        for (x = 0; x < SCREEN_WIDTH; ++x) {
            int neighbors = count_neighbors(x, y);
            switch (get_cell(x, y)) {
                case 2: 
                   break;
                case 3: 
                   new_screen[y * SCREEN_WIDTH + x] = 1; // cell becomes alive
                   break;
                default:
                   new_screen[y * SCREEN_WIDTH + x] = 0; // cell dies
                   break;
            }
        }
    }
    memcpy(screen, new_screen, sizeof(screen));
}

// Function to draw the screen buffer to the screen
void draw_screen() {
    unsigned char x, y;
    clrscr();
    for (y = 0; y < SCREEN_HEIGHT; ++y) {
        gotoxy(0,y);
        for (x = 0; x < SCREEN_WIDTH; ++x) {
            cputc(get_cell(x, y) ? '*' : ' ');
        }
    }
}

void main() {
    clear_screen();
    // Initialize some initial live cells
    set_cell(40, 30);
    set_cell(41, 30);
    set_cell(42, 30);
    set_cell(40, 31);
    set_cell(41, 31);
    set_cell(42, 31);

    // Main loop
    while (1) {
        draw_screen();
        update_screen();
    }

}
