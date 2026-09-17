#include <stdlib.h>
#include <conio.h>
#include "perceptron.h"
#include "fixed.h"

void init(unsigned char n, int weight[] )
{
	int i = NUM_INPUTS;
	Perceptron* p = BANKED_PERCEPTRON(n);

	while(i--) {
		if (weight) {
			p->weight[i] = fx_from_int(weight[i]);
		} else {
			// Random weight
			p->weight[i] = fx_from_int((rand() % 7) - 3);
		}
	}

	p->value = 0;
}

void run(unsigned char n, unsigned char input[])
{
	int i = NUM_INPUTS;
	Perceptron* p = BANKED_PERCEPTRON(n);
	fixed16 sum = 0;
	fixed16 inp_fx;
	fixed16 prod;

	while(i--) {
		inp_fx = fx_from_int(input[i]);
		prod = fx_mul(p->weight[i], inp_fx);
		sum = fx_add(sum, prod);
	}

	p->value = sum;
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
	fixed16 val = (BANKED_PERCEPTRON(n))->value;
	return (val > 0) ? 1 : -1;
}

void debug(unsigned char n)
{
	Perceptron* p = BANKED_PERCEPTRON(n);
	int i = NUM_INPUTS;

	while(i--) {
		cprintf(" weight %d: %d\r\n", i, fx_to_int_round(p->weight[i]));
	}

	cprintf(" value: %d\n\r\n", fx_to_int_round(p->value) );
}