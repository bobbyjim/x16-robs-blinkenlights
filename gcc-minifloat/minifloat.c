#include <stdio.h>
#include <stdint.h>
#include <math.h>

#include "minifloat.h"



void show(MiniFloat* mf) 
{
	double out = mf->mantissa * pow(2,(mf->exponent - 24));
	if (mf->sign) out = -out;
	printf("%f", out);
}

void setMf(MiniFloat* mf, int sign, int exp, int mant) 
{
	mf->sign = sign;
	mf->exponent = exp;
	mf->mantissa = mant;
}

int addExp(MiniFloat* mf, int exp)
{
	return mf->exponent + exp;
}

int mulMan(MiniFloat* mf, int mant)
{
	return mf->mantissa * mant;
}

void mulMf(MiniFloat* a, MiniFloat* b)
{
	a->sign = 0;
	if (a->sign != b->sign) a->sign = 1;
	a->exponent = addExp(b, a->exponent) - 24;
	a->mantissa = mulMan(b, a->mantissa);
	//
	//  TODO: underflow and overflow
	//
}

void addMf(MiniFloat* a, MiniFloat* b) {}


void dump_minifloat(MiniFloat mf) {

	int i;
	int8_t mantissa = mf.mantissa;

	if (mf.sign) printf("-");

	// if exponent > BIAS, then we have digits in front of the decimal.
	if (mf.exponent > BIAS) {
		for (i=BIAS; i<mf.exponent; ++i) {
			int val = mantissa & 1;
			mantissa >>= 1;
			printf("%d", val);
		}
	}
	else
	{
		printf("0");
	}

	printf(".");

	// now do the rest
	for (i=0; i<BIAS; ++i) {
		int val = mantissa & 1;
		mantissa >>= 1;
		printf("%d", val);
	}
}


float minifloat_to_float(MiniFloat minifloat) {

    int8_t exponent = EXPONENT_VALUE(minifloat.exponent);
    float  mantissa = MANTISSA_VALUE(minifloat.mantissa);

	float  pow      = mantissa * powf(2, exponent);

    return minifloat.sign ? -pow : pow;
}

/*
MiniFloat float_to_minifloat(float value) {
    MiniFloat minifloat;

	int8_t exponent  = 0;
    float  mantissa  = fabsf(value);

    while (mantissa >= 2.0f && exponent < (1 << EXPONENT_BITS)) {
        mantissa /= 2.0f;
        exponent++;
    }
    
	minifloat.sign = value < 0 ? 1 : 0;
    minifloat.exponent = exponent;
    minifloat.mantissa = (int8_t)((mantissa - 1.0f) * (1 << MANTISSA_BITS));
       
    return minifloat;
}
*/

int main() {
	MiniFloat mf1, mf2;
	int sign, exponent, mantissa;
    
	for(;;) {
		printf("set minifloat 1 (S,E,M): ");
		scanf("%d%d%d", &sign, &exponent, &mantissa);
		mf1.sign = sign;
		mf1.exponent = exponent;
		mf1.mantissa = mantissa;

		printf("set minifloat 2 (S,E,M): ");
		scanf("%d%d%d", &sign, &exponent, &mantissa);
		mf2.sign = sign;
		mf2.exponent = exponent;
		mf2.mantissa = mantissa;

		printf("mf1 as float: %f\n", minifloat_to_float(mf1));
		printf("mf2 as float: %f\n", minifloat_to_float(mf2));

		printf("mf1 dumped  : ");  dump_minifloat(mf1);  printf("\n");
		printf("mf2 dumped  : ");  dump_minifloat(mf1);  printf("\n");

		mulMf(&mf1, &mf2);
		printf("mf1 x mf2   : %f\n", minifloat_to_float(mf1));

		printf("\n\n\n");
	}
    return 0;
}
