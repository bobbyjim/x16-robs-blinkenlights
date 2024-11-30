#include "map.h"
#include <string.h>
#include <conio.h>

void map_init(int map_id) {
    if (!IS_VALID_MAP_ID(map_id)) return;

    SET_MAP_BANK(MAP_BANK_START + map_id);
    memset((unsigned char*)0xA000, ' ', MAP_SIZE);  // Initialize with spaces
}

unsigned char map_get_cell(int map_id, int x, int y) {
    if (!IS_VALID_MAP_ID(map_id)) return ' ';

    SET_MAP_BANK(MAP_BANK_START + map_id);
    return *((unsigned char*)0xA000 + y * MAP_COLS + x);
}

void map_set_cell(int map_id, int x, int y, unsigned char value) {
    if (!IS_VALID_MAP_ID(map_id)) return;

    SET_MAP_BANK(MAP_BANK_START + map_id);
    *((unsigned char*)0xA000 + y * MAP_COLS + x) = value;
}

void map_debug_print(int map_id) {
	int x,y;

    if (!IS_VALID_MAP_ID(map_id)) return;

    SET_MAP_BANK(MAP_BANK_START + map_id);
    for (y = 0; y < MAP_ROWS; y++) {
        for (x = 0; x < MAP_COLS; x++) {
            cputcxy(x, y, *((unsigned char*)0xA000 + y * MAP_COLS + x));
        }
    }
}
