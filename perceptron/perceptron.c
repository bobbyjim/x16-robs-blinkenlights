#include <stdlib.h>
#include <conio.h>
#include "perceptron.h"

void init(unsigned char n, int weight[] )
{
	int i = NUM_INPUTS;
	Perceptron* p = BANKED_PERCEPTRON(n);

	while(i--) {
		p->weight[i] = weight[i];
	}

	p->value = 0;
}

void run(unsigned char n, unsigned char input[])
{
	int i = NUM_INPUTS;
	Perceptron* p = BANKED_PERCEPTRON(n);
	long value = 0;

	while(i--) {
		value += input[i] * p->weight[i] / WEIGHT_SCALE;
	}

	p->value = activate_fast_sigmoid(value);
}

int activate_linear(long value)
{
	return (value > 0)? 1 : -1;
}

int activate_fast_sigmoid(long value)
{
	return (value / (1 + abs(value))) > 0? 1 : -1;
}

int outputValue(unsigned char n) 
{
	return (BANKED_PERCEPTRON(n))->value;
}

void debug(unsigned char n)
{
	Perceptron* p = BANKED_PERCEPTRON(n);
	int i = NUM_INPUTS;

	while(i--) {
		cprintf(" weight %d: %d\r\n", i, p->weight[i]);
	}

	cprintf(" value: %d\n\r\n", p->value );
}