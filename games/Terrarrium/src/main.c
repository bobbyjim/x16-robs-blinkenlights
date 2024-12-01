#include <stdio.h>
#include <stdlib.h>
#include <cbm.h>
#include <conio.h>
#include <cx16.h>
#include <time.h>
#include <unistd.h>

#include "common.h"
#include "creature.h"
#include "food.h"
#include "map.h"
#include "timer.h"

#include "debug.h"

#define DELAY_MULTIPLIER   1024

unsigned int tick = 0;

void title(byte delay) {
   gotoxy(0,0);
   cprintf("terrarium ai | delay: %3u", delay);
   gotoxy(0,1);
   textcolor(COLOR_BLUE);
   chline(80);
   chlinexy(0,STATUS_ROW-1,80);
   textcolor(COLOR_LIGHTBLUE);
}

void main()
{
   byte done = 0;
   Creature creature = { 40, 30, 0 };  // start at the center
   byte current_map_id = MAP_CREATURES;
   byte delay = 16;

   _randomize();

   cbm_k_bsout(CH_FONT_UPPER); // cbm.h
   bgcolor(0); // lets background layer in
   clrscr();

   map_init(MAP_CREATURES);
   map_init(MAP_FOOD);

   // Main loop
   while (!done) {

      // Behavior for one creature.
      map_set_cell(current_map_id, creature.x, creature.y, ' ');
      map_display(creature.x, creature.y, ' ');
      creature_move(&creature);
      creature_consume_food(&creature);
      map_set_cell(current_map_id, creature.x, creature.y, '@');
      textcolor(COLOR_LIGHTBLUE);
      map_display(creature.x, creature.y, '@');
      creature_debug(&creature);
      
      // Delay
      pause_jiffies(delay * DELAY_MULTIPLIER);
      if (kbhit()) {
         switch(cgetc()) {
            case '=': // fallthrough
            case '+': if (delay<32)  ++delay; break;
            case '-': if (delay>1)   --delay; break;
         }
         title(delay);
      }

      // Generation
      if (tick % 50 == 0) {
         food_generate();
         tick = 0;
         ++creature.hunger_level;
      }
      ++tick;
   }
}
