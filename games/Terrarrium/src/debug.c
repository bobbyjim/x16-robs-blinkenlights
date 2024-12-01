#include <conio.h>

#include "creature.h"
#include "debug.h"
#include "map.h"

void creature_debug(Creature* creature) {

    gotoxy(0,STATUS_ROW);
	textcolor(COLOR_WHITE);
	cprintf("creature: (%02u,%02u) hunger %02u",
		creature->x,
		creature->y,
		creature->hunger_level
	);
}