#ifndef _GP_H_
#define _GP_H_

#define POPULATION_SIZE        10
#define CHROMOSOME_MAX_LENGTH  40
#define MUTATION_RATE_INVERTED 10
#define MAX_GENERATIONS        100
#define NUMBER_OF_OPCODES      26

typedef struct {
    unsigned char genes[CHROMOSOME_MAX_LENGTH];
    unsigned char length;  // p-string
    unsigned char fitness;
} Chromosome;

void initialize_chromosome(Chromosome *chromosome);
void calculate_fitness(Chromosome *chromosome);
void mutate(Chromosome *chromosome);
Chromosome* selectParent();
void crossover(Chromosome *child);
void print_chromosome(Chromosome *chromosome);

#endif