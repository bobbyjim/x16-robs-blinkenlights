#include <conio.h>
#include <6502.h>

#include "kernal_test.h"

unsigned char kernal_test_memtop_read()
{
    setregs(0, 0, 0, F6502_C, KERNAL_MEMTOP);
    doit();
    return x_register() != 0 || y_register() != 159;
}

unsigned char kernal_test_memtop_write()
{
    setregs(0, 1, 159, 0, KERNAL_MEMTOP);
    doit();
    setregs(0, 0, 0, F6502_C, KERNAL_MEMTOP);
    doit();
    return x_register() != 1 || y_register() != 159;
}

unsigned char kernal_test_membot_read()
{
    setregs(0, 0, 0, F6502_C, KERNAL_MEMBOT);
    doit();
    return x_register() != 0 || y_register() != 8;
}

unsigned char kernal_test_membot_write()
{
    setregs(0, 1, 8, 0, KERNAL_MEMBOT);
    doit();
    setregs(0, 0, 0, F6502_C, KERNAL_MEMBOT);
    doit();
    return x_register() != 1 || y_register() != 8;
}
