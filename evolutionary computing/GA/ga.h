#ifndef _GA_H_
#define _GA_H_

#define POPULATION_SIZE        56
#define CHROMOSOME_LENGTH      64
#define MUTATION_RATE_INVERTED 50
#define MAX_GENERATIONS        1600

typedef struct {
    unsigned char genes[CHROMOSOME_LENGTH];
    unsigned char fitness;
} Chromosome;

void initialize_chromosome(Chromosome *chromosome);
void calculate_fitness(Chromosome *chromosome);
void mutate(Chromosome *chromosome);
Chromosome* selectParent();
void crossover(Chromosome *child);
void print_chromosome(Chromosome *chromosome);

#endif