#include <stdlib.h>

#include "creature.h"
#include "map.h"

void creature_move(Creature *creature) {
    // Move randomly in one of four directions
    int direction = rand() % 4;

    if (direction == 0) creature->x++;  // Right
    else if (direction == 1) creature->x--;  // Left
    else if (direction == 2) creature->y++;  // Down
    else if (direction == 3) creature->y--;  // Up

	if (creature->x < 0)          creature->x = MAP_COLS - 1;
	if (creature->x >= MAP_COLS) creature->x = 0;
	if (creature->y < 0) 		  creature->y = MAP_ROWS - 1;
	if (creature->y >= MAP_ROWS) creature->y = 0;
}

void creature_consume_food(Creature *creature) {
	unsigned char contents = map_get_cell(MAP_CREATURES, creature->x, creature->y);
	if (contents == SYM_FOOD) {
		creature->hunger_level = 0; 	// yum!
	}
}