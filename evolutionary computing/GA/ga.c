#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <conio.h>
#include <6502.h>
#include <cx16.h>

#include "ga.h"

Chromosome population[POPULATION_SIZE];

void initialize_chromosome(Chromosome *chromosome) {
	unsigned char i;
    for (i = 0; i < CHROMOSOME_LENGTH; ++i) {
        chromosome->genes[i] = rand() % 4; // Random quad genes
    }
}

void calculate_fitness(Chromosome *chromosome) {
    unsigned char fitness = 0;
    unsigned char i;
    for (i = 0; i < CHROMOSOME_LENGTH; ++i) {
        fitness += (chromosome->genes[i] + i) % 4;
    }
	chromosome->fitness = fitness;
    //return fitness;
}

void mutate(Chromosome *chromosome) {
	unsigned char i;
    for (i = 0; i < CHROMOSOME_LENGTH; ++i) {
        if (rand() % MUTATION_RATE_INVERTED == 0) {
            chromosome->genes[i] = rand() % 4; // Random change
        }
    }
}

void crossover(Chromosome *child) {
	unsigned char i;
    unsigned char crossover_point = rand() % CHROMOSOME_LENGTH;

    // Select parents for crossover (tournament selection)
	Chromosome *parent1 = selectParent();
	Chromosome *parent2 = selectParent();

    for (i = 0; i < CHROMOSOME_LENGTH; ++i) {
        if (i < crossover_point) {
            child->genes[i] = parent1->genes[i];
        } else {
            child->genes[i] = parent2->genes[i];
        }
    }
}

char chromosomeLetter[] = { 'A', 'G', 'C', 'T' };

unsigned char printTheCurrentGeneration(int generation, unsigned char least_fit_index) {
	unsigned char i;

	gotoxy(0,1);
    printf("Generation %03d:\n", generation);
    for (i = 0; i < POPULATION_SIZE; ++i) {
        if (generation == 0 || least_fit_index == i) {
		    gotoxy(0,3+i);
            printf("Chr# %2d: ", i);
            print_chromosome(&population[i]);
        }
        if (population[i].fitness < population[least_fit_index].fitness)
            least_fit_index = i;
    }
    return least_fit_index;
}

void print_chromosome(Chromosome *chromosome) {
	unsigned char i;

    for (i = 0; i < CHROMOSOME_LENGTH; ++i) {
        cprintf("%c", chromosomeLetter[chromosome->genes[i]]);
    }
    cprintf(" F: %u", chromosome->fitness);
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
	unsigned char i;
	int generation;
    unsigned char least_fit_index = 255;
    int tournament_size = 2;
 
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
		least_fit_index = printTheCurrentGeneration(generation, least_fit_index);

        // Create offspring through crossover
        crossover(&population[least_fit_index]);

        // Perform mutation on the offspring
        mutate(&population[least_fit_index]);

        // Calculate fitness of the offspring
        calculate_fitness(&population[least_fit_index]);
    }

    gotoxy(0,0);

    return 0;
}
