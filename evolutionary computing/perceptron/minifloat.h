#ifndef _FASTMATH_H_
#define _FASTMATH_H_


typedef struct {			// 1.5.2,-28

	unsigned int sign		: 1;	
	unsigned int exponent	: 5;	
	unsigned int significand	: 2;	

} MiniFloat;

typedef union {
	unsigned char value;
	MiniFloat mf;
} MiniUnion;

void testMiniFloat();
long mf2long( MiniFloat f );
MiniFloat long2mf( long num );
MiniFloat mfAdd( MiniFloat a, MiniFloat b );
MiniFloat mfMultiply( MiniFloat a, MiniFloat b );
void mfDump( MiniFloat mf );

#endif