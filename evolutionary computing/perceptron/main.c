/*
    A PERCEPTRON simulation for the Commander X16

    Copyright (C) 2023 Robert Eaglestone

    This file is part of PERCEPTRON

    PERCEPTRON is free software: you can redistribute it and/or modify
    it under the terms of the MIT License.

    PERCEPTRON is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    MIT License for more details.

    You should have received a copy of the MIT License along with PERCEPTRON.  
    If not, see <https://mit-license.org/>.
*/
#include <conio.h>
#include <stdio.h>
#include <cx16.h>
#include <stdlib.h>
#include <time.h>

#include "perceptron.h"
#include "fixed.h"

#define  SECONDARY_LOAD_ADDRESS_R39     3
#define  PRIMARY_LOAD_ADDRESS_R39       0x0f000

// We're going to try to put all the Perceptrons in Bank 1.

void main() 
{ 
   unsigned char p, gen, i;
    unsigned char input[NUM_INPUTS];
    unsigned char randp, randinput;
    int w;
    Perceptron *p_ptr;

   RAM_BANK = 1;

   clrscr();
   cputs("Perceptron Training Demo\r\n\r\n");
   cputs("Initializing network...\r\n");
   
   srand(time(NULL));
   
   // Initialize 4 perceptrons with random weights
   for (p = 0; p < 4; ++p) {
       init(p, NULL);
   }
   
   cputs("Press a key to start...\r\n");
   while(!kbhit());
   
   clrscr();
   
   // Training loop
   for (gen = 0; gen < 100; ++gen) {
       // Generate random input
       for (i = 0; i < NUM_INPUTS; ++i) {
           input[i] = rand() % 8;
       }
       
       gotoxy(0, 0);
       cprintf("Generation: %d\r\n\r\n", gen);
       
       // Run all perceptrons
       for (p = 0; p < 4; ++p) {
           run(p, input);
           cprintf("P%d: ", p);
           
           // Show weights as bar graph
           for (i = 0; i < NUM_INPUTS; ++i) {
               w = fx_to_int_round((BANKED_PERCEPTRON(p))->weight[i]);
               if (w > 0) cprintf("+");
               else if (w < 0) cprintf("-");
               else cprintf("0");
           }
           
           cprintf(" -> %d\r\n", outputValue(p));
       }
       
       cprintf("\r\nInputs: ");
       for (i = 0; i < NUM_INPUTS; ++i) {
           cprintf("%d ", input[i]);
       }
       cprintf("\r\n");
       
       // Simple learning: randomly nudge weights
       if (rand() % 100 < 10) {  // 10% chance each generation
           randp = rand() % 4;
           randinput = rand() % NUM_INPUTS;
           p_ptr = BANKED_PERCEPTRON(randp);
           w = fx_to_int_round(p_ptr->weight[randinput]);
           w += (rand() % 3) - 1;  // -1, 0, or +1
           if (w > 3) w = 3;
           if (w < -3) w = -3;
           p_ptr->weight[randinput] = fx_from_int(w);
       }
   }
   
   // Show final weights after training
   gotoxy(0, 15);
   cputs("Final weights:\r\n");
   for (p = 0; p < 4; ++p) {
       cprintf("P%d: ", p);
       for (i = 0; i < NUM_INPUTS; ++i) {
           w = fx_to_int_round((BANKED_PERCEPTRON(p))->weight[i]);
           cprintf("%d ", w);
       }
       cputs("\r\n");
   }
   
   gotoxy(0, 20);
   cputs("Training complete! Press key to exit.");
   while(!kbhit());
}
