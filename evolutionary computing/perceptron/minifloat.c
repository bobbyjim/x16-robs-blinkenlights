
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "minifloat.h"

#ifndef __CBM__
#define conio_disabled
#endif

//unsigned pow2[] = { 2, 4, 8, 16, 32, 64, 128, 256, 512, 1024, 2048, 4096, 8192, 16384 };

MiniFloat mfTemp;

//
//  This is a 1.5.2,-28 mini float (like Nvidia fp8)
//  Value = significand * 2^(exponent - 28)
//  Sign: 1 bit
//  Exponent: 5 bits (range 0-31, bias 28 gives effective range -28 to +3)
//  Significand: 2 bits (range 0-3, typically 1-3 with normalization)
//
void testMiniFloat()
{
	int n, e, s;
	MiniFloat 	mf1;

    for(;;) {
       puts("enter sign, exp, sig: ");
       scanf( "%d %d %d", &n, &e, &s );
	   mf1.sign = n;
	   mf1.exponent = e;
	   mf1.significand = s;
	   mfDump( mf1 );
    }
}

MiniFloat mfAdd( MiniFloat a, MiniFloat b )
{
	MiniFloat result;
	int a_val, b_val, sum;
	
	// Convert to fixed point for addition, then back
	a_val = (a.significand + 1) << (a.exponent - 1);
	b_val = (b.significand + 1) << (b.exponent - 1);
	
	if (a.sign) a_val = -a_val;
	if (b.sign) b_val = -b_val;
	
	sum = a_val + b_val;
	
	// Convert back to minifloat
	if (sum == 0) {
		result.sign = 0;
		result.exponent = 0;
		result.significand = 0;
		return result;
	}
	
	result.sign = (sum < 0);
	sum = (sum < 0) ? -sum : sum;
	
	// Find exponent by normalizing
	result.exponent = 0;
	while (sum > 3 && result.exponent < 31) {
		sum >>= 1;
		result.exponent++;
	}
	result.exponent += 1;
	
	result.significand = (sum > 0) ? (sum - 1) : 0;
	
	return result;
}

void mfDump( MiniFloat mf )
{
	printf("  mf.sign: %d\n", mf.sign );
	printf("  mf.exp : %d\n", mf.exponent );
	printf("  mf.sig : %d\n", mf.significand );
	printf("  value (approx): %d * 2^(%d - 28)\n", mf.significand + 1, mf.exponent);
	puts("\n");
}

long mf2long( MiniFloat f )
{
	long out = (long) (f.significand + 1);  // Normalize: use 1-4 instead of 0-3
	int shift = f.exponent - 28;
	
	if (shift > 0) {
		out <<= shift;  // Shift left (multiply by power of 2)
	} else if (shift < 0) {
		out >>= -shift;  // Shift right (divide by power of 2)
	}
	
	if (f.sign) return -out;
	else return out;
}

MiniFloat long2mf( long num )
{
	MiniFloat mf;
	unsigned long abs_num;
	int exponent = 0;
	
	mf.sign = 0;
	mf.exponent = 0;
	mf.significand = 0;
	
	if (num == 0) return mf;
	
	mf.sign = (num < 0);
	abs_num = (num < 0) ? -num : num;
	
	// Normalize to get significand in range 1-4 (stored as 0-3)
	exponent = 28;  // Start at bias
	
	while (abs_num > 3 && exponent < 31) {
		abs_num >>= 1;
		exponent++;
	}
	
	while (abs_num < 1 && exponent > 0) {
		abs_num <<= 1;
		exponent--;
	}
	
	mf.exponent = exponent;
	mf.significand = (abs_num > 0) ? (abs_num - 1) : 0;  // Store 0-3 (which represents 1-4)
	
	return mf;
}

MiniFloat mfMultiply( MiniFloat a, MiniFloat b )
{
	MiniFloat c;
	unsigned int sig_a = a.significand + 1;  // Convert to 1-4 range
	unsigned int sig_b = b.significand + 1;
	unsigned int product = sig_a * sig_b;
	int exponent = a.exponent + b.exponent - 28;  // -28 because we added +1 to both
	
	c.sign = (a.sign != b.sign);
	
	// Normalize product back to 1-4 range
	while (product > 3 && exponent < 31) {
		product >>= 1;
		exponent++;
	}
	
	while (product < 1 && exponent > 0) {
		product <<= 1;
		exponent--;
	}
	
	c.exponent = (exponent > 31) ? 31 : ((exponent < 0) ? 0 : exponent);
	c.significand = (product > 0) ? (product - 1) : 0;  // Convert back to 0-3 range
	
	return c;
}

