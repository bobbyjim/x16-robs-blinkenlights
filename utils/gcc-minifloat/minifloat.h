#ifndef _MINIGLOAT_H_
#define _MINIGLOAT_H_

#define		BIAS					0
#define		EXPONENT_BITS			5
#define		EXPONENT_VALUE(x)		(x - BIAS)
#define		MANTISSA_BITS			2
#define		MANTISSA_VALUE(x)		((1.0f * x + 1)/(1 << MANTISSA_BITS))

typedef struct {
    int sign      ;
    int exponent  ;
    int mantissa  ;
} MiniFloat;


void show(MiniFloat* mf);
void setMf(MiniFloat* mf, int sign, int exp, int mant);
int addExp(MiniFloat* mf, int exp);
int mulMan(MiniFloat* mf, int mant);
void mulMf(MiniFloat* a, MiniFloat* b);
void addMf(MiniFloat* a, MiniFloat* b);

#endif

