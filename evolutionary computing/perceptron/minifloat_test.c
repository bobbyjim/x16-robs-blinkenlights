#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "fixed.h"

typedef struct {
	const char *name;
	int passed;
	int failed;
} TestSuite;

TestSuite suite = {"Q4.12 Fixed Tests", 0, 0};

void assert_equal_long(long expected, long actual, const char *test_name) {
	if (expected == actual) {
		printf("  ✓ %s\n", test_name);
		suite.passed++;
	} else {
		printf("  ✗ %s: expected %ld, got %ld\n", test_name, expected, actual);
		suite.failed++;
	}
}

void assert_equal_int(int expected, int actual, const char *test_name) {
	if (expected == actual) {
		printf("  ✓ %s\n", test_name);
		suite.passed++;
	} else {
		printf("  ✗ %s: expected %d, got %d\n", test_name, expected, actual);
		suite.failed++;
	}
}

void assert_close_double(double expected, double actual, double tol, const char *test_name) {
	double diff = fabs(expected - actual);
	if (diff <= tol) {
		printf("  ✓ %s\n", test_name);
		suite.passed++;
	} else {
		printf("  ✗ %s: expected %.6f, got %.6f (diff %.6f)\n", test_name, expected, actual, diff);
		suite.failed++;
	}
}

void test_zero_conversion() {
	printf("\nTest: Zero Conversion\n");
	fixed16 z = fx_from_int(0);
	int back = fx_to_int_floor(z);
	assert_equal_int(0, back, "zero round-trip");
}

void test_int_roundtrip() {
	printf("\nTest: Integer Round-trip (-8..7)\n");
	int v;
	for (v = -8; v <= 7; ++v) {
		fixed16 fx = fx_from_int(v);
		int back = fx_to_int_floor(fx);
		char name[32];
		sprintf(name, "int %d", v);
		assert_equal_int(v, back, name);
	}
}

void test_fractional_values() {
	printf("\nTest: Fractional Values\n");

	struct { int num; int den; double expect; const char* name; } cases[] = {
		{1, 2, 0.5, "0.5"},
		{1, 4, 0.25, "0.25"},
		{3, 4, 0.75, "0.75"},
		{-1, 2, -0.5, "-0.5"},
	};

	int i;
	for (i = 0; i < 4; ++i) {
		fixed16 fx = fx_from_frac(cases[i].num, cases[i].den);
		double back = fx_to_double(fx);
		assert_close_double(cases[i].expect, back, 0.001, cases[i].name);
	}
}

void test_addition() {
	printf("\nTest: Addition\n");

	fixed16 a = fx_from_frac(5,4); // 1.25
	fixed16 b = fx_from_frac(3,4); // 0.75
	fixed16 sum = fx_add(a,b);
	assert_close_double(2.0, fx_to_double(sum), 0.001, "1.25 + 0.75 = 2");

	fixed16 c = fx_from_frac(-3,2); // -1.5
	fixed16 d = fx_from_frac(1,2);  // 0.5
	sum = fx_add(c,d);
	assert_close_double(-1.0, fx_to_double(sum), 0.001, "-1.5 + 0.5 = -1");
}

void test_multiplication() {
	printf("\nTest: Multiplication\n");

	fixed16 a = fx_from_int(2);
	fixed16 b = fx_from_int(3);
	assert_close_double(6.0, fx_to_double(fx_mul(a,b)), 0.001, "2 * 3 = 6");

	fixed16 c = fx_from_frac(3,2); // 1.5
	assert_close_double(3.0, fx_to_double(fx_mul(c, a)), 0.001, "1.5 * 2 = 3");
	assert_close_double(-3.0, fx_to_double(fx_mul(fx_from_frac(-3,2), a)), 0.001, "-1.5 * 2 = -3");

	fixed16 half = fx_from_frac(1,2);
	assert_close_double(0.25, fx_to_double(fx_mul(half, half)), 0.001, "0.5 * 0.5 = 0.25");
}

void print_summary() {
	printf("\n========================================\n");
	printf("Test Results: %d passed, %d failed\n", suite.passed, suite.failed);
	printf("========================================\n");
}

int main() {
	printf("Q4.12 Fixed-Point Test Suite\n");
	printf("Format: 1 sign, 3 integer bits, 12 fraction bits (range ~ -8..+7.9998)\n");
	
	test_zero_conversion();
	test_int_roundtrip();
	test_fractional_values();
	test_addition();
	test_multiplication();
	
	print_summary();
	
	return suite.failed;
}
