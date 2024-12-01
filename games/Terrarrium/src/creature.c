#include <stdlib.h>
#include <conio.h>

#include "common.h"
#include "creature.h"
#include "map.h"

void creature_move(Creature *creature) {
    // Move randomly in one of four directions
    byte direction = rand() % 4;

	switch(direction) {
		case 0:	creature->x = (creature->x + 1) % MAP_COLS;  // Right
				break;

		case 1: creature->x = (creature->x + MAP_COLS - 1) % MAP_COLS;  // Left
				break;

		case 2: creature->y = (creature->y + 1) % MAP_ROWS;  // Down
				break;

		case 3: creature->y = (creature->y + MAP_ROWS - 1) % MAP_ROWS;  // Up
				break;
	}
}

void creature_consume_food(Creature *creature) {
	byte contents = map_get_cell(MAP_FOOD, creature->x, creature->y);
	if (contents == SYM_FOOD) {
		creature->hunger_level = 0; 							// yum!
		map_set_cell(MAP_FOOD, creature->x, creature->y, ' ');	// eaten.
	}
}