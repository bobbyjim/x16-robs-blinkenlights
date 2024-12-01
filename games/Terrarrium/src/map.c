#include <string.h>
#include <conio.h>

#include "common.h"
#include "map.h"

void map_init(byte map_id) {
    if (!IS_VALID_MAP_ID(map_id)) return;

    SET_MAP_BANK(MAP_BANK_START + map_id);
    memset((byte*)0xA000, ' ', MAP_SIZE);  // Initialize with spaces
}

byte map_get_cell(byte map_id, byte x, byte y) {
    if (!IS_VALID_MAP_ID(map_id)) return ' ';

    SET_MAP_BANK(MAP_BANK_START + map_id);
    return *((byte*)0xA000 + y * MAP_COLS + x);
}

void map_set_cell(byte map_id, byte x, byte y, byte value) {
    if (!IS_VALID_MAP_ID(map_id)) return;

    SET_MAP_BANK(MAP_BANK_START + map_id);
    *((byte*)0xA000 + y * MAP_COLS + x) = value;
}

void map_debug_print(byte map_id) {
	byte x,y;

    if (!IS_VALID_MAP_ID(map_id)) return;

    SET_MAP_BANK(MAP_BANK_START + map_id);
    for (y = 0; y < MAP_ROWS; y++) {
        for (x = 0; x < MAP_COLS; x++) {
            map_display(x, y, *((byte*)0xA000 + y * MAP_COLS + x));
        }
    }
}