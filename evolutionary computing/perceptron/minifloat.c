
#include <conio.h>
#include <stdio.h>
#include <stdlib.h>
#include "minifloat.h"

//unsigned pow2[] = { 2, 4, 8, 16, 32, 64, 128, 256, 512, 1024, 2048, 4096, 8192, 16384 };

MiniFloat mfTemp;

//
//  This is a 1.5.2,-28 mini float
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
	if (a.exponent < b.exponent ) {
		// swap
		mfTemp = a;
		a = b;
		b = mfTemp;
	}

	
}

void mfDump( MiniFloat mf )
{
	long value = mf.significand;

	printf("  mf.sign: %d\n", mf.sign );
	printf("  mf.exp : %d\n", mf.exponent );
	printf("  mf.sig : %d\n", mf.significand );
	puts("\n");
}

long mf2long( MiniFloat f )
{
	long out = (long) f.significand;

	if (f.exponent)
	{
		out <<= (f.exponent - 28);
	}	

	if (f.sign) return -out;
	else return out;
}

MiniFloat long2mf( long num )
{
	MiniFloat mf;

	if (num == 0) return mf;

	mf.sign = (num < 0);
	num = abs(num);

	mf.significand = num % 4;
	num >>= 2;

	while(num && mf.exponent < 31)
	{
		mf.exponent++;
		num >>= 1;
	}

	return mf;
}

MiniFloat mfMultiply( MiniFloat a, MiniFloat b )
{
	MiniFloat c;
	unsigned char exponent = 0;
	unsigned char significand = a.significand * b.significand;

	c.sign = (a.sign != b.sign);
	
	while (significand > 3)
	{
		exponent++;
		significand <<= 1; // divide by 2 and try again
	}

	c.significand = significand;

	exponent += a.exponent + b.exponent;
	c.exponent = (exponent > 31)? 31 : exponent;

	return c;
}

