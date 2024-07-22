#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <conio.h>
#include <6502.h>
#include <cx16.h>

#include "gp.h"

Chromosome population[POPULATION_SIZE];
unsigned char i;
Chromosome offspring;
unsigned char generation;
unsigned char least_fitness;
int least_fit_index;

/*
    Unlike Genetic Algorithms, a chromosome in Genetic Programming
    may vary in the number of genes it has.
 */
void initialize_chromosome(Chromosome *chromosome) {
	unsigned char i;
    unsigned char length = 10 + rand() % CHROMOSOME_MAX_LENGTH;
    chromosome->length = length;
    for (i = 0; i < length; ++i) {
        chromosome->genes[i] = rand() % NUMBER_OF_OPCODES;
    }
    chromosome->genes[i+1] = 0;
}

/*
   Unlike Genetic Algorithms, fitness in Genetic Programming
   involves treating the Chromosome as a parse tree of operations.
   For a Chromosome segment of length L:

   Head Index:           0.
   Left branch indices:  1 .. L/2-1.
   Right branch indices: L/2 .. L.

 */
void calculate_fitness(Chromosome *chromosome) {
    unsigned char fitness = 0;
    unsigned char i;
    for (i = 0; i < chromosome->length; ++i) {
        fitness += chromosome->genes[i];
    }
	chromosome->fitness = fitness;
    //return fitness;
}

void mutate(Chromosome *chromosome) {
	unsigned char i;
    for (i = 0; i < chromosome->length; ++i) {
        if (rand() % MUTATION_RATE_INVERTED == 0) {
            chromosome->genes[i] = rand() % NUMBER_OF_OPCODES;
        }
    }
}

void crossover(Chromosome *child) {
	unsigned char i;
    unsigned char crossover_point = rand() % child->length;

    // Select parents for crossover (tournament selection)
	Chromosome *parent1 = selectParent();
	Chromosome *parent2 = selectParent();

    for (i = 0; i < child->length; ++i) {
        if (i < crossover_point) {
            child->genes[i] = parent1->genes[i];
        } else {
            child->genes[i] = parent2->genes[i];
        }
    }
}

void printTheCurrentGeneration(unsigned char generation) {
	unsigned char i;

	gotoxy(0,3);
    printf("Generation %d:\n", generation);
    for (i = 0; i < POPULATION_SIZE; ++i) {
		gotoxy(0,5+i);
        printf("Chromosome %2d: ", i);
        print_chromosome(&population[i]);
    }
}

void print_chromosome(Chromosome *chromosome) {
	unsigned char i;

    cprintf("  Fitness: %3u ", chromosome->fitness);
    for (i = 0; i < chromosome->length; ++i) {
        cprintf("%c", 65+chromosome->genes[i]);
    }
}

Chromosome* selectParent() {
	unsigned char i;
	unsigned char tournament_size = 2;

    Chromosome *selected = &population[rand() % POPULATION_SIZE];
	Chromosome *candidate;

	for(i=1; i<tournament_size; ++i) {
	   candidate = &population[rand() % POPULATION_SIZE];
	   if (candidate->fitness > selected->fitness) {
	      selected = candidate;
	   }
	}

	return selected;
}

int main() {
 
    //cbm_k_bsout(0x8E); // revert to primary case

    cputs("press a key to begin");
    while(!kbhit()) {}

    bgcolor(0);
	textcolor(8);
    clrscr();
    srand(time(NULL)); // Seed the random number generator

    // Initialize the population
    for (i = 0; i < POPULATION_SIZE; ++i) {
        initialize_chromosome(&population[i]);
        calculate_fitness(&population[i]);
    }

    // Main loop
    for (generation = 0; generation < MAX_GENERATIONS; ++generation) {
		printTheCurrentGeneration(generation);

        // Create offspring through crossover
        crossover(&offspring);

        // Perform mutation on the offspring
        mutate(&offspring);

        // Calculate fitness of the offspring
        calculate_fitness(&offspring);

        // Replace the least fit chromosome in the population with the offspring
        least_fit_index = 0;
        least_fitness = population[0].fitness;
        for (i = 1; i < POPULATION_SIZE; ++i) {
            if (population[i].fitness < least_fitness) {
                least_fit_index = i;
                least_fitness = population[i].fitness;
            }
        }
        population[least_fit_index] = offspring;
    }

    return 0;
}
