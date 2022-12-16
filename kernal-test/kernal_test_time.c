#include <conio.h>
#include <6502.h>

#include "kernal_test.h"

unsigned char kernal_test_settim()
{
    unsigned char *a = (unsigned char*)(0xa0);

    setregs(10, 20, 30, 0, KERNAL_SETTIM);
    doit();
    return !(a[2] == 10 && a[1] == 20 && a[0] == 30);
}

unsigned char kernal_test_rdtim()
{
    setregs(0x40, 0x50, 0x60, 0, KERNAL_SETTIM);
    doit();

    setregs(0, 0, 0, 0, KERNAL_RDTIM);
    doit();

    return !(accumulator_is(0x40) && x_register_is(0x50) && y_register_is(0x60));
}

unsigned char kernal_test_settim_and_udtim_and_rdtim()
{
    setregs(0x10, 0x20, 0x30, 0, KERNAL_SETTIM);
    doit();

    setregs(0, 0, 0, 0, KERNAL_UDTIM);
    doit();

    setregs(0, 0, 0, 0, KERNAL_RDTIM);
    doit();

    return !(accumulator_is(0x30) && x_register_is(0x20) && y_register_is(0x11));
}