#ifndef _CREATURE_H_
#define _CREATURE_H_

typedef struct {
	short x, y;			// position on the grid
	unsigned int hunger_level;
} Creature;

void creature_move(Creature *creature);
void creature_consume_food(Creature *creature);

#endif
