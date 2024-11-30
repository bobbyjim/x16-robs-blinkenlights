#include <conio.h>

#include "creature.h"
#include "debug.h"
#include "map.h"

void creature_debug(Creature* creature) {

    gotoxy(0,MAP_ROWS-1);
	cprintf("creature: (%d,%d) hunger %d",
		creature->x,
		creature->y,
		creature->hunger_level
	);
}