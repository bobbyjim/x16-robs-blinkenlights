#include <stdio.h>
#include <stdlib.h>
#include <cbm.h>
#include <conio.h>
#include <cx16.h>
#include <time.h>
#include <unistd.h>

#include "creature.h"
#include "map.h"
#include "timer.h"

#include "debug.h"

void main()
{
   unsigned char done = 0;
   Creature creature = { 40, 30, 0 };  // start at the center
   int current_map_id = MAP_CREATURES;

   _randomize();

   cbm_k_bsout(CH_FONT_UPPER); // cbm.h
   bgcolor(0); // lets background layer in
   clrscr();

   map_init(current_map_id);
   map_set_cell(current_map_id, 20, 20, '*'); // place food
   cputcxy(20, 20, '*');

   // Main loop
   while (!done) {
      map_set_cell(current_map_id, creature.x, creature.y, ' ');
      cputcxy(creature.x, creature.y, ' ');
      creature_move(&creature);
      creature_consume_food(&creature);
      map_set_cell(current_map_id, creature.x, creature.y, '@');
      cputcxy(creature.x, creature.y, '@');
      creature_debug(&creature);
      pause_jiffies(10000);
   }
}
