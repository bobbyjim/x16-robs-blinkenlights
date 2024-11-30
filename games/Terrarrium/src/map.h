#ifndef _MAP_H_
#define _MAP_H_

#include <cx16.h>

#define MAP_ROWS  60
#define MAP_COLS  80
#define MAP_BANK_START 48
#define MAP_BANK_END   63
#define MAP_SIZE (MAP_ROWS * MAP_COLS)

#define MAP_FOOD		0
#define MAP_CREATURES	1

#define  SYM_CREATURE   '@'
#define  SYM_FOOD       '*'

// Macro to set active bank
#define SET_MAP_BANK(bank) (RAM_BANK = (bank))

// Check if the map ID is valid
#define IS_VALID_MAP_ID(id) ((id) >= 0 && (id) < (MAP_BANK_END - MAP_BANK_START + 1))

void map_init(int map_id);
void map_set_cell(int map_id, int x, int y, unsigned char value);
unsigned char map_get_cell(int map_id, int x, int y);

#endif
