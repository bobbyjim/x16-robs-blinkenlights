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

#include "perceptron.h"
#include "minifloat.h"

#define  SECONDARY_LOAD_ADDRESS_R39     3
#define  PRIMARY_LOAD_ADDRESS_R39       0x0f000

// We're going to try to put all the Perceptrons in Bank 1.

unsigned char testInputs[NUM_INPUTS] = { 5, 4, 223, 40, 50, 60, 70 };
int testWeights[NUM_INPUTS] = { 1, 2, 1, -1, -2, 3, 1 };
int i;

void testlong() {
    int value;
    int out;

    for(value = -31000; value < 31000 ; value += 10) {
       out = (value / (1 + abs(value))) > 0? 1 : -1;
       printf(" value: %d, out: %d\n", value, out );
    }
}

void main() 
{ 
   cbm_k_setnam("petfont.bin");
   cbm_k_setlfs(0,8,0);
   cbm_k_load(SECONDARY_LOAD_ADDRESS_R39, PRIMARY_LOAD_ADDRESS_R39);

   RAM_BANK = 1;

   testlong();

//   testMiniFloat();

//   init(0, testWeights);
//   run(0, testInputs);
//   debug(0);
}
