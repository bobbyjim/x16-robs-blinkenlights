#ifndef FIXED_H
#define FIXED_H

// Q4.12 fixed-point: 1 sign bit, 3 integer bits, 12 fractional bits.
// Range ~ -8.0 to +7.9998, resolution ~ 0.00024.
// Suitable for small neural nets on 65C02 (fast add/mul with shifts).

typedef int fixed16;               // cc65 int is 16-bit; host int is fine
#define FIXED_FRAC_BITS 12
#define FIXED_ONE       (1 << FIXED_FRAC_BITS)

// Constructors
fixed16 fx_from_int(int x);
fixed16 fx_from_frac(int num, int denom);   // num/denom

// Basic ops
fixed16 fx_add(fixed16 a, fixed16 b);
fixed16 fx_sub(fixed16 a, fixed16 b);
fixed16 fx_mul(fixed16 a, fixed16 b);

// Converters
int     fx_to_int_floor(fixed16 x);
int     fx_to_int_round(fixed16 x);
#ifndef __CC65__
double  fx_to_double(fixed16 x);   // host-side tests only
#endif

#endif
