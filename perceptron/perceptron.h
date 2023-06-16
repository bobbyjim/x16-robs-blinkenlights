#ifndef _PERCEPT_H_ 
#define _PERCEPT_H_

//
//  Perceptrons start at 0x8c00, and there's 64 of them per RAM Bank.
//  -- That's 1K bytes.
//
#define TOTAL_PERCEPTRONS			64
#define	NUM_INPUTS					7
#define PERCEPTRON_INDEX(n)			(n << 4)
#define BANKED_PERCEPTRON(n)		(Perceptron*)((0x8c00 + PERCEPTRON_INDEX(n)))

#define WEIGHT_SCALE		10

//
//  7 inputs max = 16 bytes each.
//
typedef struct {

	int weight[ NUM_INPUTS ];
	int value;

} Perceptron;


void init(unsigned char n, int weight[] );
void run(unsigned char n, unsigned char input[]);
int outputValue(unsigned char n);
void debug(unsigned char n);

int activate_linear(long value);
int activate_fast_sigmoid(long value);

#endif
