#ifndef _MAP_H_
#define _MAP_H_

#include <cx16.h>

#include "common.h"

#define MAP_ROWS  		56
#define MAP_DISPLAY_ROW	2
#define MAP_COLS  		80
#define STATUS_ROW 		59

// Translate to screen coords.
#define map_display(x,y,obj)		cputcxy(x, y + MAP_DISPLAY_ROW, obj)
#define map_update(x,y,obj)			map_display(x,y,obj)

#define MAP_BANK_START 	48
#define MAP_BANK_END   	63
#define MAP_SIZE (MAP_ROWS * MAP_COLS)

#define MAP_FOOD		0
#define MAP_CREATURES	1

#define  SYM_CREATURE   '@'
#define  SYM_FOOD       '*'

// Macro to set active bank
#define SET_MAP_BANK(bank) (RAM_BANK = (bank))

// Check if the map ID is valid
// WARNING!  I ASSUME id IS *** UNSIGNED ***
#define IS_VALID_MAP_ID(id) ((id) < (MAP_BANK_END - MAP_BANK_START + 1))

void map_init(byte map_id);
void map_set_cell(byte map_id, byte x, byte y, byte value);
unsigned char map_get_cell(byte map_id, byte x, byte y);

#endif
