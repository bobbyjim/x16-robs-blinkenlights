#include "fixed.h"

// Constructors
fixed16 fx_from_int(int x) {
    return (fixed16)(x << FIXED_FRAC_BITS);
}

fixed16 fx_from_frac(int num, int denom) {
    long tmp;
    if (denom == 0) return 0;
    tmp = ((long)num << FIXED_FRAC_BITS) / (long)denom;
    return (fixed16)tmp;
}

// Basic ops
fixed16 fx_add(fixed16 a, fixed16 b) { return (fixed16)(a + b); }
fixed16 fx_sub(fixed16 a, fixed16 b) { return (fixed16)(a - b); }

fixed16 fx_mul(fixed16 a, fixed16 b) {
    // Use 32-bit intermediate to avoid overflow before shifting back
    long prod = (long)a * (long)b;
    prod >>= FIXED_FRAC_BITS;
    return (fixed16)prod;
}

// Converters
int fx_to_int_floor(fixed16 x) {
    return x >> FIXED_FRAC_BITS;  // arithmetic shift keeps sign
}

int fx_to_int_round(fixed16 x) {
    if (x >= 0)
        return (int)((x + (FIXED_ONE >> 1)) >> FIXED_FRAC_BITS);
    else
        return (int)((x - (FIXED_ONE >> 1)) >> FIXED_FRAC_BITS);
}

#ifndef __CC65__
double fx_to_double(fixed16 x) {
    return (double)x / (double)FIXED_ONE;
}
#endif
